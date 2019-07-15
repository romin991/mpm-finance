//
//  FormModel.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 6/21/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "FormModel.h"
#import "DropdownModel.h"
#import "PostalCode.h"
#import "Asset.h"
#import "UploadPhotoTableViewCell.h"
#import <AFImageDownloader.h>
#import "Data.h"
#import "FloatLabeledTextFieldCell.h"
@implementation FormModel

+ (void)loadValueFrom:(NSDictionary *)dictionary to:(XLFormDescriptor *)formDescriptor on:(XLFormViewController *)formViewController{
    for (XLFormSectionDescriptor *section in formDescriptor.formSections) {
        for (XLFormRowDescriptor *row in section.formRows) {
            id value;
            if ([dictionary objectForKey:row.tag]){
                value = [dictionary objectForKey:row.tag];
            }
            if (value){
                if ([row.rowType isEqualToString:XLFormRowDescriptorTypeDateInline]){
                    row.value = [MPMGlobal dateFromString:value];
                } else if ([row.rowType isEqualToString:XLFormRowDescriptorTypeSelectorPush]){
                    row.value = [XLFormOptionsObject formOptionsOptionForValue:value fromOptions:row.selectorOptions];
                } else if ([row.rowType isEqualToString:XLFormRowDescriptorTypeImage]){
                    row.value = [UIImage imageWithData:value];
                } else if ([row.rowType isEqualToString:XLFormRowDescriptorTypeButton]){
                    //do nothing, no need to include on dictionary
                } else if ([[MPMGlobal getAllFieldShouldContainThousandSeparator] containsObject:row.tag]){
                  row.value = [MPMGlobal formatToRupiah:value];
                }
                else {
                    row.value = value;
                }
            }
            
            [formViewController reloadFormRow:row];
        }
    }
}

+ (void)saveValueFrom:(XLFormDescriptor *)formDescriptor to:(NSMutableDictionary *)valueDictionary{
    for (XLFormSectionDescriptor *section in formDescriptor.formSections) {
        [self saveValueFromSection:section to:valueDictionary];
    }
    
}

+ (void)saveValueFromSection:(XLFormSectionDescriptor *)formSectionDescriptor to:(NSMutableDictionary *)valueDictionary{
    for (XLFormRowDescriptor *row in formSectionDescriptor.formRows) {
        if (row.tag != nil) {
            if (valueDictionary == nil) valueDictionary = [NSMutableDictionary dictionary];
            id object;
            if ([row.value isKindOfClass:NSDate.class]){
                if ([row.rowType isEqualToString:XLFormRowDescriptorTypeTime] ||
                    [row.rowType isEqualToString:XLFormRowDescriptorTypeTimeInline]) {
                    
                    object = [MPMGlobal stringFromTime:row.value];
                    
                } else if ([row.rowType isEqualToString:XLFormRowDescriptorTypeDate] ||
                           [row.rowType isEqualToString:XLFormRowDescriptorTypeDateInline] ||
                           [row.rowType isEqualToString:XLFormRowDescriptorTypeDatePicker]) {
                    
                    object = [MPMGlobal stringFromDate:row.value];
                    
                } else if ([row.rowType isEqualToString:XLFormRowDescriptorTypeDateTime] ||
                           [row.rowType isEqualToString:XLFormRowDescriptorTypeDateTimeInline]) {
                    
                    object = [MPMGlobal stringFromDateTime:row.value];
                    
                }
            } else if ([row.value isKindOfClass:XLFormOptionsObject.class]){
                object = ((XLFormOptionsObject *) row.value).formValue;
            } else if ([row.value isKindOfClass:PostalCode.class]){
                object = ((PostalCode *) row.value).postalCode;
            } else if ([row.value isKindOfClass:Asset.class]){
                object = ((Asset *) row.value).value;
            } else if ([row.value isKindOfClass:Data.class]){
                object = ((Data *) row.value).value;
            } else if ([row.value isKindOfClass:UIImage.class]){
                object = UIImageJPEGRepresentation(row.value, 0.0f);
            } else if ([row.value isKindOfClass:NSArray.class]) {
                NSMutableArray *arrayOfValue = [NSMutableArray array];
                for (id value in row.value) {
                    id tempValue = value;
                    if ([value isKindOfClass:XLFormOptionsObject.class]) {
                        tempValue = ((XLFormOptionsObject*)value).valueData;
                    }
                    
                    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:@{row.tag : tempValue}];
                    [arrayOfValue addObject:dictionary];
                }
                object = arrayOfValue;
            }
            else if (row.value != nil && ![row.value isKindOfClass:NSNull.class]){
                object = row.value;
            } else {
                object = @"";
            }
          
          
          if ([[MPMGlobal getAllFieldShouldContainThousandSeparator] containsObject:row.tag]) {
            NSString *newObject = object;
            @try {
            object = [newObject stringByReplacingOccurrencesOfString:@"." withString:@""];
            }
            @catch(NSException *e) {
              
            }
          }
          NSLog(@"%@ %@",object,row.tag);
            if (object) [valueDictionary setObject:object forKey:row.tag];
        }
    }
}

