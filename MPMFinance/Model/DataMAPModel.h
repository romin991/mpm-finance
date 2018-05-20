//
//  DataMAPModel.h
//  MPMFinance
//
//  Created by Rudy Suharyadi on 6/6/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "List.h"

@interface DataMAPModel : NSObject

+ (void)checkMAPSubmittedWithID:(NSInteger)pengajuanId completion:(void(^)(NSDictionary *response, NSError *error))block;
+ (void)getDataMAPWithID:(NSInteger)pengajuanId completion:(void(^)(NSDictionary *response, NSError *error))block;
+ (void)postDataMAPWithDictionary:(NSDictionary *)dictionary completion:(void(^)(NSDictionary *dictionary, NSError *error))block;

@end
