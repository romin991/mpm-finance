//
//  APIModel.h
//  MPMFinance
//
//  Created by Rudy Suharyadi on 5/25/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "List.h"

@interface APIModel : NSObject

//datamap/getworkorder with status all
+ (void)getAllListWorkOrderPage:(NSInteger)page completion:(void(^)(NSArray *lists, NSError *error))block;

//datamap/getworkorder with status needApproval
+ (void)getNeedApprovalListWorkOrderPage:(NSInteger)page completion:(void(^)(NSArray *lists, NSError *error))block;

//datamap/getworkorder with status badUsers
+ (void)getBadUsersListWorkOrderPage:(NSInteger)page completion:(void(^)(NSArray *lists, NSError *error))block;

//datamap/getworkorder with status listMapDraff
+ (void)getMapDraftListWorkOrderPage:(NSInteger)page completion:(void(^)(NSArray *lists, NSError *error))block;

//datamap/getworkorder with status listSurveyDraff
+ (void)getSurveyDraftListWorkOrderPage:(NSInteger)page completion:(void(^)(NSArray *lists, NSError *error))block;

//pengajuan/getallbyuser with status new
+ (void)getNewByUserListWorkOrderPage:(NSInteger)page completion:(void(^)(NSArray *lists, NSError *error))block;

//pengajuan/getallbyuser with status monitoring
+ (void)getMonitoringByUserListWorkOrderPage:(NSInteger)page completion:(void(^)(NSArray *lists, NSError *error))block;

//pengajuan/getallbyspv with status new
+ (void)getNewBySupervisorListWorkOrderPage:(NSInteger)page completion:(void(^)(NSArray *lists, NSError *error))block;

//pengajuan/getallbyspv with status badUsers
+ (void)getBadUsersBySupervisorListWorkOrderPage:(NSInteger)page completion:(void(^)(NSArray *lists, NSError *error))block;

//pengajuan/getallbyspv with status listMap
+ (void)getMapBySupervisorListWorkOrderPage:(NSInteger)page completion:(void(^)(NSArray *lists, NSError *error))block;

//pengajuan/getallbyspv with status listSurvey
+ (void)getSurveyBySupervisorListWorkOrderPage:(NSInteger)page completion:(void(^)(NSArray *lists, NSError *error))block;

//pengajuan/getallmarketingbyspv with dataPengajuanId
+ (void)getAllMarketingBySupervisor:(NSInteger)dataPengajuanId completion:(void(^)(NSArray *lists, NSError *error))block;


//pengajuan/jumlahnotifikasi
+ (void) getJumlahNotifikasiWithCompletion:(void(^)(NSInteger jumlahNotifikasi, NSError *error))block;
//pengajuan/readnotifikasi
+ (void) readNotifikasiWithID:(NSString *)idNotifikasi andKeterangan:(NSString *)keterangan;
//pengajuan2/getlistmarketingalternate
+ (void) getListMarketingAlternateWithWithUserId:(NSString *)userId Completion:(void(^)(NSArray *data, NSError *error))block;

//pengajuan2/detailalternate
+ (void) getDetailAlternate:(NSString *)detailID WithCompletion:(void(^)(NSDictionary *data, NSError *error))block;
//pengajuan2/setalternate
+ (void) setAlternateWithWithDateBegin:(NSString *)dateBegin
                                            dateEnd:(NSString *)dateEnd
                                          marketing:(NSString *)marketing
                                 marketingAlternate:(NSString *)marketingAlternate
                                           alasanId:(NSString *)alasanId
                            Completion:(void(^)(NSString *data, NSError *error))block;
@end
