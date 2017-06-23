//
//  CreditSimulationViewController.m
//  MPMFinance
//
//  Created by Romin Adi Santoso on 6/3/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "CreditSimulationViewController.h"

@interface CreditSimulationViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtHarga;
@property (weak, nonatomic) IBOutlet UITextField *txtLamaPembiayaan;
@property (weak, nonatomic) IBOutlet UITextField *txtUangMuka; // nilai pembiayaan di dahsyat2w dan 4w
@property (weak, nonatomic) IBOutlet UITextField *txtTotalBayarAwal;
@property (weak, nonatomic) IBOutlet UITextField *txtAngsuran;
@property (weak, nonatomic) IBOutlet UIButton *btnPengajuan;

@property (weak, nonatomic) IBOutlet UILabel *lblTotalBayarAwal;
@property (weak, nonatomic) IBOutlet UILabel *lblDP;
@property (weak, nonatomic) IBOutlet UILabel *lblAngsuran;
@end

@implementation CreditSimulationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self refreshUI];
    // Do any additional setup after loading the view.
}
-(void)refreshUI
{
    if ([self.menuType isEqualToString:kSubmenuCreditSimulationNewBike] || [self.menuType isEqualToString:kSubmenuCreditSimulationNewCar] || [self.menuType isEqualToString:kSubmenuCreditSimulationUsedCar]) {
        self.lblDP.hidden = YES;
        self.txtUangMuka.hidden = YES;
        self.txtTotalBayarAwal.enabled = NO;
        self.txtAngsuran.enabled = NO;
    }
    else if ([self.menuType isEqualToString:kSubmenuCreditSimulationDahsyat2W] || [self.menuType isEqualToString:kSubmenuCreditSimulationDahsyat4W]) {
        self.lblDP.hidden = NO;
        self.lblDP.text = @"Nilai Pembiayaan";
        self.txtUangMuka.hidden = NO;
        self.txtTotalBayarAwal.enabled = NO;
        self.txtAngsuran.enabled = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)hitung:(id)sender {
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    NSString* urlString;
    NSDictionary* param;
    if ([self.menuType isEqualToString:kSubmenuCreditSimulationNewBike]) {
        urlString = [NSString stringWithFormat:@"%@/simulation/newbike",kApiUrl];
        param = @{@"lamaPembiayaan" : self.txtLamaPembiayaan.text,
                  @"hargaKendaraan" : self.txtHarga.text};
    }
    else if ([self.menuType isEqualToString:kSubmenuCreditSimulationNewCar] || [self.menuType isEqualToString:kSubmenuCreditSimulationUsedCar]) {
        urlString = [NSString stringWithFormat:@"%@/simulation/mycar",kApiUrl];
        param = @{@"jenisKendaraan" : self.menuType,
                  @"lamaPembiayaan" : self.txtLamaPembiayaan.text,
                  @"hargaKendaraan" : self.txtHarga.text};
    }
    else if ([self.menuType isEqualToString:kSubmenuCreditSimulationDahsyat2W]) {
        urlString = [NSString stringWithFormat:@"%@/simulation/dahsyat2w",kApiUrl];
        param = @{@"nilaiPencairan" : self.txtUangMuka.text,
                  @"lamaPembiayaan" : self.txtLamaPembiayaan.text,
                  @"hargaKendaraan" : self.txtHarga.text};
    }
    else if ([self.menuType isEqualToString:kSubmenuCreditSimulationDahsyat4W]) {
        urlString = [NSString stringWithFormat:@"%@/simulation/dahsyat4w",kApiUrl];
        param = @{@"nilaiPencairan" : self.txtUangMuka.text,
                  @"lamaPembiayaan" : self.txtLamaPembiayaan.text,
                  @"hargaKendaraan" : self.txtHarga.text};
    }
    else if ([self.menuType isEqualToString:kSubmenuCreditSimulationProperty]) {
        urlString = [NSString stringWithFormat:@"%@/simulation/property",kApiUrl];
    }
    
    [manager POST:urlString parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"statusCode"] isEqual:@200]) {
            
            self.txtAngsuran.text = responseObject[@"data"][@"angsuran"];
            self.txtTotalBayarAwal.text = responseObject[@"data"][@"nilaiPembiayaan"];
            [self.btnPengajuan setHidden:NO];
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ;
    }];
    
}
- (IBAction)pengajuan:(id)sender {
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
