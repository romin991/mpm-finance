//
//  sendOTPViewController.m
//  MPMFinance
//
//  Created by Romin Adi Santoso on 6/20/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "SendOTPViewController.h"

@interface SendOTPViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtCode;

@end

@implementation SendOTPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)submit:(id)sender {
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    [manager POST:[NSString stringWithFormat:@"%@/register/inputotp",kApiUrl] parameters:@{@"userid" : self.userId,@"token" : @"",@"data" : @{@"otp" : self.txtCode.text, @"deviceId" : @"fcmid here",@"loginFrom" : @"mobile"}} progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.menuViewDelegate) [self.menuViewDelegate dismissAll];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ;
    }];
    
}
- (IBAction)resend:(id)sender {
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    [manager POST:[NSString stringWithFormat:@"%@/register/resendotp",kApiUrl] parameters:@{@"userid" : self.userId,@"token" : @""} progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ;
    }];
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
