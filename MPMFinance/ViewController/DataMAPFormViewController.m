//
//  DataMAPFormViewController.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 6/6/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "DataMAPFormViewController.h"
#import <XLForm.h>
#import "Form.h"
#import "DropdownModel.h"
#import "FormModel.h"
#import "FloatLabeledTextFieldCell.h"
#import "ProfileModel.h"

@interface DataMAPFormViewController ()

@property RLMResults *forms;

@end

@implementation DataMAPFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    // Do any additional setup after loading the view from its nib.
    
    self.forms = [Form getFormForMenu:self.menu.primaryKey];
    Form *currentForm = [self.forms objectAtIndex:self.index];
    
    [self setTitle:self.menu.title];
    
    [SVProgressHUD show];
    __block DataMAPFormViewController *weakSelf = self;
    [FormModel generate:self.form form:currentForm completion:^(XLFormDescriptor *formDescriptor, NSError *error) {
        [weakSelf checkError:error completion:^{
            weakSelf.form = formDescriptor;
            [weakSelf postProcessFormDescriptorWithCompletion:^(NSError *error) {
                [weakSelf checkError:error completion:^{
                    [FormModel loadValueFrom:weakSelf.valueDictionary on:weakSelf partialUpdate:nil];
                }];
            }];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveButtonClicked:(id)sender{
    [FormModel saveValueFrom:self.form to:self.valueDictionary];
    if (self.delegate) [self.delegate saveDictionary:self.valueDictionary];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)postProcessFormDescriptorWithCompletion:(void(^)(NSError *error))block{
    __block dispatch_group_t group = dispatch_group_create();
    __block dispatch_queue_t queue = dispatch_get_main_queue();
    __block NSError *weakError;
    NSString *idCabang = [self.valueDictionary objectForKey:@"kodeCabang"] ?: @"";
    NSString *idProduct = [self.valueDictionary objectForKey:@"product"] ?: @"";
    
    for (XLFormSectionDescriptor *section in self.form.formSections) {
        for (XLFormRowDescriptor *row in section.formRows) {
            if ([row.tag isEqualToString:@"submit"]){
                row.action.formSelector = @selector(saveButtonClicked:);
            }
            
            if ([row.tag isEqualToString:@"jenisAplikasi"]){
                dispatch_group_enter(group);
                [DropdownModel getDropdownWSType:@"jenisAplikasi" keyword:@"" idCabang:idCabang completion:^(NSArray *options, NSError *error) {
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
            
            if ([row.tag isEqualToString:@"sourceOfApplication"]){
                dispatch_group_enter(group);
                [DropdownModel getDropdownWSType:@"SourceOfApplication" keyword:@"" idProduct:idProduct idCabang:idCabang completion:^(NSArray *options, NSError *error) {
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
            
            if ([row.tag isEqualToString:@"productOffering"]){
                dispatch_group_enter(group);
                [DropdownModel getDropdownWSType:@"Product" keyword:@"" idCabang:idCabang completion:^(NSArray *options, NSError *error) {
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
    }
    
    dispatch_group_notify(group, queue, ^{
        if (block) block(weakError);
    });
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
