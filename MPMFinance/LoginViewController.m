//
//  ViewController.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 5/10/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "LoginViewController.h"
#import <AFNetworking.h>
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
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [manager.requestSerializer setValue:@"Basic TVBNRmluYW5jZToxbmZvbWVkaWE=" forHTTPHeaderField:@"authorization"];

    [manager POST:[NSString stringWithFormat:@"%@/login",kApiUrl] parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (IBAction)forgotPasswordButtonClicked:(id)sender {
}

@end
