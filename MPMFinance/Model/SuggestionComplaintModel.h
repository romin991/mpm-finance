//
//  SuggestionComplaintModel.h
//  MPMFinance
//
//  Created by Rudy Suharyadi on 7/5/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SuggestionComplaintModel : NSObject

//mpmapi/profilecustomerinfo
+ (void)getProfileDataWithAgreementNo:(NSString *)agreementNo completion:(void(^)(NSDictionary *dictionary, NSError *error))block;

@end
