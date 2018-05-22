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
extern NSString *const MPMRegexValidationMax3Number;
@interface FormRow : RLMObject

@property NSString *title;
@property NSString *type;
@property BOOL required;
@property NSInteger sort;
@property NSInteger category; //for link to spesific form
@property BOOL disabled;
@property BOOL hidden;
@property NSString *key; //for NSDictionary
@property NSString *optionType; //for dropdown API type
@property RLMArray<Option> *options;
@property NSString *validationRegex;
@property NSString *validationMessage;
+ (void)generateFields;
+ (RLMResults *)getRowsWithCategoryNumber:(NSInteger)category;
+ (FormRow *)new:(RLMRealm *)realm :(NSInteger)sort :(BOOL)required :(BOOL)disabled :(NSString *)type :(NSString *)title :(NSString *)key :(NSString *)optionType;

//use this if you want validation
+ (FormRow *)new:(RLMRealm *)realm :(NSInteger)sort :(BOOL)required :(BOOL)disabled :(NSString *)type :(NSString *)title :(NSString *)key :(NSString *)optionType regex:(NSString *)regex message:(NSString*)message;
//@property NSString *placeholder;
//@property NSString *tag;
//@property NSString *apiURL;
//@property NSString *validation;
//@property RLMArray<Menu> *menus;

@end
RLM_ARRAY_TYPE(FormRow)

