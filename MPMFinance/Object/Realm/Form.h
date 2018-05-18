//
//  Form.h
//  MPMFinance
//
//  Created by Rudy Suharyadi on 5/14/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import <Realm/Realm.h>
#import "FormRow.h"
#import "Menu.h"
#import "FormSection.h"

@interface Form : RLMObject

@property NSString *title;
@property NSInteger sort;

@property RLMArray<FormRow> *rows;
@property RLMArray<FormSection> *sections;
@property RLMArray<Menu> *menus;
@property RLMArray<Role> *roles;

+ (RLMResults *)getFormForMenu:(NSString *)primaryKey;
+ (RLMResults *)getFormForMenu:(NSString *)primaryKey role:(NSString *)role;
+ (void)generateForms;

@end
