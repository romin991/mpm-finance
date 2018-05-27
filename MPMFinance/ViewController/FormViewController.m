//
//  FormViewController.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 5/14/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "FormViewController.h"
#import "Form.h"
#import <JVFloatLabeledTextField/JVFloatLabeledTextView.h>
#import "FloatLabeledTextFieldCell.h"
#import "SimpleListViewController.h"
#import "WorkOrderModel.h"
#import "DropdownModel.h"
#import "FormModel.h"
#import "ProfileModel.h"
#import "PostalCodeViewController.h"
#import "PostalCodeValueTransformer.h"
#import "AssetViewController.h"
#import "AssetValueTransformer.h"
#import "BarcodeViewController.h"
#import "FloatLabeledTextFieldCell.h"
#import "SubmenuViewController.h"
#import "OfflineData.h"
#import "DisclaimerViewController.h"

@interface FormViewController ()

@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;
@property (weak, nonatomic) IBOutlet UIView *labelView;

@property RLMResults *forms;

@property NSString *idCabang;

@end

@implementation FormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    CGRect frame = self.tableView.frame;
    frame.origin.y += 44;
    frame.size.height -= 44;
    self.tableView.frame = frame;
    
    // Do any additional setup after loading the view from its nib.
    self.forms = [Form getFormForMenu:self.menu.primaryKey role:[MPMUserInfo getRole]];
    [self setTitle:self.menu.title];
    [self setHorizontalLabel];
    
    [SVProgressHUD show];
    __block FormViewController *weakSelf = self;
    
    if (self.valueDictionary.count == 0) self.valueDictionary = [NSMutableDictionary dictionary];
    
    [self preparingValueWithCompletion:^{
        [self preparingFormDescriptorWithCompletion:^{
            [FormModel loadValueFrom:weakSelf.valueDictionary on:weakSelf partialUpdate:nil];
            [SVProgressHUD dismiss];
        }];
    }];
}

- (void)preparingValueWithCompletion:(void(^)())block{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    __block FormViewController *weakSelf = self;
    __block NSError *_error = nil;
    
    if (self.list) {
        dispatch_group_enter(group);
        [WorkOrderModel getListWorkOrderDetailWithID:self.list.primaryKey completion:^(NSDictionary *response, NSError *error) {
            if (error) _error = error;
            if (response) [weakSelf.valueDictionary addEntriesFromDictionary:response];
            
            dispatch_group_leave(group);
        }];
    }
    
    dispatch_group_notify(group, queue, ^{
        [weakSelf.valueDictionary addEntriesFromDictionary:@{@"kewarganegaraan" : @"WNI",
                                                             @"kewarganegaraanPasangan" : @"WNI",
                                                             }];
        
        if ([[MPMUserInfo getRole] isEqualToString:kRoleCustomer]) {
            dispatch_group_enter(group);
            [ProfileModel getProfileDataWithCompletion:^(NSDictionary *dictionary, NSError *error) {
                if (error) _error = error;
                if (dictionary) [weakSelf.valueDictionary addEntriesFromDictionary:dictionary];
                
                dispatch_group_leave(group);
            }];
        }
    
        dispatch_group_notify(group, queue, ^{
            [weakSelf checkError:_error completion:^{
                if (block) block();
            }];
        });
    });
}

