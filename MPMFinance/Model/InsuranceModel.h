//
//  InsuranceModel.h
//  MPMFinance
//
//  Created by Rudy Suharyadi on 7/4/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InsuranceModel : NSObject

//mpmapi/isuranceinfo
+ (void)getInsuranceDataWithClaim:(NSString *)claim agreementNo:(NSString *)agreementNo completion:(void(^)(NSDictionary *dictionary, NSError *error))block;
+ (void)postInsuranceWithDictionary:(NSDictionary *)dictionary completion:(void(^)(NSDictionary *dictionary, NSError *error))block;
+ (void)getListInsuranceCompletion:(void(^)(NSArray *responses, NSError *error))block;

@end
