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
                               @"dp" : [[dictionary objectForKey:@"dpPercentage"] stringByReplacingOccurrencesOfString:@"," withString:@"."],
                               @"nilaiDp" : [[dictionary objectForKey:@"dpRupiah"] stringByReplacingOccurrencesOfString:@"." withString:@""],
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
                               @"supplierRate" : [[dictionary objectForKey:@"supplierRate"] stringByReplacingOccurrencesOfString:@"," withString:@"."],
                               @"refundBunga" : [[dictionary objectForKey:@"refundBunga"] stringByReplacingOccurrencesOfString:@"," withString:@"."],
                               @"refundAsuransi" : [[dictionary objectForKey:@"refundAsuransi"] stringByReplacingOccurrencesOfString:@"," withString:@"."],
                               @"uppingProvisi" : [[dictionary objectForKey:@"uppingProvisi"] stringByReplacingOccurrencesOfString:@"," withString:@"."],
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

+ (void)postCalculateUsedCarWithDictionary:(NSDictionary *)dictionary completion:(void(^)(NSDictionary *dictionary, NSError *error))block{
    AFHTTPSessionManager *manager = [MPMGlobal sessionManager];
    NSMutableDictionary *param;
    @try {
        param = [NSMutableDictionary dictionaryWithDictionary:
                 @{@"userid" :[MPMUserInfo getUserInfo][@"userId"],
                   @"token" : [MPMUserInfo getToken],
                   @"data" : @{@"hargaKendaraan" : [[dictionary objectForKey:@"otrKendaraan"] stringByReplacingOccurrencesOfString:@"." withString:@""],
                               @"dp" : [[dictionary objectForKey:@"dpPercentage"] stringByReplacingOccurrencesOfString:@"," withString:@"."],
                               @"nilaiDp" : [[dictionary objectForKey:@"dpRupiah"] stringByReplacingOccurrencesOfString:@"." withString:@""],
                               @"tahunKendaraan" : [dictionary objectForKey:@"tahunKendaraan"],
                               @"tenor" : [dictionary objectForKey:@"tenor"],
                               @"tipePembayaran" : [dictionary objectForKey:@"tipePembayaran"],
                               @"biayaProvisi" : [dictionary objectForKey:@"biayaProvisi"],
                               @"asuransiJiwa" : [dictionary objectForKey:@"opsiAsuransiJiwa"],
                               @"asuransiJiwa2" : [dictionary objectForKey:@"opsiAsuransiJiwaKapitalisasi"],
                               @"biayaAdmin" : [dictionary objectForKey:@"opsiBiayaAdministrasi"],
                               @"biayaFidusia" : [dictionary objectForKey:@"opsiBiayaFidusia"],
                               @"biayaFidusia2" : [dictionary objectForKey:@"opsiBiayaFidusiaKapitalisasi"],
                               @"wilayahAsuransiKendaraan" : [dictionary objectForKey:@"wilayahAsuransiKendaraan"],
                               @"penggunaan" : [dictionary objectForKey:@"penggunaan"],
                               @"asuransiKendaraan" : [dictionary objectForKey:@"opsiAsuransiKendaraan"],
                               @"insurancebyMPM" : [dictionary objectForKey:@"pertanggungan"],
                               
//                               @"asuransiKombinasiTh1" : @"", // [dictionary objectForKey:@"pilihanAsuransiKombinasiTahunPertama"],
                               @"asuransiKombinasiTh2" : @"", // [dictionary objectForKey:@"pilihanAsuransiKombinasiTahunKedua"],
                               @"asuransiKombinasiTh3" : @"", // [dictionary objectForKey:@"pilihanAsuransiKombinasiTahunKetiga"],
                               @"asuransiKombinasiTh4" : @"", // [dictionary objectForKey:@"pilihanAsuransiKombinasiTahunKeempat"],
                               @"asuransiKombinasiTh5" : @"", // [dictionary objectForKey:@"pilihanAsuransiKombinasiTahunKelima"],
                               @"asuransiKombinasiTh6" : @"", // [dictionary objectForKey:@"pilihanAsuransiKombinasiTahunKeenam"],
                               
                               @"asuransiNilaiTunaiSebagian" : [dictionary objectForKey:@"nilaiTunaiSebagian"],
                               @"supplierRate" : [[dictionary objectForKey:@"supplierRate"] stringByReplacingOccurrencesOfString:@"," withString:@"."],
                               @"refundBunga" : [[dictionary objectForKey:@"refundBunga"] stringByReplacingOccurrencesOfString:@"," withString:@"."],
                               @"refundAsuransi" : [[dictionary objectForKey:@"refundAsuransi"] stringByReplacingOccurrencesOfString:@"," withString:@"."],
                               @"uppingProvisi" : [[dictionary objectForKey:@"uppingProvisi"] stringByReplacingOccurrencesOfString:@"," withString:@"."],
                               @"biayaSurvey" : [dictionary objectForKey:@"biayaSurvey"],
                               @"biayaCek" : [dictionary objectForKey:@"biayaCekBlokirBPKB"],
                               },
                   }];
        
    } @catch(NSException *exception) {
        NSLog(@"%@", exception);
    }
    
    [manager POST:[NSString stringWithFormat:@"%@/calculator/usedcar", kApiUrl] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
}

+ (void)postCalculateDahsyatWithDictionary:(NSDictionary *)dictionary completion:(void(^)(NSDictionary *dictionary, NSError *error))block{
    AFHTTPSessionManager *manager = [MPMGlobal sessionManager];
    NSMutableDictionary *param;
    @try {
        param = [NSMutableDictionary dictionaryWithDictionary:
                 @{@"userid" :[MPMUserInfo getUserInfo][@"userId"],
                   @"token" : [MPMUserInfo getToken],
                   @"data" : @{@"tipeMobil" : [dictionary objectForKey:@"vehicleType"],
                               @"tahunMobil" : [dictionary objectForKey:@"manufactureYear"],
                               @"packagee" : [dictionary objectForKey:@"package"],
                               @"tipeConsumer" : [dictionary objectForKey:@"consumerType"],
                               @"pemasanganPertama" : [dictionary objectForKey:@"firstInstallment"],
                               @"tenor" : [dictionary objectForKey:@"tenor"],
                               @"masaTenggang" : [dictionary objectForKey:@"gracePeriod"],
                               @"masaTenggang2" : [dictionary objectForKey:@"gracePeriodType"],
                               @"ussage" : [dictionary objectForKey:@"usage"],
                               @"tipeCoverage" : [dictionary objectForKey:@"coverageType"],
                               @"nilaiPertanggungan" : [dictionary objectForKey:@"nilaiPertanggungan"],
                               @"provisi" : [dictionary objectForKey:@"provisi"],
                               @"biayaAdmin" : [dictionary objectForKey:@"admissionFee"],
                               @"regional" : [dictionary objectForKey:@"region"],
                               @"asuransiKesehatan" : [dictionary objectForKey:@"lifeInsurance"],
                               @"tujuanPembiayaan" : [dictionary objectForKey:@"purposeOfFinancing"],
                               @"harga" : [[dictionary objectForKey:@"otrPriceList"] stringByReplacingOccurrencesOfString:@"." withString:@""],
                               @"ltv" : [[dictionary objectForKey:@"loanOfValue"] stringByReplacingOccurrencesOfString:@"," withString:@"."],
                               @"runningRate" : [[dictionary objectForKey:@"runningRate"] stringByReplacingOccurrencesOfString:@"," withString:@"."],
                               @"feeAgent" : [[dictionary objectForKey:@"feeAgent"] stringByReplacingOccurrencesOfString:@"," withString:@"."],
                               @"other" : [[dictionary objectForKey:@"others"] stringByReplacingOccurrencesOfString:@"." withString:@""],
                               @"bulanPencairan" : [dictionary objectForKey:@"bulanPencairan"],
                               },
                   }];
        
    } @catch(NSException *exception) {
        NSLog(@"%@", exception);
    }
    
    [manager POST:[NSString stringWithFormat:@"%@/calculator/dahsyat", kApiUrl] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
}

@end
