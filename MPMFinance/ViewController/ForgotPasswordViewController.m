//
//  ForgotPasswordViewController.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 5/10/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "APIModel.h"
@interface ForgotPasswordViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UIButton *resetPasswordButton;


@end

@implementation ForgotPasswordViewController
- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
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

- (IBAction)resetPasswordButtonClicked:(id)sender {
    [APIModel forgotPasswordWithUserName:self.usernameField.text withCompletion:^(NSString *responseString, NSError *error) {
        if (!error) {
            [SVProgressHUD showWithStatus:responseString];
            [SVProgressHUD dismissWithDelay:1.5];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            [SVProgressHUD dismissWithDelay:1.5];
        }
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
