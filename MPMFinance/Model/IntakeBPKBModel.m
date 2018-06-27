//
//  IntakeBPKBModel.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 7/5/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "IntakeBPKBModel.h"

@implementation IntakeBPKBModel

+ (void)getIntakeBPKBDataWithAgreementNo:(NSString *)agreementNo completion:(void(^)(NSDictionary *dictionary, NSError *error))block{
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithDictionary:
                                  @{@"userid" :[MPMUserInfo getUserInfo][@"userId"],
                                    @"token" : [MPMUserInfo getToken]}];
    
    NSMutableDictionary *dataDictionary = [NSMutableDictionary dictionary];
    
    @try {
        [dataDictionary setObject:agreementNo forKey:@"agreementNo"];
        
        [param setObject:dataDictionary forKey:@"data"];
        
        [manager POST:[NSString stringWithFormat:@"%@/mpmapi/pengambilanbpkb", kApiUrl] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            @try {
                NSInteger code = [[responseObject objectForKey:@"statusCode"] integerValue];
                NSString *message = [responseObject objectForKey:@"message"];
                if (code == 200) {
                    NSDictionary *data = [responseObject objectForKey:@"data"];
                    NSDictionary *dictionary = @{@"nama" : [data objectForKey:@"customerName"],
                                                 @"statusKontrak" : [data objectForKey:@"contractStatus"],
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
        
    } @catch (NSException *exception) {
        NSLog(@"%@", exception);
        if (block) block(nil, [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier]
                                                  code:1
                                              userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(exception.reason, nil)}]);
    }
}

+ (void)getListIntakeBPKBCompletion:(void(^)(NSArray *responses, NSError *error))block{
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    NSDictionary* param = @{@"userid" : [MPMUserInfo getUserInfo][@"userId"],
                            @"token" : [MPMUserInfo getToken],
                            };
    
    [manager POST:[NSString stringWithFormat:@"%@/bpkb/pengambilan/getall",kApiUrl] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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

+ (void)postIntakeBPKBWithDictionary:(NSDictionary *)dictionary completion:(void(^)(NSDictionary *dictionary, NSError *error))block{
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithDictionary:
                                  @{@"userid" :[MPMUserInfo getUserInfo][@"userId"],
                                    @"token" : [MPMUserInfo getToken]}];
    
    NSMutableDictionary *dataDictionary = [NSMutableDictionary dictionary];
    @try {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd-MM-YYYY"];
        
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
        [timeFormatter setDateFormat:@"hh:mm:ss"];
        
        [dataDictionary addEntriesFromDictionary:
         @{@"nama" : [dictionary objectForKey:@"nama"] ? [dictionary objectForKey:@"nama"] : @"",
           @"noKontrak" : [dictionary objectForKey:@"noKontrak"] ? [dictionary objectForKey:@"noKontrak"] : @"",
           @"statusKontrak" : [dictionary objectForKey:@"statusKontrak"] ? [dictionary objectForKey:@"statusKontrak"] : @"",
           @"tglPengambilanDoc" : [dictionary objectForKey:@"tanggalPengambilanDokumen"] ? [dictionary objectForKey:@"tanggalPengambilanDokumen"] : @"",
           @"jamPengambilan" : [dictionary objectForKey:@"jamPengambilanDokumen"] ? [dictionary objectForKey:@"jamPengambilanDokumen"] : @"",
           @"status" : @1,
          
           }];
        
        [param setObject:dataDictionary forKey:@"data"];
        
        [manager POST:[NSString stringWithFormat:@"%@/bpkb/pengambilan", kApiUrl] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
        
    } @catch (NSException *exception) {
        NSLog(@"%@", exception);
        if (block) block(nil, [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier]
                                                  code:1
                                              userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(exception.reason, nil)}]);
        
    }
}
@end
