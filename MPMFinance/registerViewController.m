//
//  registerViewController.m
//  MPMFinance
//
//  Created by Romin Adi Santoso on 5/22/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "registerViewController.h"
#import <APAvatarImageView.h>
#import "sendOTPViewController.h"
#import <AFHTTPSessionManager.h>
@interface registerViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
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

@implementation registerViewController

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
    
    
    [self.profilePictureImageView setBorderColor:[UIColor orangeColor]];
    // Do any additional setup after loading the view.
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

-(BOOL)validate
{
    if (self.txtFirstName.text.length < 1) {
        return NO;
    }
    else if (self.txtLastName.text.length < 1) {
        return NO;
    }
    else if (self.txtEmail.text.length < 1) {
        return NO;
    }
    else if (self.txtAddress.text.length < 1) {
        return NO;
    }
    else if (self.txtNoTelpon.text.length < 1) {
        return NO;
    }
    else if (self.txtDateOfBirth.text.length < 1) {
        return NO;
    }
    else if (self.txtIDCardNumber.text.length < 1) {
        return NO;
    }
    else if (self.txtPassword.text.length < 1) {
        return NO;
    }
    else if (self.txtConfirmPassword.text.length < 1) {
        return NO;
    }
    else if (self.txtJenisKelamin.text.length < 1) {
        return NO;
    }
    else if (![self.txtPassword.text isEqualToString:self.txtConfirmPassword.text]) {
        return NO;
    }
    else if(self.imgDataString.length < 1)
    {
        return 0;
    }
    else
        return YES;
    
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
    if (![self validate]) {
        [SVProgressHUD dismiss];
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Success" message:@"Register Success" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* okButton = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];;
        }];
        [alertController addAction:okButton];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    NSDictionary* param = @{@"userid" : @"",
                            @"token" : @"",
                            @"data" : @{@"username" : [NSString stringWithFormat:@"%@ %@",self.txtFirstName.text,self.txtLastName.text],
                                        @"ktp" : self.txtIDCardNumber.text,
                                        @"password" : self.txtPassword.text,
                                        @"dob" : self.txtDateOfBirth.text,
                                        @"placeOfBirth" : self.txtPlaceOfBirth.text,
                                        @"address" : self.txtAddress.text,
                                        @"gender" : self.txtJenisKelamin.text,
                                        @"phone" : self.txtNoTelpon.text,
                                        @"groupLevel" : self.selectedGroupLevel,
                                        @"photo" : self.imgDataString,
                                        @"email" : self.txtEmail.text}};
    NSLog(@"%@",param);
    
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    [manager POST:[NSString stringWithFormat:@"%@/register",kApiUrl] parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        [SVProgressHUD dismiss];
        if ([responseObject[@"statusCode"] isEqualToString:@"200"]) {
            UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Success" message:@"Register Success" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* okButton = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self performSegueWithIdentifier:@"sendOTPViewController" sender:self];
            }];
            [alertController addAction:okButton];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        
        ;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [SVProgressHUD dismiss];
        ;
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"sendOTPViewController"]) {
        sendOTPViewController *vc = [segue destinationViewController];
        vc.userId = self.txtEmail.text;
    }
}


@end
