//
//  FormModel.h
//  MPMFinance
//
//  Created by Rudy Suharyadi on 6/21/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XLForm.h>
#import "Form.h"

@interface FormModel : NSObject

+ (void)loadValueFrom:(NSDictionary *)dictionary to:(XLFormDescriptor *)formDescriptor on:(XLFormViewController *)formViewController;
+ (void)saveValueFrom:(XLFormDescriptor *)formDescriptor to:(NSMutableDictionary *)valueDictionary;
+ (void)saveValueFromSection:(XLFormSectionDescriptor *)formSectionDescriptor to:(NSMutableDictionary *)valueDictionary;
+ (void)generate:(XLFormDescriptor *)formDescriptor dataSource:(RLMArray *)formRows completion:(void(^)(XLFormDescriptor *formDescriptor, NSError *error))block;

//new
+ (void)loadValueFrom:(NSDictionary *)dictionary on:(XLFormViewController *)formViewController partialUpdate:(NSArray *)fields;
+ (void)loadValueFrom:(NSDictionary *)dictionary to:(XLFormSectionDescriptor *)section on:(XLFormViewController *)formViewController partialUpdate:(NSArray *)fields;
+ (void)generate:(XLFormDescriptor *)formDescriptor form:(Form *)form completion:(void(^)(XLFormDescriptor *formDescriptor, NSError *error))block;

@end