- (void)preparingFormDescriptorWithCompletion:(void(^)())block{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    __block FormViewController *weakSelf = self;
    __block NSError *_error = nil;
    __block XLFormDescriptor *_formDescriptor;
    
    dispatch_group_enter(group);
    Form *currentForm = [self.forms objectAtIndex:self.index];
    [FormModel generate:self.form form:currentForm completion:^(XLFormDescriptor *formDescriptor, NSError *error) {
        if (error) _error = error;
        if (formDescriptor) _formDescriptor = formDescriptor;
        dispatch_group_leave(group);
    }];
    
    dispatch_group_notify(group, queue, ^{
        for (XLFormSectionDescriptor *section in _formDescriptor.formSections) {
            for (XLFormRowDescriptor *row in section.formRows) {
                if ([row.tag isEqualToString:@"next"]){
                    row.action.formSelector = @selector(nextButtonClicked:);
                }
                
                if ([row.tag isEqualToString:@"kodeposSesuaiKTP"] || [row.tag isEqualToString:@"kodeposDomisili"] || [row.tag isEqualToString:@"kodePosPasangan"]){
                    row.action.viewControllerNibName = @"PostalCodeViewController";
                    row.valueTransformer = [PostalCodeValueTransformer class];
                }
                
                if ([row.tag isEqualToString:@"tipeKendaraan"]){
                    row.action.viewControllerNibName = @"AssetViewController";
                    row.valueTransformer = [AssetValueTransformer class];
    
                    __block XLFormRowDescriptor *weakRow = row;
                    
                    NSString *idCabang = [self.valueDictionary objectForKey:@"kodeCabang"];
                    NSString *idProduct = [self.valueDictionary objectForKey:@"tipeProduk"];
                    NSString *tipeKendaraan = [self.valueDictionary objectForKey:@"tipeKendaraan"];
                    
                    if (idProduct && idCabang && tipeKendaraan) {
                        dispatch_group_enter(group);
                        [DropdownModel getDropdownWSForAssetWithKeyword:tipeKendaraan idProduct:idProduct idCabang:idCabang completion:^(NSArray *options, NSError *error) {
                            if (error) _error = error;
                            
                            NSMutableArray *optionObjects = [NSMutableArray array];
                            for (Asset *option in options) {
                                [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:option.value displayText:option.name]];
                            }
                            weakRow.selectorOptions = optionObjects;
                            
                            dispatch_group_leave(group);
                        }];
                    }
                }
                
                if ([row.tag isEqualToString:@"tahunKendaraan"]){
                    @try {
                        NSDate *date = [NSDate date];
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        [dateFormatter setDateFormat:@"yyyy"];
                        NSString *yearString = [dateFormatter stringFromDate:date];
                        NSInteger year = yearString.integerValue;
                        
                        NSMutableArray *optionObjects = [NSMutableArray array];
                        for (int i = 0; i < 16; i++) {
                            [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@(year - i) displayText:[NSString stringWithFormat:@"%li", (long) year - i]]];
                        }
                        row.selectorOptions = optionObjects;
                    } @catch (NSException *exception) {
                        NSLog(@"%@", exception);
                    }
                }
                
                if ([row.tag isEqualToString:@"kewarganegaraan"] || [row.tag isEqualToString:@"kewarganegaraanPasangan"]){
                    @try {
                        NSMutableArray *optionObjects = [NSMutableArray array];
                        [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"WNI" displayText:@"WNI"]];
                        [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"WNA" displayText:@"WNA"]];
                        row.selectorOptions = optionObjects;
                    } @catch (NSException *exception) {
                        NSLog(@"%@", exception);
                    }
                }
                
                if ([row.tag isEqualToString:@"rTSesuaiKTP"] ||
                    [row.tag isEqualToString:@"rWSesuaiKTP"] ||
                    [row.tag isEqualToString:@"kodeArea"] ||
                    [row.tag isEqualToString:@"nomorTelepon"] ||
                    [row.tag isEqualToString:@"nomorHandphone"] ||
                    
                    [row.tag isEqualToString:@"rtDomisili"] ||
                    [row.tag isEqualToString:@"rwDomisili"] ||
                    
                    [row.tag isEqualToString:@"noKTPPasangan"] ||
                    [row.tag isEqualToString:@"nomorHandphonePasangan"] ||
                    
                    [row.tag isEqualToString:@"rtPasangan"] ||
                    [row.tag isEqualToString:@"rwPasangan"] ||
                    
                    [row.tag isEqualToString:@"hargaPerolehan"] ||
                    [row.tag isEqualToString:@"uangMuka"] ||
                    [row.tag isEqualToString:@"jangkaWaktuPembayaran"] ||
                    [row.tag isEqualToString:@"angsuran"] ||
                    
                    [row.tag isEqualToString:@"kodeAreaTeleponTempatKerja"] ||
                    [row.tag isEqualToString:@"nomorTeleponTempatKerja"] ||
                    [row.tag isEqualToString:@"nomorTeleponEcon"]
                    ){
                    
                    //Set keyboard type to numberPad
                    if ([[row cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
                        [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setKeyboardType:UIKeyboardTypeNumberPad];
                    }
                }
                
                if ([[MPMUserInfo getRole] isEqualToString:kRoleDedicated]){
                    if ([row.tag isEqualToString:@"noKTP"] ||
                        [row.tag isEqualToString:@"namaLengkap"] ||
                        [row.tag isEqualToString:@"tempatLahir"] ||
                        [row.tag isEqualToString:@"tanggalLahir"] ||
                        [row.tag isEqualToString:@"jenisKelamin"]) {
                        row.disabled = @NO;
                    }
                }
            }
        }
        
        dispatch_group_notify(group, queue, ^{
            [weakSelf checkError:_error completion:^{
                if (_formDescriptor) weakSelf.form = _formDescriptor;
                if (block) block();
            }];
        });
    });
}

