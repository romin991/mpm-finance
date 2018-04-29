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

+ (void)getProfileDataWithCompletion:(void(^)(NSDictionary *dictionary, NSError *error))block{
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithDictionary:
                                  @{@"userid" :[MPMUserInfo getUserInfo][@"userId"],
                                    @"token" : [MPMUserInfo getToken]}];
    
    [manager POST:[NSString stringWithFormat:@"%@/profile", kApiUrl] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @try {
            NSInteger code = [[responseObject objectForKey:@"statusCode"] integerValue];
            NSString *message = [responseObject objectForKey:@"message"];
            if (code == 200) {
                NSDictionary *data = [responseObject objectForKey:@"data"];
                NSDictionary *dictionary = @{@"namaLengkap" : [data objectForKey:@"username"],
                                             @"noKTP" : [data objectForKey:@"ktp"],
                                             @"tempatLahir" : [data objectForKey:@"placeOfBirth"],
                                             @"tanggalLahir" : [data objectForKey:@"dob"],
                                             @"jenisKelamin" : [data objectForKey:@"gender"]
                                             };
                
                if (block) block(dictionary, nil);
                
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
        if (block) block(nil, error);
    }];
}

@end
