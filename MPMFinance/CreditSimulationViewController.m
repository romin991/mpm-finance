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
@property (weak, nonatomic) IBOutlet UILabel *txtValue1;
@property (weak, nonatomic) IBOutlet UILabel *txtValue2;
@property (weak, nonatomic) IBOutlet UIButton *btnPengajuan;
@property (weak, nonatomic) IBOutlet UITextField *txtJenisPerhitungan;
@property NSNumber *tipeProduk;
@property (weak, nonatomic) IBOutlet UILabel *lblValue2;
@property NSNumber *harga;
@property NSNumber *harga2;
@property (weak, nonatomic) IBOutlet UILabel *lblValue1;
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
  
  if ([self.menuType isEqualToString:@"Pembiayaan Mobil Baru"] || [self.menuType isEqualToString:@"Pembiayaan Mobil Bekas"]) {
    self.tenors = @[@11,@12,@23,@24,@35,@36,@47,@48,@59,@60];
    
  }
  else if ([self.menuType isEqualToString:@"Dahsyat - Multiguna Motor"]) {
    self.tenors = @[@6,@10,@12,@18,@24];
    
  }
  else if ([self.menuType isEqualToString:@"Dahsyat - Multiguna Mobil"]) {
    self.tenors = @[@12,@24,@35,@48];
  }
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
      if ([self.menuType isEqualToString:@"Pembiayaan Motor Baru"]) {
        self.tipeProduk = @(1);
        if ([self.txtJenisPerhitungan.text isEqualToString:@"Estimasi Harga"]) {
          self.lblValue1.text = @"Estimasi Angsuran";
          self.lblJenisHitung.text = @"Estimasi Harga";
        } else {
          self.lblJenisHitung.text = @"Estimasi Angsuran";
          self.lblValue1.text = @"Estimasi Harga";
        }
      }
      else if ([self.menuType isEqualToString:@"Pembiayaan Mobil Baru"] || [self.menuType isEqualToString:@"Pembiayaan Mobil Bekas"]) {
        self.tenors = @[@11,@12,@23,@24,@35,@36,@47,@48,@59,@60];
        if ([self.menuType isEqualToString:@"Pembiayaan Mobil Baru"]) {
          self.tipeProduk = @(3);
        } else {
          self.tipeProduk = @(4);
        }
        if ([self.txtJenisPerhitungan.text isEqualToString:@"Estimasi Harga"]) {
          self.lblValue2.text = @"Estimasi Angsuran";
          self.lblJenisHitung.text = @"Estimasi Harga";
        } else {
          self.lblJenisHitung.text = @"Estimasi Angsuran";
          self.lblValue2.text = @"Estimasi Harga";
        }
      }
      else if ([self.menuType isEqualToString:@"Dahsyat - Multiguna Motor"]) {
        self.tenors = @[@6,@10,@12,@18,@24];
        self.tipeProduk = @(7);
        if ([self.txtJenisPerhitungan.text isEqualToString:@"Estimasi Harga"]) {
          self.lblValue2.text = @"Estimasi Angsuran";
          self.lblJenisHitung.text = @"Estimasi Harga";
        } else {
          self.lblJenisHitung.text = @"Estimasi Angsuran";
          self.lblValue2.text = @"Estimasi Harga";
        }
      }
      else if ([self.menuType isEqualToString:@"Dahsyat - Multiguna Mobil"]) {
        self.tenors = @[@12,@24,@35,@48];
        self.tipeProduk = @(8);
        if ([self.txtJenisPerhitungan.text isEqualToString:@"Estimasi Harga"]) {
          self.lblValue2.text = @"Estimasi Angsuran";
          self.lblJenisHitung.text = @"Estimasi Harga";
        } else {
          self.lblJenisHitung.text = @"Estimasi Angsuran";
          self.lblValue2.text = @"Estimasi Harga";
        }
        
      }
      else if ([self.menuType isEqualToString:kSubmenuCreditSimulationProperty]) {
        
      }
      
      
    }
}
-(void)refreshUI
{
    
    if ([self.menuType isEqualToString:@"Dahsyat - Multiguna Motor"] || [self.menuType isEqualToString:@"Dahsyat - Multiguna Mobil"]) {
        self.lblValue2.hidden = NO;
        self.lblValue2.text = @"Nilai Pembiayaan";
        self.txtUangMuka.hidden = NO;
        self.lblValue1.text = @"Pencairan Maksimal";
        self.txtJenisPerhitungan.delegate = self;
    }
    else {
        if ([self.menuType isEqualToString:@"Pembiayaan Motor Baru"]) {
            [self.lblValue2 setHidden:YES];
            self.txtValue2.hidden = YES;
          
        }
        self.jenisHitungPickerView = [[UIPickerView alloc] init];
        self.jenisHitungPickerView.delegate = self;
        self.jenisHitungPickerView.dataSource = self;
        self.txtJenisPerhitungan.inputView = self.jenisHitungPickerView;
    }
  
  
  if ([self.menuType isEqualToString:@"Pembiayaan Motor Baru"]) {
    self.lblValue1.text = @"Estimasi Angsuran";
  }
  else if ([self.menuType isEqualToString:@"Pembiayaan Mobil Baru"] || [self.menuType isEqualToString:@"Pembiayaan Mobil Bekas"]) {
    self.lblValue1.text = @"Total Bayar Awal";
    self.lblValue2.text = @"Angsuran";
  }
  else if ([self.menuType isEqualToString:@"Dahsyat - Multiguna Motor"]) {
    
  }
  else if ([self.menuType isEqualToString:@"Dahsyat - Multiguna Mobil"]) {
    
    
  }
  else if ([self.menuType isEqualToString:kSubmenuCreditSimulationProperty]) {
    
  }
  
    self.txtHarga.delegate = self;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // Create the decimal style formatter
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:10];
  [formatter setGroupingSeparator:@"."];
    // Combine the new text with the old; then remove any
    // commas from the textField before formatting
    NSString *combinedText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSString *numberWithoutCommas = [combinedText stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSNumber *number = [formatter numberFromString:numberWithoutCommas];
    
    NSString *formattedString = [formatter stringFromNumber:number];
  if ([[number stringValue] length] > 9) {
    return NO;
  }
    // If the last entry was a decimal or a zero after a decimal,
    // re-add it here because the formatter will naturally remove
    // it.
    if ([string isEqualToString:@"."] &&
        range.location == textField.text.length) {
        formattedString = [formattedString stringByAppendingString:@"."];
    }
  
  if ([textField isEqual:self.txtHarga]) {
    _harga = number;
  } else if ([textField isEqual:_txtJenisPerhitungan]) {
    _harga2 = number;
  }
  
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
- (BOOL)validate {
  BOOL isValid = YES;
  NSInteger estimasiHargaAtauAngsuran = [[self.txtHarga.text stringByReplacingOccurrencesOfString:@"." withString:@""] integerValue];
  if ([self.txtJenisPerhitungan.text isEqualToString:@"Estimasi Harga"]) {
    if ([self.menuType isEqualToString:@"Pembiayaan Motor Baru"] && estimasiHargaAtauAngsuran < 4200000) {
      [SVProgressHUD showErrorWithStatus:@"Estimasi Harga minimal 4.200.000"];
      isValid = NO;
    } else if ([self.menuType isEqualToString:@"Pembiayaan Mobil Baru"] && estimasiHargaAtauAngsuran < 17000000) {
      [SVProgressHUD showErrorWithStatus:@"Estimasi Harga minimal 17.000.000"];
      isValid = NO;
    }  else if ([self.menuType isEqualToString:@"Pembiayaan Mobil Bekas"] && estimasiHargaAtauAngsuran < 17000000) {
      [SVProgressHUD showErrorWithStatus:@"Estimasi Harga minimal 17.000.000"];
      isValid = NO;
    }
    
    
  } else if ([self.txtJenisPerhitungan.text isEqualToString:@"Estimasi Angsuran"]) {
    if ([self.menuType isEqualToString:@"Pembiayaan Motor Baru"] && estimasiHargaAtauAngsuran < 250000) {
      [SVProgressHUD showErrorWithStatus:@"Estimasi Angsuran minimal 250.000"];
      isValid = NO;
    } else if ([self.menuType isEqualToString:@"Pembiayaan Mobil Baru"] && estimasiHargaAtauAngsuran < 250000) {
      [SVProgressHUD showErrorWithStatus:@"Estimasi Angsuran minimal 250.000"];
      isValid = NO;
    }  else if ([self.menuType isEqualToString:@"Pembiayaan Mobil Bekas"] && estimasiHargaAtauAngsuran < 250000) {
      [SVProgressHUD showErrorWithStatus:@"Estimasi Angsuran minimal 250.000"];
      isValid = NO;
    }
  } else {
    if ([self.menuType isEqualToString:@"Dahsyat - Multiguna Motor"]) {
      NSInteger nilaiPencairan = [[self.txtJenisPerhitungan.text stringByReplacingOccurrencesOfString:@"." withString:@""] integerValue];
      if (estimasiHargaAtauAngsuran < 4200000) {
        [SVProgressHUD showErrorWithStatus:@"Estimasi Harga minimal 4.200.000"];
        isValid = NO;
      }
      else if (nilaiPencairan < 2500000) {
        [SVProgressHUD showErrorWithStatus:@"Nilai Pencairan minimal 2.500.000"];
        isValid = NO;
      }
      
    }  else if ([self.menuType isEqualToString:@"Dahsyat - Multiguna Mobil"] ) {
      NSInteger nilaiPencairan = [[self.txtJenisPerhitungan.text stringByReplacingOccurrencesOfString:@"." withString:@""] integerValue];
      if (estimasiHargaAtauAngsuran < 17000000) {
        [SVProgressHUD showErrorWithStatus:@"Estimasi Harga minimal 17.000.000"];
        isValid = NO;
      }
      else if (nilaiPencairan < 10000000) {
        [SVProgressHUD showErrorWithStatus:@"Nilai Pencairan minimal 10.000.000"];
        isValid = NO;
      }
      
    }
  }
  [SVProgressHUD dismissWithDelay:1.0f];
  
  return isValid;
}
- (IBAction)hitung:(id)sender {
  
    if (self.txtJenisPerhitungan.text.length < 1) {
        return;
    }
  if (![self validate]) {
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
        biayaTenor = @{@"nilaiPencairan" : _harga2,
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
      [param addEntriesFromDictionary:@{@"jenisKendaraan" : [self.menuType isEqualToString:@"Pembiayaan Mobil Baru"] ? @"New Car" : @"Used Car"
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
          if ([self.menuType isEqualToString:@"Pembiayaan Motor Baru"]) {
            if ([self.txtJenisPerhitungan.text isEqualToString:@"Estimasi Harga"]) {
               self.txtValue1.text = responseObject[@"data"][@"angsuran"];
            } else {
               self.txtValue1.text = responseObject[@"data"][@"hargaKendaraan"];
            }
          } else if ([self.menuType isEqualToString:@"Pembiayaan Mobil Baru"] || [self.menuType isEqualToString:@"Pembiayaan Mobil Bekas"]) {
            if ([self.txtJenisPerhitungan.text isEqualToString:@"Estimasi Harga"]) {
              
              self.txtValue1.text = responseObject[@"data"][@"totalBayarAwal"];
              self.txtValue2.text = responseObject[@"data"][@"angsuran"];
            } else {
              self.txtValue2.text = responseObject[@"data"][@"hargaKendaraan"];
              self.txtValue1.text = responseObject[@"data"][@"totalBayarAwal"];
            }
          }
          else if ([self.menuType isEqualToString:@"Dahsyat - Multiguna Motor"]) {
            self.txtValue1.text = responseObject[@"data"][@"pencairanMaks"];
            self.txtValue2.text = responseObject[@"data"][@"angsuran"];
          }
          else if ([self.menuType isEqualToString:@"Dahsyat - Multiguna Mobil"]) {
            self.txtValue1.text = responseObject[@"data"][@"pencairanMaks"];
            self.txtValue2.text = responseObject[@"data"][@"angsuran"];
          }
          
          NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
          [numberFormatter setGroupingSeparator:@"."];
          [numberFormatter setGroupingSize:3];
          [numberFormatter setUsesGroupingSeparator:YES];
          [numberFormatter setDecimalSeparator:@","];
          [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
          [numberFormatter setMaximumFractionDigits:2];
          self.txtValue1.text = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[self.txtValue1.text doubleValue]]];
         self.txtValue2.text = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[self.txtValue2.text doubleValue]]];
                                 
          [self.btnPengajuan setHidden:NO];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
      NSLog(@"%@",error);
    }];
    
}
- (IBAction)pengajuan:(id)sender {
    Menu *menu = [Menu getMenuForPrimaryKey:kSubmenuListOnlineSubmission];
    
    FormViewController *formViewController = [[FormViewController alloc] init];
    formViewController.menu = menu;
    formViewController.list = nil;
  formViewController.tipeProduk = self.tipeProduk;
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
