//
//  SurveyFormViewController.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 6/7/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "SurveyFormViewController.h"
#import <XLForm.h>
#import "Form.h"
#import "SurveyModel.h"
#import "DropdownModel.h"
#import "FormModel.h"
#import "UploadPhotoTableViewCell.h"
#import "FloatLabeledTextFieldCell.h"

@interface SurveyFormViewController ()

@property RLMResults *forms;

@end

@implementation SurveyFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    
    [[XLFormViewController cellClassesForRowDescriptorTypes] setObject:@"UploadPhotoTableViewCell" forKey:XLFormRowDescriptorTypeTakePhoto];
    
    // Do any additional setup after loading the view from its nib.
    
    self.forms = [Form getFormForMenu:self.menu.primaryKey];
    
    [self setTitle:self.menu.title];
    [self setRightBarButton];
    
    [SVProgressHUD show];
    __block SurveyFormViewController *weakSelf = self;
    if (self.valueDictionary.count == 0) self.valueDictionary = [NSMutableDictionary dictionary];
    
    [self preparingValueWithCompletion:^{
        [self preparingFormDescriptorWithCompletion:^{
            [FormModel loadValueFrom:weakSelf.valueDictionary on:weakSelf partialUpdate:nil];
            
            NSInteger count = ((NSArray *)[self.valueDictionary objectForKey:@"informanSurvey"]).count;
            for (int i = 1; i < count; i++){
                [self addDataButtonClicked:nil];
            }
            
            NSInteger counter = 2;
            for (NSDictionary *data in [weakSelf.valueDictionary objectForKey:@"informanSurvey"]) {
                XLFormSectionDescriptor *section = [self.form formSectionAtIndex:counter];
                counter += 1;
                [FormModel loadValueFrom:data to:section on:weakSelf partialUpdate:nil];
            }
            
            [SVProgressHUD dismiss];
        }];
    }];
}

- (void)preparingValueWithCompletion:(void(^)())block{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    __block SurveyFormViewController *weakSelf = self;
    __block NSError *_error = nil;
    
    if (self.list) {
        dispatch_group_enter(group);
        [SurveyModel getSurveyWithID:self.list.primaryKey completion:^(NSDictionary *response, NSError *error) {
            if (error) _error = error;
            if (response) [weakSelf.valueDictionary addEntriesFromDictionary:response];
            
            dispatch_group_leave(group);
        }];
    }
    
    dispatch_group_notify(group, queue, ^{
        [weakSelf checkError:_error completion:^{
            if (block) block();
        }];
    });
}

