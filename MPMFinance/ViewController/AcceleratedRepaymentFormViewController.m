//
//  AcceleratedRepaymentFormViewController.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 6/28/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "AcceleratedRepaymentFormViewController.h"
#import "FormModel.h"
#import "Form.h"
#import "CustomerModel.h"
#import "AcceleratedRepaymentModel.h"
#import "AcceleratedResultViewController.h"
@interface AcceleratedRepaymentFormViewController ()

@property NSMutableDictionary *valueDictionary;
@property NSDate *selectedTanggal;
@end

@implementation AcceleratedRepaymentFormViewController

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
  dispatch_group_t group = dispatch_group_create();
  dispatch_queue_t queue = dispatch_get_main_queue();
  dispatch_group_enter(group);
  
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
          dispatch_group_leave(group);
            
        }
    }];
  
  dispatch_group_notify(group, queue, ^{
    for (XLFormSectionDescriptor *section in self.form.formSections) {
      for (XLFormRowDescriptor *row in section.formRows) {
        if ([row.tag isEqualToString:@"tanggalPelunasan"]) {
          if ([[row cellForFormController:self] isKindOfClass:XLFormDateCell.class]){
            [(XLFormDateCell *)[row cellForFormController:self] setMinimumDate:[NSDate date]];
          }
        }
      }
    }
  });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setAdditionalRow{
    XLFormDescriptor *formDescriptor = self.form;
    
    XLFormSectionDescriptor *section2 = [XLFormSectionDescriptor formSection];
    section2.title = @"Pilih no kontrak";
    [formDescriptor addFormSection:section2 atIndex:0];
    
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
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:data.value displayText:data.value]];
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
    XLFormRowDescriptor *dateRow = [self.form formRowWithTag:@"tanggalPelunasan"];
    if ([[dateRow cellForFormController:self] isKindOfClass:XLFormDateCell.class]){
        [(XLFormDateCell *)[dateRow cellForFormController:self] setMinimumDate:[NSDate date]];
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
        [AcceleratedRepaymentModel postAcceleratedRepaymentWithDictionary:self.valueDictionary completion:^(NSDictionary *dictionary, NSError *error) {
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
              AcceleratedResultViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AcceleratedResultViewController"];
              vc.dict = dictionary[@"data"];
              vc.tanggal = self.selectedTanggal;
              
              [self.navigationController pushViewController:vc animated:YES];
              return;
              
            }
        }];
    }
    
    //call api here
}

- (void)formRowDescriptorValueHasChanged:(XLFormRowDescriptor *)formRow oldValue:(id)oldValue newValue:(id)newValue{    
    if (newValue != nil && ![newValue isKindOfClass:NSNull.class] && [formRow.tag isEqualToString:@"noKontrak"]){
        [SVProgressHUD show];
        __block typeof (self) weakSelf = self;
        NSString *agreementNo = ((XLFormOptionsObject *) newValue).formDisplayText;
        [AcceleratedRepaymentModel getAcceleratedRepaymentDataWithAgreementNo:agreementNo completion:^(NSDictionary *dictionary, NSError *error) {
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
    } else if ([formRow.tag isEqualToString:@"tanggalPelunasan"]) {
      self.selectedTanggal = newValue;
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
