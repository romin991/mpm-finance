//
//  CustomerGetCustomerModel.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 8/21/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "CustomerGetCustomerModel.h"

@implementation CustomerGetCustomerModel

+ (void)postCustomerGetCustomerWithDictionary:(NSDictionary *)dictionary completion:(void(^)(NSDictionary *dictionary, NSError *error))block{
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithDictionary:
                                  @{@"userid" :[MPMUserInfo getUserInfo][@"userId"],
                                    @"token" : [MPMUserInfo getToken]}];
    
    NSMutableDictionary *dataDictionary = [NSMutableDictionary dictionary];
    @try {
        [dataDictionary addEntriesFromDictionary:
         @{@"merk" : [dictionary objectForKey:@"id"] ?: @"",
           @"noHp" : [dictionary objectForKey:@"id"] ?: @"",
           @"nama" : [dictionary objectForKey:@"id"] ?: @"",
           @"alamat" : [dictionary objectForKey:@"id"] ?: @"",
           @"email" : [dictionary objectForKey:@"id"] ?: @"",
           @"tahunKendaraan" : [dictionary objectForKey:@"id"] ?: @"",
           }];
        
        [param setObject:dataDictionary forKey:@"data"];
        
        [manager POST:[NSString stringWithFormat:@"%@/customergetcustomer", kApiUrl] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
            if (block) block(nil, error);
        }];
        
    } @catch (NSException *exception) {
        NSLog(@"%@", exception);
        if (block) block(nil, [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier]
                                                  code:1
                                              userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(exception.reason, nil)}]);
        
    }
}

@end
