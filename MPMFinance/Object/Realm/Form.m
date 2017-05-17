//
//  Form.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 5/14/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "Form.h"
#import <XLForm.h>

@implementation Form

+ (RLMResults *)getFormForMenu:(NSString *)menuTitle{
    return [Form objectsWhere:@"ANY menus.title = %@", menuTitle];
}

#pragma mark - Populate Data
+ (void)generateForms{
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    
    Form *form = [[Form alloc] init];
    form.title = @"Nama Calon Debitur";
    form.tag = @"Name";
    form.type = XLFormRowDescriptorTypeText;
    form.required = NO;
    form.sort = 0;
    form.page = 0;
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuListPengajuanApplikasi]];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
    [realm addObject:form];
    
    form = [[Form alloc] init];
    form.title = @"No KTP";
    form.tag = @"IDNumber";
    form.type = XLFormRowDescriptorTypeText;
    form.required = NO;
    form.sort = 0;
    form.page = 0;
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuListPengajuanApplikasi]];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
    [realm addObject:form];

    [realm commitWriteTransaction];
}


@end
