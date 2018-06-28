//
//  InsuranceClaimFormViewController.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 6/28/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "InsuranceClaimFormViewController.h"
#import "FormModel.h"
#import "Form.h"
#import "CustomerModel.h"
#import "InsuranceModel.h"

@interface InsuranceClaimFormViewController ()

@property NSMutableDictionary *valueDictionary;

@property NSString *agreementNo;
@property NSString *claimType;

@end

@implementation InsuranceClaimFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    // Do any additional setup after loading the view from its nib.
    RLMResults *forms = [Form getFormForMenu:self.menu.primaryKey];
    Form *currentForm = forms.firstObject;
    [self setTitle:self.menu.title];
    
    [SVProgressHUD show];
    __block typeof(self) weakSelf = self;
    XLFormDescriptor *formDescriptor;
    [FormModel generate:formDescriptor form:currentForm completion:^(XLFormDescriptor *formDescriptor, NSError *error) {
        if (error){
            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
            [SVProgressHUD dismissWithDelay:1.5 completion:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
        } else {
            weakSelf.form = formDescriptor;
            [SVProgressHUD dismiss];
            [weakSelf setAdditionalRow];
            
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setAdditionalRow{
    XLFormDescriptor *formDescriptor = self.form;
    
    XLFormSectionDescriptor *section = [XLFormSectionDescriptor formSection];
    section.title = @"Jenis Klaim";
    [formDescriptor addFormSection:section atIndex:0];
    
    XLFormRowDescriptor *row = [XLFormRowDescriptor formRowDescriptorWithTag:@"claim" rowType:XLFormRowDescriptorTypeSelectorPush title:@"Jenis Klaim"];
    row.selectorTitle = @"Jenis Klaim";
    NSMutableArray *optionObjects = [NSMutableArray array];
    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"Unit" displayText:@"Barang"]];
    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"Life" displayText:@"Credit Life"]];
    row.selectorOptions = optionObjects;
    [section addFormRow:row];
    
    XLFormSectionDescriptor *section2 = [XLFormSectionDescriptor formSection];
    section2.title = @"Pilih no kontrak";
    [formDescriptor addFormSection:section2 atIndex:1];
    
    __block XLFormRowDescriptor *row2 = [XLFormRowDescriptor formRowDescriptorWithTag:@"noKontrak" rowType:XLFormRowDescriptorTypeSelectorPush title:@"Pilih no kontrak"];
    row2.selectorTitle = @"Pilih no kontrak";
    [section2 addFormRow:row2];
    
    [SVProgressHUD show];
    [CustomerModel getListContractNumberWithCompletion:^(NSArray *datas, NSError *error) {
        @try {
            if (error) {
                [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
                [SVProgressHUD dismissWithDelay:1.5 completion:nil];
                
            } else {
                NSMutableArray *optionObjects = [NSMutableArray array];
                for (Data *data in datas) {
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@(data.id) displayText:data.value]];
                }
                row2.selectorOptions = optionObjects;
                [SVProgressHUD dismiss];
            }
            
        } @catch (NSException *exception) {
            NSLog(@"%@", exception);
        }
    }];
    
    XLFormSectionDescriptor *section3 = [XLFormSectionDescriptor formSection];
    section3.title = @"";
    [formDescriptor addFormSection:section3];
    
    XLFormRowDescriptor *row3 = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeButton title:@"Submit"];
    row3.action.formSelector = @selector(submitNow:);
    [section3 addFormRow:row3];
    
    //set minimum date today
    XLFormRowDescriptor *dateRow = [self.form formRowWithTag:@"tanggalKejadian"];
    if ([[dateRow cellForFormController:self] isKindOfClass:XLFormDateCell.class]){
        [(XLFormDateCell *)[dateRow cellForFormController:self] setMaximumDate:[NSDate date]];
    }
    
    self.form = formDescriptor;
}



- (void)submitNow:(XLFormRowDescriptor *)row{
    NSLog(@"submitNow called");
    [self deselectFormRow:row];
    
    NSArray *errors = [self formValidationErrors];
    if (errors.count) {
        [SVProgressHUD showErrorWithStatus:((NSError *)errors.firstObject).localizedDescription];
        [SVProgressHUD dismissWithDelay:1.5];
        
    } else {
        [SVProgressHUD show];
        [FormModel saveValueFrom:self.form to:self.valueDictionary];
        [InsuranceModel postInsuranceWithDictionary:self.valueDictionary completion:^(NSDictionary *dictionary, NSError *error) {
            if (error) {
                NSString *errorMessage = error.localizedDescription;
                @try {
                    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] options:NSJSONReadingAllowFragments error:nil];
                    errorMessage = [responseObject objectForKey:@"message"];
                } @catch (NSException *exception) {
                    NSLog(@"%@", exception);
                } @finally {
                    [SVProgressHUD showErrorWithStatus:errorMessage];
                    [SVProgressHUD dismissWithDelay:1.5];
                }
            } else {
                [SVProgressHUD dismiss];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
    
    //call api here
}

- (void)formRowDescriptorValueHasChanged:(XLFormRowDescriptor *)formRow oldValue:(id)oldValue newValue:(id)newValue{
    if ([formRow.tag isEqualToString:@"claim"]){
        self.claimType = newValue != nil && ![newValue isKindOfClass:NSNull.class] ? ((XLFormOptionsObject *) newValue).formValue : @"";
        [self performSelector:@selector(fillRowData) withObject:nil afterDelay:0.1];
    }
    
    if ([formRow.tag isEqualToString:@"noKontrak"]){
        self.agreementNo = newValue != nil && ![newValue isKindOfClass:NSNull.class] ? ((XLFormOptionsObject *) newValue).formDisplayText : @"";
        [self performSelector:@selector(fillRowData) withObject:nil afterDelay:0.1];
    }
}

- (void)fillRowData{
    if (self.claimType.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"Pilih jenis claim"];
        [SVProgressHUD dismissWithDelay:1.5];
        [self resetForm];
        
    } else if (self.agreementNo.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"Pilih nomor kontrak"];
        [SVProgressHUD dismissWithDelay:1.5];
        [self resetForm];
        
    } else {
        [SVProgressHUD show];
        __block typeof (self) weakSelf = self;
        [InsuranceModel getInsuranceDataWithClaim:self.claimType agreementNo:self.agreementNo completion:^(NSDictionary *dictionary, NSError *error) {
            if (error == nil) {
                if (dictionary) {
                    weakSelf.valueDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
                    [FormModel loadValueFrom:weakSelf.valueDictionary to:weakSelf.form on:weakSelf];
                }
                [SVProgressHUD dismiss];
                
            } else {
                [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
                [SVProgressHUD dismissWithDelay:1.5];
            }
        }];
    }
}

- (void)resetForm{
    NSDictionary *dictionary = @{@"nama" : @"",
                                 @"nomorPlat" : @"",
                                 @"insco" : @"",
                                 @"hotline" : @"",
                                 };
    [FormModel loadValueFrom:dictionary to:self.form on:self];
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
