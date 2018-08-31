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
#import "NJOPasswordStrengthEvaluator.h"
@interface ChangePasswordViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *oldPasswordField;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (readwrite, nonatomic, strong) NJOPasswordValidator *strictValidator;
@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.strictValidator = [NJOPasswordValidator validatorWithRules:@[[NJOLengthRule ruleWithRange:NSMakeRange(6, 64)], [NJORequiredCharacterRule lowercaseCharacterRequiredRule], [NJORequiredCharacterRule uppercaseCharacterRequiredRule], [NJORequiredCharacterRule symbolCharacterRequiredRule],[NJORequiredCharacterRule decimalDigitCharacterRequiredRule]]];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(BOOL)isValidPassword:(NSString *)checkString{
    
    NSArray *failingRules = nil;
    if([self.strictValidator validatePassword:checkString failingRules:&failingRules]){
        return YES;
    } else {
        for (id <NJOPasswordRule> rule in failingRules) {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"• %@\n", [rule localizedErrorDescription]]];
            [SVProgressHUD dismissWithDelay:1.5];
            break;
        }
        
        return NO;
    }
    
}
- (IBAction)save:(id)sender {
  
  if (![[MPMGlobal MD5fromString:self.oldPasswordField.text] isEqualToString:[MPMUserInfo getPassword]]) {
    [SVProgressHUD showErrorWithStatus:@"Old Password is not matched"];
    [SVProgressHUD dismissWithDelay:1.5];
    return;
  }
  if (![self isValidPassword:self.passwordField.text]) {
    return;
    
  }
        [SVProgressHUD show];
        [ProfileModel changePassword:self.oldPasswordField.text password:self.passwordField.text completion:^(NSDictionary *dictionary, NSError *error) {
            [SVProgressHUD dismiss];
            if (!error) {
                [SVProgressHUD showSuccessWithStatus:@"Change Password Success"];
                [SVProgressHUD dismissWithDelay:1.5 completion:^{
                  [self.navigationController popViewControllerAnimated:YES];
                }];
            } else {
                [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
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
