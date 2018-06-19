//
//  MyProfileTableViewController.m
//  MPMFinance
//
//  Created by Romin Adi Santoso on 5/17/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "MyProfileTableViewController.h"
#import <APAvatarImageView.h>
#import <UIImageView+AFNetworking.h>
#import "ChangePasswordViewController.h"
#import "MenuNavigationViewController.h"

@interface MyProfileTableViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtNamaCabang;
@property (weak, nonatomic) IBOutlet APAvatarImageView *profilePictureImageView;
@property (weak, nonatomic) IBOutlet UITextField *txtDateOfBirth;
@property (weak, nonatomic) IBOutlet UITextField *txtPhoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtFullName;
@property (weak, nonatomic) IBOutlet UITextField *txtIdCardNumber;
@property (weak, nonatomic) IBOutlet UITextField *txtUserID;
@property (weak, nonatomic) IBOutlet UITextField *txtTempatLahir;
@property (weak, nonatomic) IBOutlet UITextField *txtAddress;
@property (weak, nonatomic) IBOutlet UITextField *txtAddressDealer;
@property (weak, nonatomic) IBOutlet UITextField *txtGender;
@property (weak, nonatomic) IBOutlet UITextField *txtNamaDealer;
@property (weak, nonatomic) IBOutlet UIButton *changePasswordButton;

@property NSString* fileName;
@property NSString* fileSize;
@property NSString* fileType;
@property NSString* fileMimeType;
@property BOOL isEdit;
@property NSData* imgData;

@end

