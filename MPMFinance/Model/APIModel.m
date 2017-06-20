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

@implementation APIModel

+ (void)getAllListWorkOrderPage:(NSInteger)page completion:(void(^)(NSArray *lists, NSError *error))block{
    [WorkOrderModel getListWorkOrderWithStatus:@"all" page:page completion:block];
}

+ (void)getNeedApprovalListWorkOrderPage:(NSInteger)page completion:(void(^)(NSArray *lists, NSError *error))block{
    [WorkOrderModel getListWorkOrderWithStatus:@"needApproval" page:page completion:block];
}

+ (void)getBadUsersListWorkOrderPage:(NSInteger)page completion:(void(^)(NSArray *lists, NSError *error))block{
    [WorkOrderModel getListWorkOrderWithStatus:@"badUsers" page:page completion:block];
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
        if (block) block(nil, error);
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
        if (block) block(nil, error);
    }];
    
}
@end