+ (void)generate:(XLFormDescriptor *)formDescriptor dataSource:(RLMArray *)formRows completion:(void(^)(XLFormDescriptor *, NSError *error))block{
    __block dispatch_group_t group = dispatch_group_create();
    __block dispatch_queue_t queue = dispatch_get_main_queue();
    __block NSError *weakError;
    
    // Form
    formDescriptor = [XLFormDescriptor formDescriptorWithTitle:@"Text Fields"];
    XLFormSectionDescriptor *section;
    
    // Section
    section = [XLFormSectionDescriptor formSection];
    [formDescriptor addFormSection:section];
    
    // Row
    for (FormRow *formRow in formRows) {
        __block XLFormRowDescriptor *row = [XLFormRowDescriptor formRowDescriptorWithTag:formRow.key rowType:formRow.type title:formRow.title];
        row.required = formRow.required;
        row.disabled = @(formRow.disabled);
        row.hidden = @(formRow.hidden);
        row.selectorTitle = formRow.title;
        if (formRow.validationRegex.length > 0) {
            [row addValidator:[[XLFormRegexValidator alloc] initWithMsg:formRow.validationMessage andRegexString:formRow.validationRegex]];
        }
        
        [section addFormRow:row];
        
        if (formRow.optionType.length) {
            dispatch_group_enter(group);
            NSLog(@"enter");
            [DropdownModel getDropdownForType:formRow.optionType completion:^(NSArray *options, NSError *error) {
                @try {
                    if (error) {
                        weakError = error;
                        
                    } else {
                        NSMutableArray *optionObjects = [NSMutableArray array];
                        for (Option *option in options) {
                            [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@(option.primaryKey) displayText:option.name]];
                        }
                        row.selectorOptions = optionObjects;
                    }
                    
                } @catch (NSException *exception) {
                    NSLog(@"%@", exception);
                } @finally {
                    dispatch_group_leave(group);
                    NSLog(@"leave");
                }
            }];
        }
    }
    
    dispatch_group_notify(group, queue, ^{
        if (block) block(formDescriptor, weakError);
    });
}



//new
+ (void)loadValueFrom:(NSDictionary *)dictionary on:(XLFormViewController *)formViewController partialUpdate:(NSArray *)fields{
    [formViewController.form.formSections enumerateObjectsUsingBlock:^(XLFormSectionDescriptor *section, NSUInteger idx, BOOL *stop) {
        [self loadValueFrom:dictionary to:section on:formViewController partialUpdate:fields];
    }];
}

+ (void)loadValueFrom:(NSDictionary *)dictionary to:(XLFormSectionDescriptor *)section on:(XLFormViewController *)formViewController partialUpdate:(NSArray *)fields{
    [section.formRows enumerateObjectsUsingBlock:^(XLFormRowDescriptor *row, NSUInteger idx, BOOL *stop) {
        id value;
      NSLog(@"%@",row.tag);
        
        if ([dictionary objectForKey:row.tag] && (fields.count == 0 || [fields containsObject:row.tag])){
            value = [dictionary objectForKey:row.tag];
        }
        if (value){
            if ([row.rowType isEqualToString:XLFormRowDescriptorTypeDateInline]){
                row.value = [MPMGlobal dateFromString:value];
            } else if ([row.rowType isEqualToString:XLFormRowDescriptorTypeSelectorPush]){
                row.value = row.selectorOptions.count ? [XLFormOptionsObject formOptionsOptionForValue:value fromOptions:row.selectorOptions] : [NSString stringWithFormat:@"%@", value];
             
            } else if ([row.rowType isEqualToString:XLFormRowDescriptorTypeImage]){
              
              
                row.value = [UIImage imageWithData:value];
            } else if ([row.rowType isEqualToString:XLFormRowDescriptorTypeButton]){
                //do nothing, no need to include on dictionary
            } else {
                row.value = value;
            }
  
            [formViewController reloadFormRow:row];
        }
    }];
}


+ (void)generate:(XLFormDescriptor *)formDescriptor form:(Form *)form completion:(void(^)(XLFormDescriptor *formDescriptor, NSError *error))block{
    __block dispatch_group_t group = dispatch_group_create();
    __block dispatch_queue_t queue = dispatch_get_main_queue();
    __block NSError *weakError;
    
    // Form
    formDescriptor = [XLFormDescriptor formDescriptorWithTitle:@"Text Fields"];
    
    for (FormSection *formSection in form.sections) {
        // Section
        XLFormSectionDescriptor *section = [XLFormSectionDescriptor formSection];
        section.title = formSection.title;
        if (formSection.hidden.length > 0) section.hidden = formSection.hidden;
        [formDescriptor addFormSection:section];
        
        // Row
        for (FormRow *formRow in formSection.rows) {
            __block XLFormRowDescriptor *row = [XLFormRowDescriptor formRowDescriptorWithTag:formRow.key rowType:formRow.type title:formRow.title];
            row.required = formRow.required;
            row.disabled = @(formRow.disabled);
            row.hidden = @(formRow.hidden);
            row.selectorTitle = formRow.title;
            
            if (formRow.validationRegex.length > 0) {
                [row addValidator:[[XLFormRegexValidator alloc] initWithMsg:formRow.validationMessage andRegexString:formRow.validationRegex]];
            }
            [section addFormRow:row];
            
            if (formRow.optionType.length) {
                dispatch_group_enter(group);
                NSLog(@"enter %@",formRow.optionType);
              NSString *optionType = formRow.optionType;
              if ([formRow.optionType isEqualToString:@"getProduct"] && [[MPMUserInfo getRole] isEqualToString:kRoleAgent]) {
                optionType = @"getProductByAgent";
              }
                [DropdownModel getDropdownForType:optionType completion:^(NSArray *options, NSError *error) {
                    @try {
                        if (error) {
                            weakError = error;
                            
                        } else {
                            NSMutableArray *optionObjects = [NSMutableArray array];
                            for (Option *option in options) {
                                [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@(option.primaryKey) displayText:option.name]];
                            }
                            row.selectorOptions = optionObjects;
                        }
                        
                    } @catch (NSException *exception) {
                        NSLog(@"%@", exception);
                    } @finally {
                        dispatch_group_leave(group);
                        NSLog(@"leave");
                    }
                }];
            }
        }
    }
    
    
    dispatch_group_notify(group, queue, ^{
        if (block) block(formDescriptor, weakError);
    });
}

@end
