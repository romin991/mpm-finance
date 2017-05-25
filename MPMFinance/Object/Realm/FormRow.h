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
@property NSString *type;
@property BOOL required;
@property NSInteger sort;
@property NSInteger category;

@property RLMArray<Option> *options;

+ (void)generateFields;
+ (RLMResults *)getRowsWithCategoryNumber:(NSInteger)category;



//@property NSString *placeholder;
//@property NSString *tag;
//@property NSString *apiURL;
//@property NSString *validation;
//@property RLMArray<Menu> *menus;

@end
RLM_ARRAY_TYPE(FormRow)

