//
//  NewCarFormViewController.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 6/22/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "NewCarFormViewController.h"
#import <XLForm.h>
#import "FormModel.h"
#import "Form.h"
#import "FloatLabeledTextFieldCell.h"
#import "CalculatorMarketingModel.h"
#import "ResultCalculatorViewController.h"
#import "ResultTableData.h"

@interface NewCarFormViewController ()

@property NSMutableDictionary *valueDictionary;
@property Form *currentForm;

@end

@implementation NewCarFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    RLMResults *forms = [Form getFormForMenu:self.menu.primaryKey];
    self.currentForm = forms.firstObject;
    
    [self setTitle:self.menu.title];
    
    [SVProgressHUD show];
    __block NewCarFormViewController *weakSelf = self;
    if (self.valueDictionary.count == 0) self.valueDictionary = [NSMutableDictionary dictionary];
    [self preparingValueWithCompletion:^{
        [self preparingFormDescriptorWithCompletion:^{
            [FormModel loadValueFrom:weakSelf.valueDictionary on:weakSelf partialUpdate:nil];
            [SVProgressHUD dismiss];
        }];
    }];
}

- (void)preparingFormDescriptorWithCompletion:(void(^)())block{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    __block NewCarFormViewController *weakSelf = self;
    __block NSError *_error = nil;
    __block XLFormDescriptor *_formDescriptor;
    
    dispatch_group_enter(group);
    [FormModel generate:self.form form:self.currentForm completion:^(XLFormDescriptor *formDescriptor, NSError *error) {
        if (error) _error = error;
        if (formDescriptor) _formDescriptor = formDescriptor;
        dispatch_group_leave(group);
    }];
    
    dispatch_group_notify(group, queue, ^{
        for (XLFormSectionDescriptor *section in _formDescriptor.formSections) {
            for (XLFormRowDescriptor *row in section.formRows) {
                if ([row.tag isEqualToString:@"calculate"]) {
                    row.action.formSelector = @selector(calculateNow:);
                }
                
                if ([row.tag isEqualToString:@"rate"]) {
                    row.value = @"Efektif ke Flat";
                }
                
                if ([row.tag isEqualToString:@"tenor"]){
                    NSMutableArray *optionObjects = [NSMutableArray array];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"11" displayText:@"11"]];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"12" displayText:@"12"]];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"23" displayText:@"23"]];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"24" displayText:@"24"]];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"35" displayText:@"35"]];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"36" displayText:@"36"]];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"47" displayText:@"47"]];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"48" displayText:@"48"]];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"59" displayText:@"59"]];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"60" displayText:@"60"]];
                    row.selectorOptions = optionObjects;
                    row.value = optionObjects.firstObject;
                }
                
                if ([row.tag isEqualToString:@"tipePembayaran"]){
                    NSMutableArray *optionObjects = [NSMutableArray array];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"Arrear" displayText:@"Arrear"]];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"Advance" displayText:@"Advance"]];
                    row.selectorOptions = optionObjects;
                    row.value = optionObjects.firstObject;
                }
                
                if ([row.tag isEqualToString:@"biayaProvisi"]){
                    NSMutableArray *optionObjects = [NSMutableArray array];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"Kapitalisasi" displayText:@"Kapitalisasi"]];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"Tunai" displayText:@"Tunai"]];
                    row.selectorOptions = optionObjects;
                    row.value = optionObjects.firstObject;
                }
                
                if ([row.tag isEqualToString:@"opsiAsuransiJiwa"]){
                    NSMutableArray *optionObjects = [NSMutableArray array];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"Ya" displayText:@"Ya"]];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"Tidak" displayText:@"Tidak"]];
                    row.selectorOptions = optionObjects;
                    row.value = optionObjects.firstObject;
                }
                
                if ([row.tag isEqualToString:@"opsiAsuransiJiwaKapitalisasi"]){
                    NSMutableArray *optionObjects = [NSMutableArray array];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"Kapitalisasi" displayText:@"Kapitalisasi"]];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"Tunai" displayText:@"Tunai"]];
                    row.selectorOptions = optionObjects;
                    row.value = optionObjects.firstObject;
                }
                
                if ([row.tag isEqualToString:@"opsiBiayaAdministrasi"]){
                    NSMutableArray *optionObjects = [NSMutableArray array];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"Kapitalisasi" displayText:@"Kapitalisasi"]];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"Tunai" displayText:@"Tunai"]];
                    row.selectorOptions = optionObjects;
                    row.value = optionObjects.firstObject;
                }
                
                if ([row.tag isEqualToString:@"opsiBiayaFidusia"]){
                    NSMutableArray *optionObjects = [NSMutableArray array];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"Ya" displayText:@"Ya"]];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"Tidak" displayText:@"Tidak"]];
                    row.selectorOptions = optionObjects;
                    row.value = optionObjects.firstObject;
                }
                
                if ([row.tag isEqualToString:@"opsiBiayaFidusiaKapitalisasi"]){
                    NSMutableArray *optionObjects = [NSMutableArray array];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"Kapitalisasi" displayText:@"Kapitalisasi"]];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"Tunai" displayText:@"Tunai"]];
                    row.selectorOptions = optionObjects;
                    row.value = optionObjects.firstObject;
                }
                
                if ([row.tag isEqualToString:@"wilayahAsuransiKendaraan"]){
                    NSMutableArray *optionObjects = [NSMutableArray array];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"I Passenger" displayText:@"I Passenger"]];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"II Passenger" displayText:@"II Passenger"]];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"III Passenger" displayText:@"III Passenger"]];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"I Truck&PU" displayText:@"I Truck&PU"]];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"II Truck&PU" displayText:@"II Truck&PU"]];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"III Truck&PU" displayText:@"III Truck&PU"]];
                    row.selectorOptions = optionObjects;
                    row.value = optionObjects.firstObject;
                }
                
                if ([row.tag isEqualToString:@"opsiPremi"]){
                    NSMutableArray *optionObjects = [NSMutableArray array];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"Authorize Dealer" displayText:@"Authorize Dealer"]];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"Non Authorize Dealer" displayText:@"Non Authorize Dealer"]];
                    row.selectorOptions = optionObjects;
                    row.value = optionObjects.firstObject;
                }
                
                if ([row.tag isEqualToString:@"pertanggungan"]){
                    NSMutableArray *optionObjects = [NSMutableArray array];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"All Risk" displayText:@"All Risk"]];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"TLO" displayText:@"TLO"]];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"Combination" displayText:@"Combination"]];
                    row.selectorOptions = optionObjects;
                    row.value = optionObjects.firstObject;
                }
                
                if ([row.tag isEqualToString:@"penggunaan"]){
                    NSMutableArray *optionObjects = [NSMutableArray array];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"Non Commercial" displayText:@"Non Commercial"]];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"Commercial" displayText:@"Commercial"]];
                    row.selectorOptions = optionObjects;
                    row.value = optionObjects.firstObject;
                }
                
                if ([row.tag isEqualToString:@"opsiAsuransiKendaraan"]){
                    NSMutableArray *optionObjects = [NSMutableArray array];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"Tunai" displayText:@"Tunai"]];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"Kapitalisasi" displayText:@"Kapitalisasi"]];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"Tunai Sebagian" displayText:@"Tunai Sebagian"]];
                    row.selectorOptions = optionObjects;
                    row.value = optionObjects.firstObject;
                }
                
                //other setting
                NSArray *tagForKeyboardNumberPad = [NSArray arrayWithObjects:
                                                    @"biayaSurvey", @"biayaCekBlokirBPKB", @"nilaiTunaiSebagian", @"otrKendaraan",
                                                    nil];
                if ([tagForKeyboardNumberPad containsObject:row.tag]){
                    //Set keyboard type to numberPad
                    if ([[row cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
                        [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setKeyboardType:UIKeyboardTypeNumberPad];
                      [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setMustNumericOnly:YES];
                      [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setMaximumLength:12];
                      if ([row.tag isEqualToString:@"otrKendaraan"]) {
                        
                      }
                    }
                }
                
                NSArray *tagForKeyboardDecimalPad = [NSArray arrayWithObjects:
                                                    @"uppingProvisi", @"refundAsuransi", @"refundBunga", @"supplierRate", @"dpPercentage",
                                                    nil];
                if ([tagForKeyboardDecimalPad containsObject:row.tag]){
                    //Set keyboard type to numberPad
                    if ([[row cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
                        [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setKeyboardType:UIKeyboardTypeDecimalPad];
                      [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setMaximumLength:15];
                      [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setMustNumericOnly:YES];
                    }
                }
            }
        }
        
        dispatch_group_notify(group, queue, ^{
            [weakSelf checkError:_error completion:^{
                if (_formDescriptor) weakSelf.form = _formDescriptor;
                if (block) block();
            }];
        });
    });
}

