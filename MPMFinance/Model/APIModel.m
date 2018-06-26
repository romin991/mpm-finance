//
//  APIModel.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 5/25/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "APIModel.h"
#import "SurveyModel.h"
#import "WorkOrderModel.h"
#import "MarketingModel.h"

@implementation APIModel

+ (void) getJumlahNotifikasiWithCompletion:(void(^)(NSInteger jumlahNotifikasi, NSError *error))block {
    AFHTTPSessionManager *manager = [MPMGlobal sessionManager];
    NSDictionary *param = @{ @"userid" : [MPMUserInfo getUserInfo][@"userId"],
                             @"token" : [MPMUserInfo getToken]
                             };
    [manager POST:[NSString stringWithFormat:@"%@/pengajuan/jumlahnotifikasi",kApiUrl] parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject objectForKey:@"data"]) {
            block([responseObject[@"data"] integerValue],nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString *errorMessage = error.localizedDescription;
        NSInteger statusCode = 0;
        @try{
            NSDictionary *errorResponse = [NSJSONSerialization JSONObjectWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey]
                                                                          options:NSJSONReadingAllowFragments
                                                                            error:nil];
            errorMessage = [errorResponse objectForKey:@"message"];
            statusCode = [[errorResponse objectForKey:@"statusCode"] integerValue];
        } @catch(NSException *exception) {
            NSLog(@"%@", exception);
        }
        if (block) block(0, [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier]
                                                  code:1
                                              userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(errorMessage, nil)}]);
        
        if (statusCode == 605) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UserKickNotification" object:nil];
        }
    }];
}
+ (void) getAllMarketingWithCompletion:(void(^)(NSArray *data, NSError *error))block {
    AFHTTPSessionManager *manager = [MPMGlobal sessionManager];
    NSDictionary *param = @{ @"userid" : [MPMUserInfo getUserInfo][@"userId"],
                             @"token" : [MPMUserInfo getToken]
                             };
    [manager POST:[NSString stringWithFormat:@"%@/tracking/getallmarketing",kApiUrl] parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject objectForKey:@"data"]) {
            block(responseObject[@"data"],nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString *errorMessage = error.localizedDescription;
        NSInteger statusCode = 0;
        @try{
            NSDictionary *errorResponse = [NSJSONSerialization JSONObjectWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey]
                                                                          options:NSJSONReadingAllowFragments
                                                                            error:nil];
            errorMessage = [errorResponse objectForKey:@"message"];
            statusCode = [[errorResponse objectForKey:@"statusCode"] integerValue];
        } @catch(NSException *exception) {
            NSLog(@"%@", exception);
        }
        if (block) block(@[], [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier]
                                                  code:1
                                              userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(errorMessage, nil)}]);
        
        if (statusCode == 605) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UserKickNotification" object:nil];
        }
    }];
}
+ (void) getAllMarketingTrackingDetail:(NSString *)marketingUserId WithCompletion:(void(^)(NSArray *data, NSError *error))block {
    AFHTTPSessionManager *manager = [MPMGlobal sessionManager];
    NSDictionary *param = @{ @"userid" : [MPMUserInfo getUserInfo][@"userId"],
                             @"token" : [MPMUserInfo getToken],
                             @"data" : @{@"marketingUserId" : marketingUserId}
                             };
    [manager POST:[NSString stringWithFormat:@"%@/tracking/getmarketingtrackingdetail",kApiUrl] parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject objectForKey:@"data"]) {
            block(responseObject[@"data"],nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString *errorMessage = error.localizedDescription;
        NSInteger statusCode = 0;
        @try{
            NSDictionary *errorResponse = [NSJSONSerialization JSONObjectWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey]
                                                                          options:NSJSONReadingAllowFragments
                                                                            error:nil];
            errorMessage = [errorResponse objectForKey:@"message"];
            statusCode = [[errorResponse objectForKey:@"statusCode"] integerValue];
        } @catch(NSException *exception) {
            NSLog(@"%@", exception);
        }
        if (block) block(@[], [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier]
                                                  code:1
                                              userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(errorMessage, nil)}]);
        
        if (statusCode == 605) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UserKickNotification" object:nil];
        }
    }];
}

