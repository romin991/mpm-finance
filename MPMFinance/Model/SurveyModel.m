//
//  SurveyModel.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 6/7/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "SurveyModel.h"

@implementation SurveyModel

+ (void)getSurveyWithID:(NSInteger)pengajuanId completion:(void(^)(NSDictionary *dictionary, NSError *error))block{
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    NSDictionary* param = @{@"userid" : [MPMUserInfo getUserInfo][@"userId"],
                            @"token" : [MPMUserInfo getToken],
                            @"data" : @{@"dataPengajuanId" : @(pengajuanId)}
                            };
    
    [manager POST:[NSString stringWithFormat:@"%@/survey/detail", kApiUrl] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @try {
            NSInteger code = [[responseObject objectForKey:@"statusCode"] integerValue];
            NSString *message = [responseObject objectForKey:@"message"];
            if (code == 200) {
                NSDictionary *data = [responseObject objectForKey:@"data"];
                NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:
                                                  @{@"id" : [data objectForKey:@"id"],
                                                    @"idPengajuan" : [data objectForKey:@"idPengajuan"],
                                                    @"tanggalSurvey" : [data objectForKey:@"tglSurvey"],
                                                    @"namaSurveyor" : [data objectForKey:@"namaSurveyor"],
                                                    @"alamatSurveyDitemukan" : [data objectForKey:@"alamatSurveyDitemukan"],
                                                    @"penjelasan" : [data objectForKey:@"ketSurvey"],
                                                    @"namaCalonDebitur" : [data objectForKey:@"namaCalon"],
                                                    @"fotoRmhDpn" : [data objectForKey:@"fotoRmhDpn"],
                                                    @"fotoJlnRmh" : [data objectForKey:@"fotoJlnRmh"],
                                                    @"fotoKtpDebitur" : [data objectForKey:@"fotoKtpDebitur"],
                                                    @"fotoKtpPasangan" : [data objectForKey:@"fotoKtpPasangan"],
                                                    @"fotoKk1" : [data objectForKey:@"fotoKk1"],
                                                    @"fotoKk2" : [data objectForKey:@"fotoKk2"],
                                                    @"fotoBuktiKepemilikanRmh" : [data objectForKey:@"fotoBuktiKepemilikanRmh"],
                                                    @"fotoUsaha1" : [data objectForKey:@"fotoUsaha1"],
                                                    @"fotoUsaha2" : [data objectForKey:@"fotoUsaha2"],
                                             }];
                
                NSDictionary *observasiTempatTinggalDictionary = [data objectForKey:@"observasiTempatTinggal"];
                NSMutableArray *fasilitasRumah = [NSMutableArray array];
                for (NSDictionary *tempDictionary in [observasiTempatTinggalDictionary objectForKey:@"fasilitasRumah"]) {
                    [fasilitasRumah addObject:@([[tempDictionary objectForKey:@"fasilitasRumah"] integerValue])];
                    
                    if ([tempDictionary objectForKey:@"freeTextFasilitas"] &&
                        ![[tempDictionary objectForKey:@"freeTextFasilitas"] isKindOfClass:NSNull.class] &&
                        [NSString stringWithFormat:@"%@", [tempDictionary objectForKey:@"freeTextFasilitas"]].length > 0) {
                        [dictionary setObject:[tempDictionary objectForKey:@"freeTextFasilitas"] forKey:@"fasilitasRumahLainnya"];
                    }
                }
                
                NSMutableArray *patokanDktRmh = [NSMutableArray array];
                for (NSDictionary *tempDictionary in [observasiTempatTinggalDictionary objectForKey:@"patokanDktRmh"]) {
                    [patokanDktRmh addObject:@([[tempDictionary objectForKey:@"patokanDktRmh"] integerValue])];
                    
                    if ([tempDictionary objectForKey:@"freeText"] &&
                        ![[tempDictionary objectForKey:@"freeText"] isKindOfClass:NSNull.class] &&
                        [NSString stringWithFormat:@"%@", [tempDictionary objectForKey:@"freeText"]].length > 0) {
                        [dictionary setObject:[tempDictionary objectForKey:@"freeText"] forKey:@"patokanDktRmhLainnya"];
                    }
                }
                
                [dictionary addEntriesFromDictionary:@{@"lingkungan" : @([[observasiTempatTinggalDictionary objectForKey:@"lingkungan"] integerValue]),
                                                      @"fasilitasRumah" : fasilitasRumah,
                                                      @"aksesJalanMasuk" : @([[observasiTempatTinggalDictionary objectForKey:@"aksesJlnMasuk"] integerValue]),
                                                      @"patokanDktRmh" : patokanDktRmh,
                                                      @"penampakanDepanRumah" : @([[observasiTempatTinggalDictionary objectForKey:@"penampakanDpnRmh"] integerValue]),
                                                      @"kondisiTempatTinggal" : @([[observasiTempatTinggalDictionary objectForKey:@"kondisiRumah"] integerValue]),
                                                      }];
                
                NSArray *informanSurvey = [data objectForKey:@"informanSurvey"];
                NSMutableArray *informanSurveyArray = [NSMutableArray array];
                for (NSDictionary *tempDictionary in informanSurvey) {
                    NSArray *debiturOrganisasi = [[tempDictionary objectForKey:@"debiturOrganisasi"] componentsSeparatedByString:@","];
                    
                    NSDictionary *informanDictionary = @{@"frekuensiDidatangiPenagihUtang" : @([[tempDictionary objectForKey:@"frekDebtCollector"] integerValue]),
                                                         @"nama" : [tempDictionary objectForKey:@"namaInforman"],
                                                         @"informasiLain" : [tempDictionary objectForKey:@"informasiLain"],
                                                         @"statusKepemilikanRumah" : @([[tempDictionary objectForKey:@"statusRmh"] integerValue]),
                                                         @"hubungan" : @([[tempDictionary objectForKey:@"hubungan"] integerValue]),
                                                         @"ketDomisili" : [tempDictionary objectForKey:@"ketDomisili"],
                                                         @"lamaTinggal" : @([[tempDictionary objectForKey:@"lamaTinggal"] integerValue]),
                                                         @"debiturOrganisasi" : @([debiturOrganisasi.firstObject integerValue]),
                                                         @"namaOrganisasi" : debiturOrganisasi.lastObject != debiturOrganisasi.firstObject ? debiturOrganisasi.lastObject : @"",
                                                         @"jumlahOrang" : @([[tempDictionary objectForKey:@"jmlOrgTglDirmh"] integerValue]),
                                                         @"kebenaranDomisili" : @([[tempDictionary objectForKey:@"kebenaranDomisili"] integerValue]),
                                                         @"terakhirBerinteraksiDenganDebitur" : @([[tempDictionary objectForKey:@"lastDebitur"] integerValue]),
                                                         };
                    [informanSurveyArray addObject:informanDictionary];
                }
                [dictionary setObject:informanSurveyArray forKey:@"informanSurvey"];
                
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

+ (void)postSurveyWithList:(List *)list dictionary:(NSDictionary *)dictionary completion:(void(^)(NSDictionary *dictionary, NSError *error))block{
    AFHTTPSessionManager *manager = [MPMGlobal sessionManager];
    NSMutableDictionary *param;
        param = [NSMutableDictionary dictionaryWithDictionary:
                                      @{@"userid" :[MPMUserInfo getUserInfo][@"userId"],
                                        @"token" : [MPMUserInfo getToken],
                                        }];
        
        for (NSMutableDictionary *objectDictionary in [dictionary objectForKey:@"fasilitasRumah"]) {
            [objectDictionary setObject:[NSString stringWithFormat:@"%@", [objectDictionary objectForKey:@"fasilitasRumah"]] forKey:@"fasilitasRumah"];
            if ([[objectDictionary objectForKey:@"fasilitasRumah"] isEqualToString:@"348"]) {
                [objectDictionary setObject:[NSString stringWithFormat:@"%@", [dictionary objectForKey:@"fasilitasRumahLainnya"]] forKey:@"freeTextFasilitas"];
            }
        }
        
        for (NSMutableDictionary *objectDictionary in [dictionary objectForKey:@"patokanDktRmh"]) {
            [objectDictionary setObject:[NSString stringWithFormat:@"%@", [objectDictionary objectForKey:@"patokanDktRmh"]] forKey:@"patokanDktRmh"];
            if ([[objectDictionary objectForKey:@"patokanDktRmh"] isEqualToString:@"347"]) {
                [objectDictionary setObject:[NSString stringWithFormat:@"%@", [dictionary objectForKey:@"patokanDktRmhLainnya"]] forKey:@"freeText"];
            }
        }
        
        NSMutableDictionary *observasiTempatTinggal = [NSMutableDictionary dictionaryWithDictionary:
                                                       @{@"lingkungan" : [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"lingkungan"]],
                                                         @"fasilitasRumah" : [dictionary objectForKey:@"fasilitasRumah"],
                                                         @"aksesJlnMasuk" : [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"aksesJalanMasuk"]],
                                                         @"patokanDktRmh" : [dictionary objectForKey:@"patokanDktRmh"],
                                                         @"penampakanDpnRmh" : [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"penampakanDepanRumah"]],
                                                         @"kondisiRumah" : [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"kondisiTempatTinggal"]],
                                                         }];
        
        NSMutableArray *informanArray = [NSMutableArray array];
        for (NSDictionary *informanDictionary in [dictionary objectForKey:@"informanSurvey"]) {
            NSMutableString *debiturOrganisasi = [NSMutableString stringWithFormat:@"%@", [informanDictionary objectForKey:@"debiturOrganisasi"]];
            if ([informanDictionary objectForKey:@"namaOrganisasi"] && [[informanDictionary objectForKey:@"namaOrganisasi"] length] > 0) {
                [debiturOrganisasi appendString:@","];
                [debiturOrganisasi appendString:[informanDictionary objectForKey:@"namaOrganisasi"]];
            }
            NSMutableDictionary *informanAPIDictionary = [NSMutableDictionary dictionaryWithDictionary:
                                                          @{@"frekDebtCollector": [NSString stringWithFormat:@"%@", [informanDictionary objectForKey:@"frekuensiDidatangiPenagihUtang"]],
                                                            @"namaInforman": [NSString stringWithFormat:@"%@", [informanDictionary objectForKey:@"nama"]],
                                                            @"informasiLain": [NSString stringWithFormat:@"%@", [informanDictionary objectForKey:@"informasiLain"]],
                                                            @"statusRmh": [NSString stringWithFormat:@"%@", [informanDictionary objectForKey:@"statusKepemilikanRumah"]],
                                                            @"hubungan": [NSString stringWithFormat:@"%@", [informanDictionary objectForKey:@"hubungan"]],
                                                            @"ketDomisili": [informanDictionary objectForKey:@"ketDomisili"],
                                                            @"lamaTinggal": [informanDictionary objectForKey:@"lamaTinggal"],
                                                            @"debiturOrganisasi": debiturOrganisasi,
                                                            @"jmlOrgTglDirmh": [informanDictionary objectForKey:@"jumlahOrang"],
                                                            @"kebenaranDomisili": [NSString stringWithFormat:@"%@", [informanDictionary objectForKey:@"kebenaranDomisili"]],
                                                            @"lastDebitur": [NSString stringWithFormat:@"%@", [informanDictionary objectForKey:@"terakhirBerinteraksiDenganDebitur"]]
                                                            }];
            [informanArray addObject:informanAPIDictionary];
        }
        
        NSMutableDictionary *dataSurvey = [NSMutableDictionary dictionaryWithDictionary:
                                           @{@"informanSurvey" : informanArray,
                                             @"idPengajuan" : @(list.primaryKey),
                                             @"lng" : @0,
                                             @"lat" : @0,
                                             @"fotoRmhDpn" : [dictionary objectForKey:@"fotoRmhDpn"],
                                             @"fotoJlnRmh" : [dictionary objectForKey:@"fotoJlnRmh"],
                                             @"fotoKtpDebitur" : [dictionary objectForKey:@"fotoKtpDebitur"],
                                             @"fotoKtpPasangan" : [dictionary objectForKey:@"fotoKtpPasangan"],
                                             @"fotoKk1" : [dictionary objectForKey:@"fotoKk1"],
                                             @"fotoKk2" : [dictionary objectForKey:@"fotoKk2"],
                                             @"fotoBuktiKepemilikanRmh" : [dictionary objectForKey:@"fotoBuktiKepemilikanRmh"],
                                             @"fotoUsaha1" : [dictionary objectForKey:@"fotoUsaha1"],
                                             @"fotoUsaha2" : [dictionary objectForKey:@"fotoUsaha2"],
                                             }];
        
        NSMutableDictionary *data = [NSMutableDictionary dictionaryWithDictionary:
                                     @{@"ketSurvey" : [dictionary objectForKey:@"penjelasan"],
                                       @"alamatDitemukan" : [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"alamatSurveyDitemukan"]],
                                       @"tanggalSurvey" : [dictionary objectForKey:@"tanggalSurvey"],
                                       @"observasiTempatTinggal" : observasiTempatTinggal,
                                       @"dataSurvey" : dataSurvey,
                                       }];
        
        [param setObject:data forKey:@"data"];
     
    
    [manager POST:[NSString stringWithFormat:@"%@/survey/insert", kApiUrl] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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

+ (void)postSurveyWithID:(NSInteger)pengajuanId completion:(void(^)(NSDictionary *dictionary, NSError *error))block{
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithDictionary:
                                  @{@"userid" :[MPMUserInfo getUserInfo][@"userId"],
                                    @"token" : [MPMUserInfo getToken],
                                    @"data" : @{@"idPengajuan" : @(pengajuanId)}
                                    }];
    @try {
        [manager POST:[NSString stringWithFormat:@"%@/survey/sumbitsurvey", kApiUrl] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
        if (block) block(nil, [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier]
                                                  code:1
                                              userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(exception.reason, nil)}]);
        
    }
}

@end
