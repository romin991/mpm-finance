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
#import "SendOTPViewController.h"
@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UIButton *forgotPasswordButton;
@property (weak, nonatomic) IBOutlet UILabel *backButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    gesture.numberOfTapsRequired = 1;
    gesture.numberOfTouchesRequired = 1;
    [gesture setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:gesture];
    // Do any additional setup after loading the view.
}
- (void)handleTap
{
    [self.view endEditing:YES];
    // Handle the tap if you want to
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
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)resetPassword:(id)sender {
    
}

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
              [self.loginDelegate loginDidSuccess];
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
        } else if ([error.localizedDescription isEqualToString:@"input otp"]) {
          [self performSegueWithIdentifier:@"sendOTPViewController" sender:self];
        }else {
            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
            [SVProgressHUD dismissWithDelay:1.5];
        }
    }];
}
- (IBAction)showHidePassword:(id)sender {
    [((UIButton *)sender) setTitle:self.passwordField.isSecureTextEntry?@"Hide" : @"Show" forState:UIControlStateNormal];
    self.passwordField.secureTextEntry = !self.passwordField.isSecureTextEntry;
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
        
    } else if ([segue.identifier isEqualToString:@"sendOTPViewController"]) {
      SendOTPViewController *vc = [segue destinationViewController];
      vc.userId = self.usernameField.text;
      vc.password = self.passwordField.text;
      vc.menuViewDelegate = self.menuViewDelegate;
    }
}

@end
