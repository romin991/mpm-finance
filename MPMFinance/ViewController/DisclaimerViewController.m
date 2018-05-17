//
//  DisclaimerViewController.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 5/16/18.
//  Copyright © 2018 MPMFinance. All rights reserved.
//

#import "DisclaimerViewController.h"
#import "WorkOrderModel.h"
#import "BarcodeViewController.h"
#import "SubmenuViewController.h"

@interface DisclaimerViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, BarcodeDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *agreeButton;
@property (weak, nonatomic) IBOutlet UIButton *disagreeButton;

@property BOOL isAgree;

@end

@implementation DisclaimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.isAgree = false;
    [self refreshSelected];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectImage:(id)sender {
    [SVProgressHUD show];
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:imagePickerController animated:true completion:^{
        [SVProgressHUD dismiss];
    }];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:^(void){
        self.imageView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    }];
}

- (IBAction)agree:(id)sender {
    self.isAgree = true;
    [self refreshSelected];
}

- (IBAction)disagree:(id)sender {
    self.isAgree = false;
    [self refreshSelected];
}

- (void)refreshSelected{
    if (self.isAgree) {
        self.agreeButton.selected = true;
        self.disagreeButton.selected = false;
    } else {
        self.agreeButton.selected = false;
        self.disagreeButton.selected = true;
    }
}

- (IBAction)submit:(id)sender {
    [self.valueDictionary addEntriesFromDictionary:@{@"ttd" : [MPMGlobal encodeToBase64String:self.imageView.image],
                                                     @"pernyataanPemohon" : @(self.isAgree),
                                                     }];
    
    [SVProgressHUD show];
    [WorkOrderModel postListWorkOrder:self.list dictionary:self.valueDictionary completion:^(NSDictionary *dictionary, NSError *error) {
        if (error == nil) {
            if (dictionary) {
                @try {
                    NSString *noRegistrasi = [[dictionary objectForKey:@"data"] objectForKey:@"noRegistrasi"];
                    
                    BarcodeViewController *barcodeVC = [[BarcodeViewController alloc] init];
                    barcodeVC.barcodeString = noRegistrasi;
                    barcodeVC.modalPresentationStyle = UIModalPresentationFullScreen;
                    barcodeVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                    barcodeVC.delegate = self;
                    
                    [self presentViewController:barcodeVC animated:YES completion:nil];
                } @catch (NSException *exception) {
                    NSLog(@"%@", exception);
                }
            }
            [SVProgressHUD dismiss];
        } else {
            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
            [SVProgressHUD dismissWithDelay:1.5];
        }
    }];
}

#pragma mark - Barcode Delegate
- (void)finish{
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[SubmenuViewController class]]) {
            [self.navigationController popToViewController:vc animated:NO];
        }
    }
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
