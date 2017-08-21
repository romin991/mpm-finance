//
//  TopUpFormViewController.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 6/28/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "TopUpFormViewController.h"
#import "FormModel.h"
#import "Form.h"
#import "CustomerModel.h"
#import "TopUpModel.h"
#import "FloatLabeledTextFieldCell.h"

@interface TopUpFormViewController ()

@property NSMutableDictionary *valueDictionary;

@end

@implementation TopUpFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
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
            
//            __block typeof(self) weakWeakSelf = weakSelf;
//            [weakSelf setAdditionalFormDescriptor:formDescriptor completion:^(XLFormDescriptor *formDescriptor, NSError *error) {
//                weakWeakSelf.form = formDescriptor;
//                [SVProgressHUD dismiss];
//            }];
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
    section.title = @"Pilih no kontrak";
    [formDescriptor addFormSection:section atIndex:0];
    
    __block XLFormRowDescriptor *row = [XLFormRowDescriptor formRowDescriptorWithTag:@"noKontrak" rowType:XLFormRowDescriptorTypeSelectorPush title:@"Pilih no kontrak"];
    row.selectorTitle = @"Pilih no kontrak";
    [section addFormRow:row];
    
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
                row.selectorOptions = optionObjects;
                [SVProgressHUD dismiss];
            }
            
        } @catch (NSException *exception) {
            NSLog(@"%@", exception);
        }
    }];
    
    XLFormSectionDescriptor *section3 = [XLFormSectionDescriptor formSection];
    section3.title = @"";
    [formDescriptor addFormSection:section3];
    
    XLFormRowDescriptor *row2 = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeButton title:@"Submit"];
    row2.action.formSelector = @selector(submitNow:);
    [section3 addFormRow:row2];
    
    //Set keyboard type to numberPad
    XLFormRowDescriptor *hargaKisaran = [self.form formRowWithTag:@"hargaKisaran"];
    if ([[hargaKisaran cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
        [(FloatLabeledTextFieldCell *)[hargaKisaran cellForFormController:self] setKeyboardType:UIKeyboardTypeNumberPad];
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
        [TopUpModel postTopUpWithDictionary:self.valueDictionary completion:^(NSDictionary *dictionary, NSError *error) {
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
    if (newValue != nil && ![newValue isKindOfClass:NSNull.class] && [formRow.tag isEqualToString:@"noKontrak"]){
        [SVProgressHUD show];
        __block typeof (self) weakSelf = self;
        NSString *agreementNo = ((XLFormOptionsObject *) newValue).formDisplayText;
        [TopUpModel getTopUpDataWithAgreementNo:agreementNo completion:^(NSDictionary *dictionary, NSError *error) {
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
    
    if (newValue != nil && ![newValue isKindOfClass:NSNull.class] && [formRow.tag isEqualToString:@"hargaKisaran"]){
        XLFormRowDescriptor *outstanding = [self.form formRowWithTag:@"outstanding"];
        XLFormRowDescriptor *row = [self.form formRowWithTag:@"jumlahYangDiterima"];
        NSInteger value = 0;
        @try {
            value = [newValue integerValue] - [outstanding.value integerValue];
            if (value < 0) {
                [SVProgressHUD showErrorWithStatus:@"Harga kisaran harus lebih besar daripada outstanding"];
                [SVProgressHUD dismissWithDelay:1.5];
            }
            
        } @catch (NSException *exception) {
            NSLog(@"%@", exception);
            
        } @finally {
            row.value = @(value > 0 ? value : 0);
            [self reloadFormRow:row];
            
        }
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












//- (void)setAdditionalFormDescriptor:(XLFormDescriptor *)formDescriptor completion:(void(^)(XLFormDescriptor *formDescriptor, NSError *error))block{
//    __block dispatch_group_t group = dispatch_group_create();
//    __block dispatch_queue_t queue = dispatch_get_main_queue();
//    __block NSError *weakError;
//    
//    XLFormSectionDescriptor *section = [XLFormSectionDescriptor formSection];
//    section.title = @"Pilih no kontrak";
//    [formDescriptor addFormSection:section atIndex:0];
//    
//    __block XLFormRowDescriptor *row = [XLFormRowDescriptor formRowDescriptorWithTag:@"noKontrak" rowType:XLFormRowDescriptorTypeSelectorPush title:@"Pilih no kontrak"];
//    row.selectorTitle = @"Pilih no kontrak";
//    [section addFormRow:row];
//    
//    dispatch_group_enter(group);
//    NSLog(@"enter");
//    [CustomerModel getListContractNumberWithCompletion:^(NSArray *datas, NSError *error) {
//        @try {
//            if (error) {
//                weakError = error;
//                
//            } else {
//                NSMutableArray *optionObjects = [NSMutableArray array];
//                for (Data *data in datas) {
//                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@(data.id) displayText:data.value]];
//                }
//                row.selectorOptions = optionObjects;
//            }
//            
//        } @catch (NSException *exception) {
//            NSLog(@"%@", exception);
//        } @finally {
//            dispatch_group_leave(group);
//            NSLog(@"leave");
//        }
//    }];
//    
//    XLFormSectionDescriptor *section3 = [XLFormSectionDescriptor formSection];
//    section3.title = @"";
//    [formDescriptor addFormSection:section3];
//    
//    XLFormRowDescriptor *row2 = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeButton title:@"Submit"];
//    row2.action.formSelector = @selector(submitNow:);
//    [section3 addFormRow:row2];
//    
//    dispatch_group_notify(group, queue, ^{
//        if (block) block(formDescriptor, weakError);
//    });
//}

@end
