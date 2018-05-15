//
//  ViewController.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 5/10/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "LoginViewController.h"
#import <AFNetworking.h>
#import "MPMUserInfo.h"
#import "RegisterViewController.h"
#import "ProfileModel.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UIButton *forgotPasswordButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
 spv :
 marketing_spv_mobile/password
 marketing :
 officer_spv_mobile/password
 officer_spv_mobile_2/password
 marketing_dedicated_mobile / password
 vika@gmail.com / password
 hadi / password
 */

- (IBAction)signInButtonClicked:(id)sender {
    if (self.usernameField.text.length < 1) {
        return;
    }
    if (self.passwordField.text.length < 1) {
        return;
    }
    
    [SVProgressHUD show];
    [ProfileModel login:self.usernameField.text password:self.passwordField.text completion:^(NSDictionary *dictionary, NSError *error) {
        [SVProgressHUD dismiss];
        if (!error) {
            [SVProgressHUD showSuccessWithStatus:@"Login Success"];
            [SVProgressHUD dismissWithDelay:1.5 completion:^{
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
        } else {
            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
            [SVProgressHUD dismissWithDelay:1.5];
        }
    }];
}

- (IBAction)forgotPasswordButtonClicked:(id)sender {
}

- (IBAction)registerButtonClicked:(id)sender {
    [self performSegueWithIdentifier:@"signUpSegue" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"signUpSegue"]){
        RegisterViewController *vc = (RegisterViewController *)segue.destinationViewController;
        vc.menuViewDelegate = self.menuViewDelegate;
        
    }
}

@end
