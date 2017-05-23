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

- (IBAction)signInButtonClicked:(id)sender {
    if (self.usernameField.text.length < 1) {
        return;
    }
    if (self.passwordField.text.length < 1) {
        return;
    }
    NSDictionary* param = @{@"userid" : self.usernameField.text,
                            @"token" : @"",
                            @"data" : @{
                                    @"password" : self.passwordField.text,
                                    @"deviceId" : @"fcmid here",
                                    @"loginFrom" : @"mobile"
                                    }
                            };
    NSLog(@"%@",param);
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    [manager POST:[NSString stringWithFormat:@"%@/login",kApiUrl] parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"status"] isEqualToString:@"success"]) {
            [MPMUserInfo save:responseObject[@"data"]];
            UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Success" message:@"Login Success" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* okButton = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self dismissViewControllerAnimated:YES completion:nil];;
            }];
            [alertController addAction:okButton];
            [self presentViewController:alertController animated:YES completion:nil];
        
        }
        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (IBAction)forgotPasswordButtonClicked:(id)sender {
}

@end
