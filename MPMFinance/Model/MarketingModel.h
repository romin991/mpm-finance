//
//  MarketingModel.h
//  MPMFinance
//
//  Created by Rudy Suharyadi on 6/22/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MarketingModel : NSObject

//pengajuan/getallmarketingbyspv
+ (void)getAllMarketingBySupervisor:(NSInteger)dataPengajuanId completion:(void(^)(NSArray *marketings, NSError *error))block;

//pengajuan/assignmarketing
+ (void)assignMarketing:(NSInteger)dataPengajuanId marketingId:(NSString *)marketingId completion:(void(^)(NSDictionary *dictionary, NSError *error))block;

@end
