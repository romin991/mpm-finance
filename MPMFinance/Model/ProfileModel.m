//
//  ProfileModel.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 6/15/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "ProfileModel.h"
#import "MPMUserInfo.h"

@implementation ProfileModel

+ (void)checkTokenWithCompletion:(void (^)(BOOL isExpired))block {
    if ([MPMUserInfo isLoggedIn]) {
        NSMutableDictionary* param = [NSMutableDictionary dictionaryWithDictionary:
                                      @{@"userid" :[MPMUserInfo getUserInfo][@"userId"],
                                        @"token" : [MPMUserInfo getToken]}];
        
        AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
        [manager POST:[NSString stringWithFormat:@"%@/login/checktoken",kApiUrl] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@",responseObject);
            if (block) block(NO);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if(block) block(YES);
        }];
    }
}

@end
