//
//  APIModel.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 5/25/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "APIModel.h"
#import "List.h"

@implementation APIModel

+ (void)getListWorkOrder:(void(^)(NSArray *lists, NSError *error))block{
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    NSDictionary* param = @{@"userid" : [MPMUserInfo getUserInfo][@"userId"],
                            @"token" : [MPMUserInfo getToken]};
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    __block NSArray* products;
    dispatch_group_enter(group);
    [APIModel getListProduct:^(NSArray *lists, NSError *error) {
        products = lists;
        dispatch_group_leave(group);
    }];
    
    dispatch_group_notify(group, queue, ^{
        [manager POST:[NSString stringWithFormat:@"%@/datamap/getworkorder",kApiUrl] parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
            ;
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject[@"statusCode"] isEqual:@200]) {
                NSMutableArray *lists = [NSMutableArray array];
                NSLog(@"%@",responseObject);
                for (NSDictionary* listDict in responseObject[@"data"]) {
                    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"id = %@",listDict[@"tipeProduk"]];
                    NSArray* tipeProducts = [products filteredArrayUsingPredicate:predicate];
                    
                    List *list = [[List alloc] init];
                    list.title = listDict[@"noRegistrasi"];
                    list.date = listDict[@"tanggal"];
                    list.assignee = listDict[@"namaPengaju"];
                    list.status = listDict[@"status"];
                    list.type = listDict[@"tipeProduk"];
                    list.statusColor = listDict[@"color"];
                    if (tipeProducts.count > 0) {
                        list.imageURL = tipeProducts[0][@"imageIcon"];
                    }
                    
                    [lists addObject:list];
                }
                
                if (block) block(lists, nil);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (block) block(nil, error);
        }];
    });
    
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
    [manager POST:[NSString stringWithFormat:@"%@/datamap/getworkorder",kApiUrl] parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
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
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) block(nil, error);
    }];

}
@end
