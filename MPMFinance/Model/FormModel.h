//
//  FormModel.h
//  MPMFinance
//
//  Created by Rudy Suharyadi on 6/21/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XLForm.h>
#import "FormRow.h"

@interface FormModel : NSObject

+ (void)loadValueFrom:(NSDictionary *)dictionary to:(XLFormDescriptor *)formDescriptor on:(XLFormViewController *)formViewController;
+ (void)saveValueFrom:(XLFormDescriptor *)formDescriptor to:(NSMutableDictionary *)valueDictionary;
+ (void)generate:(XLFormDescriptor *)formDescriptor dataSource:(RLMArray *)formRows completion:(void(^)(NSError *error))block;

@end