@implementation MyProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(onDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.txtDateOfBirth.inputView = datePicker;
    self.isEdit = NO;
    self.profilePictureImageView.borderColor = [UIColor orangeColor];
    self.profilePictureImageView.borderWidth = 1;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    
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

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setTextFieldsEnable:NO];
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    [manager GET:[MPMUserInfo getUserInfo][@"photo"] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        self.profilePictureImageView.image = [UIImage imageWithData:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    self.txtEmail.text = [MPMUserInfo getUserInfo][@"email"];
    self.txtFullName.text = [MPMUserInfo getUserInfo][@"username"];
    self.txtUserID.text = [MPMUserInfo getUserInfo][@"userId"];
    self.txtPhoneNumber.text = [MPMUserInfo getUserInfo][@"phone"];
    self.txtAddress.text = [MPMUserInfo getUserInfo][@"address"];
    self.txtDateOfBirth.text = [MPMUserInfo getUserInfo][@"dob"];
    self.txtIdCardNumber.text = [MPMUserInfo getUserInfo][@"ktp"];
    self.txtTempatLahir.text = [MPMUserInfo getUserInfo][@"placeOfBirth"];
    self.txtNamaDealer.text = [MPMUserInfo getUserInfo][@"dealer_name"];
    self.txtAddressDealer.text = [MPMUserInfo getUserInfo][@"dealer_address"];
    self.txtNamaCabang.text = [MPMUserInfo getUserInfo][@"namaCabang"];
    self.txtGender.text = [MPMUserInfo getUserInfo][@"gender"];
    
}

- (IBAction)goToChangePasswordPage:(id)sender {
    ChangePasswordViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangePasswordViewController"];
    [self.navigationController.navigationController.navigationController pushViewController:vc animated:YES];
//    [self performSegueWithIdentifier:@"changePasswordSegue" sender:nil];
}

- (IBAction)logOut:(id)sender {
    NSLog(@"logout");
    [MPMUserInfo deleteUserInfo];
    self.txtEmail.text = @"";
    self.txtFullName.text = @"";
    self.txtDateOfBirth.text = @"";
    self.txtIdCardNumber.text = @"";
    
    if (self.menuViewDelegate) [self.menuViewDelegate selectMenuAtIndex:kHome];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [super tableView:tableView heightForRowAtIndexPath:indexPath];
    if (indexPath.section == 1 && indexPath.row == 0) { //nama cabang
        if ([[MPMUserInfo getRole] isEqualToString:kRoleCustomer] ||
            [[MPMUserInfo getRole] isEqualToString:kRoleDealer] ||
            [[MPMUserInfo getRole] isEqualToString:kRoleAgent]) {
            height = 0;
        }
    }
    
    if (indexPath.section == 1 && indexPath.row == 3) { //no KTP
        if ([[MPMUserInfo getRole] isEqualToString:kRoleDedicated] ||
            [[MPMUserInfo getRole] isEqualToString:kRoleSupervisor] ||
            [[MPMUserInfo getRole] isEqualToString:kRoleBM] ||
            [[MPMUserInfo getRole] isEqualToString:kRoleOfficer]) {
            height = 0;
        }
    }
    
    if (indexPath.section == 1 && indexPath.row == 4) { //nama dealer
        if ([[MPMUserInfo getRole] isEqualToString:kRoleCustomer] ||
            [[MPMUserInfo getRole] isEqualToString:kRoleAgent] ||
            [[MPMUserInfo getRole] isEqualToString:kRoleDedicated] ||
            [[MPMUserInfo getRole] isEqualToString:kRoleSupervisor] ||
            [[MPMUserInfo getRole] isEqualToString:kRoleBM] ||
            [[MPMUserInfo getRole] isEqualToString:kRoleOfficer]) {
            height = 0;
        }
    }
    
    if (indexPath.section == 1 && indexPath.row == 7) { //tanggal lahir
        if ([[MPMUserInfo getRole] isEqualToString:kRoleDedicated] ||
            [[MPMUserInfo getRole] isEqualToString:kRoleSupervisor] ||
            [[MPMUserInfo getRole] isEqualToString:kRoleBM] ||
            [[MPMUserInfo getRole] isEqualToString:kRoleOfficer]) {
            height = 0;
        }
    }
    
    if (indexPath.section == 1 && indexPath.row == 8) { //tempat lahir
        if ([[MPMUserInfo getRole] isEqualToString:kRoleDedicated] ||
            [[MPMUserInfo getRole] isEqualToString:kRoleSupervisor] ||
            [[MPMUserInfo getRole] isEqualToString:kRoleBM] ||
            [[MPMUserInfo getRole] isEqualToString:kRoleOfficer]) {
            height = 0;
        }
    }
    
    if (indexPath.section == 1 && indexPath.row == 9) { //alamat
        if ([[MPMUserInfo getRole] isEqualToString:kRoleDedicated] ||
            [[MPMUserInfo getRole] isEqualToString:kRoleSupervisor] ||
            [[MPMUserInfo getRole] isEqualToString:kRoleBM] ||
            [[MPMUserInfo getRole] isEqualToString:kRoleOfficer]) {
            height = 0;
        }
    }
    
    if (indexPath.section == 1 && indexPath.row == 10) { //alamat dealer
        if ([[MPMUserInfo getRole] isEqualToString:kRoleCustomer] ||
            [[MPMUserInfo getRole] isEqualToString:kRoleAgent] ||
            [[MPMUserInfo getRole] isEqualToString:kRoleDedicated] ||
            [[MPMUserInfo getRole] isEqualToString:kRoleSupervisor] ||
            [[MPMUserInfo getRole] isEqualToString:kRoleBM] ||
            [[MPMUserInfo getRole] isEqualToString:kRoleOfficer]) {
            height = 0;
        }
    }
    
    if (indexPath.section == 1 && indexPath.row == 11) { //jenis kelamin
        if ([[MPMUserInfo getRole] isEqualToString:kRoleDedicated] ||
            [[MPMUserInfo getRole] isEqualToString:kRoleSupervisor] ||
            [[MPMUserInfo getRole] isEqualToString:kRoleBM] ||
            [[MPMUserInfo getRole] isEqualToString:kRoleOfficer]) {
            height = 0;
        }
    }
    return height;
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
    NSString *fileName = [NSString stringWithFormat:@"%ld%c%c.jpg", (long)[[NSDate date] timeIntervalSince1970], arc4random_uniform(26) + 'a', arc4random_uniform(26) + 'a'];
    
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    self.imgData = data;
    self.fileName = fileName;
    
    [self.profilePictureImageView setImage:image];
}

- (IBAction)editSave:(id)sender {
    if (!_isEdit) {
        [self setTextFieldsEnable:YES];
        [((UIButton * )sender) setTitle:@"SAVE" forState:UIControlStateNormal];
        _isEdit = YES;
        
    } else {
        _isEdit = NO;
        [self setTextFieldsEnable:NO];
        [((UIButton * )sender) setTitle:@"EDIT" forState:UIControlStateNormal];
        NSDictionary *param = @{
                                @"userid": [MPMUserInfo getUserInfo][@"userId"],
                                @"token": [MPMUserInfo getToken],
                                @"data": @{
                                        @"ktp": self.txtIdCardNumber.text,
                                        @"username": self.txtFullName.text,
                                        @"email": self.txtEmail.text,
                                        @"dob": self.txtDateOfBirth.text,
                                        @"placeOfBirth": self.txtTempatLahir.text,
                                        @"address": self.txtAddress.text,
                                        @"gender": self.txtGender.text,
                                        @"phone": self.txtPhoneNumber.text,
                                        @"photo": [MPMGlobal encodeToBase64String:self.profilePictureImageView.image]
                                        }
                                };
        AFHTTPSessionManager *manager = [MPMGlobal sessionManager];
        [manager POST:[NSString stringWithFormat:@"%@/profile/update",kApiUrl] parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
            ;
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@",responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] != nil) {
                NSDictionary *errorDict = [NSJSONSerialization JSONObjectWithData:error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] options:0 error:nil];
                UIAlertController* alertVC = [UIAlertController alertControllerWithTitle:@"Error" message:errorDict[@"message"] preferredStyle:UIAlertControllerStyleAlert];
                [alertVC addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
                [super presentViewController:alertVC animated:YES completion:nil];
                return;
            } else {
                UIAlertController* alertVC = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                [alertVC addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
//                __block UITextField *oldPasswordField;
//                [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//                    oldPasswordField = textField;
//                }];
//
                [super presentViewController:alertVC animated:YES completion:nil];
                return;
            }
            
        }];
        
    }
}
- (void)setTextFieldsEnable:(BOOL)enable{
    [_txtDateOfBirth setEnabled:enable];
    [_txtPhoneNumber setEnabled:enable];
    [_txtEmail setEnabled:enable];
    [_txtFullName setEnabled:enable];
    [_txtIdCardNumber setEnabled:enable];
    [_txtTempatLahir setEnabled:enable];
    [_txtAddress setEnabled:enable];
    [_txtAddressDealer setEnabled:enable];
    [_txtGender setEnabled:enable];
    [_txtNamaDealer setEnabled:enable];
}

-(void)onDatePickerValueChanged:(UIDatePicker*)datePicker
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-YYYY"];
    self.txtDateOfBirth.text = [dateFormatter stringFromDate:datePicker.date];
    
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
