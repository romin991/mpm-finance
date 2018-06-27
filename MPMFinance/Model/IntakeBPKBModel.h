//
//  IntakeBPKBModel.h
//  MPMFinance
//
//  Created by Rudy Suharyadi on 7/5/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IntakeBPKBModel : NSObject

//mpmapi/pengambilanbpkb
+ (void)getIntakeBPKBDataWithAgreementNo:(NSString *)agreementNo completion:(void(^)(NSDictionary *dictionary, NSError *error))block;
+ (void)getListIntakeBPKBCompletion:(void(^)(NSArray *responses, NSError *error))block;
+ (void)postIntakeBPKBWithDictionary:(NSDictionary *)dictionary completion:(void(^)(NSDictionary *dictionary, NSError *error))block;

@end
