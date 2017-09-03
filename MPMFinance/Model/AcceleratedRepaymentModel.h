//
//  AcceleratedRepaymentModel.h
//  MPMFinance
//
//  Created by Rudy Suharyadi on 9/3/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AcceleratedRepaymentModel : NSObject

+ (void)getAcceleratedRepaymentDataWithAgreementNo:(NSString *)agreementNo completion:(void(^)(NSDictionary *dictionary, NSError *error))block;
+ (void)postAcceleratedRepaymentWithDictionary:(NSDictionary *)dictionary completion:(void(^)(NSDictionary *dictionary, NSError *error))block;

@end
