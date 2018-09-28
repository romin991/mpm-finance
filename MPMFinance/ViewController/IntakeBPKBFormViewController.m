//
//  IntakeBPKBFormViewController.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 6/28/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "IntakeBPKBFormViewController.h"
#import "FormModel.h"
#import "Form.h"
#import "CustomerModel.h"
#import "IntakeBPKBModel.h"
#import "IntakeBPKBTableViewController.h"
@interface IntakeBPKBFormViewController ()

@property NSMutableDictionary *valueDictionary;
@property NSString *agreementNo;

@end

@implementation IntakeBPKBFormViewController

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
    
    self.form = formDescriptor;
}



- (void)submitNow:(XLFormRowDescriptor *)row{
    NSLog(@"submitNow called");
    [self deselectFormRow:row];
    [FormModel saveValueFrom:self.form to:self.valueDictionary];
    
    //call api here
    [SVProgressHUD show];
    __block typeof (self) weakSelf = self;
    [IntakeBPKBModel postIntakeBPKBWithDictionary:self.valueDictionary completion:^(NSDictionary *dictionary, NSError *error) {
        if (error == nil) {
            [SVProgressHUD dismiss];
          IntakeBPKBTableViewController *viewController = [[IntakeBPKBTableViewController alloc] init];
          [self.navigationController pushViewController:viewController animated:YES];
            
        } else {
            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
            [SVProgressHUD dismissWithDelay:1.5];
        }
    }];
}

- (void)formRowDescriptorValueHasChanged:(XLFormRowDescriptor *)formRow oldValue:(id)oldValue newValue:(id)newValue{
    if ([formRow.tag isEqualToString:@"noKontrak"]){
        self.agreementNo = newValue != nil && ![newValue isKindOfClass:NSNull.class] ? ((XLFormOptionsObject *) newValue).formDisplayText : @"";
        [self performSelector:@selector(fillRowData) withObject:nil afterDelay:0.1];
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
      return;
    }
    NSDateComponents *otherDay = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:formRow.value];
    NSDateComponents *today = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    XLFormRowDescriptor *timeRow = [self.form formRowWithTag:@"jamPengambilanDokumen"];
    if ([otherDay day] == [today day]) {
      
      [(XLFormDateCell *)[timeRow cellForFormController:self] setMinimumDate:[NSDate date]];
    } else {
      [(XLFormDateCell *)[timeRow cellForFormController:self] setMinimumDate:[NSDate dateWithTimeIntervalSince1970:0]];
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

- (void)fillRowData{
    if (self.agreementNo.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"Pilih nomor kontrak"];
        [SVProgressHUD dismissWithDelay:1.5];
        [self resetForm];
        
    } else {
        [SVProgressHUD show];
        __block typeof (self) weakSelf = self;
        [IntakeBPKBModel getIntakeBPKBDataWithAgreementNo:self.agreementNo completion:^(NSDictionary *dictionary, NSError *error) {
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
                                 @"statusKontrak" : @"",
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
