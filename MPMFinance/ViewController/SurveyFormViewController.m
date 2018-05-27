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
        if ([self.title isEqualToString:@"Data Keluarga"]) {
            NSInteger familyCount = ((NSArray *)[self.valueDictionary objectForKey:@"dataKeluarga"]).count;
            for (int i = 1; i < familyCount; i++){
                [self addDataButtonClicked:nil];
            }
        }
        
        for (XLFormSectionDescriptor *section in _formDescriptor.formSections) {
            for (XLFormRowDescriptor *row in section.formRows) {
                if ([row.tag isEqualToString:@"tambahInformasiSurveyLingkungan"]){
                    row.action.formSelector = @selector(addDataButtonClicked:);
                }
                if ([row.tag isEqualToString:@"hapusInformasiSurveyLingkungan"]){
                    row.action.formSelector = @selector(deleteDataButtonClicked:);
                }
                
                if (self.isReadOnly) {
                    row.disabled = @YES;
                    [self reloadFormRow:row];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveButtonClicked:(id)sender{
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
        
//        if ([newRow.tag isEqualToString:@"nomorIndukKependudukan"]){
//            //Set keyboard type to numberPad
//            if ([[row cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
//                [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setKeyboardType:UIKeyboardTypeNumberPad];
//            }
//        }
        
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

- (void)setRightBarButton{
    if (!self.isReadOnly) {
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save"
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(saveButtonClicked:)];
        [self.navigationItem setRightBarButtonItem:barButtonItem];
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
