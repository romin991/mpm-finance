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
    self.forms = [Form getFormForMenu:self.menu.primaryKey];
    Form *currentForm = [self.forms objectAtIndex:self.index];

    [self setTitle:self.menu.title];
    [self setHorizontalLabel];
    
    [SVProgressHUD show];
    __block FormViewController *weakSelf = self;
    [FormModel generate:self.form form:currentForm completion:^(XLFormDescriptor *formDescriptor, NSError *error) {
        [weakSelf checkError:error completion:^{
            if (weakSelf.valueDictionary.count > 0){
                weakSelf.form = formDescriptor;
                [weakSelf postProcessFormDescriptorWithCompletion:^(NSError *error) {
                    [weakSelf checkError:error completion:^{
                        [FormModel loadValueFrom:weakSelf.valueDictionary on:weakSelf partialUpdate:nil];
                    }];
                }];
                
                
            } else if (weakSelf.list) {
                weakSelf.valueDictionary = [NSMutableDictionary dictionary];
                weakSelf.form = formDescriptor;
                [weakSelf postProcessFormDescriptorWithCompletion:^(NSError *error) {
                    [weakSelf checkError:error completion:^{
                        [WorkOrderModel getListWorkOrderDetailWithID:weakSelf.list.primaryKey completion:^(NSDictionary *response, NSError *error) {
                            [weakSelf checkError:error completion:^{
                                if (response) {
                                    [weakSelf.valueDictionary addEntriesFromDictionary:response];
                                    [FormModel loadValueFrom:weakSelf.valueDictionary on:weakSelf partialUpdate:nil];
                                }
                            }];
                        }];
                    }];
                }];
                
            } else {
                weakSelf.valueDictionary = [NSMutableDictionary dictionary];
                weakSelf.form = formDescriptor;
                [weakSelf postProcessFormDescriptorWithCompletion:^(NSError *error) {
                    [weakSelf checkError:error completion:^{
                        [FormModel loadValueFrom:weakSelf.valueDictionary on:weakSelf partialUpdate:nil];
                    }];
                }];
            }
        }];
    }];
}

- (void)checkError:(NSError *)error completion:(void(^)())block{
    if (error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
        [SVProgressHUD dismissWithDelay:1.5 completion:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } else {
        [SVProgressHUD dismiss];
        block();
    }
}

- (void)saveButtonClicked:(id)sender{
    //save to object, call delegate, then pop navigation
    [FormModel saveValueFrom:self.form to:self.valueDictionary];
    [SVProgressHUD show];
    [WorkOrderModel postListWorkOrder:self.list dictionary:self.valueDictionary completion:^(NSDictionary *dictionary, NSError *error) {
        if (error == nil) {
            if (dictionary) {
                @try {
                    NSString *noRegistrasi = [[dictionary objectForKey:@"data"] objectForKey:@"noRegistrasi"];
                    
                    BarcodeViewController *barcodeVC = [[BarcodeViewController alloc] init];
                    barcodeVC.barcodeString = noRegistrasi;
                    barcodeVC.modalPresentationStyle = UIModalPresentationFullScreen;
                    barcodeVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                    barcodeVC.delegate = self;
                    
                    [self presentViewController:barcodeVC animated:YES completion:nil];
                } @catch (NSException *exception) {
                    NSLog(@"%@", exception);
                }
            }
            [SVProgressHUD dismiss];
        } else {
            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
            [SVProgressHUD dismissWithDelay:1.5];
        }
    }];
}

- (void)finish{
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[SubmenuViewController class]]) {
            [self.navigationController popToViewController:vc animated:NO];
        }
    }
}

- (void)nextButtonClicked:(id)sender{
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

- (void)postProcessFormDescriptorWithCompletion:(void(^)(NSError *error))block{
    for (XLFormSectionDescriptor *section in self.form.formSections) {
        for (XLFormRowDescriptor *row in section.formRows) {
            if ([row.tag isEqualToString:@"submit"]){
                row.action.formSelector = @selector(saveButtonClicked:);
            }
            
            if ([row.tag isEqualToString:@"next"]){
                row.action.formSelector = @selector(nextButtonClicked:);
            }
            
            if ([row.tag isEqualToString:@"kodeposSesuaiKTP"] || [row.tag isEqualToString:@"kodeposDomisili"]){
                row.action.viewControllerNibName = @"PostalCodeViewController";
                row.valueTransformer = [PostalCodeValueTransformer class];
            }
            
            if ([row.tag isEqualToString:@"tipeKendaraan"]){
                row.action.viewControllerNibName = @"AssetViewController";
                row.valueTransformer = [AssetValueTransformer class];
            }
            
            if ([row.tag isEqualToString:@"rTSesuaiKTP"] ||
                [row.tag isEqualToString:@"rWSesuaiKTP"] ||
                [row.tag isEqualToString:@"kodeArea"] ||
                [row.tag isEqualToString:@"nomorTelepon"] ||
                [row.tag isEqualToString:@"nomorHandphone"] ||
                [row.tag isEqualToString:@"noHandphonePasangan"] ||
                [row.tag isEqualToString:@"tahunKendaraan"] ||
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
        }
    }
    
    __block typeof (self) weakSelf = self;
    [ProfileModel getProfileDataWithCompletion:^(NSDictionary *dictionary, NSError *error) {
        [weakSelf.valueDictionary addEntriesFromDictionary:dictionary];
        block(error);
    }];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
