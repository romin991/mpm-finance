//
//  LegalizationBPKBModel.h
//  MPMFinance
//
//  Created by Rudy Suharyadi on 7/4/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LegalizationBPKBModel : NSObject

//mpmapi/pengambilanbpkb
+ (void)getLegalizationBPKBDataWithAgreementNo:(NSString *)agreementNo completion:(void(^)(NSDictionary *dictionary, NSError *error))block;

@end
