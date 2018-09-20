//
//  LegalizationBPKBFormViewController.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 6/28/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "LegalizationBPKBFormViewController.h"
#import "FormModel.h"
#import "Form.h"
#import "CustomerModel.h"
#import "LegalizationBPKBModel.h"
#import "LegalizationBPKBTableViewController.h"
@interface LegalizationBPKBFormViewController ()

@property NSMutableDictionary *valueDictionary;

@end

@implementation LegalizationBPKBFormViewController

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
        [row.cellConfig setObject:[UIFont systemFontOfSize:12.0f] forKey:@"textLabel.font"];
        [row.cellConfig setObject:[UIFont systemFontOfSize:12.0f] forKey:@"detailTextLabel.font"];
         if ([row.tag isEqualToString:@"tanggalPengambilanDokumen"]) {
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
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:data.value displayText:data.value]];
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
        [LegalizationBPKBModel postLegalizationBPKBWithDictionary:self.valueDictionary completion:^(NSDictionary *dictionary, NSError *error) {
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
              LegalizationBPKBTableViewController *viewController = [[LegalizationBPKBTableViewController alloc] init];
              [self.navigationController pushViewController:viewController animated:YES];
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
        [LegalizationBPKBModel getLegalizationBPKBDataWithAgreementNo:agreementNo completion:^(NSDictionary *dictionary, NSError *error) {
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
  if ([formRow.tag isEqualToString:@"tanggalPengambilanDokumen"])  {
    NSInteger weekday = [[NSCalendar currentCalendar] component:NSCalendarUnitWeekday
                                                       fromDate:newValue];
    if (weekday == 7 || weekday == 1) {
      UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Layanan ini hanya tersedia dari senin - jumat" preferredStyle:UIAlertControllerStyleAlert];
      UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (![oldValue isEqual:[NSNull null]]) {
          formRow.value = oldValue;
          [self reloadFormRow:formRow];
        } else {
          NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
          if (weekday == 7) {
            dayComponent.day = 2;
          } else if (weekday == 1) {
            dayComponent.day = 1;
          }
          NSCalendar *theCalendar = [NSCalendar currentCalendar];
          NSDate *nextDate = [theCalendar dateByAddingComponents:dayComponent toDate:newValue options:0];
          formRow.value = nextDate;
          [self reloadFormRow:formRow];
        }
      }];
      [alert addAction:action];
      [self presentViewController:alert animated:YES completion:nil];
    }
  }
  if ([formRow.tag isEqualToString:@"jamPengambilanDokumen"])  {
    NSDate *newTime = [MPMGlobal timeFromString:[MPMGlobal stringFromTime:newValue]];
    NSDate *time1 = [MPMGlobal timeFromString:@"08:30:00"];
    NSDate *time2 = [MPMGlobal timeFromString:@"16:00:00"];
    NSComparisonResult result1 = [newTime compare:time1];
    NSComparisonResult result2 = [newTime compare:time2];
    
    if (result1 != NSOrderedDescending || result2 != NSOrderedAscending) {
      UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Layanan ini hanya tersedia dari pukul 08:30 - 16:00" preferredStyle:UIAlertControllerStyleAlert];
      UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([[oldValue class] isKindOfClass:[NSNull class]]) {
          formRow.value = oldValue;
          [self reloadFormRow:formRow];
        }
        
      }];
      [alert addAction:action];
      [self presentViewController:alert animated:YES completion:nil];
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

@end
