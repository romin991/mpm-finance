//
//  UploadPhotoTableViewCell.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 21/05/18.
//  Copyright © 2018 MPMFinance. All rights reserved.
//

#import "UploadPhotoTableViewCell.h"

NSString * const XLFormRowDescriptorTypeTakePhoto = @"XLFormRowDescriptorTypeTakePhoto";

@interface UploadPhotoTableViewCell()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *pictureImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *takePictureButton;

@end

@implementation UploadPhotoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.titleLabel.text = self.rowDescriptor.title;
}

- (IBAction)takePicture:(id)sender {
    [SVProgressHUD show];
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self.formViewController presentViewController:imagePickerController animated:true completion:^{
        [SVProgressHUD dismiss];
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:^(void){
        self.pictureImageView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        self.rowDescriptor.value = [MPMGlobal encodeToBase64String:self.pictureImageView.image];
    }];
}

@end
