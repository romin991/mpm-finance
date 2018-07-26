//
//  CustomerGetCustomerFormViewController.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 6/28/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "CustomerGetCustomerFormViewController.h"
#import "FormModel.h"
#import "Form.h"
#import "CustomerModel.h"
#import "CustomerGetCustomerModel.h"
#import "FloatLabeledTextFieldCell.h"

@interface CustomerGetCustomerFormViewController ()

@property NSMutableDictionary *valueDictionary;

@end

@implementation CustomerGetCustomerFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    self.valueDictionary = [NSMutableDictionary dictionary];
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
    section.title = @"";
    [formDescriptor addFormSection:section];
    
    XLFormRowDescriptor *row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeButton title:@"Submit"];
    row.action.formSelector = @selector(submitNow:);
    [section addFormRow:row];
    
    //Set keyboard type to numberPad
    XLFormRowDescriptor *numpadRow = [self.form formRowWithTag:@"nomorHandphone"];
    if ([[numpadRow cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
        [(FloatLabeledTextFieldCell *)[numpadRow cellForFormController:self] setKeyboardType:UIKeyboardTypeNumberPad];
      [(FloatLabeledTextFieldCell *)[numpadRow cellForFormController:self]  setMaximumLength:15];
    }
  XLFormRowDescriptor *namaRow = [self.form formRowWithTag:@"nama"];
  if ([[namaRow cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
    [(FloatLabeledTextFieldCell *)[namaRow cellForFormController:self] setMustAlphabetOnly:YES];
  }
  XLFormRowDescriptor *tahunRow = [self.form formRowWithTag:@"tahunKendaraan"];
  if ([[tahunRow cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
    [(FloatLabeledTextFieldCell *)[tahunRow cellForFormController:self] setKeyboardType:UIKeyboardTypeNumberPad];
    [(FloatLabeledTextFieldCell *)[tahunRow cellForFormController:self] setMaximumLength:4];
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
        [CustomerGetCustomerModel postCustomerGetCustomerWithDictionary:self.valueDictionary completion:^(NSDictionary *dictionary, NSError *error) {
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

@end
