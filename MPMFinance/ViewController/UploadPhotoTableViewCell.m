//
//  UploadPhotoTableViewCell.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 21/05/18.
//  Copyright © 2018 MPMFinance. All rights reserved.
//

#import "UploadPhotoTableViewCell.h"
#import "AFImageDownloader.h"
#import "EXPhotoViewer.h"
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
    if ([self.rowDescriptor.value isKindOfClass:NSString.class]) {
        if ([MPMGlobal isStringAnURL:self.rowDescriptor.value]) {
                        AFImageDownloader *imageDownloader = [AFImageDownloader   defaultInstance];
          
                        NSURLCache *urlCache = imageDownloader.sessionManager.session.configuration.URLCache;
          
                        [urlCache removeAllCachedResponses];
          
                        [imageDownloader.imageCache removeImageWithIdentifier:self.rowDescriptor.value];
            NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.rowDescriptor.value]
                                                          cachePolicy:NSURLRequestReloadRevalidatingCacheData
                                                      timeoutInterval:60];
            
            __weak typeof(self) weakSelf = self;
            [[AFImageDownloader defaultInstance] downloadImageForURLRequest:imageRequest success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull responseObject) {
                weakSelf.pictureImageView.image = responseObject;
            } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                
            }];
        } else {
            UIImage *image = [MPMGlobal decodeFromBase64String:self.rowDescriptor.value];
            if (image) {
                self.pictureImageView.image = image;
            }
        }
    }
}

- (IBAction)takePicture:(id)sender {
  
  if (self.pictureImageView.image) {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"" message:@"Pilih Opsi:" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *takePhoto = [UIAlertAction actionWithTitle:@"Ambil Gambar" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
      [SVProgressHUD show];
      UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
      imagePickerController.delegate = self;
      imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
      [self.formViewController presentViewController:imagePickerController animated:true completion:^{
        [SVProgressHUD dismiss];
      }];
    }];
    UIAlertAction *zoom = [UIAlertAction actionWithTitle:@"Lihat Gambar" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
      [EXPhotoViewer showImageFrom:self.pictureImageView];
      return;
    }];
    if (!self.isViewOnly) {
      [controller addAction:takePhoto];
    }
    [controller addAction:zoom];
    [self.formViewController presentViewController:controller animated:YES completion:nil];
    
  }
  
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:^(void){
        self.pictureImageView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        self.rowDescriptor.value = [MPMGlobal encodeToBase64String:self.pictureImageView.image];
    }];
}

@end
