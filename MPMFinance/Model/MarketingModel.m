//
//  MarketingModel.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 6/22/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "MarketingModel.h"
#import "List.h"

@implementation MarketingModel

+ (void)getAllMarketingBySupervisor:(NSInteger)dataPengajuanId completion:(void(^)(NSArray *lists, NSError *error))block{
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    NSDictionary* param = @{@"userid" : [MPMUserInfo getUserInfo][@"userId"],
                            @"token" : [MPMUserInfo getToken],
                            @"data" : @{@"dataPengajuanId" : @(dataPengajuanId)}};

    [manager POST:[NSString stringWithFormat:@"%@/pengajuan/getallmarketingbyspv", kApiUrl] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @try {
            NSInteger code = [[responseObject objectForKey:@"statusCode"] integerValue];
            NSString *message = [responseObject objectForKey:@"message"];
            if (code == 200) {
                NSDictionary *data = responseObject[@"data"];
                NSMutableArray *lists = [NSMutableArray array];
                for (NSDictionary* listDict in data) {
                    List *list = [[List alloc] init];
                    list.primaryKey = [listDict[@"id"] integerValue];
                    list.title = listDict[@"nama"];
                    list.assignee = [NSString stringWithFormat:@"Summary Work Order %@", listDict[@"jumlahwo"]];
                    list.imageURL = listDict[@"foto"];
                    [lists addObject:list];
                }
            
                if (block) block(lists, nil);
                
            } else {
                if (block) block(nil, [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier]
                                                          code:code
                                                      userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(message, nil)}]);
            }
            
        } @catch (NSException *exception) {
            NSLog(@"%@", exception);
            if (block) block(nil, [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier]
                                                      code:1
                                                  userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(exception.reason, nil)}]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        if (block) block(nil, error);
        
    }];
}

@end
