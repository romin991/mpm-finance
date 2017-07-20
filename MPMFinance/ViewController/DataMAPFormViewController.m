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
            if (weakSelf.valueDictionary.count > 0){
                [FormModel loadValueFrom:weakSelf.valueDictionary on:weakSelf partialUpdate:nil];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveButtonClicked:(id)sender{
    [FormModel saveValueFrom:self.form to:self.valueDictionary];
    if (self.delegate) [self.delegate saveDictionary:self.valueDictionary];
    [self.navigationController popViewControllerAnimated:YES];
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
