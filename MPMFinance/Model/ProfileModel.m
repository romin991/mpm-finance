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
                NSDictionary *dictionary = @{@"kodeCabang" : [data objectForKey:@"kodeCabang"],
                                             @"namaLengkap" : [data objectForKey:@"username"],
                                             @"noKTP" : [data objectForKey:@"ktp"],
                                             @"tempatLahir" : [data objectForKey:@"placeOfBirth"],
                                             @"tanggalLahir" : [data objectForKey:@"dob"],
                                             @"jenisKelamin" : @([[data objectForKey:@"gender"] integerValue]),
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

+ (void)login:(NSString *)username password:(NSString *)password completion:(void(^)(NSDictionary *dictionary, NSError *error))block{
    NSDictionary* param = @{@"userid" : username,
                            @"token" : @"",
                            @"data" : @{
                                    @"password" : [MPMGlobal MD5fromString:password],
                                    @"deviceId" : @"fcmid here",
                                    @"loginFrom" : @"mobile"
                                    }
                            };
    NSLog(@"%@",param);

    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    [manager POST:[NSString stringWithFormat:@"%@/login",kApiUrl] parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @try {
            NSInteger code = [[responseObject objectForKey:@"statusCode"] integerValue];
            NSString *message = [responseObject objectForKey:@"message"];
            if (code == 200) {
                NSDictionary *data = [responseObject objectForKey:@"data"];
                [MPMUserInfo save:data];
                
                if (block) block(data, nil);
                
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

+ (void)changePassword:(NSString *)oldPassword password:(NSString *)password completion:(void(^)(NSDictionary *dictionary, NSError *error))block{
    NSDictionary* param = @{@"userid" :[MPMUserInfo getUserInfo][@"userId"],
                            @"token" : [MPMUserInfo getToken],
                            @"data" : @{
                                    @"old_password" : [MPMGlobal MD5fromString:oldPassword],
                                    @"new_password" : [MPMGlobal MD5fromString:password],
                                    }
                            };
    NSLog(@"%@",param);

    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    [manager POST:[NSString stringWithFormat:@"%@/login/changepassword",kApiUrl] parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @try {
            NSInteger code = [[responseObject objectForKey:@"statusCode"] integerValue];
            NSString *message = [responseObject objectForKey:@"message"];
            if (code == 200) {
                NSDictionary *data = [responseObject objectForKey:@"data"];
                if (block) block(data, nil);
                
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
