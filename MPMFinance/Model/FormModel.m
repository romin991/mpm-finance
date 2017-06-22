//
//  FormModel.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 6/21/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "FormModel.h"
#import "DropdownModel.h"

@implementation FormModel

+ (void)loadValueFrom:(NSDictionary *)dictionary to:(XLFormDescriptor *)formDescriptor on:(XLFormViewController *)formViewController{
    for (XLFormSectionDescriptor *section in formDescriptor.formSections) {
        for (XLFormRowDescriptor *row in section.formRows) {
            NSString *value;
            if ([dictionary objectForKey:row.tag]){
                value = [dictionary objectForKey:row.tag];
            }
            if (value){
                if ([row.rowType isEqualToString:XLFormRowDescriptorTypeDateInline]){
                    row.value = [MPMGlobal dateFromString:value];
                } else if ([row.rowType isEqualToString:XLFormRowDescriptorTypeSelectorPush]){
                    row.value = [XLFormOptionsObject formOptionsOptionForValue:value fromOptions:row.selectorOptions];
                } else {
                    row.value = value;
                }
            }
            
            [formViewController reloadFormRow:row];
        }
    }
}

+ (void)saveValueFrom:(XLFormDescriptor *)formDescriptor to:(NSMutableDictionary *)valueDictionary{
    for (XLFormSectionDescriptor *section in formDescriptor.formSections) {
        for (XLFormRowDescriptor *row in section.formRows) {
            if (valueDictionary == nil) valueDictionary = [NSMutableDictionary dictionary];
            id object;
            if ([row.rowType isEqualToString:XLFormRowDescriptorTypeDateInline]){
                object = [MPMGlobal stringFromDate:row.value];
            } else if ([row.rowType isEqualToString:XLFormRowDescriptorTypeSelectorPush]){
                object = ((XLFormOptionsObject *) row.value).formValue;
            } else {
                object = row.value;
            }
            
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
        row.selectorTitle = formRow.title;
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

@end
