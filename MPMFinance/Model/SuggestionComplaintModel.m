//
//  SuggestionComplaintModel.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 7/5/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "SuggestionComplaintModel.h"

@implementation SuggestionComplaintModel

+ (void)getProfileDataWithAgreementNo:(NSString *)agreementNo completion:(void(^)(NSDictionary *dictionary, NSError *error))block{
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithDictionary:
                                  @{@"userid" :[MPMUserInfo getUserInfo][@"userId"],
                                    @"token" : [MPMUserInfo getToken]}];
    
    NSMutableDictionary *dataDictionary = [NSMutableDictionary dictionary];
    
    @try {
        [dataDictionary setObject:agreementNo forKey:@"agreementNo"];
        
        [param setObject:dataDictionary forKey:@"data"];
        
        [manager POST:[NSString stringWithFormat:@"%@/mpmapi/profilecustomerinfo", kApiUrl] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            @try {
                NSInteger code = [[responseObject objectForKey:@"statusCode"] integerValue];
                NSString *message = [responseObject objectForKey:@"message"];
                if (code == 200) {
                    NSDictionary *data = [responseObject objectForKey:@"data"];
                    NSDictionary *dictionary = @{@"nama" : [data objectForKey:@"customerName"],
                                                 @"nomorTelepon" : [data objectForKey:@"phone"],
                                                 @"nomorHandphone" : [data objectForKey:@"mobilePhone"],
                                                 @"alamat" : [data objectForKey:@"address"],
                                                 @"email" : [data objectForKey:@"email"],
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
            @try{
                NSDictionary *errorResponse = [NSJSONSerialization JSONObjectWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey]
                                                                              options:NSJSONReadingAllowFragments
                                                                                error:nil];
                errorMessage = [errorResponse objectForKey:@"message"];
            } @catch(NSException *exception) {
                NSLog(@"%@", exception);
            }
            if (block) block(nil, [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier]
                                                      code:1
                                                  userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(errorMessage, nil)}]);
        }];
        
    } @catch (NSException *exception) {
        NSLog(@"%@", exception);
        if (block) block(nil, [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier]
                                                  code:1
                                              userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(exception.reason, nil)}]);
    }
}

+ (void)postSuggestionWithDictionary:(NSDictionary *)dictionary completion:(void(^)(NSDictionary *dictionary, NSError *error))block{
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithDictionary:
                                  @{@"userid" :[MPMUserInfo getUserInfo][@"userId"],
                                    @"token" : [MPMUserInfo getToken]}];
    
    NSMutableDictionary *dataDictionary = [NSMutableDictionary dictionary];
    @try {
        [dataDictionary addEntriesFromDictionary:
         @{@"noHp" : [dictionary objectForKey:@"noHP"] ?: @"",
           @"nama" : [dictionary objectForKey:@"nama"] ?: @"",
           @"noKontrak" : [dictionary objectForKey:@"noKontrak"] ?: @"",
           @"alamat" : [dictionary objectForKey:@"alamat"] ?: @"",
           @"email" : [dictionary objectForKey:@"email"] ?: @"",
           @"saran" : [dictionary objectForKey:@"saran"] ?: @"",
           }];
        
        [param setObject:dataDictionary forKey:@"data"];
        
        [manager POST:[NSString stringWithFormat:@"%@/complain/saran", kApiUrl] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            @try {
                NSInteger code = [[responseObject objectForKey:@"statusCode"] integerValue];
                NSString *message = [responseObject objectForKey:@"message"];
                if (code == 200) {
                    if (block) block(responseObject, nil);
                    
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
            @try{
                NSDictionary *errorResponse = [NSJSONSerialization JSONObjectWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey]
                                                                              options:NSJSONReadingAllowFragments
                                                                                error:nil];
                errorMessage = [errorResponse objectForKey:@"message"];
            } @catch(NSException *exception) {
                NSLog(@"%@", exception);
            }
            if (block) block(nil, [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier]
                                                      code:1
                                                  userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(errorMessage, nil)}]);
        }];
        
    } @catch (NSException *exception) {
        NSLog(@"%@", exception);
        if (block) block(nil, [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier]
                                                  code:1
                                              userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(exception.reason, nil)}]);
        
    }
}

