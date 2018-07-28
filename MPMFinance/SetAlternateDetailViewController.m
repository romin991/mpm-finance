//
//  SetAlternateDetailViewController.m
//  MPMFinance
//
//  Created by Romin Adi Santoso on 5/24/18.
//  Copyright © 2018 MPMFinance. All rights reserved.
//

#import "SetAlternateDetailViewController.h"
#import "XLForm.h"
#import "APIModel.h"
#import "DropdownModel.h"
#import "FloatLabeledTextFieldCell.h"
@interface SetAlternateDetailViewController ()
@property NSArray *dropdownReasons;
@property NSArray *dropdownListMarketing;
@property NSArray *dropdownListMarketing2;
@property BOOL isEdit;
@end

@implementation SetAlternateDetailViewController
NSString * const kValidationName = @"kName";
NSString * const kValidationReplacementName = @"kReplacementName";
NSString * const kValidationBeginDate = @"kBeginDate";
NSString * const kValidationEndDate = @"kEndDate";
NSString * const kValidationReason = @"kReason";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isEdit = NO;
    [self preloadDropdown];
    
    UIBarButtonItem *rightBar;
    
    if (self.data) {
        rightBar = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(edit:)];
    } else {
        rightBar = [[UIBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStylePlain target:self action:@selector(submit:)];
    }
    self.navigationItem.rightBarButtonItem = rightBar;
    self.title = @"Set Alternate";
    // Do any additional setup after loading the view from its nib.
}
- (void) edit:(id)sender {
    self.isEdit = YES;
    [self preloadDropdown];
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStylePlain target:self action:@selector(submit:)];
    self.navigationItem.rightBarButtonItem = rightBar;
}
- (void) submit:(id)sender{
    XLFormRowDescriptor *dateBeginRow = [self.form formRowWithTag:kValidationBeginDate];
    NSString *dateBegin = [MPMGlobal stringFromDateTime:dateBeginRow.value];
    XLFormRowDescriptor *dateEndRow = [self.form formRowWithTag:kValidationEndDate];
    NSString *dateEnd = [MPMGlobal stringFromDateTime:dateEndRow.value];
    XLFormRowDescriptor *nameRow = [self.form formRowWithTag:kValidationName];
    NSString *name = ((XLFormOptionsObject *)nameRow.value).valueData;
    XLFormRowDescriptor *replacementNameRow = [self.form formRowWithTag:kValidationReplacementName];
    NSString *replacementName = ((XLFormOptionsObject *)replacementNameRow.value).valueData;
    XLFormRowDescriptor *reasonRow = [self.form formRowWithTag:kValidationReason];
    NSString *reason;
    if (self.isEdit) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.name = %@",reasonRow.value];
        NSArray *result = [self.dropdownReasons filteredArrayUsingPredicate:predicate];
        if (result.count > 0) {
            Option *opsi = [result firstObject];
            reason = [NSString stringWithFormat:@"%li",(long)opsi.primaryKey];
        }
    } else {
        reason = [((XLFormOptionsObject *)reasonRow.value).valueData stringValue];
    }
    [APIModel setAlternateWithWithDateBegin:dateBegin dateEnd:dateEnd marketing:name marketingAlternate:replacementName alasanId:reason isEdit:self.isEdit idAlternate:self.data ?self.data[@"id"] : @"" Completion:^(NSString *data, NSError *error) {
        if (!error) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
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
                self.dropdownReasons = datas;
                [self initializeForm];
            }
        } @catch (NSException *exception) {
        } @finally {
        }
    }];
    [DropdownModel getDropdownMarketingForTypeWithcompletion:^(NSArray *datas, NSError *error) {
        @try {
            if (error) {
            } else {
                self.dropdownListMarketing = datas;
                XLFormRowDescriptor *row = [self.form formRowWithTag:kValidationName];
                NSMutableArray *optionObjects = [NSMutableArray array];
                for (NSDictionary *data in self.dropdownListMarketing) {
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:data[@"userid"] displayText:data[@"nama"]]];
                }
                row.selectorOptions = optionObjects;
            }
        } @catch (NSException *exception) {
        } @finally {
        }
    }];
}

