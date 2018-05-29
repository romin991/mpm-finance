//
//  CalculatorMarketingModel.h
//  MPMFinance
//
//  Created by Rudy Suharyadi on 29/05/18.
//  Copyright © 2018 MPMFinance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorMarketingModel : NSObject

+ (void)postCalculateNewCarWithDictionary:(NSDictionary *)dictionary completion:(void(^)(NSDictionary *dictionary, NSError *error))block;

@end
