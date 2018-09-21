//
//  SuggestionComplainFormViewController.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 6/28/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "SuggestionComplainFormViewController.h"
#import "FormModel.h"
#import "Form.h"
#import "CustomerModel.h"
#import "SuggestionComplaintModel.h"
#import "FloatLabeledTextFieldCell.h"
#import "SuggestionComplaintTableViewController.h"
@interface SuggestionComplainFormViewController ()

@property NSMutableDictionary *valueDictionary;
@property NSString *agreementNo;
@property NSString *category;

@end

@implementation SuggestionComplainFormViewController

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
    section.title = @"Kategori";
    [formDescriptor addFormSection:section atIndex:0];
    
    XLFormRowDescriptor *row = [XLFormRowDescriptor formRowDescriptorWithTag:@"kategori" rowType:XLFormRowDescriptorTypeSelectorPush title:@"Kategori"];
    row.selectorTitle = @"Kategori";
    NSMutableArray *optionObjects = [NSMutableArray array];
    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"Saran" displayText:@"Saran"]];
    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"Pengaduan" displayText:@"Pengaduan"]];
    row.selectorOptions = optionObjects;
    row.value = optionObjects.firstObject;
    row.required = YES;
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
    
    XLFormSectionDescriptor *pengaduan = [formDescriptor.formSections objectAtIndex:3];
    pengaduan.hidden = @"$kategori.value.formValue == 'Saran'";
  
    XLFormSectionDescriptor *saran = [formDescriptor.formSections objectAtIndex:2];
    saran.hidden = @"$kategori.value.formValue == 'Pengaduan'";
    
    XLFormRowDescriptor *subJenisMasalah = [self.form formRowWithTag:@"subJenisMasalah"];
    optionObjects = [NSMutableArray array];
    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"ASR" displayText:@"ASR"]];
    subJenisMasalah.selectorOptions = optionObjects;
    
    //Set keyboard type to numberPad
    XLFormRowDescriptor *numpadRow = [self.form formRowWithTag:@"noHP"];
    if ([[numpadRow cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
        [(FloatLabeledTextFieldCell *)[numpadRow cellForFormController:self] setKeyboardType:UIKeyboardTypeNumberPad];
     /// numpadRow.value = [MPMUserInfo getUserInfo][@"phone"];
      numpadRow.disabled = @YES;
    }
  XLFormRowDescriptor *nomorHandphoneRow = [self.form formRowWithTag:@"nomorHandphone"];
  if ([[nomorHandphoneRow cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
    [(FloatLabeledTextFieldCell *)[nomorHandphoneRow cellForFormController:self] setKeyboardType:UIKeyboardTypeNumberPad];
    /// numpadRow.value = [MPMUserInfo getUserInfo][@"phone"];
    nomorHandphoneRow.disabled = @YES;
  }
  
  XLFormRowDescriptor *emailRow = [self.form formRowWithTag:@"email"];
  if ([[emailRow cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
    emailRow.disabled = @(NO);
  }
  
  emailRow = [self.form formRowWithTag:@"alamat"];
  if ([[emailRow cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
   // [(FloatLabeledTextFieldCell *)[emailRow cellForFormController:self] setMustAlphabetPunctuationOnly:YES];
    emailRow.disabled = @YES;
  }
    numpadRow = [self.form formRowWithTag:@"nomorhandphonebaruJikaDiubah"];
  numpadRow.required = NO;
    if ([[numpadRow cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
        [(FloatLabeledTextFieldCell *)[numpadRow cellForFormController:self] setKeyboardType:UIKeyboardTypeNumberPad];
      [(FloatLabeledTextFieldCell *)[numpadRow cellForFormController:self] setMaximumLength:20];
      [(FloatLabeledTextFieldCell *)[numpadRow cellForFormController:self] setMustNumericOnly:YES];
      
    }
    
    numpadRow = [self.form formRowWithTag:@"nomorTelepon"];
    if ([[numpadRow cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
        [(FloatLabeledTextFieldCell *)[numpadRow cellForFormController:self] setKeyboardType:UIKeyboardTypeNumberPad];
      [(FloatLabeledTextFieldCell *)[numpadRow cellForFormController:self] setMustNumericOnly:YES];
        numpadRow.disabled = @(YES);
      
    }
    
    numpadRow = [self.form formRowWithTag:@"nomorTeleponBaruJikaDiubah"];
    if ([[numpadRow cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
        [(FloatLabeledTextFieldCell *)[numpadRow cellForFormController:self] setKeyboardType:UIKeyboardTypeNumberPad];
      [(FloatLabeledTextFieldCell *)[numpadRow cellForFormController:self] setMustNumericOnly:YES];
      [(FloatLabeledTextFieldCell *)[numpadRow cellForFormController:self] setMaximumLength:20];
    }
    
    numpadRow = [self.form formRowWithTag:@"noHP"];
    if ([[numpadRow cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
        [(FloatLabeledTextFieldCell *)[numpadRow cellForFormController:self] setKeyboardType:UIKeyboardTypeNumberPad];
      [(FloatLabeledTextFieldCell *)[numpadRow cellForFormController:self] setMustNumericOnly:YES];
      [(FloatLabeledTextFieldCell *)[numpadRow cellForFormController:self] setMaximumLength:20];
    }

    self.form = formDescriptor;
}

- (void)submitNow:(XLFormRowDescriptor *)row{
    NSLog(@"submitNow called");
    [self deselectFormRow:row];
  if (![MPMGlobal isValidEmail:[[self.form formValues] valueForKey:@"email"]]) {
    [SVProgressHUD showErrorWithStatus:@"Email Tidak Valid"];
    [SVProgressHUD dismissWithDelay:1.0f];
    return ;
  }
    NSArray *errors = [self formValidationErrors];
    if (errors.count) {
        [SVProgressHUD showErrorWithStatus:((NSError *)errors.firstObject).localizedDescription];
        [SVProgressHUD dismissWithDelay:1.5];
        
    } else {
        [SVProgressHUD show];
        [FormModel saveValueFrom:self.form to:self.valueDictionary];
        
        XLFormRowDescriptor *kategoriRow = [self.form formRowWithTag:@"kategori"];
        if ([((XLFormOptionsObject *) kategoriRow.value).formValue isEqualToString:@"Saran"]) {
            [SuggestionComplaintModel postSuggestionWithDictionary:self.valueDictionary completion:^(NSDictionary *dictionary, NSError *error) {
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
                  SuggestionComplaintTableViewController *vc = [[SuggestionComplaintTableViewController alloc] init];
                  
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }];
            
        } else if ([((XLFormOptionsObject *) kategoriRow.value).formValue isEqualToString:@"Pengaduan"]) {
            [SuggestionComplaintModel postComplainWithDictionary:self.valueDictionary completion:^(NSDictionary *dictionary, NSError *error) {
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
                  SuggestionComplaintTableViewController *vc = [[SuggestionComplaintTableViewController alloc] init];
                  
                  [self.navigationController pushViewController:vc animated:YES];
                }
            }];
        }
    }
    
    //call api here
}

- (void)formRowDescriptorValueHasChanged:(XLFormRowDescriptor *)formRow oldValue:(id)oldValue newValue:(id)newValue{
    if ([formRow.tag isEqualToString:@"kategori"]){
        [self.form forceEvaluate];
        [self performSelector:@selector(fillRowData) withObject:nil afterDelay:0.1];
    }
    
    if ([formRow.tag isEqualToString:@"noKontrak"]){
        self.agreementNo = newValue != nil && ![newValue isKindOfClass:NSNull.class] ? ((XLFormOptionsObject *) newValue).formDisplayText : @"";
        [self performSelector:@selector(fillRowData) withObject:nil afterDelay:0.1];
    }
}

- (void)fillRowData{
    if (self.agreementNo.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"Pilih nomor kontrak"];
        [SVProgressHUD dismissWithDelay:1.5];
        [self resetForm];
        
    } else {
        [SVProgressHUD show];
        __block typeof (self) weakSelf = self;
        [SuggestionComplaintModel getProfileDataWithAgreementNo:self.agreementNo completion:^(NSDictionary *dictionary, NSError *error) {
            if (error == nil) {
                if (dictionary) {
                    weakSelf.valueDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
                  [weakSelf.valueDictionary addEntriesFromDictionary:@{@"noHP" : dictionary[@"nomorHandphone"]}];
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
                                 @"nomorTelepon" : @"",
                                 @"nomorTeleponBaruJikaDiubah" : @"",
                                 @"nomorHandphone" : @"",
                                 @"nomorhandphonebaruJikaDiubah" : @"",
                                 @"alamat" : @"",
                                 @"email" : @"",
                                 @"kronologisMasalah" : @"",
                                 @"penjelasanMasalah" : @"",
                                 
                                 @"saran" : @"",
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
