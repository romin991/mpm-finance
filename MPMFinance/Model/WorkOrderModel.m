//
//  WorkOrderModel.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 6/7/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "WorkOrderModel.h"
#import "OfflineData.h"
#import "ViewStepMonitoring.h"

@implementation WorkOrderModel

+ (void)getListWorkOrderBySupervisorWithStatus:(NSString *)status page:(NSInteger)page completion:(void(^)(NSArray *lists, NSError *error))block{
    NSInteger offset = [MPMGlobal limitPerPage] * page;
    
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    NSDictionary* param = @{@"userid" : [MPMUserInfo getUserInfo][@"userId"],
                            @"token" : [MPMUserInfo getToken],
                            @"data" : @{@"status" : status,
                                        @"limit" : @([MPMGlobal limitPerPage]),
                                        @"offset" : @(offset)}};
    NSLog(@"%@",param);
    [manager POST:[NSString stringWithFormat:@"%@/pengajuan/getallbyspv",kApiUrl] parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @try {
            NSInteger code = [[responseObject objectForKey:@"statusCode"] integerValue];
            NSString *message = [responseObject objectForKey:@"message"];
            if (code == 200) {
                NSDictionary *data = responseObject[@"data"];
                NSMutableArray *lists = [NSMutableArray array];
                for (NSDictionary* listDict in data) {
                    List *list = [[List alloc] init];
                    list.primaryKey = [listDict[@"id"] integerValue];
                    list.title = listDict[@"noRegistrasi"];
                    list.date = listDict[@"tanggal"];
                    list.assignee = listDict[@"namaPengaju"];
                    list.status = listDict[@"status"];
                    list.type = listDict[@"tipeProduk"];
                    list.statusColor = listDict[@"color"];
                    list.imageURL = listDict[@"imageIconIos"];
                    [lists addObject:list];
                }
                
                if (block) block(lists, nil);
                
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

+ (void)getListWorkOrderByUserWithStatus:(NSString *)status page:(NSInteger)page completion:(void(^)(NSArray *lists, NSError *error))block{
    NSInteger offset = [MPMGlobal limitPerPage] * page;
    
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    NSDictionary* param = @{@"userid" : [MPMUserInfo getUserInfo][@"userId"],
                            @"token" : [MPMUserInfo getToken],
                            @"data" : @{@"status" : status,
                                        @"limit" : @([MPMGlobal limitPerPage]),
                                        @"offset" : @(offset)}};
    NSLog(@"%@",param);
    [manager POST:[NSString stringWithFormat:@"%@/pengajuan/getallbyuser",kApiUrl] parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @try {
            NSInteger code = [[responseObject objectForKey:@"statusCode"] integerValue];
            NSString *message = [responseObject objectForKey:@"message"];
            if (code == 200) {
                NSDictionary *data = responseObject[@"data"];
                NSMutableArray *lists = [NSMutableArray array];
                for (NSDictionary* listDict in data) {
                    List *list = [[List alloc] init];
                    list.primaryKey = [listDict[@"id"] integerValue];
                    list.title = listDict[@"noRegistrasi"];
                    list.date = listDict[@"tanggal"];
                    list.assignee = listDict[@"namaPengaju"];
                    list.status = listDict[@"status"];
                    list.type = listDict[@"tipeProduk"];
                    list.statusColor = listDict[@"color"];
                    list.imageURL = listDict[@"imageIconIos"];
                    [lists addObject:list];
                }
                
                if (block) block(lists, nil);
                
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

+ (void)getListWorkOrderWithStatus:(NSString *)status page:(NSInteger)page completion:(void(^)(NSArray *lists, NSError *error))block{
    NSInteger offset = [MPMGlobal limitPerPage] * page;
    
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    NSDictionary* param = @{@"userid" : [MPMUserInfo getUserInfo][@"userId"],
                            @"token" : [MPMUserInfo getToken],
                            @"data" : @{@"status" : status,
                                        @"limit" : @([MPMGlobal limitPerPage]),
                                        @"offset" : @(offset)}};
    NSLog(@"%@",param);
    [manager POST:[NSString stringWithFormat:@"%@/pengajuan/getworkorderbymarketing",kApiUrl] parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @try {
            NSInteger code = [[responseObject objectForKey:@"statusCode"] integerValue];
            NSString *message = [responseObject objectForKey:@"message"];
            if (code == 200) {
                NSDictionary *data = responseObject[@"data"];
                NSMutableArray *lists = [NSMutableArray array];
                for (NSDictionary* listDict in data) {
                    List *list = [[List alloc] init];
                    list.primaryKey = [listDict[@"id"] integerValue];
                    list.title = listDict[@"noRegistrasi"];
                    list.date = listDict[@"tanggal"];
                    list.assignee = listDict[@"namaPengaju"];
                    list.status = listDict[@"status"];
                    list.type = listDict[@"tipeProduk"];
                    list.statusColor = listDict[@"color"];
                    list.imageURL = listDict[@"imageIconIos"];
                    list.groupLevel = listDict[@"groupLevel"];
                    [lists addObject:list];
                }
                
                if (block) block(lists, nil);
                
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

+ (void)getListWorkOrderWithUserID:(NSString *)userID page:(NSInteger)page completion:(void(^)(NSArray *lists, NSError *error))block{
    NSInteger offset = [MPMGlobal limitPerPage] * page;
    
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    NSDictionary* param = @{@"userid" : userID,
                            @"token" : [MPMUserInfo getToken],
                            @"data" : @{@"status" : @"history",
                                        @"limit" : @([MPMGlobal limitPerPage]),
                                        @"offset" : @(offset)}};
    NSLog(@"%@",param);
    [manager POST:[NSString stringWithFormat:@"%@/datamap/getworkorder",kApiUrl] parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @try {
            NSInteger code = [[responseObject objectForKey:@"statusCode"] integerValue];
            NSString *message = [responseObject objectForKey:@"message"];
            if (code == 200) {
                NSDictionary *data = responseObject[@"data"];
                NSMutableArray *lists = [NSMutableArray array];
                for (NSDictionary* listDict in data) {
                    List *list = [[List alloc] init];
                    list.primaryKey = [listDict[@"id"] integerValue];
                    list.title = listDict[@"noRegistrasi"];
                    list.date = listDict[@"tanggal"];
                    list.assignee = listDict[@"namaPengaju"];
                    list.status = listDict[@"status"];
                    list.type = listDict[@"tipeProduk"];
                    list.statusColor = listDict[@"color"];
                    list.imageURL = listDict[@"imageIconIos"];
                    [lists addObject:list];
                }
                
                if (block) block(lists, nil);
                
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

+ (void)getListWorkOrderDetailWithID:(NSInteger)pengajuanId completion:(void(^)(NSDictionary *response, NSError *error))block{
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    NSDictionary* param = @{@"userid" : [MPMUserInfo getUserInfo][@"userId"],
                            @"token" : [MPMUserInfo getToken],
                            @"data" : @{@"id" : @(pengajuanId)}
                            };
    
    [manager POST:[NSString stringWithFormat:@"%@/pengajuandraft/detail",kApiUrl] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @try {
            NSInteger code = [[responseObject objectForKey:@"statusCode"] integerValue];
            NSString *message = [responseObject objectForKey:@"message"];
            if (code == 200) {
                NSDictionary *data = responseObject[@"data"];
                NSDictionary *dictionary = @{@"noRegistrasi" : data[@"noRegistrasi"],
                                             @"noKTP" : data[@"noKtp"],
                                             @"namaLengkap" : data[@"namaCalon"],
                                             @"tempatLahir" : data[@"tmpLahir"],
                                             @"tanggalLahir" : data[@"tglLahir"],
                                             @"jenisKelamin" : @([data[@"jnsKelamin"] integerValue]),
                                             
                                             @"alamatRumahSesuaiKTP" : data[@"alamatLegal"],
                                             @"rTSesuaiKTP" : data[@"alamatLegalRt"],
                                             @"rWSesuaiKTP" : data[@"alamatLegalRw"],
                                             @"kodeposSesuaiKTP" : data[@"kodePosAlamatCalon"],
                                             @"kecamatanSesuaiKTP" : data[@"alamatLegalKecamatan"],
                                             @"kelurahanSesuaiKTP" : data[@"alamatLegalKelurahan"],
                                             @"kotaSesuaiKTP" : data[@"alamatLegalKota"],
                                             @"masaBerlakuKTP" : data[@"ktpBerlaku"],
                                             @"kewarganegaraan" : data[@"kewarganegaraan"],
                                             
                                             @"nomorHandphone" : data[@"handphone"],
                                             @"kodeArea" : data[@"kodeArea"],
                                             @"nomorTelepon" : data[@"noTlp"],
                                             
                                             @"samaDenganAlamatLegal" : data[@"cekAlamatSama"],
                                             
                                             @"alamatDomisili" : data[@"alamatDomisili"],
                                             @"rTDomisili" : data[@"alamatDomisiliRt"],
                                             @"rWDomisili" : data[@"alamatDomisiliRw"],
                                             @"kelurahanDomisili" : data[@"alamatDomisiliKelurahan"],
                                             @"kecamatanDomisili" : data[@"alamatDomisiliKecamatan"],
                                             @"kotaDomisili" : data[@"alamatDomisiliKota"],
                                             @"kodeposDomisili" : data[@"alamatDomisiliKodePos"],
                                             @"namaGadisIbuKandung" : data[@"namaIbuKandung"],
                                             
                                             @"namaLengkapPasangan" : data[@"namaPasangan"],
                                             @"noKTPPasangan" : data[@"ktpPasangan"],
                                             @"nomorHandphonePasangan" : data[@"noTlpPasangan"],
                                             @"tempatLahirPasangan" : data[@"tmpLahirPasangan"],
                                             @"tanggalLahirPasangan" : data[@"tglLahirPasangan"],
                                             @"jenisKelaminPasangan" : @([data[@"jnsKelaminPasangan"] integerValue]),
                                             @"alamatPasangan" : data[@"alamatLegalPasangan"],
                                             @"rTPasangan" : data[@"alamatLegalPasanganRt"],
                                             @"rWPasangan" : data[@"alamatLegalPasanganRw"],
                                             @"kelurahanPasangan" : data[@"alamatLegalPasanganKelurahan"],
                                             @"kecamatanPasangan" : data[@"alamatLegalPasanganKecamatan"],
                                             @"kotaPasangan" : data[@"alamatLegalPasanganKota"],
                                             @"kodePosPasangan" : data[@"alamatLegalPasanganKodePos"],
                                             @"masaBerlakuKTPPasangan" : data[@"berlakuHingga"],
                                             @"kewarganegaraanPasangan" : data[@"kewarganegaraanPasangan"],
                                             @"namaGadisIbuKandungPasangan" : data[@"namaIbuKandungPasangan"],
                                             
                                             @"tipeProduk" : data[@"tipeProduk"],
                                             @"tipeKendaraan" : data[@"tipeKendaraan"],
                                             @"tahunKendaraan" : data[@"tahunKendaraan"],
                                             
//                                             @"hargaPerolehan" : data[@"hargaPerolehan"],
//                                             @"uangMuka" : data[@"uangMuka"],
//                                             @"jangkaWaktuPembiayaan" : data[@"tenor"],
//                                             @"angsuran" : data[@"angsuran"],
                                             
                                             @"namaTempatKerja" : data[@"namaTmpKerja"],
                                             @"kodeAreaTeleponTempatKerja" : data[@"kodeAreaTelpTmpKerja"],
                                             @"nomorTeleponTempatKerja" : data[@"tlpTmpKerja"],
                                             
                                             @"namaEcon" : data[@"namaEcon"],
                                             @"nomorTeleponEcon" : data[@"noTlpEcon"],
                                             
                                             @"pinjamanTempatLain1" : data[@"pinjamanLain"],
                                             @"pinjamanTempatLain2" : data[@"pinjamanLain2"],
                                             @"nomorKartuKreditAtauKontrak1" : data[@"noCc1"],
                                             @"nomorKartuKreditAtauKontrak2" : data[@"noCc2"],
                                             
                                             @"catatanTV" : data[@"noteTv"],
                                             @"catatanSS" : data[@"noteSs"],
                                             @"ttd" : data[@"ttd"],
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

+ (void)getListWorkOrderDetailCompleteDataWithID:(NSInteger)pengajuanId completion:(void(^)(NSDictionary *response, NSError *error))block{
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    NSDictionary* param = @{@"userid" : [MPMUserInfo getUserInfo][@"userId"],
                            @"token" : [MPMUserInfo getToken],
                            @"data" : @{@"id" : @(pengajuanId)}
                            };
    
    [manager POST:[NSString stringWithFormat:@"%@/pengajuan/detail",kApiUrl] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @try {
            NSInteger code = [[responseObject objectForKey:@"statusCode"] integerValue];
            NSString *message = [responseObject objectForKey:@"message"];
            if (code == 200) {
                NSDictionary *data = responseObject[@"data"];
                NSDictionary *dictionary = @{@"noRegistrasi" : data[@"noRegistrasi"],
                                             @"noKTP" : data[@"noKtp"],
                                             @"namaLengkap" : data[@"namaCalon"],
                                             @"tempatLahir" : data[@"tmpLahir"],
                                             @"tanggalLahir" : data[@"tglLahir"],
                                             @"jenisKelamin" : @([data[@"jnsKelamin"] integerValue]),
                                             
                                             @"alamatRumahSesuaiKTP" : data[@"alamatLegal"],
                                             @"rTSesuaiKTP" : data[@"alamatLegalRt"],
                                             @"rWSesuaiKTP" : data[@"alamatLegalRw"],
                                             @"kodeposSesuaiKTP" : data[@"kodePosAlamatCalon"],
                                             @"kecamatanSesuaiKTP" : data[@"alamatLegalKecamatan"],
                                             @"kelurahanSesuaiKTP" : data[@"alamatLegalKelurahan"],
                                             @"kotaSesuaiKTP" : data[@"alamatLegalKota"],
                                             @"masaBerlakuKTP" : data[@"ktpBerlaku"],
                                             @"kewarganegaraan" : data[@"kewarganegaraan"],
                                             
                                             @"nomorHandphone" : data[@"handphone"],
                                             @"kodeArea" : data[@"kodeArea"],
                                             @"nomorTelepon" : data[@"noTlp"],
                                             
                                             @"samaDenganAlamatLegal" : data[@"cekAlamatSama"],
                                             
                                             @"alamatDomisili" : data[@"alamatDomisili"],
                                             @"rTDomisili" : data[@"alamatDomisiliRt"],
                                             @"rWDomisili" : data[@"alamatDomisiliRw"],
                                             @"kelurahanDomisili" : data[@"alamatDomisiliKelurahan"],
                                             @"kecamatanDomisili" : data[@"alamatDomisiliKecamatan"],
                                             @"kotaDomisili" : data[@"alamatDomisiliKota"],
                                             @"kodeposDomisili" : data[@"alamatDomisiliKodePos"],
                                             @"namaGadisIbuKandung" : data[@"namaIbuKandung"],
                                             
                                             @"namaLengkapPasangan" : data[@"namaPasangan"],
                                             @"noKTPPasangan" : data[@"ktpPasangan"],
                                             @"nomorHandphonePasangan" : data[@"noTlpPasangan"],
                                             @"tempatLahirPasangan" : data[@"tmpLahirPasangan"],
                                             @"tanggalLahirPasangan" : data[@"tglLahirPasangan"],
                                             @"jenisKelaminPasangan" : @([data[@"jnsKelaminPasangan"] integerValue]),
                                             @"alamatPasangan" : data[@"alamatLegalPasangan"],
                                             @"rTPasangan" : data[@"alamatLegalPasanganRt"],
                                             @"rWPasangan" : data[@"alamatLegalPasanganRw"],
                                             @"kelurahanPasangan" : data[@"alamatLegalPasanganKelurahan"],
                                             @"kecamatanPasangan" : data[@"alamatLegalPasanganKecamatan"],
                                             @"kotaPasangan" : data[@"alamatLegalPasanganKota"],
                                             @"kodePosPasangan" : data[@"alamatLegalPasanganKodePos"],
                                             @"masaBerlakuKTPPasangan" : data[@"berlakuHingga"],
                                             @"kewarganegaraanPasangan" : data[@"kewarganegaraanPasangan"],
                                             @"namaGadisIbuKandungPasangan" : data[@"namaIbuKandungPasangan"],
                                             
                                             @"tipeProduk" : data[@"tipeProduk"],
                                             @"tipeKendaraan" : data[@"tipeKendaraan"],
                                             @"tahunKendaraan" : data[@"tahunKendaraan"],
                                             
                                             //                                             @"hargaPerolehan" : data[@"hargaPerolehan"],
                                             //                                             @"uangMuka" : data[@"uangMuka"],
                                             //                                             @"jangkaWaktuPembiayaan" : data[@"tenor"],
                                             //                                             @"angsuran" : data[@"angsuran"],
                                             
                                             @"namaTempatKerja" : data[@"namaTmpKerja"],
                                             @"kodeAreaTeleponTempatKerja" : data[@"kodeAreaTelpTmpKerja"],
                                             @"nomorTeleponTempatKerja" : data[@"tlpTmpKerja"],
                                             
                                             @"namaEcon" : data[@"namaEcon"],
                                             @"nomorTeleponEcon" : data[@"noTlpEcon"],
                                             
                                             @"pinjamanTempatLain1" : data[@"pinjamanLain"],
                                             @"pinjamanTempatLain2" : data[@"pinjamanLain2"],
                                             @"nomorKartuKreditAtauKontrak1" : data[@"noCc1"],
                                             @"nomorKartuKreditAtauKontrak2" : data[@"noCc2"],
                                             
                                             @"catatanTV" : data[@"noteTv"],
                                             @"catatanSS" : data[@"noteSs"],
                                             @"ttd" : data[@"ttd"],
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




+ (void)deleteCustomerDraft:(NSNumber *)draftID{
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithDictionary:
                                  @{@"userid" :[MPMUserInfo getUserInfo][@"userId"],
                                    @"token" : [MPMUserInfo getToken],
                                    @"data" : @{@"id" : draftID}
                                    }];
    [manager POST:[NSString stringWithFormat:@"%@/pengajuandraft/customer/delete", kApiUrl] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        [SVProgressHUD dismissWithDelay:1.5];;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"Error Delete Draft"];
        [SVProgressHUD dismissWithDelay:1.5];
    }];

}




+ (void)postDraftWorkOrder:(List *)list dictionary:(NSDictionary *)dictionary completion:(void(^)(NSDictionary *dictionary, NSError *error))block{
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithDictionary:
                                  @{@"userid" :[MPMUserInfo getUserInfo][@"userId"],
                                    @"token" : [MPMUserInfo getToken]}];
    
    NSMutableDictionary *dataDictionary = [NSMutableDictionary dictionary];
    NSString *url = [[MPMUserInfo getRole] isEqualToString:kRoleCustomer] ? @"customer/input" : @"marketing/input";
    @try {
        if (list){
            [dataDictionary setObject:@(list.primaryKey) forKey:@"id"];
            url = @"customer/update";
        }
        
        [dataDictionary addEntriesFromDictionary:
         @{@"noKtp" : [dictionary objectForKey:@"noKTP"] ? [dictionary objectForKey:@"noKTP"] : @"",
           @"namaCalon" : [dictionary objectForKey:@"namaLengkap"] ? [dictionary objectForKey:@"namaLengkap"] : @"",
           @"tmpLahir" : [dictionary objectForKey:@"tempatLahir"] ? [dictionary objectForKey:@"tempatLahir"] : @"",
           @"tglLahir" : [dictionary objectForKey:@"tanggalLahir"] ? [MPMGlobal removeTimeFromString:[dictionary objectForKey:@"tanggalLahir"]] : @"",
           @"jnsKelamin" : [dictionary objectForKey:@"jenisKelamin"] ? [NSString stringWithFormat:@"%li", [[dictionary objectForKey:@"jenisKelamin"] integerValue]] : @"",
           
           @"alamatLegal" : [dictionary objectForKey:@"alamatRumahSesuaiKTP"] ? [dictionary objectForKey:@"alamatRumahSesuaiKTP"] : @"",
           @"alamatLegalRt" : [dictionary objectForKey:@"rTSesuaiKTP"] ? [dictionary objectForKey:@"rTSesuaiKTP"] : @"",
           @"alamatLegalRw" : [dictionary objectForKey:@"rWSesuaiKTP"] ? [dictionary objectForKey:@"rWSesuaiKTP"] : @"",
           @"kodePosAlamatCalon" : [dictionary objectForKey:@"kodeposSesuaiKTP"] ? [dictionary objectForKey:@"kodeposSesuaiKTP"] : @"",
           @"alamatLegalKecamatan" : [dictionary objectForKey:@"kecamatanSesuaiKTP"] ? [dictionary objectForKey:@"kecamatanSesuaiKTP"] : @"",
           @"alamatLegalKelurahan" : [dictionary objectForKey:@"kelurahanSesuaiKTP"] ? [dictionary objectForKey:@"kelurahanSesuaiKTP"] : @"",
           @"alamatLegalKota" : [dictionary objectForKey:@"kotaSesuaiKTP"] ? [dictionary objectForKey:@"kotaSesuaiKTP"] : @"",
           
           @"ktpBerlaku" : [dictionary objectForKey:@"masaBerlakuKTP"] ? [MPMGlobal removeTimeFromString:[dictionary objectForKey:@"masaBerlakuKTP"]] : @"",
           @"kewarganegaraan" : [dictionary objectForKey:@"kewarganegaraan"] ? [dictionary objectForKey:@"kewarganegaraan"] : @"",
           
           @"handphone" : [dictionary objectForKey:@"nomorHandphone"] ? [dictionary objectForKey:@"nomorHandphone"] : @"",
           @"kodeArea" : [dictionary objectForKey:@"kodeArea"] ? [dictionary objectForKey:@"kodeArea"] : @"",
           @"noTlp" : [dictionary objectForKey:@"nomorTelepon"] ? [dictionary objectForKey:@"nomorTelepon"] : @"",
           
           @"cekAlamatSama" : [dictionary objectForKey:@"samaDenganAlamatLegal"] ? @([[dictionary objectForKey:@"samaDenganAlamatLegal"] integerValue]) : @0,
           @"alamatDomisili" : [dictionary objectForKey:@"alamatDomisili"] ? [dictionary objectForKey:@"alamatDomisili"] : @"",
           @"alamatDomisiliRt" : [dictionary objectForKey:@"rTDomisili"] ? [dictionary objectForKey:@"rTDomisili"] : @"",
           @"alamatDomisiliRw" : [dictionary objectForKey:@"rWDomisili"] ? [dictionary objectForKey:@"rWDomisili"] : @"",
           @"alamatDomisiliKecamatan" : [dictionary objectForKey:@"kecamatanDomisili"] ? [dictionary objectForKey:@"kecamatanDomisili"] : @"",
           @"alamatDomisiliKelurahan" : [dictionary objectForKey:@"kelurahanDomisili"] ? [dictionary objectForKey:@"kelurahanDomisili"] : @"",
           @"alamatDomisiliKodePos" : [dictionary objectForKey:@"kodeposDomisili"] ? [dictionary objectForKey:@"kodeposDomisili"] : @"",
           @"alamatDomisiliKota" : [dictionary objectForKey:@"kotaDomisili"] ? [dictionary objectForKey:@"kotaDomisili"] : @"",
           
           @"namaIbuKandung" : [dictionary objectForKey:@"namaGadisIbuKandung"] ? [dictionary objectForKey:@"namaGadisIbuKandung"] : @"",
           
           @"ktpPasangan" : [dictionary objectForKey:@"noKTPPasangan"] ? [dictionary objectForKey:@"noKTPPasangan"] : @"",
           @"namaPasangan" : [dictionary objectForKey:@"namaLengkapPasangan"] ? [dictionary objectForKey:@"namaLengkapPasangan"] : @"",
           @"noTlpPasangan" : [dictionary objectForKey:@"nomorHandphonePasangan"] ? [dictionary objectForKey:@"nomorHandphonePasangan"] : @"",
           @"tmpLahirPasangan" : [dictionary objectForKey:@"tempatLahirPasangan"] ? [dictionary objectForKey:@"tempatLahirPasangan"] : @"",
           @"tglLahirPasangan" : [dictionary objectForKey:@"tanggalLahirPasangan"] ? [dictionary objectForKey:@"tanggalLahirPasangan"] : @"",
           @"jnsKelaminPasangan" : [dictionary objectForKey:@"jenisKelaminPasangan"] ? [dictionary objectForKey:@"jenisKelaminPasangan"] : @"",
           @"alamatLegalPasangan" : [dictionary objectForKey:@"alamatPasangan"] ? [dictionary objectForKey:@"alamatPasangan"] : @"",
           @"alamatLegalPasanganRt": [dictionary objectForKey:@"rTPasangan"] ? [dictionary objectForKey:@"rTPasangan"] : @"",
           @"alamatLegalPasanganRw": [dictionary objectForKey:@"rWPasangan"] ? [dictionary objectForKey:@"rWPasangan"] : @"",
           @"alamatLegalPasanganKodePos": [dictionary objectForKey:@"kodePosPasangan"] ? [dictionary objectForKey:@"kodePosPasangan"] : @"",
           @"alamatLegalPasanganKelurahan": [dictionary objectForKey:@"kelurahanPasangan"] ? [dictionary objectForKey:@"kelurahanPasangan"] : @"",
           @"alamatLegalPasanganKecamatan": [dictionary objectForKey:@"kecamatanPasangan"] ? [dictionary objectForKey:@"kecamatanPasangan"] : @"",
           @"alamatLegalPasanganKota": [dictionary objectForKey:@"kotaPasangan"] ? [dictionary objectForKey:@"kotaPasangan"] : @"",
           @"berlakuHingga": [dictionary objectForKey:@"masaBerlakuKTPPasangan"] ? [dictionary objectForKey:@"masaBerlakuKTPPasangan"] : @"",
           @"kewarganegaraanPasangan": [dictionary objectForKey:@"kewarganegaraanPasangan"] ? [dictionary objectForKey:@"kewarganegaraanPasangan"] : @"",
           @"namaIbuKandungPasangan": [dictionary objectForKey:@"namaGadisIbuKandungPasangan"] ? [dictionary objectForKey:@"namaGadisIbuKandungPasangan"] : @"",
           
           @"tipeProduk" : [dictionary objectForKey:@"tipeProduk"] ? [dictionary objectForKey:@"tipeProduk"] : @"",
           @"tipeKendaraan" : [dictionary objectForKey:@"tipeKendaraan"] ? [dictionary objectForKey:@"tipeKendaraan"] : @"",
           @"tahunKendaraan" : [dictionary objectForKey:@"tahunKendaraan"] ? [dictionary objectForKey:@"tahunKendaraan"] : @"",
           
//           @"hargaPerolehan" : [dictionary objectForKey:@"hargaPerolehan"] ? [dictionary objectForKey:@"hargaPerolehan"] : @"",
//           @"uangMuka" : [dictionary objectForKey:@"uangMuka"] ? [dictionary objectForKey:@"uangMuka"] : @"",
//           @"tenor" : [dictionary objectForKey:@"jangkaWaktuPembiayaan"] ? [dictionary objectForKey:@"jangkaWaktuPembiayaan"] : @"",
//           @"angsuran" : [dictionary objectForKey:@"angsuran"] ? [dictionary objectForKey:@"angsuran"] : @"",
           
           @"namaTmpKerja" : [dictionary objectForKey:@"namaTempatKerja"] ? [dictionary objectForKey:@"namaTempatKerja"] : @"",
           @"kodeAreaTelpTmpKerja" : [dictionary objectForKey:@"kodeAreaTeleponTempatKerja"] ? [dictionary objectForKey:@"kodeAreaTeleponTempatKerja"] : @"",
           @"tlpTmpKerja" : [dictionary objectForKey:@"nomorTeleponTempatKerja"] ? [dictionary objectForKey:@"nomorTeleponTempatKerja"] : @"",
           
           @"namaEcon" : [dictionary objectForKey:@"namaEcon"] ? [dictionary objectForKey:@"namaEcon"] : @"",
           @"noTlpEcon" : [dictionary objectForKey:@"nomorTeleponEcon"] ? [dictionary objectForKey:@"nomorTeleponEcon"] : @"",
           
           @"pinjamanLain": [dictionary objectForKey:@"pinjamanTempatLain1"] ? [dictionary objectForKey:@"pinjamanTempatLain1"] : @"",
           @"pinjamanLain2": [dictionary objectForKey:@"pinjamanTempatLain2"] ? [dictionary objectForKey:@"pinjamanTempatLain2"] : @"",
           @"noCc1": [dictionary objectForKey:@"nomorKartuKreditAtauKontrak1"] ? [dictionary objectForKey:@"nomorKartuKreditAtauKontrak1"] : @"",
           @"noCc2": [dictionary objectForKey:@"nomorKartuKreditAtauKontrak2"] ? [dictionary objectForKey:@"nomorKartuKreditAtauKontrak2"] : @"",
           
           @"noteTv": [dictionary objectForKey:@"catatanTV"] ? [dictionary objectForKey:@"catatanTV"] : @"",
           @"noteSs": [dictionary objectForKey:@"catatanSS"] ? [dictionary objectForKey:@"catatanSS"] : @"",
           @"ttd": [dictionary objectForKey:@"ttd"] ? [dictionary objectForKey:@"ttd"] : @"",
//           @"pernyataanPemohon" : @TRUE,
           }];
        
        [param setObject:dataDictionary forKey:@"data"];
        
        [manager POST:[NSString stringWithFormat:@"%@/pengajuandraft/%@", kApiUrl, url] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
            [OfflineData save:dictionary];
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


+ (void)postListWorkOrder:(List *)list dictionary:(NSDictionary *)dictionary completion:(void(^)(NSDictionary *dictionary, NSError *error))block{
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithDictionary:
                                  @{@"userid" :[MPMUserInfo getUserInfo][@"userId"],
                                    @"token" : [MPMUserInfo getToken]}];
    
    NSMutableDictionary *dataDictionary = [NSMutableDictionary dictionary];
    NSString *url = [[MPMUserInfo getRole] isEqualToString:kRoleCustomer] ? @"customer/input" : @"marketing/input";
    @try {
        if (list){
            [dataDictionary setObject:@(list.primaryKey) forKey:@"id"];
        }
        
        [dataDictionary addEntriesFromDictionary:
         @{@"noKtp" : [dictionary objectForKey:@"noKTP"] ? [dictionary objectForKey:@"noKTP"] : @"",
           @"namaCalon" : [dictionary objectForKey:@"namaLengkap"] ? [dictionary objectForKey:@"namaLengkap"] : @"",
           @"tmpLahir" : [dictionary objectForKey:@"tempatLahir"] ? [dictionary objectForKey:@"tempatLahir"] : @"",
           @"tglLahir" : [dictionary objectForKey:@"tanggalLahir"] ? [MPMGlobal removeTimeFromString:[dictionary objectForKey:@"tanggalLahir"]] : @"",
           @"jnsKelamin" : [dictionary objectForKey:@"jenisKelamin"] ? [NSString stringWithFormat:@"%li", [[dictionary objectForKey:@"jenisKelamin"] integerValue]] : @"",
           
           @"alamatLegal" : [dictionary objectForKey:@"alamatRumahSesuaiKTP"] ? [dictionary objectForKey:@"alamatRumahSesuaiKTP"] : @"",
           @"alamatLegalRt" : [dictionary objectForKey:@"rTSesuaiKTP"] ? [dictionary objectForKey:@"rTSesuaiKTP"] : @"",
           @"alamatLegalRw" : [dictionary objectForKey:@"rWSesuaiKTP"] ? [dictionary objectForKey:@"rWSesuaiKTP"] : @"",
           @"kodePosAlamatCalon" : [dictionary objectForKey:@"kodeposSesuaiKTP"] ? [dictionary objectForKey:@"kodeposSesuaiKTP"] : @"",
           @"alamatLegalKecamatan" : [dictionary objectForKey:@"kecamatanSesuaiKTP"] ? [dictionary objectForKey:@"kecamatanSesuaiKTP"] : @"",
           @"alamatLegalKelurahan" : [dictionary objectForKey:@"kelurahanSesuaiKTP"] ? [dictionary objectForKey:@"kelurahanSesuaiKTP"] : @"",
           @"alamatLegalKota" : [dictionary objectForKey:@"kotaSesuaiKTP"] ? [dictionary objectForKey:@"kotaSesuaiKTP"] : @"",
           
           @"ktpBerlaku" : [dictionary objectForKey:@"masaBerlakuKTP"] ? [MPMGlobal removeTimeFromString:[dictionary objectForKey:@"masaBerlakuKTP"]] : @"",
           @"kewarganegaraan" : [dictionary objectForKey:@"kewarganegaraan"] ? [dictionary objectForKey:@"kewarganegaraan"] : @"",
           
           @"handphone" : [dictionary objectForKey:@"nomorHandphone"] ? [dictionary objectForKey:@"nomorHandphone"] : @"",
           @"kodeArea" : [dictionary objectForKey:@"kodeArea"] ? [dictionary objectForKey:@"kodeArea"] : @"",
           @"noTlp" : [dictionary objectForKey:@"nomorTelepon"] ? [dictionary objectForKey:@"nomorTelepon"] : @"",
           
           @"cekAlamatSama" : [dictionary objectForKey:@"samaDenganAlamatLegal"] ? @([[dictionary objectForKey:@"samaDenganAlamatLegal"] integerValue]) : @NO,
           @"alamatDomisili" : [dictionary objectForKey:@"alamatDomisili"] ? [dictionary objectForKey:@"alamatDomisili"] : @"",
           @"alamatDomisiliRt" : [dictionary objectForKey:@"rTDomisili"] ? [dictionary objectForKey:@"rTDomisili"] : @"",
           @"alamatDomisiliRw" : [dictionary objectForKey:@"rWDomisili"] ? [dictionary objectForKey:@"rWDomisili"] : @"",
           @"alamatDomisiliKecamatan" : [dictionary objectForKey:@"kecamatanDomisili"] ? [dictionary objectForKey:@"kecamatanDomisili"] : @"",
           @"alamatDomisiliKelurahan" : [dictionary objectForKey:@"kelurahanDomisili"] ? [dictionary objectForKey:@"kelurahanDomisili"] : @"",
           @"alamatDomisiliKodePos" : [dictionary objectForKey:@"kodeposDomisili"] ? [dictionary objectForKey:@"kodeposDomisili"] : @"",
           @"alamatDomisiliKota" : [dictionary objectForKey:@"kotaDomisili"] ? [dictionary objectForKey:@"kotaDomisili"] : @"",
           
           @"namaIbuKandung" : [dictionary objectForKey:@"namaGadisIbuKandung"] ? [dictionary objectForKey:@"namaGadisIbuKandung"] : @"",
           
           @"ktpPasangan" : [dictionary objectForKey:@"noKTPPasangan"] ? [dictionary objectForKey:@"noKTPPasangan"] : @"",
           @"namaPasangan" : [dictionary objectForKey:@"namaLengkapPasangan"] ? [dictionary objectForKey:@"namaLengkapPasangan"] : @"",
           @"noTlpPasangan" : [dictionary objectForKey:@"nomorHandphonePasangan"] ? [dictionary objectForKey:@"nomorHandphonePasangan"] : @"",
           @"tmpLahirPasangan" : [dictionary objectForKey:@"tempatLahirPasangan"] ? [dictionary objectForKey:@"tempatLahirPasangan"] : @"",
           @"tglLahirPasangan" : [dictionary objectForKey:@"tanggalLahirPasangan"] ? [dictionary objectForKey:@"tanggalLahirPasangan"] : @"",
           @"jnsKelaminPasangan" : [dictionary objectForKey:@"jenisKelaminPasangan"] ? [NSString stringWithFormat:@"%li", [[dictionary objectForKey:@"jenisKelaminPasangan"] integerValue]] : @"",
           @"alamatLegalPasangan" : [dictionary objectForKey:@"alamatPasangan"] ? [dictionary objectForKey:@"alamatPasangan"] : @"",
           @"alamatLegalPasanganRt": [dictionary objectForKey:@"rTPasangan"] ? [dictionary objectForKey:@"rTPasangan"] : @"",
           @"alamatLegalPasanganRw": [dictionary objectForKey:@"rWPasangan"] ? [dictionary objectForKey:@"rWPasangan"] : @"",
           @"alamatLegalPasanganKodePos": [dictionary objectForKey:@"kodePosPasangan"] ? [dictionary objectForKey:@"kodePosPasangan"] : @"",
           @"alamatLegalPasanganKelurahan": [dictionary objectForKey:@"kelurahanPasangan"] ? [dictionary objectForKey:@"kelurahanPasangan"] : @"",
           @"alamatLegalPasanganKecamatan": [dictionary objectForKey:@"kecamatanPasangan"] ? [dictionary objectForKey:@"kecamatanPasangan"] : @"",
           @"alamatLegalPasanganKota": [dictionary objectForKey:@"kotaPasangan"] ? [dictionary objectForKey:@"kotaPasangan"] : @"",
           @"berlakuHingga": [dictionary objectForKey:@"masaBerlakuKTPPasangan"] ? [dictionary objectForKey:@"masaBerlakuKTPPasangan"] : @"",
           @"kewarganegaraanPasangan": [dictionary objectForKey:@"kewarganegaraanPasangan"] ? [dictionary objectForKey:@"kewarganegaraanPasangan"] : @"",
           @"namaIbuKandungPasangan": [dictionary objectForKey:@"namaGadisIbuKandungPasangan"] ? [dictionary objectForKey:@"namaGadisIbuKandungPasangan"] : @"",
           
           @"tipeProduk" : [dictionary objectForKey:@"tipeProduk"] ? [dictionary objectForKey:@"tipeProduk"] : @"",
           @"tipeKendaraan" : [dictionary objectForKey:@"tipeKendaraan"] ? [dictionary objectForKey:@"tipeKendaraan"] : @"",
           @"tahunKendaraan" : [dictionary objectForKey:@"tahunKendaraan"] ? [dictionary objectForKey:@"tahunKendaraan"] : @"",
           
           //not used anymore, but still required by api
           @"hargaPerolehan" : [dictionary objectForKey:@"hargaPerolehan"] ? [dictionary objectForKey:@"hargaPerolehan"] : @"",
           @"uangMuka" : [dictionary objectForKey:@"uangMuka"] ? [dictionary objectForKey:@"uangMuka"] : @"",
           @"tenor" : [dictionary objectForKey:@"jangkaWaktuPembiayaan"] ? [dictionary objectForKey:@"jangkaWaktuPembiayaan"] : @"",
           @"angsuran" : [dictionary objectForKey:@"angsuran"] ? [dictionary objectForKey:@"angsuran"] : @"",
           //====end

           @"namaTmpKerja" : [dictionary objectForKey:@"namaTempatKerja"] ? [dictionary objectForKey:@"namaTempatKerja"] : @"",
           @"kodeAreaTelpTmpKerja" : [dictionary objectForKey:@"kodeAreaTeleponTempatKerja"] ? [dictionary objectForKey:@"kodeAreaTeleponTempatKerja"] : @"",
           @"tlpTmpKerja" : [dictionary objectForKey:@"nomorTeleponTempatKerja"] ? [dictionary objectForKey:@"nomorTeleponTempatKerja"] : @"",
           
           @"namaEcon" : [dictionary objectForKey:@"namaEcon"] ? [dictionary objectForKey:@"namaEcon"] : @"",
           @"noTlpEcon" : [dictionary objectForKey:@"nomorTeleponEcon"] ? [dictionary objectForKey:@"nomorTeleponEcon"] : @"",
           
           @"pinjamanLain": [dictionary objectForKey:@"pinjamanTempatLain1"] ? [dictionary objectForKey:@"pinjamanTempatLain1"] : @"",
           @"pinjamanLain2": [dictionary objectForKey:@"pinjamanTempatLain2"] ? [dictionary objectForKey:@"pinjamanTempatLain2"] : @"",
           @"noCc1": [dictionary objectForKey:@"nomorKartuKreditAtauKontrak1"] ? [dictionary objectForKey:@"nomorKartuKreditAtauKontrak1"] : @"",
           @"noCc2": [dictionary objectForKey:@"nomorKartuKreditAtauKontrak2"] ? [dictionary objectForKey:@"nomorKartuKreditAtauKontrak2"] : @"",
           
           @"noteTv": [dictionary objectForKey:@"catatanTV"] ? [dictionary objectForKey:@"catatanTV"] : @"",
           @"noteSs": [dictionary objectForKey:@"catatanSS"] ? [dictionary objectForKey:@"catatanSS"] : @"",
           @"ttd": [dictionary objectForKey:@"ttd"] ? [dictionary objectForKey:@"ttd"] : @"",
           @"pernyataanPemohon" : [dictionary objectForKey:@"pernyataanPemohon"] && [[dictionary objectForKey:@"pernyataanPemohon"] boolValue] == true ? @"1" : @"0",
           }];
        
        [param setObject:dataDictionary forKey:@"data"];
        
        [manager POST:[NSString stringWithFormat:@"%@/pengajuan/%@", kApiUrl, url] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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

+ (void)setBlackListWithID:(NSInteger)pengajuanId type:(NSString *)type completion:(void(^)(NSDictionary *dictionary, NSError *error))block{
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithDictionary:
                                  @{@"userid" :[MPMUserInfo getUserInfo][@"userId"],
                                    @"token" : [MPMUserInfo getToken],
                                    @"data" : @{@"id" : @(pengajuanId),
                                                @"tipe" : type}
                                    }];
    
    [manager POST:[NSString stringWithFormat:@"%@/pengajuan/setblacklist", kApiUrl] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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

+ (void)setApproveWithID:(NSInteger)pengajuanId completion:(void(^)(NSDictionary *dictionary, NSError *error))block{
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithDictionary:
                                  @{@"userid" :[MPMUserInfo getUserInfo][@"userId"],
                                    @"token" : [MPMUserInfo getToken],
                                    @"data" : @{@"id" : @(pengajuanId),}
                                    }];
    
    [manager POST:[NSString stringWithFormat:@"%@/pengajuan/marketing/approve", kApiUrl] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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

+ (void)setStopProccessWithID:(NSInteger)pengajuanId reason:(NSInteger)reason completion:(void(^)(NSDictionary *dictionary, NSError *error))block{
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithDictionary:
                                  @{@"userid" :[MPMUserInfo getUserInfo][@"userId"],
                                    @"token" : [MPMUserInfo getToken],
                                    @"data" : @{@"id" : [NSString stringWithFormat:@"%li", (long)pengajuanId],
                                                @"tipe" : @"stopProccess",
                                                @"reason" : [NSString stringWithFormat:@"%li", (long)reason],
                                                }
                                    }];
    
    [manager POST:[NSString stringWithFormat:@"%@/pengajuan/stopnext", kApiUrl] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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

+ (void)getViewStepMonitoringWithID:(NSInteger)pengajuanId completion:(void(^)(NSArray *datas, NSError *error))block{
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    NSDictionary* param = @{@"userid" : [MPMUserInfo getUserInfo][@"userId"],
                            @"token" : [MPMUserInfo getToken],
                            @"data" : @{@"id" : @(pengajuanId)}
                            };
    NSLog(@"%@",param);
    [manager POST:[NSString stringWithFormat:@"%@/pengajuan2/milestonecust",kApiUrl] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @try {
            NSInteger code = [[responseObject objectForKey:@"statusCode"] integerValue];
            NSString *message = [responseObject objectForKey:@"message"];
            if (code == 200) {
                NSDictionary *data = responseObject[@"data"];
                NSMutableArray *datas = [NSMutableArray array];
                for (NSDictionary* listDict in data) {
                    ViewStepMonitoring *object = [[ViewStepMonitoring alloc] init];
                    object.label = [listDict objectForKey:@"label"];
                    object.date = [listDict objectForKey:@"date"];
                    object.status = [listDict objectForKey:@"status"];
                    [datas addObject:object];
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
