//
//  Form.h
//  MPMFinance
//
//  Created by Rudy Suharyadi on 5/14/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import <Realm/Realm.h>
#import "Menu.h"
#import "Option.h"

@interface Form : RLMObject

@property NSString *title;
@property NSString *placeholder;
@property NSString *type;
@property NSString *validation;
@property NSInteger sort;
@property NSInteger page;
@property NSString *apiURL;

@property RLMArray<Option> *options;
@property RLMArray<Menu> *menus;

+ (RLMResults *)getFormForMenu:(NSString *)menuTitle role:(NSString *)roleName;
+ (void)generateForms;

@end
