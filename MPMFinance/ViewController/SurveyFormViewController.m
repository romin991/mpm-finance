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

@interface SurveyFormViewController ()

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property RLMResults *forms;
@property RLMArray *formRows;
@property XLFormDescriptor *formDescriptor;
@property XLFormViewController *formViewController;

@end

@implementation SurveyFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.forms = [Form getFormForMenu:self.menu.title];
    Form *currentForm = [self.forms objectAtIndex:self.index];
    if (self.forms.count > self.index) self.formRows = currentForm.rows;
    
    [self setTitle:self.menu.title];
    [self setRightBarButton];
    
    [SVProgressHUD show];
    [self generateFormDescriptorWithCompletion:^(NSError *error) {
        if (error){
            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
            [SVProgressHUD dismissWithDelay:1.5 completion:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
        } else if (self.valueDictionary.count > 0){
            [self setFormValueWithDictionary:self.valueDictionary];
            [SVProgressHUD dismiss];
            
        } else if (self.list) {
            __block SurveyFormViewController *weakSelf = self;
            [SurveyModel getSurveyWithID:self.list.primaryKey completion:^(NSDictionary *dictionary, NSError *error) {
                if (error == nil) {
                    if (dictionary) {
                        weakSelf.valueDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
                        [weakSelf setFormValueWithDictionary:weakSelf.valueDictionary];
                    }
                    [SVProgressHUD dismiss];
                    
                } else {
                    [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
                    [SVProgressHUD dismissWithDelay:1.5 completion:^{
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                }
            }];
            
        } else {
            //something wrong i think
            [SVProgressHUD dismiss];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setFormValueWithDictionary:(NSDictionary *)dictionary{
    for (XLFormSectionDescriptor *section in self.formDescriptor.formSections) {
        for (XLFormRowDescriptor *row in section.formRows) {
            NSString *value;
            if ([dictionary objectForKey:row.tag]){
                value = [dictionary objectForKey:row.tag];
            }
            if (value){
                if ([row.rowType isEqualToString:XLFormRowDescriptorTypeDateInline]){
                    row.value = [MPMGlobal dateFromString:value];
                } else if ([row.rowType isEqualToString:XLFormRowDescriptorTypeSelectorPush]){
                    row.value = [XLFormOptionsObject formOptionsOptionForValue:value fromOptions:row.selectorOptions];
                } else {
                    row.value = value;
                }
            }
            
            [self.formViewController reloadFormRow:row];
        }
    }
}

- (void)saveValueToDictionary{
    for (XLFormSectionDescriptor *section in self.formDescriptor.formSections) {
        for (XLFormRowDescriptor *row in section.formRows) {
            if (self.valueDictionary == nil) self.valueDictionary = [NSMutableDictionary dictionary];
            id object;
            if ([row.rowType isEqualToString:XLFormRowDescriptorTypeDateInline]){
                object = [MPMGlobal stringFromDate:row.value];
            } else if ([row.rowType isEqualToString:XLFormRowDescriptorTypeSelectorPush]){
                object = ((XLFormOptionsObject *) row.value).formValue;
            } else {
                object = row.value;
            }
            
            if (object) [self.valueDictionary setObject:object forKey:row.tag];
        }
    }
}

- (void)saveButtonClicked:(id)sender{
    [self saveValueToDictionary];
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

- (void)setRightBarButton{
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(saveButtonClicked:)];
    [self.navigationItem setRightBarButtonItem:barButtonItem];
}

- (void)generateFormDescriptorWithCompletion:(void(^)(NSError *error))block{
    __block dispatch_group_t group = dispatch_group_create();
    __block dispatch_queue_t queue = dispatch_get_main_queue();
    __block NSError *weakError;
    
    // Form
    self.formDescriptor = [XLFormDescriptor formDescriptorWithTitle:@"Text Fields"];
    XLFormSectionDescriptor *section;
    
    // Section
    section = [XLFormSectionDescriptor formSection];
    [self.formDescriptor addFormSection:section];
    
    // Row
    for (FormRow *formRow in self.formRows) {
        __block XLFormRowDescriptor *row = [XLFormRowDescriptor formRowDescriptorWithTag:formRow.key rowType:formRow.type title:formRow.title];
        row.required = formRow.required;
        row.disabled = @(formRow.disabled);
        row.selectorTitle = formRow.title;
        [section addFormRow:row];
        
        if (formRow.optionType.length) {
            dispatch_group_enter(group);
            NSLog(@"enter");
            [DropdownModel getDropdownForType:formRow.optionType completion:^(NSArray *options, NSError *error) {
                @try {
                    if (error) {
                        weakError = error;
                        
                    } else {
                        NSMutableArray *optionObjects = [NSMutableArray array];
                        for (Option *option in options) {
                            [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@(option.primaryKey) displayText:option.name]];
                        }
                        row.selectorOptions = optionObjects;
                    }
                    
                } @catch (NSException *exception) {
                    NSLog(@"%@", exception);
                } @finally {
                    dispatch_group_leave(group);
                    NSLog(@"leave");
                }
            }];
        }
    }
    
    dispatch_group_notify(group, queue, ^{
        if (block) block(weakError);
    });
}

- (void)viewDidLayoutSubviews{
    XLFormViewController *formViewController = [[XLFormViewController alloc] init];
    formViewController.form = self.formDescriptor;
    self.formViewController = formViewController;
    
    [self addChildViewController:formViewController];
    formViewController.view.frame = self.containerView.frame;
    [self.view addSubview:formViewController.view];
    [formViewController didMoveToParentViewController:self];
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