- (void)preparingFormDescriptorWithCompletion:(void(^)())block{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    __block SurveyFormViewController *weakSelf = self;
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
                if ([row.tag isEqualToString:@"tambahInformasiSurveyLingkungan"]){
                    row.action.formSelector = @selector(addDataButtonClicked:);
                }
                if ([row.tag isEqualToString:@"hapusInformasiSurveyLingkungan"]){
                    row.action.formSelector = @selector(deleteDataButtonClicked:);
                }
                if ([row.tag isEqualToString:@"tanggalSurvey"]) {
                    if ([[row cellForFormController:self] isKindOfClass:XLFormDateCell.class]){
                        [(XLFormDateCell *)[row cellForFormController:self] setMaximumDate:[NSDate date]];
                        [(XLFormDateCell *)[row cellForFormController:self] setMinimumDate:[NSDate date]];
                    }
                }
                
                if (self.isReadOnly) {
                    row.disabled = @YES;
                    
                    [self reloadFormRow:row];
                } else {
                    if (![row.tag isEqualToString:@"namaCalonDebitur"] && ![row.tag isEqualToString:@"namaSurveyor"]) {
                        
                    } else {
                        row.disabled = @YES;
                        
                        [self reloadFormRow:row];
                    }
                }
                
                [self otherAdditionalSettingFor:row];
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

- (void)otherAdditionalSettingFor:(XLFormRowDescriptor *)row{
    NSArray *tagForKeyboardNumberPad = [NSArray arrayWithObjects:
                                        @"jumlahOrang", @"lamaTinggal",
                                        nil];
    if ([tagForKeyboardNumberPad containsObject:row.tag]){
        //Set keyboard type to numberPad
        if ([[row cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
            [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setKeyboardType:UIKeyboardTypeNumberPad];
        }
    }
    
    if ([row.tag isEqualToString:@"nama"]){
        if ([[row cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
            [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setMustAlphabetOnly:YES];
        }
    }
    if ([row.tag isEqualToString:@"jumlahOrang"]){
        if ([[row cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
            [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setMaximumLength:4];
        }
    }
    if ([row.tag isEqualToString:@"lamaTinggal"]){
        if ([[row cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
            [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setMaximumLength:2];
        }
    }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveButtonClicked:(id)sender{
    [self resignFirstResponder];
    
    NSArray *inputErrors = [self validateForm];
    if (inputErrors.count > 0) {
        [SVProgressHUD showErrorWithStatus:((NSError *)inputErrors.firstObject).localizedDescription];
        [SVProgressHUD dismissWithDelay:1.5];
    } else {
    
        NSMutableArray *dataArray = [NSMutableArray array];
        for (XLFormSectionDescriptor *section in self.form.formSections) {
            if ([section.title isEqualToString:@"Informasi Survey Lingkungan"]) {
                NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
                [FormModel saveValueFromSection:section to:dictionary];
                [dataArray addObject:dictionary];
            } else {
                [FormModel saveValueFromSection:section to:self.valueDictionary];
            }
        }
        [self.valueDictionary setObject:dataArray forKey:@"informanSurvey"];
        
        [SVProgressHUD show];
        [SurveyModel postSurveyWithList:self.list dictionary:self.valueDictionary completion:^(NSDictionary *dictionary, NSError *error) {
            if (error == nil) {
                [SVProgressHUD dismiss];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
                [SVProgressHUD dismissWithDelay:1.5];
            }
        }];
    }
}

- (void)addDataButtonClicked:(id)sender{
    XLFormSectionDescriptor *section = [self.form formSectionAtIndex:2];
    XLFormSectionDescriptor *newSection = [XLFormSectionDescriptor formSectionWithTitle:section.title];
    for (XLFormRowDescriptor *row in section.formRows) {
        XLFormRowDescriptor *newRow = [XLFormRowDescriptor formRowDescriptorWithTag:row.tag rowType:row.rowType title:row.title];
        newRow.required = row.required;
        newRow.disabled = row.disabled;
        newRow.hidden = row.hidden;
        newRow.selectorTitle = row.selectorTitle;
        newRow.selectorOptions = row.selectorOptions;
        [self otherAdditionalSettingFor:newRow];
        
        [newSection addFormRow:newRow];
    }
    [self.form addFormSection:newSection atIndex:self.form.formSections.count -2];
}

- (void)deleteDataButtonClicked:(id)sender{
    XLFormSectionDescriptor *section = [self.form.formSections objectAtIndex:self.form.formSections.count - 3];
    if (self.form.formSections.count > 5 && section && [section.title isEqualToString:@"Informasi Survey Lingkungan"]) {
        [self.form removeFormSection:section];
    }
}
- (void)formRowDescriptorValueHasChanged:(XLFormRowDescriptor *)formRow oldValue:(id)oldValue newValue:(id)newValue {
    if ([formRow.tag isEqualToString:@"alamatSurveyDitemukan"]) {
        if ([newValue integerValue] == 1) {
            XLFormRowDescriptor *row = [self.form formRowWithTag:@"penjelasan"];
            row.hidden = @(1);
            [self reloadFormRow:row];
        } else {
            XLFormRowDescriptor *row = [self.form formRowWithTag:@"penjelasan"];
            row.hidden = @(0);
            [self reloadFormRow:row];
        }
    }
    if ([formRow.tag isEqualToString:@"fasilitasRumah"]) {
        NSMutableArray *arrayOfValue = [NSMutableArray array];
        for (id value in newValue) {
            id tempValue = value;
            if ([value isKindOfClass:XLFormOptionsObject.class]) {
                tempValue = ((XLFormOptionsObject*)value).valueData;
            }
            
            [arrayOfValue addObject:tempValue];
        }
        
        if ([arrayOfValue containsObject:@(348)]) {
            XLFormRowDescriptor *row = [self.form formRowWithTag:@"fasilitasRumahLainnya"];
            row.hidden = @NO;
            [self reloadFormRow:row];
        } else {
            XLFormRowDescriptor *row = [self.form formRowWithTag:@"fasilitasRumahLainnya"];
            row.hidden = @YES;
            [self reloadFormRow:row];
        }
    }
    if ([formRow.tag isEqualToString:@"patokanDktRmh"]) {
        NSMutableArray *arrayOfValue = [NSMutableArray array];
        for (id value in newValue) {
            id tempValue = value;
            if ([value isKindOfClass:XLFormOptionsObject.class]) {
                tempValue = ((XLFormOptionsObject*)value).valueData;
            }
            
            [arrayOfValue addObject:tempValue];
        }
        
        if ([arrayOfValue containsObject:@(347)]) {
            XLFormRowDescriptor *row = [self.form formRowWithTag:@"patokanDktRmhLainnya"];
            row.hidden = @NO;
            [self reloadFormRow:row];
        } else {
            XLFormRowDescriptor *row = [self.form formRowWithTag:@"patokanDktRmhLainnya"];
            row.hidden = @YES;
            [self reloadFormRow:row];
        }
    }
}

- (void)setRightBarButton{
    if (!self.isReadOnly) {
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save"
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(saveButtonClicked:)];
        [self.navigationItem setRightBarButtonItem:barButtonItem];
    }
}

- (NSArray *)validateForm {
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