- (void)checkError:(NSError *)error completion:(void(^)())block{
    if (error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
        [SVProgressHUD dismissWithDelay:1.5 completion:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } else {
        block();
    }
}

- (void)finish{
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[SubmenuViewController class]]) {
            [self.navigationController popToViewController:vc animated:NO];
        }
    }
}

- (void)nextButtonClicked:(id)sender{
    NSArray *inputErrors = [self validateForm];
    if (inputErrors.count > 0)
    {
        [SVProgressHUD showErrorWithStatus:((NSError *)inputErrors.firstObject).localizedDescription];
        [SVProgressHUD dismissWithDelay:1.5];
        return;
    }
    Form *nextForm = [self.forms objectAtIndex:self.index + 1];
    if ([nextForm.title isEqualToString:@"Disclaimer"]) {
        //save to object, call delegate, then pop navigation
        [FormModel saveValueFrom:self.form to:self.valueDictionary];
        DisclaimerViewController *disclaimerVC = [[DisclaimerViewController alloc] init];
        disclaimerVC.valueDictionary = self.valueDictionary;
        disclaimerVC.list = self.list;
        [self.navigationController pushViewController:disclaimerVC animated:true];
        
    } else {
        NSArray *errors = [self formValidationErrors];
        if (errors.count) {
            [SVProgressHUD showErrorWithStatus:((NSError *)errors.firstObject).localizedDescription];
            [SVProgressHUD dismissWithDelay:1.5];
            
        } else {
            [SVProgressHUD show];
            [FormModel saveValueFrom:self.form to:self.valueDictionary];
            [WorkOrderModel postDraftWorkOrder:self.list dictionary:self.valueDictionary completion:^(NSDictionary *dictionary, NSError *error) {
                if (error) {
                    
                    NSString *errorMessage = error.localizedDescription;
                    @try {
                        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] options:NSJSONReadingAllowFragments error:nil];
                        errorMessage = [responseObject objectForKey:@"message"];
                    } @catch (NSException *exception) {
                        NSLog(@"%@", exception);
                    } @finally {
                        [SVProgressHUD showErrorWithStatus:errorMessage];
                        [SVProgressHUD dismissWithDelay:1.5];
                    }
                } else {
                    [SVProgressHUD dismiss];
                    FormViewController *nextFormViewController = [[FormViewController alloc] init];
                    nextFormViewController.menu = self.menu;
                    nextFormViewController.index = self.index + 1;
                    nextFormViewController.valueDictionary = self.valueDictionary;
                    nextFormViewController.list = self.list;
                    [self.navigationController pushViewController:nextFormViewController animated:YES];
                }
            }];
        }
    }
}

