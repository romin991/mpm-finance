//
//  APIModel.h
//  MPMFinance
//
//  Created by Rudy Suharyadi on 5/25/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIModel : NSObject

+ (void)getListWorkOrder:(void(^)(NSArray *lists, NSError *error))block;
+ (void)getListSurvey:(void(^)(NSArray *lists, NSError *error))block;
+ (void)getListMapDraft:(void(^)(NSArray *lists, NSError *error))block;
+ (void)getListPengembalianBPKB:(void(^)(NSArray *lists, NSError *error))block;
+ (void)createListWorkOrder:(NSDictionary *)dictionary completion:(void(^)(NSError *error))block;
+ (void)getListWorkOrderDetailWithID:(NSInteger)pengajuanId completion:(void(^)(NSDictionary *response, NSError *error))block;

@end