+ (void) getDetailAlternate:(NSString *)detailID WithCompletion:(void(^)(NSDictionary *data, NSError *error))block {
    AFHTTPSessionManager *manager = [MPMGlobal sessionManager];
    NSDictionary *param = @{ @"userid" : [MPMUserInfo getUserInfo][@"userId"],
                             @"token" : [MPMUserInfo getToken],
                             @"data": @{
                                     @"id" : detailID
                                     }
                             };
    [manager POST:[NSString stringWithFormat:@"%@/pengajuan2/detailalternate",kApiUrl] parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject objectForKey:@"data"]) {
            block(responseObject[@"data"],nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString *errorMessage = error.localizedDescription;
        NSInteger statusCode = 0;
        @try{
            NSDictionary *errorResponse = [NSJSONSerialization JSONObjectWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey]
                                                                          options:NSJSONReadingAllowFragments
                                                                            error:nil];
            errorMessage = [errorResponse objectForKey:@"message"];
            statusCode = [[errorResponse objectForKey:@"statusCode"] integerValue];
        } @catch(NSException *exception) {
            NSLog(@"%@", exception);
        }
        if (block) block(nil, [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier]
                                                  code:1
                                              userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(errorMessage, nil)}]);
        
        if (statusCode == 605) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UserKickNotification" object:nil];
        }
    }];
}
+ (void) getListMarketingAlternateWithWithUserId:(NSString *)userId Completion:(void(^)(NSArray *data, NSError *error))block {
    AFHTTPSessionManager *manager = [MPMGlobal sessionManager];
    NSDictionary *param = @{ @"userid" : [MPMUserInfo getUserInfo][@"userId"],
                             @"token" : [MPMUserInfo getToken],
                             @"data": @{
                                     @"mkt": userId
                                     }
                             };
    [manager POST:[NSString stringWithFormat:@"%@/pengajuan2/getlistmarketingalternate",kApiUrl] parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject objectForKey:@"data"]) {
            block(responseObject[@"data"],nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString *errorMessage = error.localizedDescription;
        NSInteger statusCode = 0;
        @try{
            NSDictionary *errorResponse = [NSJSONSerialization JSONObjectWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey]
                                                                          options:NSJSONReadingAllowFragments
                                                                            error:nil];
            errorMessage = [errorResponse objectForKey:@"message"];
            statusCode = [[errorResponse objectForKey:@"statusCode"] integerValue];
        } @catch(NSException *exception) {
            NSLog(@"%@", exception);
        }
        if (block) block(@[], [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier]
                                                  code:1
                                              userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(errorMessage, nil)}]);
        
        if (statusCode == 605) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UserKickNotification" object:nil];
        }
    }];
}
+ (void) setAlternateWithWithDateBegin:(NSString *)dateBegin
                                            dateEnd:(NSString *)dateEnd
                                          marketing:(NSString *)marketing
                                 marketingAlternate:(NSString *)marketingAlternate
                                           alasanId:(NSString *)alasanId
                                         Completion:(void(^)(NSString *data, NSError *error))block {
    AFHTTPSessionManager *manager = [MPMGlobal sessionManager];
    NSDictionary *param = @{ @"userid" : [MPMUserInfo getUserInfo][@"userId"],
                             @"token" : [MPMUserInfo getToken],
                             @"data": @{
                                     @"dateBegin" : dateBegin,
                                     @"dateEnd" : dateEnd,
                                     @"marketing" : marketing,
                                     @"marketingAlternate" : marketingAlternate,
                                     @"alasan" : alasanId
                                     }
                             };
    [manager POST:[NSString stringWithFormat:@"%@/pengajuan2/setalternate",kApiUrl] parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject objectForKey:@"data"]) {
            block(responseObject[@"data"],nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString *errorMessage = error.localizedDescription;
        NSInteger statusCode = 0;
        @try{
            NSDictionary *errorResponse = [NSJSONSerialization JSONObjectWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey]
                                                                          options:NSJSONReadingAllowFragments
                                                                            error:nil];
            errorMessage = [errorResponse objectForKey:@"message"];
            statusCode = [[errorResponse objectForKey:@"statusCode"] integerValue];
        } @catch(NSException *exception) {
            NSLog(@"%@", exception);
        }
        if (block) block(nil, [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier]
                                                  code:1
                                              userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(errorMessage, nil)}]);
        
        if (statusCode == 605) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UserKickNotification" object:nil];
        }
    }];
}
+ (void) readNotifikasiWithID:(NSString *)idNotifikasi andKeterangan:(NSString *)keterangan {
    AFHTTPSessionManager *manager = [MPMGlobal sessionManager];
    NSDictionary *param = @{ @"userid" : [MPMUserInfo getUserInfo][@"userId"],
                             @"token" : [MPMUserInfo getToken],
                             @"data" : @{@"id" : idNotifikasi,
                                         @"ket" : keterangan
                                         }
                             };
    [manager POST:[NSString stringWithFormat:@"%@/pengajuan/notifikasiread",kApiUrl] parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
    }];
}
+ (void) cancelAlternateWithId:(NSString *)idAlternate andDateBegin:(NSString *)dateBegin andMarketing:(NSString *)marketing withCompletion:(void(^)(NSString *responseString, NSError *error))block{
    AFHTTPSessionManager *manager = [MPMGlobal sessionManager];
    NSDictionary *param = @{ @"userid" : [MPMUserInfo getUserInfo][@"userId"],
                             @"token" : [MPMUserInfo getToken],
                             @"data" : @{@"id" : idAlternate,
                                         @"dateBegin" : dateBegin,
                                         @"marketing" : marketing
                                         }
                             };
    [manager POST:[NSString stringWithFormat:@"%@/pengajuan2/cancelalternate",kApiUrl] parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        block(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(nil,error);
    }];
}
+ (void) forgotPasswordWithUserName:(NSString *)username withCompletion:(void(^)(NSString *responseString, NSError *error))block{
    AFHTTPSessionManager *manager = [MPMGlobal sessionManager];
   // [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    
    [securityPolicy setValidatesDomainName:NO];
    [manager setSecurityPolicy:securityPolicy];
    NSDictionary *param = @{ @"ausername" : username
                             };
    [manager POST:[NSString stringWithFormat:@"%@/login/forgot_by_email",kMPMUrl] parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError* error;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:kNilOptions error:&error];
        block(json[@"ind"],nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(@"",error);
    }];
}
+ (void)getAllListWorkOrderPage:(NSInteger)page completion:(void(^)(NSArray *lists, NSError *error))block{
    [WorkOrderModel getListWorkOrderWithStatus:@"clear" page:page completion:block];
}

