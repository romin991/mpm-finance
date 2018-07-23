//
//  CreditSimulationViewController.m
//  MPMFinance
//
//  Created by Romin Adi Santoso on 6/3/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "CreditSimulationViewController.h"
#import "Menu.h"
#import "FormViewController.h"
@interface CreditSimulationViewController ()<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *lblPencairan;
@property (weak, nonatomic) IBOutlet UITextField *txtHarga;
@property (weak, nonatomic) IBOutlet UITextField *txtLamaPembiayaan;
@property (weak, nonatomic) IBOutlet UITextField *txtUangMuka; // nilai pembiayaan di dahsyat2w dan 4w
@property (weak, nonatomic) IBOutlet UILabel *txtTotalBayarAwal;
@property (weak, nonatomic) IBOutlet UILabel *txtAngsuran;
@property (weak, nonatomic) IBOutlet UIButton *btnPengajuan;
@property (weak, nonatomic) IBOutlet UITextField *txtJenisPerhitungan;

@property (weak, nonatomic) IBOutlet UILabel *lblDP;
@property NSNumber *harga;
@property (weak, nonatomic) IBOutlet UILabel *lblAngsuran;
@property (weak, nonatomic) IBOutlet UILabel *lblJenisHitung;
@property UIPickerView *tenorPickerView;
@property UIPickerView *jenisHitungPickerView;
@property NSArray *tenors;
@property NSArray *jenisHitungs;
@end

