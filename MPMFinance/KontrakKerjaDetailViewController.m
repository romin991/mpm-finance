//
//  KontrakKerjaDetailViewController.m
//  MPMFinance
//
//  Created by Romin Adi Santoso on 5/6/18.
//  Copyright © 2018 MPMFinance. All rights reserved.
//

#import "KontrakKerjaDetailViewController.h"
#import "QRCodeGenerator.h"
@interface KontrakKerjaDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblTotalTerlambat;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalDenda;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewQR;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewBarcode;
@property (weak, nonatomic) IBOutlet UILabel *noKontrak;
@property (weak, nonatomic) IBOutlet UILabel *jenisAset;
@property (weak, nonatomic) IBOutlet UILabel *warna;
@property (weak, nonatomic) IBOutlet UILabel *nomorPlat;
@property (weak, nonatomic) IBOutlet UILabel *estimasiAngsuran;
//{
//    "statusCode": 200,
//    "status": "success",
//    "message": "List data",
//    "data": {
//        "agreementNo": "5392017111000106",
//        "desc": "",
//        "color": "",
//        "licPlate": "",
//        "installmentAmmount": 2773500,
//        "totLCDays": 0,
//        "totLCAmount": 0,
//        "message": "Success",
//        "noreg": 83900001050
//    }
//}
@end

@implementation KontrakKerjaDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageViewQR.image = [[[QRCodeGenerator alloc] initWithString:[self.data[@"noreg"] stringValue]] getImage];
    self.imageViewBarcode.image = [UIImage imageWithCIImage: [self generateBarcode:[self.data[@"noreg"] stringValue]]];
    self.lblTotalDenda.text = [NSString stringWithFormat:@"Rp. %@",[MPMGlobal formatToMoney:self.data[@"installmentAmmount"]]];
    self.noKontrak.text = [self.data[@"noreg"] stringValue];
    self.warna.text = self.data[@"color"];
    self.nomorPlat.text = self.data[@"licPlate"];
    self.lblTotalTerlambat.text = [self.data[@"totLCDays"] stringValue];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CIImage*)generateBarcode:(NSString*)dataString{
    
    CIFilter *barCodeFilter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    NSData *barCodeData = [dataString dataUsingEncoding:NSASCIIStringEncoding];
    [barCodeFilter setValue:barCodeData forKey:@"inputMessage"];
    [barCodeFilter setValue:[NSNumber numberWithFloat:0] forKey:@"inputQuietSpace"];
    
    CIImage *barCodeImage = barCodeFilter.outputImage;
    return barCodeImage;
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
