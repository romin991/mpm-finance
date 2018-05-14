//
//  ActivityHistoryViewController.m
//  MPMFinance
//
//  Created by Romin Adi Santoso on 4/29/18.
//  Copyright © 2018 MPMFinance. All rights reserved.
//

#import "ActivityHistoryViewController.h"
#import "FormModel.h"
#import "Form.h"
#import "CustomerModel.h"
#import "AcitivityHistoryModel.h"
#import "XLFormActivityTableViewCell.h"
@interface ActivityHistoryViewController ()
@property NSMutableDictionary *valueDictionary;
@property XLFormSectionDescriptor *sectionActivity;
@end

@implementation ActivityHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
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
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    
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
    _sectionActivity = [XLFormSectionDescriptor formSection];
    _sectionActivity.title = @"Aktivitas Transaksi";
    [formDescriptor addFormSection:_sectionActivity atIndex:1];
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
    
    self.form = formDescriptor;
}

- (void)formRowDescriptorValueHasChanged:(XLFormRowDescriptor *)formRow oldValue:(id)oldValue newValue:(id)newValue{
    if (newValue != nil && ![newValue isKindOfClass:NSNull.class] && [formRow.tag isEqualToString:@"noKontrak"]){
        [SVProgressHUD show];
        //__block typeof (self) weakSelf = self;
        NSString *agreementNo = ((XLFormOptionsObject *) newValue).formDisplayText;
        [AcitivityHistoryModel getPaymentHistoryInfoWithAgreementNo:agreementNo completion:^(NSArray *array, NSError *error) {
            if (error == nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    XLFormRowDescriptor * row;
                    for (NSDictionary *dictionary in array) {
                        row = [XLFormRowDescriptor formRowDescriptorWithTag:@"historyCell" rowType:XLFormRowDescriptorTypeFormActivity title:@"---"];
                        row.value = dictionary;
                        [_sectionActivity addFormRow:row];
                    }
                    [SVProgressHUD dismiss];
                });
                
                
            } else {
                [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
                [SVProgressHUD dismissWithDelay:1.5];
            }
        }];
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
