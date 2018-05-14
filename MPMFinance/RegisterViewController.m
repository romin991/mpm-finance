//
//  registerViewController.m
//  MPMFinance
//
//  Created by Romin Adi Santoso on 5/22/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "RegisterViewController.h"
#import <APAvatarImageView.h>
#import "SendOTPViewController.h"
#import <AFHTTPSessionManager.h>

@interface RegisterViewController ()
<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet APAvatarImageView *profilePictureImageView;
@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;
@property (weak, nonatomic) IBOutlet UITextField *txtIDCardNumber;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtDateOfBirth;
@property (weak, nonatomic) IBOutlet UITextField *txtPlaceOfBirth;
@property (weak, nonatomic) IBOutlet UITextField *txtAddress;
@property (weak, nonatomic) IBOutlet UITextField *txtJenisKelamin;
@property (weak, nonatomic) IBOutlet UITextField *txtNoTelpon;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirmPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtGroupLevel;
@property NSString* fileName;
@property NSString* fileSize;
@property NSString* fileType;
@property NSString* fileMimeType;
@property NSString* imgDataString;
@property NSString* selectedGroupLevel;

@property UIPickerView* genderPicker;
@property UIPickerView* groupLevelPicker;

@property NSArray *genderArray;
@property NSArray *groupLevelArray;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _genderArray = @[@"male", @"female"];
    _groupLevelArray = @[@{@"name" : @"Customer",
                           @"code" : @"2"},
                         @{@"name" : @"Agent",
                           @"code" : @"3"},
                         @{@"name" : @"Dealer",
                           @"code" : @"4"}];
    UIDatePicker* datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(onDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.txtDateOfBirth.inputView = datePicker;
    self.genderPicker = [[UIPickerView alloc] init];
    self.genderPicker.dataSource = self;
    self.genderPicker.delegate = self;
    self.txtJenisKelamin.inputView = self.genderPicker;
    
    self.groupLevelPicker = [[UIPickerView alloc] init];
    self.groupLevelPicker.dataSource = self;
    self.groupLevelPicker.delegate = self;
    self.txtGroupLevel.inputView = self.groupLevelPicker;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    gesture.numberOfTapsRequired = 1;
    gesture.numberOfTouchesRequired = 1;
    [gesture setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:gesture];

    [self.profilePictureImageView setBorderColor:[UIColor orangeColor]];
    // Do any additional setup after loading the view.
}
- (void)handleTap
{
    [self.view endEditing:YES];
    // Handle the tap if you want to
}
-(void)onDatePickerValueChanged:(UIDatePicker*)datePicker
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    self.txtDateOfBirth.text = [dateFormatter stringFromDate:datePicker.date];

}
-(void)viewWillAppear:(BOOL)animated
{
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, 1300);
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)changeProfilePicture:(id)sender {
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Pilih Dokumen"
                                 message:@"Pilih Sumber Dokumen"
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* galleryButton = [UIAlertAction
                                    actionWithTitle:@"Gallery"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                        picker.delegate = self;
                                        picker.allowsEditing = YES;
                                        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                        [self presentViewController:picker animated:YES completion:NULL];
                                        
                                    }];
    UIAlertAction* cameraButton = [UIAlertAction
                                   actionWithTitle:@"Camera"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                       picker.delegate = self;
                                       picker.allowsEditing = YES;
                                       picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                       [self presentViewController:picker animated:YES completion:NULL];
                                       
                                   }];
    UIAlertAction* cancelButton = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                   }];
    
    [alert addAction:cameraButton];
    [alert addAction:galleryButton];
    [alert addAction:cancelButton];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    self.imgDataString = [MPMGlobal encodeToBase64String:image];
    
    [self.profilePictureImageView setImage:image];
    
}

#pragma mark - UIPickerDataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == self.genderPicker) {
        return self.genderArray.count;
    }
    else if (pickerView == self.groupLevelPicker) {
        return self.groupLevelArray.count;
    }
    else
        return 0;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == self.genderPicker) {
        return self.genderArray[row];
    }
    else if(pickerView == self.groupLevelPicker) {
        return self.groupLevelArray[row][@"name"];
    }
    else
        return @"";
}

#pragma mark - UIPickerDelegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView == self.genderPicker) {
        self.txtJenisKelamin.text = self.genderArray[row];
    }
    else if (pickerView == self.groupLevelPicker) {
        self.txtGroupLevel.text = self.groupLevelArray[row][@"name"];
        _selectedGroupLevel = self.groupLevelArray[row][@"code"];
    }
}


- (IBAction)signUp:(id)sender {
    [SVProgressHUD show];
    NSDictionary* param;
    @try {
        param = @{@"userid" : @"",
                            @"token" : @"",
                            @"data" : @{@"username" : [NSString stringWithFormat:@"%@ %@",self.txtFirstName.text,self.txtLastName.text],
                                        @"ktp" : self.txtIDCardNumber.text,
                                        @"password" : self.txtPassword.text,
                                        @"dob" : self.txtDateOfBirth.text,
                                        @"placeOfBirth" : self.txtPlaceOfBirth.text,
                                        @"address" : self.txtAddress.text,
                                        @"gender" : self.txtJenisKelamin.text,
                                        @"phone" : self.txtNoTelpon.text,
                                        @"groupLevel" : self.selectedGroupLevel ? self.selectedGroupLevel : @"",
                                        @"email" : self.txtEmail.text}};
    } @catch(NSException *exception) {
        NSLog(@"%@", exception);
    }
    NSLog(@"%@",param);
    
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    [manager POST:[NSString stringWithFormat:@"%@/register",kApiUrl] parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        [SVProgressHUD dismiss];
        @try {
            if ([responseObject[@"statusCode"] integerValue] == 200) {
                UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Success" message:@"Register Success" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* okButton = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [self performSegueWithIdentifier:@"sendOTPViewController" sender:self];
                }];
                [alertController addAction:okButton];
                [self presentViewController:alertController animated:YES completion:nil];
            }
        
        } @catch(NSException *exception) {
            NSLog(@"%@", exception);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        @try {
            NSError *errorParser;
            NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] options:NSJSONReadingAllowFragments error:&errorParser];
            NSString *errorMessage = [responseObject objectForKey:@"message"];
            [SVProgressHUD showErrorWithStatus:errorMessage];
            [SVProgressHUD dismissWithDelay:1.5];
            
        } @catch(NSException *exception) {
            NSLog(@"%@", exception);
        }
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"sendOTPViewController"]) {
        SendOTPViewController *vc = [segue destinationViewController];
        vc.userId = self.txtEmail.text;
        vc.password = self.txtPassword.text;
        vc.menuViewDelegate = self.menuViewDelegate;
    }
}


@end