-(void)formRowDescriptorValueHasChanged:(XLFormRowDescriptor *)formRow oldValue:(id)oldValue newValue:(id)newValue
{
    if ([formRow.tag isEqualToString:kValidationName]) {
        [APIModel getListMarketingAlternateWithWithUserId:((XLFormOptionsObject *) newValue).formValue Completion:^(NSArray *data, NSError *error) {
            self.dropdownListMarketing2 = data;
            XLFormRowDescriptor *row = [self.form formRowWithTag:kValidationReplacementName];
            NSMutableArray *optionObjects = [NSMutableArray array];
            for (NSDictionary *data in self.dropdownListMarketing2) {
                [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:data[@"userid"] displayText:data[@"nama"]]];
            }
            row.selectorOptions = optionObjects;
        }];
    }
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
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kValidationName rowType:XLFormRowDescriptorTypeSelectorPush title:@"Nama Marketing"];
    row.required = YES;
    if (self.data) {
        [row setDisabled:@(!self.isEdit)];
        row.value = self.data[@"mkt"];
    }
    
    [section addFormRow:row];
    
    // Email
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kValidationReplacementName rowType:XLFormRowDescriptorTypeSelectorPush title:@"Nama Marketing yang Menggantikan"];
   
    row.required = NO;
    if (self.data) {
        [row setDisabled:@(!self.isEdit)];
        row.value = self.data[@"mktAlternate"];
    }
    //[row addValidator:[XLFormValidator emailValidator]];
    [section addFormRow:row];
    
    // begin date
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kValidationBeginDate rowType:XLFormRowDescriptorTypeDateTime title:@"Tanggal Mulai"];
    row.required = YES;
    if (self.data) {
        [row setDisabled:@(!self.isEdit)];
        row.value = [MPMGlobal dateTimeFromString:self.data[@"date"]];
      
    }
   [(XLFormDateCell *)[row cellForFormController:self] setMaximumDate:[NSDate date]];
    //[row addValidator:[XLFormRegexValidator formRegexValidatorWithMsg:@"At least 6, max 32 characters" regex:@"^(?=.*\\d)(?=.*[A-Za-z]).{6,32}$"]];
    [section addFormRow:row];
    
    
    // end date
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kValidationEndDate rowType:XLFormRowDescriptorTypeDateTime title:@"Tanggal Selesai"];
    row.required = YES;
    //[row addValidator:[XLFormRegexValidator formRegexValidatorWithMsg:@"greater than 50 and less than 100" regex:@"^([5-9][0-9]|100)$"]];
    if (self.data) {
        [row setDisabled:@(!self.isEdit)];
        row.value = [MPMGlobal dateTimeFromString:self.data[@"date2"]];
    }
   [(XLFormDateCell *)[row cellForFormController:self] setMaximumDate:[NSDate date]];
    [section addFormRow:row];
    
    
    // reason
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kValidationReason rowType:XLFormRowDescriptorTypeSelectorPush title:@"Alasan"];
    row.required = YES;
    //[row addValidator:[XLFormRegexValidator formRegexValidatorWithMsg:@"greater than 50 and less than 100" regex:@"^([5-9][0-9]|100)$"]];
    if (self.data) {
        [row setDisabled:@(!self.isEdit)];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.primaryKey = %i",[self.data[@"reason"] integerValue]];
        NSArray *result = [self.dropdownReasons filteredArrayUsingPredicate:predicate];
        if (result.count > 0) {
            Option *firstResult = [result firstObject];
            row.value = firstResult.name;
        }
        
    } else {
        NSMutableArray *optionObjects = [NSMutableArray array];
        for (Option *data in self.dropdownReasons) {
            [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@(data.primaryKey) displayText:data.name]];
        }
        row.selectorOptions = optionObjects;
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
