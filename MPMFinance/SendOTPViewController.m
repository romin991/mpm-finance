//
//  sendOTPViewController.m
//  MPMFinance
//
//  Created by Romin Adi Santoso on 6/20/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "SendOTPViewController.h"
#import "ProfileModel.h"

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

- (void)loginAndClose{
    [SVProgressHUD show];
    [ProfileModel login:self.userId password:self.password completion:^(NSDictionary *dictionary, NSError *error) {
        if (!error) {
            [SVProgressHUD showSuccessWithStatus:@"Login Success"];
            [SVProgressHUD dismissWithDelay:1.5 completion:^{
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
        } else {
            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
            [SVProgressHUD dismissWithDelay:1.5];
        }
        
        if (self.menuViewDelegate) [self.menuViewDelegate dismissAll];
    }];
}

- (IBAction)submit:(id)sender {
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    [manager POST:[NSString stringWithFormat:@"%@/register/inputotp",kApiUrl] parameters:@{@"userid" : self.userId,@"token" : @"",@"data" : @{@"otp" : self.txtCode.text, @"deviceId" : @"fcmid here",@"loginFrom" : @"mobile"}} progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self loginAndClose];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ;
    }];
    
}
- (IBAction)back:(id)sender {
  [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)resend:(id)sender {
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    [manager POST:[NSString stringWithFormat:@"%@/register/resendotp",kApiUrl] parameters:@{@"userid" : self.userId,@"token" : @""} progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
      UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Status" message:responseObject[@"message"] preferredStyle:UIAlertControllerStyleAlert];
      UIAlertAction* okButton = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil];
      [alertController addAction:okButton];
      [self presentViewController:alertController animated:YES completion:nil];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
      UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
      UIAlertAction* okButton = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil];
      [alertController addAction:okButton];
      [self presentViewController:alertController animated:YES completion:nil];
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