+ (void)getNeedApprovalListWorkOrderPage:(NSInteger)page completion:(void(^)(NSArray *lists, NSError *error))block{
    [WorkOrderModel getListWorkOrderWithStatus:@"approval" page:page completion:block];
}

+ (void)getBadUsersListWorkOrderPage:(NSInteger)page completion:(void(^)(NSArray *lists, NSError *error))block{
    [WorkOrderModel getListWorkOrderWithStatus:@"negative" page:page completion:block];
}

+ (void)getMapDraftListWorkOrderPage:(NSInteger)page completion:(void(^)(NSArray *lists, NSError *error))block{
    [WorkOrderModel getListWorkOrderWithStatus:@"listMapDraff" page:page completion:block];
}

+ (void)getSurveyDraftListWorkOrderPage:(NSInteger)page completion:(void(^)(NSArray *lists, NSError *error))block{
    [WorkOrderModel getListWorkOrderWithStatus:@"listSurveyDraff" page:page completion:block];
}

+ (void)getNewByUserListWorkOrderPage:(NSInteger)page completion:(void(^)(NSArray *lists, NSError *error))block{
    [WorkOrderModel getListWorkOrderByUserWithStatus:@"new" page:page completion:block];
}

+ (void)getMonitoringByUserListWorkOrderPage:(NSInteger)page completion:(void(^)(NSArray *lists, NSError *error))block{
    [WorkOrderModel getListWorkOrderByUserWithStatus:@"monitoring" page:page completion:block];
}

+ (void)getNewBySupervisorListWorkOrderPage:(NSInteger)page completion:(void(^)(NSArray *lists, NSError *error))block{
    [WorkOrderModel getListWorkOrderBySupervisorWithStatus:@"new" page:page completion:block];
}

+ (void)getBadUsersBySupervisorListWorkOrderPage:(NSInteger)page completion:(void(^)(NSArray *lists, NSError *error))block{
    [WorkOrderModel getListWorkOrderBySupervisorWithStatus:@"badUsers" page:page completion:block];
}

+ (void)getMapBySupervisorListWorkOrderPage:(NSInteger)page completion:(void(^)(NSArray *lists, NSError *error))block{
    [WorkOrderModel getListWorkOrderBySupervisorWithStatus:@"listMap" page:page completion:block];
}

