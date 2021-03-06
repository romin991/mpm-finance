//
//  WorkOrderModel.h
//  MPMFinance
//
//  Created by Rudy Suharyadi on 6/7/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "List.h"

@interface WorkOrderModel : NSObject

//pengajuan/getallbyspv
+ (void)getListWorkOrderBySupervisorWithStatus:(NSString *)status page:(NSInteger)page completion:(void(^)(NSArray *lists, NSError *error))block;

//pengajuan/getallbyuser
+ (void)getListWorkOrderByUserWithStatus:(NSString *)status page:(NSInteger)page completion:(void(^)(NSArray *lists, NSError *error))block;

//datamap/getworkorder
+ (void)getListWorkOrderWithStatus:(NSString *)status page:(NSInteger)page completion:(void(^)(NSArray *lists, NSError *error))block;
+ (void)getListWorkOrderWithUserID:(NSString *)userID page:(NSInteger)page completion:(void(^)(NSArray *lists, NSError *error))block;

+ (void)getListWorkOrderDetailWithID:(NSInteger)pengajuanId completion:(void(^)(NSDictionary *response, NSError *error))block;
+ (void)getListWorkOrderDetailCompleteDataWithID:(NSInteger)pengajuanId completion:(void(^)(NSDictionary *response, NSError *error))block;

+ (void)postDraftWorkOrder:(List *)list dictionary:(NSDictionary *)dictionary isOffline:(BOOL)isOffline completion:(void(^)(NSDictionary *dictionary, NSError *error))block;
+ (void)postListWorkOrder:(List *)list dictionary:(NSDictionary *)dictionary completion:(void(^)(NSDictionary *dictionary, NSError *error))block;

+ (void)setBlackListWithID:(NSInteger)pengajuanId type:(NSString *)type completion:(void(^)(NSDictionary *dictionary, NSError *error))block;
+ (void)setApproveWithID:(NSInteger)pengajuanId completion:(void(^)(NSDictionary *dictionary, NSError *error))block; //for officer only i guess
+ (void)setStopProccessWithID:(NSInteger)pengajuanId reason:(NSInteger)reason completion:(void(^)(NSDictionary *dictionary, NSError *error))block;
+ (void)deleteCustomerDraft:(NSNumber *)draftID;

+ (void)getViewStepMonitoringWithID:(NSInteger)pengajuanId completion:(void(^)(NSArray *datas, NSError *error))block;
+ (void)setStopProccessWithID:(NSInteger)pengajuanId completion:(void(^)(NSDictionary *dictionary, NSError *error))block;
@end
