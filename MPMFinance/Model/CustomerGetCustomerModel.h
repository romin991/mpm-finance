//
//  CustomerGetCustomerModel.h
//  MPMFinance
//
//  Created by Rudy Suharyadi on 8/21/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomerGetCustomerModel : NSObject

+ (void)postCustomerGetCustomerWithDictionary:(NSDictionary *)dictionary completion:(void(^)(NSDictionary *dictionary, NSError *error))block;
+ (void)getListCustomerGetCustomerCompletion:(void(^)(NSArray *responses, NSError *error))block;

@end
