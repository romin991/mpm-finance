//
//  DahsyatFormViewController.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 6/22/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "DahsyatFormViewController.h"
#import <XLForm.h>
#import "FormModel.h"
#import "Form.h"
#import "FloatLabeledTextFieldCell.h"
#import "CalculatorMarketingModel.h"
#import "ResultCalculatorViewController.h"
#import "ResultTableData.h"

@interface DahsyatFormViewController ()

@property NSMutableDictionary *valueDictionary;
@property Form *currentForm;

@end

@implementation DahsyatFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    RLMResults *forms = [Form getFormForMenu:self.menu.primaryKey];
    self.currentForm = forms.firstObject;
    
    [self setTitle:self.menu.title];
    
    [SVProgressHUD show];
    __block DahsyatFormViewController *weakSelf = self;
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
    
    __block typeof(self) weakSelf = self;
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
                
                if ([row.tag isEqualToString:@"vehicleType"]){
                    NSMutableArray *optionObjects = [NSMutableArray array];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"Passenger A & B" displayText:@"Passenger A & B"]];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"Passenger C" displayText:@"Passenger C"]];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"Pick Up" displayText:@"Pick Up"]];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"Truck" displayText:@"Truck"]];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"Bus" displayText:@"Bus"]];
                    row.selectorOptions = optionObjects;
                    row.value = optionObjects.firstObject;
                }
                
                if ([row.tag isEqualToString:@"manufactureYear"]){
                    NSDate *date = [NSDate date];
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"yyyy"];
                    NSString *yearString = [dateFormatter stringFromDate:date];
                    NSInteger year = yearString.integerValue;
                    
                    NSMutableArray *optionObjects = [NSMutableArray array];
                    for(int i = 0; i < 11; i++) {
                        NSString *stringValue = [NSString stringWithFormat:@"%li", (long)year-1];
                        [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:stringValue displayText:stringValue]];
                    }
                    row.selectorOptions = optionObjects;
                    row.value = optionObjects.firstObject;
                }
                
                if ([row.tag isEqualToString:@"package"]){
                    NSMutableArray *optionObjects = [NSMutableArray array];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"Standart" displayText:@"Standart"]];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"Paket" displayText:@"Paket"]];
                    row.selectorOptions = optionObjects;
                    row.value = optionObjects.firstObject;
                }
                
                if ([row.tag isEqualToString:@"consumerType"]){
                    NSMutableArray *optionObjects = [NSMutableArray array];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"New Customer" displayText:@"New Customer"]];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"RO Excellent" displayText:@"RO Excellent"]];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"RO Good" displayText:@"RO Good"]];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"RO Reguler" displayText:@"RO Reguler"]];
                    row.selectorOptions = optionObjects;
                    row.value = optionObjects.firstObject;
                }
                
                if ([row.tag isEqualToString:@"firstInstallment"]){
                    NSMutableArray *optionObjects = [NSMutableArray array];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"Arrears" displayText:@"Arrears"]];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"Advance" displayText:@"Advance"]];
                    row.selectorOptions = optionObjects;
                    row.value = optionObjects.firstObject;
                }
                
                if ([row.tag isEqualToString:@"tenor"]){
                    NSMutableArray *optionObjects = [NSMutableArray array];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"6" displayText:@"6"]];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"12" displayText:@"12"]];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"18" displayText:@"18"]];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"24" displayText:@"24"]];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"30" displayText:@"30"]];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"36" displayText:@"36"]];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"42" displayText:@"42"]];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"48" displayText:@"48"]];
                    row.selectorOptions = optionObjects;
                    row.value = optionObjects.firstObject;
                }
                
                if ([row.tag isEqualToString:@"gracePeriod"]){
                    NSMutableArray *optionObjects = [NSMutableArray array];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"0" displayText:@"0"]];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"1" displayText:@"1"]];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"2" displayText:@"2"]];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"3" displayText:@"3"]];
                    row.selectorOptions = optionObjects;
                    row.value = optionObjects.firstObject;
                }
                
                if ([row.tag isEqualToString:@"gracePeriodType"]){
                    NSMutableArray *optionObjects = [NSMutableArray array];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"Roll Over" displayText:@"Roll Over"]];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"Interest Only" displayText:@"Interest Only"]];
                    row.selectorOptions = optionObjects;
                    row.value = optionObjects.firstObject;
                }
                
                if ([row.tag isEqualToString:@"usage"]){
                    NSMutableArray *optionObjects = [NSMutableArray array];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"Komersil" displayText:@"Komersil"]];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"Non Komersil" displayText:@"Non Komersil"]];
                    row.selectorOptions = optionObjects;
                    row.value = optionObjects.firstObject;
                }
                
                if ([row.tag isEqualToString:@"coverageType"]){
                    NSMutableArray *optionObjects = [NSMutableArray array];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"All Risk" displayText:@"All Risk"]];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"TLO" displayText:@"TLO"]];
                    row.selectorOptions = optionObjects;
                    row.value = optionObjects.firstObject;
                }
                
                if ([row.tag isEqualToString:@"nilaiPertanggungan"]){
                    NSMutableArray *optionObjects = [NSMutableArray array];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"By OTR" displayText:@"By OTR"]];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"By NTF" displayText:@"By NTF"]];
                    row.selectorOptions = optionObjects;
                    row.value = optionObjects.firstObject;
                }
                
                if ([row.tag isEqualToString:@"provisi"]){
                    NSMutableArray *optionObjects = [NSMutableArray array];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"0.5%" displayText:@"0.5%"]];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"0.75%" displayText:@"0.75%"]];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"1%" displayText:@"1%"]];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"1.25%" displayText:@"1.25%"]];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"1.5%" displayText:@"1.5%"]];
                    row.selectorOptions = optionObjects;
                    row.value = optionObjects.firstObject;
                }
                
                if ([row.tag isEqualToString:@"admissionFee"]){
                    NSMutableArray *optionObjects = [NSMutableArray array];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"0" displayText:@"0"]];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"50.000" displayText:@"50.000"]];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"750.000" displayText:@"750.000"]];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"1.000.000" displayText:@"1.000.000"]];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"1.500.000" displayText:@"1.500.000"]];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"1.850.000" displayText:@"1.850.000"]];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"1.950.000" displayText:@"1.950.000"]];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"2.000.000" displayText:@"2.000.000"]];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"2.050.000" displayText:@"2.050.000"]];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"2.150.000" displayText:@"2.150.000"]];
                    row.selectorOptions = optionObjects;
                    row.value = optionObjects.firstObject;
                }
                
                if ([row.tag isEqualToString:@"region"]){
                    NSMutableArray *optionObjects = [NSMutableArray array];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"Wilayah 1 (Sumatera)" displayText:@"Wilayah 1 (Sumatera)"]];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"Wilayah 2 (Banten,DKI,Jabar)" displayText:@"Wilayah 2 (Banten,DKI,Jabar)"]];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"Wilayah 3 (Jateng,Jatim,Ka sul,&IBT)" displayText:@"Wilayah 3 (Jateng,Jatim,Ka sul,&IBT)"]];
                    row.selectorOptions = optionObjects;
                    row.value = optionObjects.firstObject;
                }
                
                if ([row.tag isEqualToString:@"lifeInsurance"]){
                    NSMutableArray *optionObjects = [NSMutableArray array];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"Ya" displayText:@"Ya"]];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"Tidak" displayText:@"Tidak"]];
                    row.selectorOptions = optionObjects;
                    row.value = optionObjects.firstObject;
                }
                
                if ([row.tag isEqualToString:@"purposeOfFinancing"]){
                    NSMutableArray *optionObjects = [NSMutableArray array];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"Investasi" displayText:@"Investasi"]];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"Modal Kerja" displayText:@"Modal Kerja"]];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"Multi Guna" displayText:@"Multi Guna"]];
                    row.selectorOptions = optionObjects;
                    row.value = optionObjects.firstObject;
                }
                
                if ([row.tag isEqualToString:@"bulanPencairan"]){
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"MMMM yyyy"];
                    
                    NSCalendar *calendar = [NSCalendar currentCalendar];
                    NSDateComponents *comps = [NSDateComponents new];
                    
                    NSMutableArray *optionObjects = [NSMutableArray array];
                    for (int i = 0; i < 18; i++) {
                        comps.month = 13-(i);
                        NSDate *date = [calendar dateByAddingComponents:comps toDate:[NSDate date] options:0];
                        NSString *dateString = [dateFormatter stringFromDate:date];
                        [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:dateString displayText:dateString]];
                    }
                    row.selectorOptions = optionObjects;
                    row.value = optionObjects.firstObject;
                }
                
                //other setting
                NSArray *tagForKeyboardNumberPad = [NSArray arrayWithObjects:
                                                    @"otrPriceList",
                                                    nil];
                if ([tagForKeyboardNumberPad containsObject:row.tag]){
                    //Set keyboard type to numberPad
                    if ([[row cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
                        [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setKeyboardType:UIKeyboardTypeNumberPad];
                    }
                }
                
                NSArray *tagForKeyboardDecimalPad = [NSArray arrayWithObjects:
                                                     @"loanToValue", @"runningRate", @"feeAgent", @"others",
                                                     nil];
                if ([tagForKeyboardDecimalPad containsObject:row.tag]){
                    //Set keyboard type to numberPad
                    if ([[row cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
                        [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setKeyboardType:UIKeyboardTypeDecimalPad];
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
    
    __block typeof(self) weakSelf = self;
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

- (NSMutableArray *)setupDataSourcesRequest:(NSDictionary *)requestDictionary response:(NSDictionary *)responseDictionary{
    NSMutableArray *dataSources = [NSMutableArray array];
    
    [dataSources addObject:[ResultTableData addDataWithLeft:@"" middle:@"" right:@"" type:ResultTableDataTypeNormal]];
    
    //Perincian
    [dataSources addObject:[ResultTableData addDataWithLeft:@"Perincian" middle:@"" right:@"" type:ResultTableDataTypeHeader]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"OTR (for system)" middle:@"" right:@"" type:ResultTableDataTypeNormal]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"Price List" middle:@"" right:@"" type:ResultTableDataTypeNormal]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"Down Payment" middle:@"" right:@"" type:ResultTableDataTypeNormal]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"NTF" middle:@"" right:@"" type:ResultTableDataTypeNormal]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"NTF Capitalization" middle:@"" right:@"" type:ResultTableDataTypeNormal]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"Rate Flat" middle:@"" right:@"" type:ResultTableDataTypeNormal]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"Premi & Polis Vehicle Ins" middle:@"" right:@"" type:ResultTableDataTypeNormal]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"Premi & Polis Life Ins" middle:@"" right:@"" type:ResultTableDataTypeNormal]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"Administration Fee" middle:@"" right:@"" type:ResultTableDataTypeNormal]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"Adm Amortization Fee" middle:@"" right:@"" type:ResultTableDataTypeNormal]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"Provisi Fee" middle:@"" right:@"" type:ResultTableDataTypeNormal]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"Survey & Cek BPKB" middle:@"" right:@"" type:ResultTableDataTypeNormal]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"Fidusia Fee" middle:@"" right:@"" type:ResultTableDataTypeNormal]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"Agent Fee" middle:@"" right:@"" type:ResultTableDataTypeNormal]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"Installment" middle:@"" right:@"" type:ResultTableDataTypeNormal]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"Disburse" middle:@"" right:@"" type:ResultTableDataTypeNormal]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"" middle:@"" right:@"" type:ResultTableDataTypeNormal]];
    
    [dataSources addObject:[ResultTableData addDataWithLeft:@"Agreement Card" middle:@"" right:@"" type:ResultTableDataTypeHeader]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"Bulan Pencairan" middle:@"" right:@"" type:ResultTableDataTypeBold]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"Pokok Hutang" middle:@"" right:@"" type:ResultTableDataTypeBold]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"Nilai Pencairan" middle:@"" right:@"" type:ResultTableDataTypeBold]];
    
    [dataSources addObject:[ResultTableData addDataWithLeft:@"Angsuran Ke-" middle:@"Tanggal Jatuh Tempo" right:@"Nilai Angsuran" type:ResultTableDataTypeBold]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"1" middle:@"" right:@"" type:ResultTableDataTypeNormal]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"2" middle:@"" right:@"" type:ResultTableDataTypeNormal]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"3" middle:@"" right:@"" type:ResultTableDataTypeNormal]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"4" middle:@"" right:@"" type:ResultTableDataTypeNormal]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"5" middle:@"" right:@"" type:ResultTableDataTypeNormal]];
    [dataSources addObject:[ResultTableData addDataWithLeft:@"6" middle:@"" right:@"" type:ResultTableDataTypeNormal]];
    
    [dataSources addObject:[ResultTableData addDataWithLeft:@"" middle:@"Total" right:@"" type:ResultTableDataTypeNormal]];
    
    return dataSources;
}

@end