- (void)preparingValueWithCompletion:(void(^)())block{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    __block NewCarFormViewController *weakSelf = self;
    __block NSError *_error = nil;
    
    dispatch_group_notify(group, queue, ^{
        [weakSelf checkError:_error completion:^{
            if (block) block();
        }];
    });
}

- (void)checkError:(NSError *)error completion:(void(^)())block{
    if (error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
        [SVProgressHUD dismissWithDelay:1.5 completion:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } else {
        block();
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)calculateNow:(XLFormRowDescriptor *)row{
    NSLog(@"calculateNow called");
    [self deselectFormRow:row];
    [FormModel saveValueFrom:self.form to:self.valueDictionary];
    
    //calculate base on valueDictionary here
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD show];
    [CalculatorMarketingModel postCalculateNewCarWithDictionary:self.valueDictionary completion:^(NSDictionary *dictionary, NSError *error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            [SVProgressHUD dismissWithDelay:1.5];
        } else {
            [SVProgressHUD dismiss];
            
            if ([dictionary objectForKey:@"data"]) {
                ResultCalculatorViewController *resultVC = [[ResultCalculatorViewController alloc] init];
                resultVC.dataSources = [self setupDataSourcesRequest:self.valueDictionary response:[dictionary objectForKey:@"data"]];
                [weakSelf.navigationController pushViewController:resultVC animated:true];
                
            } else {
                [SVProgressHUD showErrorWithStatus:@"Dictionary not found"];
                [SVProgressHUD dismissWithDelay:1.5];
            }
        }
    }];
}

