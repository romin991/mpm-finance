//
//  ChangePasswordViewController.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 5/15/18.
//  Copyright © 2018 MPMFinance. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import <JVFloatLabeledTextField/JVFloatLabeledTextField.h>
#import "ProfileModel.h"

@interface ChangePasswordViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *oldPasswordField;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *passwordField;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *confirmPasswordField;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)save:(id)sender {
    if (![self.passwordField.text isEqualToString:self.confirmPasswordField.text]) {
        [SVProgressHUD showErrorWithStatus:@"Confirm password does not match"];
        [SVProgressHUD dismissWithDelay:1.5];
        
    } else {
        [SVProgressHUD show];
        [ProfileModel changePassword:self.oldPasswordField.text password:self.passwordField.text completion:^(NSDictionary *dictionary, NSError *error) {
            [SVProgressHUD dismiss];
            if (!error) {
                [SVProgressHUD showSuccessWithStatus:@"Change Password Success"];
                [SVProgressHUD dismissWithDelay:1.5 completion:^{
                    [self dismissViewControllerAnimated:YES completion:nil];
                }];
            } else {
                [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
                [SVProgressHUD dismissWithDelay:1.5];
            }
        }];
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
