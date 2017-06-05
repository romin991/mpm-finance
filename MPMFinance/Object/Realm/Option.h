//
//  Option.h
//  MPMFinance
//
//  Created by Rudy Suharyadi on 5/14/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import <Realm/Realm.h>

@interface Option : RLMObject

@property NSString *name;
@property NSInteger sort;
@property NSInteger category;
@property NSInteger primaryKey;

+ (RLMResults *)getOptionWithCategoryNumber:(NSInteger)category;
+ (void)generateOptions;

@end
RLM_ARRAY_TYPE(Option)
