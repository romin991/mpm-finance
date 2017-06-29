//
//  TopUpModel.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 6/29/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "TopUpModel.h"

@implementation TopUpModel

+ (void)getTopUpDataWithAgreementNo:(NSString *)agreementNo completion:(void(^)(NSDictionary *dictionary, NSError *error))block{
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithDictionary:
                                  @{@"userid" :[MPMUserInfo getUserInfo][@"userId"],
                                    @"token" : [MPMUserInfo getToken]}];
    
    NSMutableDictionary *dataDictionary = [NSMutableDictionary dictionary];
    
    @try {
        [dataDictionary setObject:agreementNo forKey:@"agreementNo"];
        
        [param setObject:dataDictionary forKey:@"data"];
    } @catch (NSException *exception) {
        NSLog(@"%@", exception);
        if (block) block(nil, [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier]
                                                  code:1
                                              userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(exception.reason, nil)}]);
    } @finally {
        [manager POST:[NSString stringWithFormat:@"%@/mpmapi/topup", kApiUrl] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            @try {
                NSInteger code = [[responseObject objectForKey:@"statusCode"] integerValue];
                NSString *message = [responseObject objectForKey:@"message"];
                if (code == 200) {
                    NSDictionary *data = [responseObject objectForKey:@"data"];
                    NSDictionary *dictionary = @{@"nama" : [data objectForKey:@"customerName"],
                                                 @"nomorPlat" : [data objectForKey:@"licensePlate"],
                                                 @"unitPerTahun" : [data objectForKey:@"manufacturingYear"],
                                                 @"outstanding" : [data objectForKey:@"installmentAmount"],
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
}

@end