- (void)formRowDescriptorValueHasChanged:(XLFormRowDescriptor *)formRow oldValue:(id)oldValue newValue:(id)newValue{
    @try {
        if ([formRow.tag isEqualToString:@"otrKendaraan"]) {
            XLFormRowDescriptor *dpRow = [self.form formRowWithTag:@"dpPercentage"];
            NSDecimalNumber *dpPercentage = [NSDecimalNumber decimalNumberWithString:dpRow.value];
            XLFormRowDescriptor *dpRupiahRow = [self.form formRowWithTag:@"dpRupiah"];
            dpRupiahRow.value = [[[dpPercentage decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:newValue]] decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:@"100"]] stringValue];
            [self reloadFormRow:dpRupiahRow];
        }
        if ([formRow.tag isEqualToString:@"dpPercentage"]) {
            XLFormRowDescriptor *otrKendaraanRow = [self.form formRowWithTag:@"otrKendaraan"];
            NSDecimalNumber *otrKendaraan = [NSDecimalNumber decimalNumberWithString:otrKendaraanRow.value];
            XLFormRowDescriptor *dpRupiahRow = [self.form formRowWithTag:@"dpRupiah"];
            dpRupiahRow.value = [[[otrKendaraan decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:newValue]] decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:@"100"]] stringValue];
            [self reloadFormRow:dpRupiahRow];
        }
    } @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
}