- (void)setHorizontalLabel{
    Form *firstForm;
    Form *secondForm;
    Form *thirdForm;
    
    if (self.forms.count > self.index) firstForm = [self.forms objectAtIndex:self.index];
    if (self.forms.count > self.index + 1) secondForm = [self.forms objectAtIndex:self.index + 1];
    if (self.forms.count > self.index + 2) thirdForm = [self.forms objectAtIndex:self.index + 2];
    
    self.firstLabel.text = firstForm ? firstForm.title : @"";
    self.secondLabel.text = secondForm ? secondForm.title : @"";
    self.thirdLabel.text = thirdForm ? thirdForm.title : @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)formRowDescriptorValueHasChanged:(XLFormRowDescriptor *)formRow oldValue:(id)oldValue newValue:(id)newValue{
    if ([formRow.tag isEqualToString:@"alamatRumahSesuaiKTP"] ||
        [formRow.tag isEqualToString:@"rTSesuaiKTP"] ||
        [formRow.tag isEqualToString:@"rWSesuaiKTP"]){
        
        [self setDomicileAddressValueWithTheSameValueAsLegalAddress];
    }
    
    if ([formRow.tag isEqualToString:@"kodeposSesuaiKTP"] && newValue != nil && [newValue isKindOfClass:PostalCode.class]) {
        @try {
            PostalCode *postalCode = (PostalCode *)newValue;
            //set value
            [self.valueDictionary addEntriesFromDictionary:@{@"kecamatanSesuaiKTP" : postalCode.subDistrict,
                                                             @"kelurahanSesuaiKTP" : postalCode.disctrict,
                                                             @"kotaSesuaiKTP" : postalCode.city,}];
            [FormModel loadValueFrom:self.valueDictionary on:self partialUpdate:
             [NSArray arrayWithObjects:@"kecamatanSesuaiKTP", @"kelurahanSesuaiKTP", @"kotaSesuaiKTP", nil]];
            [self setDomicileAddressValueWithTheSameValueAsLegalAddress];
        } @catch (NSException *exception) {
            NSLog(@"%@", exception);
        }
    }
    
    if ([formRow.tag isEqualToString:@"kodeposDomisili"] && newValue != nil && [newValue isKindOfClass:PostalCode.class]) {
        @try {
            PostalCode *postalCode = (PostalCode *)newValue;
            //set value
            [self.valueDictionary addEntriesFromDictionary:@{@"kecamatanDomisili" : postalCode.subDistrict,
                                                             @"kelurahanDomisili" : postalCode.disctrict,
                                                             @"kotaDomisili" : postalCode.city,}];
            
            [FormModel loadValueFrom:self.valueDictionary on:self partialUpdate:
             [NSArray arrayWithObjects:@"kecamatanDomisili", @"kelurahanDomisili", @"kotaDomisili", nil]];
        } @catch (NSException *exception) {
            NSLog(@"%@", exception);
        }
    }
    if ([formRow.tag isEqualToString:@"kodePosPasangan"] && newValue != nil && [newValue isKindOfClass:PostalCode.class]) {
        @try {
            PostalCode *postalCode = (PostalCode *)newValue;
            //set value
            [self.valueDictionary addEntriesFromDictionary:@{@"kecamatanPasangan" : postalCode.subDistrict,
                                                             @"kelurahanPasangan" : postalCode.disctrict,
                                                             @"kotaPasangan" : postalCode.city,}];
            
            [FormModel loadValueFrom:self.valueDictionary on:self partialUpdate:
             [NSArray arrayWithObjects:@"kecamatanPasangan", @"kelurahanPasangan", @"kotaPasangan", nil]];
        } @catch (NSException *exception) {
            NSLog(@"%@", exception);
        }
    }
    
    
    if ([formRow.tag isEqualToString:@"samaDenganAlamatLegal"]){
        if ([newValue boolValue]){
            [self setDomicileAddressValueWithTheSameValueAsLegalAddress];
        } else {
            XLFormRowDescriptor *row = [self.form formRowWithTag:@"alamatDomisili"];
            if (row) {
                row.disabled = @NO;
                row.value = @"";
                [self reloadFormRow:row];
            }
            
            row = [self.form formRowWithTag:@"rTDomisili"];
            if (row) {
                row.disabled = @NO;
                row.value = @"";
                [self reloadFormRow:row];
            }
            
            row = [self.form formRowWithTag:@"rWDomisili"];
            if (row) {
                row.disabled = @NO;
                row.value = @"";
                [self reloadFormRow:row];
            }
            
            row = [self.form formRowWithTag:@"kodeposDomisili"];
            if (row) {
                row.disabled = @NO;
                row.value = nil;
                [self reloadFormRow:row];
            }
            
            row = [self.form formRowWithTag:@"kecamatanDomisili"];
            if (row) {
                row.value = @"";
                [self reloadFormRow:row];
            }
            
            row = [self.form formRowWithTag:@"kelurahanDomisili"];
            if (row) {
                row.value = @"";
                [self reloadFormRow:row];
            }
            
            row = [self.form formRowWithTag:@"kotaDomisili"];
            if (row) {
                row.value = @"";
                [self reloadFormRow:row];
            }
        }
    }
    
    if ([formRow.tag isEqualToString:@"tipeKendaraan"] && newValue != nil) {
        @try {
//            Asset *asset = (Asset *)newValue;
        } @catch (NSException *exception) {
            NSLog(@"%@", exception);
        }
    }
}

