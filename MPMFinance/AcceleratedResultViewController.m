//
//  AcceleratedResultViewController.m
//  MPMFinance
//
//  Created by Romin Adi Santoso on 19/09/18.
//  Copyright © 2018 MPMFinance. All rights reserved.
//

#import "AcceleratedResultViewController.h"

@interface AcceleratedResultViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblNamaDebitur;
@property (weak, nonatomic) IBOutlet UILabel *lblNomorKontrak;
@property (weak, nonatomic) IBOutlet UILabel *lblTanggalPelunasan;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalAngsuran;
@property (weak, nonatomic) IBOutlet UILabel *lblPembayaranYangDiterima;
@property (weak, nonatomic) IBOutlet UILabel *lblDiskon;
@property (weak, nonatomic) IBOutlet UILabel *lblDendaKeterlambatan;
@property (weak, nonatomic) IBOutlet UILabel *lblBiayaVisit;
@property (weak, nonatomic) IBOutlet UILabel *lblBiayaPickUp;
@property (weak, nonatomic) IBOutlet UILabel *lblTotal;

@end

@implementation AcceleratedResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  [self setupDataWithDictionary:self.dict andTanggalnya:self.tanggal];
  UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
  self.navigationItem.leftBarButtonItem = backButton;
}
- (void)back:(id)sender {
  [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
}

- (void)setupDataWithDictionary:(NSDictionary *)dict andTanggalnya:(NSDate *)tanggal{
  self.lblNamaDebitur.text = dict[@"customerName"];
  self.lblTotal.text = [MPMGlobal formatToRupiah:[dict[@"totalInstallmentToBePaid"] stringValue]];
  self.lblDiskon.text = [MPMGlobal formatToRupiah:[dict[@"totalDiscount"] stringValue]];
  self.lblBiayaVisit.text = [MPMGlobal formatToRupiah:[dict[@"visitFee"] stringValue]];
  self.lblBiayaPickUp.text = [MPMGlobal formatToRupiah:[dict[@"pickUpFee"] stringValue]];
  self.lblNomorKontrak.text = dict[@"agreementNo"];
  self.lblTotalAngsuran.text = [MPMGlobal formatToRupiah:[dict[@"installmentAmount"] stringValue]];
  self.lblTanggalPelunasan.text = [MPMGlobal stringFromDate2:tanggal];
  
  self.lblDendaKeterlambatan.text = [MPMGlobal formatToRupiah:[dict[@"lcinstallment"] stringValue]];
  self.lblPembayaranYangDiterima.text = [MPMGlobal formatToRupiah:[dict[@"installmentDuePaid"] stringValue]];
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
