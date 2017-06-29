//
//  TopUpModel.h
//  MPMFinance
//
//  Created by Rudy Suharyadi on 6/29/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopUpModel : NSObject

//mpmapi/topup
+ (void)getTopUpDataWithAgreementNo:(NSString *)agreementNo completion:(void(^)(NSDictionary *dictionary, NSError *error))block;

@end