- (void)setDomicileAddressValueWithTheSameValueAsLegalAddress{
    XLFormRowDescriptor *row = [self.form formRowWithTag:@"samaDenganAlamatLegal"];
    if ([row.value boolValue]) {
        row = [self.form formRowWithTag:@"alamatDomisili"];
        if (row) {
            row.disabled = @YES;
            row.value = [self.form formRowWithTag:@"alamatRumahSesuaiKTP"].value;
            [self reloadFormRow:row];
        }
        
        row = [self.form formRowWithTag:@"rTDomisili"];
        if (row) {
            row.disabled = @YES;
            row.value = [self.form formRowWithTag:@"rTSesuaiKTP"].value;
            [self reloadFormRow:row];
        }
        
        row = [self.form formRowWithTag:@"rWDomisili"];
        if (row) {
            row.disabled = @YES;
            row.value = [self.form formRowWithTag:@"rWSesuaiKTP"].value;
            [self reloadFormRow:row];
        }
        
        row = [self.form formRowWithTag:@"kodeposDomisili"];
        if (row) {
            row.disabled = @YES;
            row.value = [self.form formRowWithTag:@"kodeposSesuaiKTP"].value;
            [self reloadFormRow:row];
        }
        
        row = [self.form formRowWithTag:@"kecamatanDomisili"];
        if (row) {
            row.value = [self.form formRowWithTag:@"kecamatanSesuaiKTP"].value;
            [self reloadFormRow:row];
        }
        
        row = [self.form formRowWithTag:@"kelurahanDomisili"];
        if (row) {
            row.value = [self.form formRowWithTag:@"kelurahanSesuaiKTP"].value;
            [self reloadFormRow:row];
        }
        
        row = [self.form formRowWithTag:@"kotaDomisili"];
        if (row) {
            row.value = [self.form formRowWithTag:@"kotaSesuaiKTP"].value;
            [self reloadFormRow:row];
        }
        
    }
}
#pragma mark - actions

-(NSArray *)validateForm
{
    NSArray * array = [self formValidationErrors];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        XLFormValidationStatus * validationStatus = [[obj userInfo] objectForKey:XLValidationStatusErrorKey];
        UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:[self.form indexPathOfFormRow:validationStatus.rowDescriptor]];
        [self animateCell:cell];
    
    }];
    return array;
}


#pragma mark - Helper

-(void)animateCell:(UITableViewCell *)cell
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position.x";
    animation.values =  @[ @0, @20, @-20, @10, @0];
    animation.keyTimes = @[@0, @(1 / 6.0), @(3 / 6.0), @(5 / 6.0), @1];
    animation.duration = 0.3;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.additive = YES;
    
    [cell.layer addAnimation:animation forKey:@"shake"];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
