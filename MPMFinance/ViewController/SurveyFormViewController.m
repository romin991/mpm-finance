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
    Form *currentForm = [self.forms objectAtIndex:self.index];
    
    [self setTitle:self.menu.title];
    [self setRightBarButton];
    
    [SVProgressHUD show];
    __block SurveyFormViewController *weakSelf = self;
    [FormModel generate:self.form form:currentForm completion:^(XLFormDescriptor *formDescriptor, NSError *error) {
        [weakSelf checkError:error completion:^{
            if (weakSelf.valueDictionary.count > 0){
                weakSelf.form = formDescriptor;
                [weakSelf postProcessFormDescriptorWithCompletion:^(NSError *error) {
                    [weakSelf checkError:error completion:^{
                        [FormModel loadValueFrom:weakSelf.valueDictionary on:weakSelf partialUpdate:nil];
                        [SVProgressHUD dismiss];
                        
                    }];
                }];
                
            } else if (weakSelf.list) {
                weakSelf.form = formDescriptor;
                [weakSelf postProcessFormDescriptorWithCompletion:^(NSError *error) {
                    [weakSelf checkError:error completion:^{
                        [SurveyModel getSurveyWithID:weakSelf.list.primaryKey completion:^(NSDictionary *dictionary, NSError *error) {
                            if (error == nil) {
                                if (dictionary) {
                                    weakSelf.valueDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
                                    [FormModel loadValueFrom:weakSelf.valueDictionary on:weakSelf partialUpdate:nil];
                                }
                                [SVProgressHUD dismiss];
                                
                            } else {
                                [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
                                [SVProgressHUD dismissWithDelay:1.5 completion:^{
                                    [weakSelf.navigationController popViewControllerAnimated:YES];
                                }];
                            }
                        }];
                    }];
                }];
                
            } else {
                //something wrong i think
                [SVProgressHUD showErrorWithStatus:@"Data Not Found"];
                [SVProgressHUD dismissWithDelay:1.5 completion:^{
                    [self.navigationController popViewControllerAnimated:YES];
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
        block();
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveButtonClicked:(id)sender{
    [FormModel saveValueFrom:self.form to:self.valueDictionary];
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
    if (!self.isReadOnly) {
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save"
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(saveButtonClicked:)];
        [self.navigationItem setRightBarButtonItem:barButtonItem];
    }
}

- (void)postProcessFormDescriptorWithCompletion:(void(^)(NSError *error))block{
    for (XLFormSectionDescriptor *section in self.form.formSections) {
        for (XLFormRowDescriptor *row in section.formRows) {
            if (self.isReadOnly) {
                row.disabled = @YES;
                [self reloadFormRow:row];
            }
        }
    }
    
    if (block) block(nil);
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
