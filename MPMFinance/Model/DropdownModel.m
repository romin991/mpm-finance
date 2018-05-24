//
//  DropdownModel.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 6/6/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "DropdownModel.h"

@implementation DropdownModel

+ (void)getDropdownForType:(NSString *)type completion:(void(^)(NSArray *options, NSError *error))block{
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    NSDictionary* param = @{@"userid" : [MPMUserInfo getUserInfo][@"userId"],
                            @"token" : [MPMUserInfo getToken],
                            @"data" : @{@"tipe" : type}
                            };
    
    [manager POST:[NSString stringWithFormat:@"%@/dropdown", kApiUrl] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @try {
            NSInteger code = [[responseObject objectForKey:@"statusCode"] integerValue];
            NSString *message = [responseObject objectForKey:@"message"];
            if (code == 200) {
                NSMutableArray *options = [NSMutableArray array];
                for (NSDictionary *dictionary in [responseObject objectForKey:@"data"]) {
                    Option *option = [[Option alloc] init];
                    option.primaryKey = [[dictionary objectForKey:@"id"] integerValue];
                    option.name = [dictionary objectForKey:@"value"];
                    
                    [options addObject:option];
                }
                
                if (block) block(options, nil);
                
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
+ (void)getDropdownMarketingForTypeWithcompletion:(void(^)(NSArray *options, NSError *error))block{
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    NSDictionary* param = @{@"userid" : [MPMUserInfo getUserInfo][@"userId"],
                            @"token" : [MPMUserInfo getToken]
                            };
    
    [manager POST:[NSString stringWithFormat:@"%@/dropdown/listmarketing", kApiUrl] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @try {
            NSInteger code = [[responseObject objectForKey:@"statusCode"] integerValue];
            NSString *message = [responseObject objectForKey:@"message"];
            if (code == 200) {
                if (block) block(responseObject[@"data"], nil);
                
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

+ (void)getDropdownWSType:(NSString *)type keyword:(NSString *)keyword idCabang:(NSString *)idCabang additionalURL:(NSString *)additionalURL completion:(void(^)(NSArray *datas, NSError *error))block{
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    NSDictionary* param = @{@"userid" : [MPMUserInfo getUserInfo][@"userId"],
                            @"token" : [MPMUserInfo getToken],
                            @"data" : @{@"tipe" : type,
                                        @"keyword" : keyword,
                                        @"idCabang" : idCabang}
                            };
    
    [manager POST:[NSString stringWithFormat:@"%@/dropdownws/%@", kApiUrl, additionalURL] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @try {
            NSInteger code = [[responseObject objectForKey:@"statusCode"] integerValue];
            NSString *message = [responseObject objectForKey:@"message"];
            if (code == 200) {
                NSMutableArray *datas = [NSMutableArray array];
                for (NSDictionary *dictionary in [responseObject objectForKey:@"data"]) {
                    Data *data = [[Data alloc] init];
                    data.value = [dictionary objectForKey:@"id"];
                    data.name = [dictionary objectForKey:@"name"];
                    
                    [datas addObject:data];
                }
                
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
        if (block) block(nil, error);
    }];
}

+ (void)getDropdownWSType:(NSString *)type keyword:(NSString *)keyword idProduct:(NSString *)idProduct idCabang:(NSString *)idCabang additionalURL:(NSString *)additionalURL completion:(void(^)(NSArray *datas, NSError *error))block{
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    NSDictionary* param = @{@"userid" : [MPMUserInfo getUserInfo][@"userId"],
                            @"token" : [MPMUserInfo getToken],
                            @"data" : @{@"tipe" : type,
                                        @"keyword" : keyword,
                                        @"produckId" : idProduct,
                                        @"idCabang" : idCabang}
                            };
    
    [manager POST:[NSString stringWithFormat:@"%@/dropdownws/%@", kApiUrl, additionalURL] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @try {
            NSInteger code = [[responseObject objectForKey:@"statusCode"] integerValue];
            NSString *message = [responseObject objectForKey:@"message"];
            if (code == 200) {
                NSMutableArray *datas = [NSMutableArray array];
                for (NSDictionary *dictionary in [responseObject objectForKey:@"data"]) {
                    Data *data = [[Data alloc] init];
                    data.value = [dictionary objectForKey:@"id"];
                    data.name = [dictionary objectForKey:@"name"];
                    
                    [datas addObject:data];
                }
                
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
        if (block) block(nil, error);
    }];
}

+ (void)getDropdownWSType:(NSString *)type keyword:(NSString *)keyword idProductOffering:(NSString *)idProductOffering idCabang:(NSString *)idCabang additionalURL:(NSString *)additionalURL completion:(void(^)(NSArray *datas, NSError *error))block{
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    NSDictionary* param = @{@"userid" : [MPMUserInfo getUserInfo][@"userId"],
                            @"token" : [MPMUserInfo getToken],
                            @"data" : @{@"tipe" : type,
                                        @"keyword" : keyword,
                                        @"productOfferingId" : idProductOffering,
                                        @"idCabang" : idCabang}
                            };
    
    [manager POST:[NSString stringWithFormat:@"%@/dropdownws/%@", kApiUrl, additionalURL] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @try {
            NSInteger code = [[responseObject objectForKey:@"statusCode"] integerValue];
            NSString *message = [responseObject objectForKey:@"message"];
            if (code == 200) {
                NSMutableArray *datas = [NSMutableArray array];
                for (NSDictionary *dictionary in [responseObject objectForKey:@"data"]) {
                    Data *data = [[Data alloc] init];
                    data.value = [dictionary objectForKey:@"id"];
                    data.name = [dictionary objectForKey:@"name"];
                    
                    [datas addObject:data];
                }
                
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
        if (block) block(nil, error);
    }];
}

+ (void)getDropdownWSForPostalCodeWithKeyword:(NSString *)keyword idCabang:(NSString *)idCabang completion:(void(^)(NSArray *options, NSError *error))block{
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    NSDictionary* param = @{@"userid" : [MPMUserInfo getUserInfo][@"userId"],
                            @"token" : [MPMUserInfo getToken],
                            @"data" : @{@"tipe" : @"KodePos",
                                        @"keyword" : keyword,
                                        @"idCabang" : @""}
                            };
    
    [manager POST:[NSString stringWithFormat:@"%@/dropdownws/kodepos", kApiUrl] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @try {
            NSInteger code = [[responseObject objectForKey:@"statusCode"] integerValue];
            NSString *message = [responseObject objectForKey:@"message"];
            if (code == 200) {
                NSMutableArray *postalCodes = [NSMutableArray array];
                for (NSDictionary *dictionary in [responseObject objectForKey:@"data"]) {
                    PostalCode *postalCode = [[PostalCode alloc] init];
                    postalCode.postalCode = [dictionary objectForKey:@"kodePos"];
                    postalCode.disctrict = [dictionary objectForKey:@"kelurahan"];
                    postalCode.subDistrict = [dictionary objectForKey:@"kecamatan"];
                    postalCode.city = [dictionary objectForKey:@"kota"];
                    
                    [postalCodes addObject:postalCode];
                }
                
                if (block) block(postalCodes, nil);
                
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

+ (void)getDropdownWSForAssetWithKeyword:(NSString *)keyword idProduct:(NSString *)idProduct idCabang:(NSString *)idCabang completion:(void(^)(NSArray *options, NSError *error))block{
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    NSDictionary* param = @{@"userid" : [MPMUserInfo getUserInfo][@"userId"],
                            @"token" : [MPMUserInfo getToken],
                            @"data" : @{@"tipe" : @"Asset",
                                        @"keyword" : keyword,
                                        @"produckId" : idProduct,
                                        @"idCabang" : idCabang}
                            };
    
    [manager POST:[NSString stringWithFormat:@"%@/dropdownws/asset", kApiUrl] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @try {
            NSInteger code = [[responseObject objectForKey:@"statusCode"] integerValue];
            NSString *message = [responseObject objectForKey:@"message"];
            if (code == 200) {
                NSMutableArray *assets = [NSMutableArray array];
                for (NSDictionary *dictionary in [responseObject objectForKey:@"data"]) {
                    Asset *asset = [[Asset alloc] init];
                    asset.name = [dictionary objectForKey:@"name"];
                    asset.value = [dictionary objectForKey:@"id"];
                    
                    [assets addObject:asset];
                }
                
                if (block) block(assets, nil);
                
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