+ (void)postComplainWithDictionary:(NSDictionary *)dictionary completion:(void(^)(NSDictionary *dictionary, NSError *error))block{
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithDictionary:
                                  @{@"userid" :[MPMUserInfo getUserInfo][@"userId"],
                                    @"token" : [MPMUserInfo getToken]}];
    
    NSMutableDictionary *dataDictionary = [NSMutableDictionary dictionary];
    @try {
        [dataDictionary addEntriesFromDictionary:
         @{@"noKontrak" : [dictionary objectForKey:@"noKontrak"] ?: @"",
           @"subJnsMasalah" : [dictionary objectForKey:@"subJenisMasalah"] ?: @"",
           @"email" : [dictionary objectForKey:@"email"] ?: @"",
           @"noHpBaru" : [dictionary objectForKey:@"nomorHandphoneBaru"] ?: @"",
           @"kronologiMasalah" : [dictionary objectForKey:@"kronologisMasalah"] ?: @"",
           @"noTlp" : [dictionary objectForKey:@"nomorTelepon"] ?: @"",
           @"noHp" : [dictionary objectForKey:@"nomorHandphone"] ?: @"",
           @"nama" : [dictionary objectForKey:@"nama"] ?: @"",
           @"alamat" : [dictionary objectForKey:@"alamat"] ?: @"",
           @"noTlpBaru" : [dictionary objectForKey:@"nomorTeleponBaru"] ?: @"",
           @"penjelasanMasalah" : [dictionary objectForKey:@"penjelasanMasalah"] ?: @"",
           }];
        
        [param setObject:dataDictionary forKey:@"data"];
        
        [manager POST:[NSString stringWithFormat:@"%@/complain/pengaduan", kApiUrl] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            @try {
                NSInteger code = [[responseObject objectForKey:@"statusCode"] integerValue];
                NSString *message = [responseObject objectForKey:@"message"];
                if (code == 200) {
                    if (block) block(responseObject, nil);
                    
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
            @try{
                NSDictionary *errorResponse = [NSJSONSerialization JSONObjectWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey]
                                                                              options:NSJSONReadingAllowFragments
                                                                                error:nil];
                errorMessage = [errorResponse objectForKey:@"message"];
            } @catch(NSException *exception) {
                NSLog(@"%@", exception);
            }
            if (block) block(nil, [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier]
                                                      code:1
                                                  userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(errorMessage, nil)}]);
        }];
        
    } @catch (NSException *exception) {
        NSLog(@"%@", exception);
        if (block) block(nil, [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier]
                                                  code:1
                                              userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(exception.reason, nil)}]);
        
    }
}

+ (void)getListSuggestionCompletion:(void(^)(NSArray *responses, NSError *error))block{
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    NSDictionary* param = @{@"userid" : [MPMUserInfo getUserInfo][@"userId"],
                            @"token" : [MPMUserInfo getToken],
                            };
    
    [manager POST:[NSString stringWithFormat:@"%@/complain/saran/getall",kApiUrl] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @try {
            NSInteger code = [[responseObject objectForKey:@"statusCode"] integerValue];
            NSString *message = [responseObject objectForKey:@"message"];
            if (code == 200) {
                NSArray *datas = responseObject[@"data"];
                if (block) block(datas, nil);
                
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
        @try{
            NSDictionary *errorResponse = [NSJSONSerialization JSONObjectWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey]
                                                                          options:NSJSONReadingAllowFragments
                                                                            error:nil];
            errorMessage = [errorResponse objectForKey:@"message"];
        } @catch(NSException *exception) {
            NSLog(@"%@", exception);
        }
        if (block) block(nil, [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier]
                                                  code:1
                                              userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(errorMessage, nil)}]);
    }];
}

+ (void)getListComplainCompletion:(void(^)(NSArray *responses, NSError *error))block{
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    NSDictionary* param = @{@"userid" : [MPMUserInfo getUserInfo][@"userId"],
                            @"token" : [MPMUserInfo getToken],
                            };
    
    [manager POST:[NSString stringWithFormat:@"%@/complain/pengaduan/getall",kApiUrl] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @try {
            NSInteger code = [[responseObject objectForKey:@"statusCode"] integerValue];
            NSString *message = [responseObject objectForKey:@"message"];
            if (code == 200) {
                NSArray *datas = responseObject[@"data"];
                if (block) block(datas, nil);
                
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
        @try{
            NSDictionary *errorResponse = [NSJSONSerialization JSONObjectWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey]
                                                                          options:NSJSONReadingAllowFragments
                                                                            error:nil];
            errorMessage = [errorResponse objectForKey:@"message"];
        } @catch(NSException *exception) {
            NSLog(@"%@", exception);
        }
        if (block) block(nil, [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier]
                                                  code:1
                                              userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(errorMessage, nil)}]);
    }];
}

@end