@implementation CreditSimulationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",self.menuType);
    self.tenors = @[@12,@18,@24,@30,@36];
    self.jenisHitungs = @[@"Estimasi Harga", @"Estimasi Angsuran"];
    [self refreshUI];
    self.tenorPickerView = [[UIPickerView alloc] init];
    self.tenorPickerView.delegate = self;
    self.tenorPickerView.dataSource = self;
    self.txtLamaPembiayaan.inputView = self.tenorPickerView;
    
   
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
#pragma mark UIPickerViewDelegate
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == _tenorPickerView) {
        return self.tenors.count;
    } else {
        return self.jenisHitungs.count;
    }
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == self.tenorPickerView) {
        return [self.tenors[row] stringValue];
    } else {
        return self.jenisHitungs[row];
    }
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView == self.tenorPickerView) {
        self.txtLamaPembiayaan.text =  [self.tenors[row] stringValue];
    } else {
        
        self.txtJenisPerhitungan.text = self.jenisHitungs[row];
        if ([self.txtJenisPerhitungan.text isEqualToString:@"Estimasi Harga"]) {
            self.lblAngsuran.text = @"Estimasi Angsuran";
            self.lblJenisHitung.text = @"Estimasi Harga";
        } else {
            self.lblJenisHitung.text = @"Estimasi Angsuran";
            self.lblAngsuran.text = @"Estimasi Harga";
        }
    }
}
-(void)refreshUI
{
    
    if ([self.menuType isEqualToString:@"Dahsyat - Multiguna Motor"] || [self.menuType isEqualToString:@"Dahsyat - Multiguna Mobil"]) {
        self.lblDP.hidden = NO;
        self.lblDP.text = @"Nilai Pembiayaan";
        self.txtUangMuka.hidden = NO;
        self.lblPencairan.text = @"Nilai Pencairan";
        self.lblAngsuran.text = @"Pencairan Maksimal";
        self.txtJenisPerhitungan.delegate = self;
    }
    else {
        if ([self.menuType isEqualToString:@"Pembiayaan Motor Baru"]) {
            [self.lblDP setHidden:YES];
          self.txtUangMuka.hidden = YES;
          
        }
        self.jenisHitungPickerView = [[UIPickerView alloc] init];
        self.jenisHitungPickerView.delegate = self;
        self.jenisHitungPickerView.dataSource = self;
        self.txtJenisPerhitungan.inputView = self.jenisHitungPickerView;
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
- (NSString *)formatToRupiah:(NSNumber *)charge{
    
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    [nf setGroupingSeparator:@"."];
    nf.usesGroupingSeparator = YES;
    nf.numberStyle = NSNumberFormatterDecimalStyle;
    [nf setMaximumFractionDigits:0];
    nf.roundingMode = NSNumberFormatterRoundHalfUp;
    return [nf stringFromNumber:charge];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)hitung:(id)sender {
    if (self.txtJenisPerhitungan.text.length < 1) {
        return;
    }
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    NSString* urlString;
    BOOL isDahsyat = NO;
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    NSDictionary *biayaTenor;
    if ([self.txtJenisPerhitungan.text isEqualToString:@"Estimasi Harga"]) {
        if (!_harga || self.txtLamaPembiayaan.text.length < 1) {
            return;
        }
        biayaTenor = @{@"hargaKendaraan" : _harga,
                       @"angsuran" : @"",
                       @"lamaPembiayaan" : self.txtLamaPembiayaan.text
                       };
    } else if([self.txtJenisPerhitungan.text isEqualToString:@"Estimasi Angsuran"]) {
        if (!_harga || self.txtLamaPembiayaan.text.length < 1) {
            return;
        }
        biayaTenor = @{@"angsuran" : _harga,
                       @"hargaKendaraan" : @"",
                       @"lamaPembiayaan" : self.txtLamaPembiayaan.text
                       };
    } else {
        if (!_harga || self.txtLamaPembiayaan.text.length < 1) {
            return;
        }
        biayaTenor = @{@"nilaiPencairan" : _txtJenisPerhitungan.text,
                       @"hargaKendaraan" : _harga,
                       @"lamaPembiayaan" : self.txtLamaPembiayaan.text
                       };
    }
    [param addEntriesFromDictionary:biayaTenor];
    if ([self.menuType isEqualToString:@"Pembiayaan Motor Baru"]) {
        urlString = [NSString stringWithFormat:@"%@/simulation/newbike",kApiUrl];
        param = [NSMutableDictionary dictionaryWithDictionary:biayaTenor];
    }
    else if ([self.menuType isEqualToString:@"Pembiayaan Mobil Baru"] || [self.menuType isEqualToString:@"Pembiayaan Mobil Bekas"]) {
        urlString = [NSString stringWithFormat:@"%@/simulation/mycar",kApiUrl];
        [param addEntriesFromDictionary:@{@"jenisKendaraan" : self.menuType
                                          }];
    }
    else if ([self.menuType isEqualToString:@"Dahsyat - Multiguna Motor"]) {
        urlString = [NSString stringWithFormat:@"%@/simulation/dahsyat2w",kApiUrl];
        isDahsyat = YES;
    }
    else if ([self.menuType isEqualToString:@"Dahsyat - Multiguna Mobil"]) {
        urlString = [NSString stringWithFormat:@"%@/simulation/dahsyat4w",kApiUrl];
        isDahsyat = YES;
    
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
            if (isDahsyat) {
                self.txtTotalBayarAwal.text = [self formatToRupiah:responseObject[@"data"][@"pencairanMaks"]];
            } else if ([self.txtJenisPerhitungan.text isEqualToString:@"Estimasi Angsuran"]) {
              self.txtTotalBayarAwal.text = [self formatToRupiah:responseObject[@"data"][@"hargaKendaraan"]];
            } else
                self.txtTotalBayarAwal.text = [self formatToRupiah:responseObject[@"data"][@"totalBayarAwal"]];
            [self.btnPengajuan setHidden:NO];
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ;
    }];
    
}
- (IBAction)pengajuan:(id)sender {
    Menu *menu = [Menu getMenuForPrimaryKey:kSubmenuListOnlineSubmission];
    
    FormViewController *formViewController = [[FormViewController alloc] init];
    formViewController.menu = menu;
    formViewController.list = nil;
    [self.navigationController pushViewController:formViewController animated:YES];
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
