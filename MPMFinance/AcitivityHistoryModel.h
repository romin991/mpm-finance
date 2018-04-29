//
//  AcitivityHistoryModel.h
//  MPMFinance
//
//  Created by Romin Adi Santoso on 4/29/18.
//  Copyright © 2018 MPMFinance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AcitivityHistoryModel : NSObject
//mpmapi/topup
+ (void)getPaymentHistoryInfoWithAgreementNo:(NSString *)agreementNo completion:(void(^)(NSArray *array, NSError *error))block;
@end
