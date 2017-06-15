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

+ (void)getListWorkOrderPage:(NSInteger)page completion:(void(^)(NSArray *lists, NSError *error))block{
    [WorkOrderModel getListWorkOrderWithPage:page completion:block];
}

+ (void)getListSurvey:(void(^)(NSArray *lists, NSError *error))block{
//    [SurveyModel getListSurvey:block];
}
+ (void)getListMapDraft:(void(^)(NSArray *lists, NSError *error))block{
    [self getListWorkOrderWithStatus:@"listMapDraft" block:^(NSArray *lists, NSError *error) {
        if (block) {
            block(lists,error);
        }
    }];
}

+ (void)getListWorkOrderWithStatus:(NSString*)status block:(void(^)(NSArray *lists, NSError *error))block{
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    NSDictionary* param = @{@"userid" : [MPMUserInfo getUserInfo][@"userId"],
                            @"token" : [MPMUserInfo getToken],
                            @"data" : @{@"status" : status,
                                        @"limit" : @20,
                                        @"offset" : @0}};
    NSLog(@"%@",param);
    [manager POST:[NSString stringWithFormat:@"%@/datamap/getworkorder",kApiUrl] parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"statusCode"] isEqual:@200]) {
            NSMutableArray *lists = [NSMutableArray array];
            NSLog(@"%@",responseObject);
            for (NSDictionary* listDict in responseObject[@"data"]) {
                List *list = [[List alloc] init];
                list.primaryKey = [listDict[@"id"] integerValue];
                list.title = listDict[@"noRegistrasi"];
                list.date = listDict[@"tanggal"];
                list.assignee = listDict[@"namaPengaju"];
                list.status = listDict[@"status"];
                list.type = listDict[@"tipeProduk"];
                list.statusColor = listDict[@"color"];
                list.imageURL = listDict[@"imageIconIos"];
                [lists addObject:list];
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
        NSLog(@"%@",error);
        if (block) block(nil, error);
        
    }];
    
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
