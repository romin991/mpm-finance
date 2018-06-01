//
//  BarcodeViewController.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 7/14/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "BarcodeViewController.h"

@interface BarcodeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *qrCoreImageView;
@property (weak, nonatomic) IBOutlet UIImageView *barcodeImageView;
@property (weak, nonatomic) IBOutlet UILabel *barcodeLabel;

@end

@implementation BarcodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.qrCoreImageView.image = [MPMGlobal qrCodeFromString:self.barcodeString];
    self.barcodeImageView.image = [MPMGlobal barcodeFromString:self.barcodeString];
    self.barcodeLabel.text = self.barcodeString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)finishButtonClicked:(id)sender {
    [self.delegate finish];
    [self dismissViewControllerAnimated:YES completion:nil];
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
