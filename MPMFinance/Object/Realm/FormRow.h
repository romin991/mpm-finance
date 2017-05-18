//
//  FormRow.h
//  MPMFinance
//
//  Created by Rudy Suharyadi on 5/17/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import <Realm.h>
#import "Menu.h"
#import "Option.h"

@interface FormRow : RLMObject

@property NSString *title;
@property NSString *tag;
@property NSString *placeholder;
@property NSString *type;
@property BOOL required;
@property NSString *validation;
@property NSInteger sort;
@property NSString *apiURL;

@property RLMArray<Option> *options;
@property RLMArray<Menu> *menus;

@end
RLM_ARRAY_TYPE(FormRow)
