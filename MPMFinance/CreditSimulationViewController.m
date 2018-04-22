//
//  CreditSimulationViewController.m
//  MPMFinance
//
//  Created by Romin Adi Santoso on 6/3/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "CreditSimulationViewController.h"

@interface CreditSimulationViewController ()<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *txtHarga;
@property (weak, nonatomic) IBOutlet UITextField *txtLamaPembiayaan;
@property (weak, nonatomic) IBOutlet UITextField *txtUangMuka; // nilai pembiayaan di dahsyat2w dan 4w
@property (weak, nonatomic) IBOutlet UITextField *txtTotalBayarAwal;
@property (weak, nonatomic) IBOutlet UITextField *txtAngsuran;
@property (weak, nonatomic) IBOutlet UIButton *btnPengajuan;

@property (weak, nonatomic) IBOutlet UILabel *lblTotalBayarAwal;
@property (weak, nonatomic) IBOutlet UILabel *lblDP;
@property NSNumber *harga;
@property (weak, nonatomic) IBOutlet UILabel *lblAngsuran;
@property UIPickerView *tenorPickerView;
@end

@implementation CreditSimulationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self refreshUI];
    self.tenorPickerView = [[UIPickerView alloc] init];
    self.tenorPickerView.delegate = self;
    self.tenorPickerView.dataSource = self;
    self.txtLamaPembiayaan.inputView = self.tenorPickerView;
    // Do any additional setup after loading the view.
}
#pragma mark UIPickerViewDelegate
//-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
//{
//    
//}
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
    
    self.txtHarga.delegate = self;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // Create the decimal style formatter
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:10];
    
    // Combine the new text with the old; then remove any
    // commas from the textField before formatting
    NSString *combinedText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSString *numberWithoutCommas = [combinedText stringByReplacingOccurrencesOfString:@"," withString:@""];
    NSNumber *number = [formatter numberFromString:numberWithoutCommas];
    
    NSString *formattedString = [formatter stringFromNumber:number];
    
    // If the last entry was a decimal or a zero after a decimal,
    // re-add it here because the formatter will naturally remove
    // it.
    if ([string isEqualToString:@"."] &&
        range.location == textField.text.length) {
        formattedString = [formattedString stringByAppendingString:@"."];
    }
    
    _harga = number;
    textField.text = formattedString;
    return NO;
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
                  @"hargaKendaraan" : _harga};
    }
    else if ([self.menuType isEqualToString:kSubmenuCreditSimulationNewCar] || [self.menuType isEqualToString:kSubmenuCreditSimulationUsedCar]) {
        urlString = [NSString stringWithFormat:@"%@/simulation/mycar",kApiUrl];
        param = @{@"jenisKendaraan" : self.menuType,
                  @"lamaPembiayaan" : self.txtLamaPembiayaan.text,
                  @"hargaKendaraan" : _harga};
    }
    else if ([self.menuType isEqualToString:kSubmenuCreditSimulationDahsyat2W]) {
        urlString = [NSString stringWithFormat:@"%@/simulation/dahsyat2w",kApiUrl];
        param = @{@"nilaiPencairan" : self.txtUangMuka.text,
                  @"lamaPembiayaan" : self.txtLamaPembiayaan.text,
                  @"hargaKendaraan" : _harga};
    }
    else if ([self.menuType isEqualToString:kSubmenuCreditSimulationDahsyat4W]) {
        urlString = [NSString stringWithFormat:@"%@/simulation/dahsyat4w",kApiUrl];
        param = @{@"nilaiPencairan" : self.txtUangMuka.text,
                  @"lamaPembiayaan" : self.txtLamaPembiayaan.text,
                  @"hargaKendaraan" : _harga};
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
