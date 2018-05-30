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

@interface NewCarFormViewController ()

@property (weak, nonatomic) IBOutlet UIView *containerView;

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
                    }
                }
                
                NSArray *tagForKeyboardDecimalPad = [NSArray arrayWithObjects:
                                                    @"uppingProvisi", @"refundAsuransi", @"refundBunga", @"supplierRate", @"dpPercentage",
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
                resultVC.requestDictionary = weakSelf.valueDictionary;
                resultVC.responseDictionary = [dictionary objectForKey:@"data"];
                [weakSelf.navigationController pushViewController:resultVC animated:true];
            } else {
                [SVProgressHUD showErrorWithStatus:@"Dictionary not found"];
                [SVProgressHUD dismissWithDelay:1.5];
            }
        }
    }];
}

+ (NSString *)serializeDictionary:(NSDictionary *)dictionary{
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
