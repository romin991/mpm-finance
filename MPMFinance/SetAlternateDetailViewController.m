//
//  SetAlternateDetailViewController.m
//  MPMFinance
//
//  Created by Romin Adi Santoso on 5/24/18.
//  Copyright © 2018 MPMFinance. All rights reserved.
//

#import "SetAlternateDetailViewController.h"
#import "XLForm.h"
#import "DropdownModel.h"
#import "FloatLabeledTextFieldCell.h"
@interface SetAlternateDetailViewController ()
@property NSArray *dropdownReasons;
@end

@implementation SetAlternateDetailViewController
NSString * const kValidationName = @"kName";
NSString * const kValidationReplacementName = @"kReplacementName";
NSString * const kValidationBeginDate = @"kBeginDate";
NSString * const kValidationEndDate = @"kEndDate";
NSString * const kValidationReason = @"kReason";
- (void)viewDidLoad {
    [super viewDidLoad];
    [self preloadDropdown];
    
    
    self.title = @"Set Alternate";
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)preloadDropdown {
    [DropdownModel getDropdownForType:@"getReasonAlternate" completion:^(NSArray *datas, NSError *error) {
        @try {
            if (error) {
                
                
            } else {
                //NSMutableArray *optionObjects = [NSMutableArray array];
                self.dropdownReasons = datas;
                [self initializeForm];
//                for (Data *data in datas) {
//                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:data.value displayText:data.name]];
//                }
                
            }
            
        } @catch (NSException *exception) {
            NSLog(@"%@", exception);
        } @finally {
            NSLog(@"leave");
        }
    }];
}
-(void)initializeForm
{
    XLFormDescriptor * formDescriptor = [XLFormDescriptor formDescriptorWithTitle:@"Text Fields"];
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    // Name Section
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Detail"];
    [formDescriptor addFormSection:section];
    
    // Name
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kValidationName rowType:XLFormRowDescriptorTypeFloatLabeledTextField title:@"Nama Marketing"];
    row.required = YES;
    if (self.data) {
        [row setDisabled:@YES];
        row.value = self.data[@"mkt"];
    }
    
    [section addFormRow:row];
    
    // Email
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kValidationReplacementName rowType:XLFormRowDescriptorTypeFloatLabeledTextField title:@"Nama Marketing yang Menggantikan"];
   
    row.required = NO;
    if (self.data) {
        [row setDisabled:@YES];
        row.value = self.data[@"mktAlternate"];
    }
    //[row addValidator:[XLFormValidator emailValidator]];
    [section addFormRow:row];
    
    // begin date
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kValidationBeginDate rowType:XLFormRowDescriptorTypeDateTime title:@"Tanggal Mulai"];
    row.required = YES;
    if (self.data) {
        [row setDisabled:@YES];
        row.value = [MPMGlobal dateTimeFromString:self.data[@"date"]];
    }
    //[row addValidator:[XLFormRegexValidator formRegexValidatorWithMsg:@"At least 6, max 32 characters" regex:@"^(?=.*\\d)(?=.*[A-Za-z]).{6,32}$"]];
    [section addFormRow:row];
    
    
    // end date
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kValidationEndDate rowType:XLFormRowDescriptorTypeDateTime title:@"Tanggal Selesai"];
    row.required = YES;
    //[row addValidator:[XLFormRegexValidator formRegexValidatorWithMsg:@"greater than 50 and less than 100" regex:@"^([5-9][0-9]|100)$"]];
    if (self.data) {
        [row setDisabled:@YES];
        row.value = [MPMGlobal dateTimeFromString:self.data[@"date2"]];
    }
    [section addFormRow:row];
    
    
    // reason
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kValidationReason rowType:XLFormRowDescriptorTypeFloatLabeledTextField title:@"Alasan"];
    row.required = YES;
    //[row addValidator:[XLFormRegexValidator formRegexValidatorWithMsg:@"greater than 50 and less than 100" regex:@"^([5-9][0-9]|100)$"]];
    if (self.data) {
        [row setDisabled:@YES];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.primaryKey = %i",[self.data[@"reason"] integerValue]];
        NSArray *result = [self.dropdownReasons filteredArrayUsingPredicate:predicate];
        if (result.count > 0) {
            Option *firstResult = [result firstObject];
            row.value = firstResult.name;
        }
        
    }
    [section addFormRow:row];
    
    self.form = formDescriptor;
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