- (NSMutableArray *)setupDataSourcesRequest:(NSDictionary *)requestDictionary response:(NSDictionary *)responseDictionary{
    NSMutableArray *dataSources = [NSMutableArray array];
    
    [dataSources addObject:[ResultTableData addDataWithLeft:@"" middle:@"" right:@"" type:ResultTableDataTypeNormal]];
    
    //Setting Rate
    [dataSources addObject:[ResultTableData addDataWithLeft:@"Setting Rate" middle:@"" right:@"" type:ResultTableDataTypeHeader]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"Rate" middle:[requestDictionary objectForKey:@"rate"] right:@"" type:ResultTableDataTypeNormal]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"Tenor" middle:[requestDictionary objectForKey:@"tenor"] right:@"Bulan" type:ResultTableDataTypeRightTextAlignmentLeft]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"Supplier Rate" middle:[NSString stringWithFormat:@"%@%%",[requestDictionary objectForKey:@"supplierRate"]] right:@"Efektif" type:ResultTableDataTypeRightTextAlignmentLeft]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"Tipe Pembayaran" middle:[requestDictionary objectForKey:@"tipePembayaran"] right:@"" type:ResultTableDataTypeNormal]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"Supplier Rate" middle:[NSString stringWithFormat:@"%@%%",[responseDictionary objectForKey:@"supplier_Rate"]] right:@"flat per tahun" type:ResultTableDataTypeRightTextAlignmentLeft]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"Refund Bunga" middle:[NSString stringWithFormat:@"%@%%",[requestDictionary objectForKey:@"refundBunga"]] right:@"" type:ResultTableDataTypeNormal]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"Refund Asuransi" middle:[NSString stringWithFormat:@"%@%%",[requestDictionary objectForKey:@"refundAsuransi"]] right:@"" type:ResultTableDataTypeNormal]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"Running Rate" middle:[NSString stringWithFormat:@"%@%%",[responseDictionary objectForKey:@"running_Rate"]] right:@"flat per tahun" type:ResultTableDataTypeRightTextAlignmentLeft]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"Biaya Provisi" middle:[NSString stringWithFormat:@"%@%%",[requestDictionary objectForKey:@"uppingProvisi"]] right:[requestDictionary objectForKey:@"biayaProvisi"] type:ResultTableDataTypeRightTextAlignmentLeft]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"Upping Provisi" middle:[NSString stringWithFormat:@"%@%%",[requestDictionary objectForKey:@"uppingProvisi"]] right:@"" type:ResultTableDataTypeNormal]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"Opsi Asuransi Jiwa" middle:[requestDictionary objectForKey:@"opsiAsuransiJiwa"] right:[requestDictionary objectForKey:@"opsiAsuransiJiwaKapitalisasi"] type:ResultTableDataTypeRightTextAlignmentLeft]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"Opsi Biaya Admin" middle:[requestDictionary objectForKey:@"opsiBiayaAdministrasi"] right:@"" type:ResultTableDataTypeNormal]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"Opsi Biaya Fidusia" middle:[requestDictionary objectForKey:@"opsiBiayaFidusia"] right:[requestDictionary objectForKey:@"opsiBiayaFidusiaKapitalisasi"] type:ResultTableDataTypeRightTextAlignmentLeft]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"" middle:@"" right:@"" type:ResultTableDataTypeNormal]];
    
    //Asuransi Kendaraan
    [dataSources addObject:[ResultTableData addDataWithLeft:@"Asuransi Kendaraan" middle:@"" right:@"" type:ResultTableDataTypeHeader]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"Wilayah" middle:@"" right:[requestDictionary objectForKey:@"wilayahAsuransiKendaraan"] type:ResultTableDataTypeNormal]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"Opsi Premi" middle:@"" right:[requestDictionary objectForKey:@"opsiPremi"] type:ResultTableDataTypeNormal]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"Pertanggungan" middle:@"" right:[requestDictionary objectForKey:@"pertanggungan"] type:ResultTableDataTypeNormal]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"Opsi Asuransi" middle:@"" right:[requestDictionary objectForKey:@"opsiAsuransiKendaraan"] type:ResultTableDataTypeNormal]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"Penggunaan" middle:@"" right:[requestDictionary objectForKey:@"penggunaan"] type:ResultTableDataTypeNormal]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"Nilai Tunai Sebagian" middle:@"" right:[requestDictionary objectForKey:@"nilaiTunaiSebagian"] type:ResultTableDataTypeNormal]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"" middle:@"" right:@"" type:ResultTableDataTypeNormal]];
    
    //Struktur Pembiayaan
    [dataSources addObject:[ResultTableData addDataWithLeft:@"Struktur Pembiayaan" middle:@"" right:@"" type:ResultTableDataTypeHeader]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"Harga OTR Kendaraan" middle:@"" right:[requestDictionary objectForKey:@"otrKendaraan"] type:ResultTableDataTypeNormal]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"Uang Muka" middle:[NSString stringWithFormat:@"%@%%", [requestDictionary objectForKey:@"dpPercentage"]] right:[responseDictionary objectForKey:@"struktur_pembiayaan_uang_muka"] type:ResultTableDataTypeNormal]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"Pokok Hutang" middle:@"" right:[responseDictionary objectForKey:@"struktur_pembiayaan_pokok_utang"] type:ResultTableDataTypeNormal]];
    
    [dataSources addObject:[ResultTableData addDataWithLeft:@"Biaya Kapitalisasi" middle:@"" right:@"" type:ResultTableDataTypeBold]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"1. Biaya Administrasi" middle:@"" right:[responseDictionary objectForKey:@"biaya_kapitalisasi_biaya_administrasi"] type:ResultTableDataTypeNormal]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"2. Asuransi Kendaraan" middle:@"" right:[responseDictionary objectForKey:@"biaya_kapitalisasi_asuransi_kendaraan"] type:ResultTableDataTypeNormal]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"3. Polis Asuransi Kendaraan" middle:@"" right:[responseDictionary objectForKey:@"biaya_kapitalisasi_polis_asuransi_kendaraan"] type:ResultTableDataTypeNormal]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"4. Biaya Provisi" middle:@"" right:[responseDictionary objectForKey:@"biaya_kapitalisasi_biaya_provisi"] type:ResultTableDataTypeNormal]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"5. Asuransi Jiwa" middle:@"" right:[responseDictionary objectForKey:@"biaya_kapitalisasi_asuransi_jiwa"] type:ResultTableDataTypeNormal]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"6. Polis Asuransi Jiwa" middle:@"" right:[responseDictionary objectForKey:@"biaya_kapitalisasi_polis_asuransi_jiwa"] type:ResultTableDataTypeNormal]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"7. Biaya Fidusia" middle:@"" right:[responseDictionary objectForKey:@"biaya_kapitalisasi_biaya_fidusia"] type:ResultTableDataTypeNormal]];
    
    [dataSources addObject:[ResultTableData addDataWithLeft:@"Biaya Tunai" middle:@"" right:@"" type:ResultTableDataTypeBold]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"1. Biaya Administrasi" middle:@"" right:[responseDictionary objectForKey:@"biaya_administrasi_biaya_tunai"] type:ResultTableDataTypeNormal]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"2. Asuransi Kendaraan" middle:@"" right:[responseDictionary objectForKey:@"asuransi_kendaraan_biaya_tunai"] type:ResultTableDataTypeNormal]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"3. Polis Asuransi Kendaraan" middle:@"" right:[responseDictionary objectForKey:@"biaya_polis_ass_kendaraan_biaya_tunai"] type:ResultTableDataTypeNormal]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"4. Biaya Provisi" middle:@"" right:[responseDictionary objectForKey:@"biaya_provisi_biaya_tunai"] type:ResultTableDataTypeNormal]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"5. Biaya Fidusia" middle:@"" right:[responseDictionary objectForKey:@"biaya_fidusia_biaya_tunai"] type:ResultTableDataTypeNormal]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"6. Biaya Survey (Jika ada)" middle:@"" right:[responseDictionary objectForKey:@"biaya_survey_biaya_tunai"] type:ResultTableDataTypeNormal]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"7. Biaya Cek/Blokir BPKB" middle:@"" right:[responseDictionary objectForKey:@"biaya_cek_blokir_bpkp_biaya_tunai"] type:ResultTableDataTypeNormal]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"8. Asuransi Jiwa" middle:@"" right:[responseDictionary objectForKey:@"asuransi_jiwa_biaya_tunai"] type:ResultTableDataTypeNormal]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"9. Polis Asuransi Jiwa" middle:@"" right:[responseDictionary objectForKey:@"polis_asuransi_jiwa_biaya_tunai"] type:ResultTableDataTypeNormal]];
    
    [dataSources addObject:[ResultTableData addDataWithLeft:@"Total Uang Muka (TDP)" middle:@"" right:[responseDictionary objectForKey:@"total_uang_muka_biaya_tunai"] type:ResultTableDataTypeBold]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"Pembayaran (Disburse)" middle:@"" right:[responseDictionary objectForKey:@"pembayaran_disbure"] type:ResultTableDataTypeBold]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"Nil Pertanggungan Ass Jiwa" middle:@"" right:[responseDictionary objectForKey:@"nilai_pertanggunggan_asuransi_jiwa"] type:ResultTableDataTypeBold]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"NTF Kapitalisasi" middle:@"" right:[responseDictionary objectForKey:@"ntf_kapitalisasi"] type:ResultTableDataTypeBold]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"Angsuran Per Bulan" middle:[NSString stringWithFormat:@"(%lix)", (long) [[responseDictionary objectForKey:@"angsuran_perbulan_2"] integerValue]] right:[responseDictionary objectForKey:@"angsuran_perbulan"] type:ResultTableDataTypeBold]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"" middle:@"" right:@"" type:ResultTableDataTypeNormal]];
     
    //Refund Bunga
    [dataSources addObject:[ResultTableData addDataWithLeft:@"Refund Bunga" middle:@"" right:@"" type:ResultTableDataTypeHeader]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"% Refund" middle:[NSString stringWithFormat:@"%@%%", [responseDictionary objectForKey:@"presentase_refund_bunga"]] right:@"flat per tahun" type:ResultTableDataTypeRightTextAlignmentLeft]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"Running Rate" middle:[NSString stringWithFormat:@"%@%%", [responseDictionary objectForKey:@"running_rate_refund_bunga"]] right:@"flat per tahun" type:ResultTableDataTypeRightTextAlignmentLeft]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"Gross Refund" middle:[responseDictionary objectForKey:@"gross_refund_refund_bunga"] right:@"" type:ResultTableDataTypeNormal]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"" middle:@"" right:@"" type:ResultTableDataTypeNormal]];
     
    //Refund Provisi
    [dataSources addObject:[ResultTableData addDataWithLeft:@"Refund Provisi" middle:@"" right:@"" type:ResultTableDataTypeHeader]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"% Refund" middle:[NSString stringWithFormat:@"%@%%", [responseDictionary objectForKey:@"refund_provisi"]] right:@"" type:ResultTableDataTypeNormal]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"Gross Refund" middle:[responseDictionary objectForKey:@"gross_refund_refund_provisi"] right:@"" type:ResultTableDataTypeNormal]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"" middle:@"" right:@"" type:ResultTableDataTypeNormal]];
     
    //Refund Asuransi
    [dataSources addObject:[ResultTableData addDataWithLeft:@"Refund Asuransi" middle:@"" right:@"" type:ResultTableDataTypeHeader]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"% Refund" middle:[NSString stringWithFormat:@"%@%%", [responseDictionary objectForKey:@"refund_asuransi"]] right:@"" type:ResultTableDataTypeNormal]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"Gross Refund" middle:[responseDictionary objectForKey:@"gross_refund_refund_asuransi"] right:@"" type:ResultTableDataTypeNormal]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"" middle:@"" right:@"" type:ResultTableDataTypeNormal]];
     
    [dataSources addObject:[ResultTableData addDataWithLeft:@"Maks. Refund" middle:@"" right:[responseDictionary objectForKey:@"maks_refund"] type:ResultTableDataTypeSummary]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"" middle:@"" right:@"" type:ResultTableDataTypeNormal]];
     
    return dataSources;
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