+ (void)getSurveyBySupervisorListWorkOrderPage:(NSInteger)page completion:(void(^)(NSArray *lists, NSError *error))block{
    [WorkOrderModel getListWorkOrderBySupervisorWithStatus:@"listSurvey" page:page completion:block];
}

+ (void)getAllMarketingBySupervisor:(NSInteger)dataPengajuanId completion:(void(^)(NSArray *lists, NSError *error))block{
    [MarketingModel getAllMarketingBySupervisor:dataPengajuanId completion:block];
}

















+(void)getListProduct:(void(^)(NSArray *lists, NSError *error))block
{
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    NSDictionary* param = @{@"userid" : [MPMUserInfo getUserInfo][@"userId"],
                            @"token" : [MPMUserInfo getToken]};
    
    [manager POST:[NSString stringWithFormat:@"%@/product",kApiUrl] parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"statusCode"] isEqual:@200]) {
            NSMutableArray *lists = [NSMutableArray array];
            lists = responseObject[@"data"];
            if (block) block(lists, nil);
        } else {
            NSInteger code = 0;
            NSString *message = @"";
            @try {
                if (responseObject[@"statusCode"]) code = [responseObject[@"statusCode"] integerValue];
                if (responseObject[@"message"]) message = responseObject[@"message"];
            } @catch (NSException *exception) {
                NSLog(@"%@", exception);
            } @finally {
                if (block) block(nil, [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier]
                                                          code:code
                                                      userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(message, nil)}]);
            }
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString *errorMessage = error.localizedDescription;
        NSInteger statusCode = 0;
        @try{
            NSDictionary *errorResponse = [NSJSONSerialization JSONObjectWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey]
                                                                          options:NSJSONReadingAllowFragments
                                                                            error:nil];
            errorMessage = [errorResponse objectForKey:@"message"];
            statusCode = [[errorResponse objectForKey:@"statusCode"] integerValue];
        } @catch(NSException *exception) {
            NSLog(@"%@", exception);
        }
        if (block) block(nil, [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier]
                                                  code:1
                                              userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(errorMessage, nil)}]);
        
        if (statusCode == 605) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UserKickNotification" object:nil];
        }
    }];
}

+ (void)getListPengembalianBPKB:(void(^)(NSArray *lists, NSError *error))block
{
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    NSDictionary* param = @{@"userid" :[MPMUserInfo getUserInfo][@"userId"],
                            @"token" : [MPMUserInfo getToken]};
    
    [manager POST:[NSString stringWithFormat:@"%@/datamap/getworkorder", kApiUrl] parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"statusCode"] isEqual:@200]) {
            NSMutableArray *lists = [NSMutableArray array];
            NSLog(@"%@",responseObject);
            for (NSDictionary* listDict in responseObject[@"data"]) {
                //                List *list = [[List alloc] init];
                //                list.title = listDict[@"noRegistrasi"];
                //                list.date = listDict[@"tanggal"];
                //                list.assignee = listDict[@"namaPengaju"];
                //                list.imageURL = @"https://image.flaticon.com/teams/new/1-freepik.jpg";
                //                [lists addObject:list];
            }
            
            if (block) block(lists, nil);
        } else {
            NSInteger code = 0;
            NSString *message = @"";
            @try {
                if (responseObject[@"statusCode"]) code = [responseObject[@"statusCode"] integerValue];
                if (responseObject[@"message"]) message = responseObject[@"message"];
            } @catch (NSException *exception) {
                NSLog(@"%@", exception);
            } @finally {
                if (block) block(nil, [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier]
                                                          code:code
                                                      userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(message, nil)}]);
            }
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString *errorMessage = error.localizedDescription;
        NSInteger statusCode = 0;
        @try{
            NSDictionary *errorResponse = [NSJSONSerialization JSONObjectWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey]
                                                                          options:NSJSONReadingAllowFragments
                                                                            error:nil];
            errorMessage = [errorResponse objectForKey:@"message"];
            statusCode = [[errorResponse objectForKey:@"statusCode"] integerValue];
        } @catch(NSException *exception) {
            NSLog(@"%@", exception);
        }
        if (block) block(nil, [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier]
                                                  code:1
                                              userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(errorMessage, nil)}]);
        
        if (statusCode == 605) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UserKickNotification" object:nil];
        }
    }];
    
}
@end
