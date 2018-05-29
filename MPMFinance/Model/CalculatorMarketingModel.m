//
//  CalculatorMarketingModel.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 29/05/18.
//  Copyright © 2018 MPMFinance. All rights reserved.
//

#import "CalculatorMarketingModel.h"

@implementation CalculatorMarketingModel

+ (void)postCalculateNewCarWithDictionary:(NSDictionary *)dictionary completion:(void(^)(NSDictionary *dictionary, NSError *error))block{
    AFHTTPSessionManager *manager = [MPMGlobal sessionManager];
    NSMutableDictionary *param;
    @try {
        param = [NSMutableDictionary dictionaryWithDictionary:
                 @{@"userid" :[MPMUserInfo getUserInfo][@"userId"],
                   @"token" : [MPMUserInfo getToken],
                   @"data" : @{@"hargaKendaraan" : [dictionary objectForKey:@"otrKendaraan"],
                               @"dp" : [dictionary objectForKey:@"dpPercentage"],
                               @"nilaiDp" : [dictionary objectForKey:@"dpRupiah"],
                               @"tenor" : [dictionary objectForKey:@"tenor"],
                               @"tipePembayaran" : [dictionary objectForKey:@"tipePembayaran"],
                               @"biayaProvisi" : [dictionary objectForKey:@"biayaProvisi"],
                               @"asuransiJiwa" : [dictionary objectForKey:@"opsiAsuransiJiwa"],
                               @"asuransiJiwa2" : [dictionary objectForKey:@"opsiAsuransiJiwaKapitalisasi"],
                               @"biayaAdmin" : [dictionary objectForKey:@"opsiBiayaAdministrasi"],
                               @"biayaFidusia" : [dictionary objectForKey:@"opsiBiayaFidusia"],
                               @"biayaFidusia2" : [dictionary objectForKey:@"opsiBiayaFidusiaKapitalisasi"],
                               @"wilayahAsuransiKendaraan" : [dictionary objectForKey:@"wilayahAsuransiKendaraan"],
                               @"premi" : [dictionary objectForKey:@"opsiPremi"],
                               @"insurancebyMPM" : [dictionary objectForKey:@"pertanggungan"],
                               @"penggunaan" : [dictionary objectForKey:@"penggunaan"],
                               @"asuransiKendaraan" : [dictionary objectForKey:@"opsiAsuransiKendaraan"],
                               @"nilaiAsuransiKendaraan" : [dictionary objectForKey:@"nilaiTunaiSebagian"],
                               @"supplierRate" : [dictionary objectForKey:@"supplierRate"],
                               @"refundBunga" : [dictionary objectForKey:@"refundBunga"],
                               @"refundAsuransi" : [dictionary objectForKey:@"refundAsuransi"],
                               @"uppingProvisi" : [dictionary objectForKey:@"uppingProvisi"],
                               @"biayaSurvey" : [dictionary objectForKey:@"biayaSurvey"],
                               @"biayaCek" : [dictionary objectForKey:@"biayaCekBlokirBPKB"],
                               },
                   }];
        
    } @catch(NSException *exception) {
        NSLog(@"%@", exception);
    }
    
    [manager POST:[NSString stringWithFormat:@"%@/calculator/newcar", kApiUrl] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
}

@end
