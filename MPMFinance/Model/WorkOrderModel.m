//
//  WorkOrderModel.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 6/7/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "WorkOrderModel.h"

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
        NSLog(@"%@",error);
        if (block) block(nil, error);
        
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
        NSLog(@"%@",error);
        if (block) block(nil, error);
        
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
        NSLog(@"%@",error);
        if (block) block(nil, error);
        
    }];
    
}

+ (void)getListWorkOrderDetailWithID:(NSInteger)pengajuanId completion:(void(^)(NSDictionary *response, NSError *error))block{
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
                NSDictionary *dictionary = @{@"kodeCabang" : data[@"kodeCabang"],
                                             @"namaCalonDebitur" : data[@"namaCalon"],
                                             @"noKTP" : data[@"noKtp"],
                                             @"tempatLahir" : data[@"tmpLahir"],
                                             @"tanggalLahir" : data[@"tglLahir"],
                                             @"alamatRumahSesuaiKTP" : data[@"alamatLegal"],
                                             @"nomorHandphone" : data[@"handphone"],
                                             @"nomorTelepon" : data[@"noTlp"],
                                             @"alamatDomisili" : data[@"alamatDomisili"],
                                             @"kodePosAlamatDomisili" : data[@"kodePosAlamatCalon"],
                                             @"namaGadisIbuKandung" : data[@"namaIbuKandung"],
                                             
                                             @"namaPasangan" : data[@"namaPasangan"],
                                             @"noKTPPasangan" : data[@"ktpPasangan"],
                                             @"tempatLahirPasangan" : data[@"tmpLahirPasangan"],
                                             @"tanggalLahirPasangan" : data[@"tglLahirPasangan"],
                                             @"alamatPasangan" : data[@"alamatLegalPasangan"],
                                             @"nomorTeleponPasangan" : data[@"noTlpPasangan"],
                                             @"namaGadisIbuKandungPasangan" : data[@"namaIbuKandungPasangan"],
                                             
                                             @"tipeProduk" : data[@"tipeProduk"],
                                             @"tipeKendaraan" : data[@"tipeKendaraan"],
                                             @"tahunKendaraan" : data[@"tahunKendaraan"],
                                             
                                             @"hargaPerolehan" : data[@"hargaPerolehan"],
                                             @"uangMuka" : data[@"uangMuka"],
                                             @"jangkaWaktuPembiayaan" : data[@"tenor"],
                                             @"angsuran" : data[@"angsuran"],
                                             
                                             @"namaTempatKerja" : data[@"namaTmpKerja"],
                                             @"nomorTeleponTempatKerja" : data[@"tlpTmpKerja"],
                                             
                                             @"namaE-con" : data[@"namaEcon"],
                                             @"nomorTeleponE-con" : data[@"noTlpEcon"],
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









+ (void)postDraftWorkOrder:(List *)list dictionary:(NSDictionary *)dictionary completion:(void(^)(NSDictionary *dictionary, NSError *error))block{
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithDictionary:
                                  @{@"userid" :[MPMUserInfo getUserInfo][@"userId"],
                                    @"token" : [MPMUserInfo getToken]}];
    
    NSMutableDictionary *dataDictionary = [NSMutableDictionary dictionary];
    NSString *url = @"input";
    @try {
        if (list){
            [dataDictionary setObject:@(list.primaryKey) forKey:@"id"];
            url = @"update";
        }
        
        [dataDictionary addEntriesFromDictionary:
         @{@"kodeCabang" : [dictionary objectForKey:@"cabang"] ? [dictionary objectForKey:@"cabang"] : @"",
           @"namaCalon" : [dictionary objectForKey:@"namaLengkap"] ? [dictionary objectForKey:@"namaLengkap"] : @"",
           @"noKtp" : [dictionary objectForKey:@"noKTP"] ? [dictionary objectForKey:@"noKTP"] : @"",
           @"tmpLahir" : [dictionary objectForKey:@"tempatLahir"] ? [dictionary objectForKey:@"tempatLahir"] : @"",
           @"tglLahir" : [dictionary objectForKey:@"tanggalLahir"] ? [MPMGlobal removeTimeFromString:[dictionary objectForKey:@"tanggalLahir"]] : @"",
           
           @"alamatLegal" : [dictionary objectForKey:@"alamatRumahSesuaiKTP"] ? [dictionary objectForKey:@"alamatRumahSesuaiKTP"] : @"",
           @"alamatLegalRt" : [dictionary objectForKey:@"rTSesuaiKTP"] ? [dictionary objectForKey:@"rTSesuaiKTP"] : @"",
           @"alamatLegalRw" : [dictionary objectForKey:@"rWSesuaiKTP"] ? [dictionary objectForKey:@"rWSesuaiKTP"] : @"",
           @"kodePosAlamatCalon" : [dictionary objectForKey:@"kodeposSesuaiKTP"] ? [dictionary objectForKey:@"kodeposSesuaiKTP"] : @"",
           @"alamatLegalKecamatan" : [dictionary objectForKey:@"kecamatanSesuaiKTP"] ? [dictionary objectForKey:@"kecamatanSesuaiKTP"] : @"",
           @"alamatLegalKelurahan" : [dictionary objectForKey:@"kelurahanSesuaiKTP"] ? [dictionary objectForKey:@"kelurahanSesuaiKTP"] : @"",
           @"alamatLegalKota" : [dictionary objectForKey:@"kotaSesuaiKTP"] ? [dictionary objectForKey:@"kotaSesuaiKTP"] : @"",
           
           @"handphone" : [dictionary objectForKey:@"nomorHandphone"] ? [dictionary objectForKey:@"nomorHandphone"] : @"",
           @"kodeArea" : [dictionary objectForKey:@"kodeArea"] ? [dictionary objectForKey:@"kodeArea"] : @"",
           @"noTlp" : [dictionary objectForKey:@"nomorTelepon"] ? [dictionary objectForKey:@"nomorTelepon"] : @"",
           
           @"cekAlamatSama" : [dictionary objectForKey:@"samaDenganAlamatLegal"] ? @([[dictionary objectForKey:@"samaDenganAlamatLegal"] integerValue]) : @NO,
           @"alamatDomisili" : [dictionary objectForKey:@"alamatDomisili"] ? [dictionary objectForKey:@"alamatDomisili"] : @"",
           @"alamatDomisiliRt" : [dictionary objectForKey:@"rTDomisili"] ? [dictionary objectForKey:@"rTDomisili"] : @"",
           @"alamatDomisiliRw" : [dictionary objectForKey:@"rWDomisili"] ? [dictionary objectForKey:@"rWDomisili"] : @"",
           @"alamatDomisiliKecamatan" : [dictionary objectForKey:@"kodeposDomisili"] ? [dictionary objectForKey:@"kodeposDomisili"] : @"",
           @"alamatDomisiliKelurahan" : [dictionary objectForKey:@"kecamatanDomisili"] ? [dictionary objectForKey:@"kecamatanDomisili"] : @"",
           @"alamatDomisiliKota" : [dictionary objectForKey:@"kelurahanDomisili"] ? [dictionary objectForKey:@"kelurahanDomisili"] : @"",
           @"alamatDomisiliKota" : [dictionary objectForKey:@"kotaDomisili"] ? [dictionary objectForKey:@"kotaDomisili"] : @"",
           
           @"namaIbuKandung" : [dictionary objectForKey:@"namaGadisIbuKandung"] ? [dictionary objectForKey:@"namaGadisIbuKandung"] : @"",
           
           @"namaPasangan" : [dictionary objectForKey:@"namaPasangan"] ? [dictionary objectForKey:@"namaPasangan"] : @"",
           @"noTlpPasangan" : [dictionary objectForKey:@"noHandphonePasangan"] ? [dictionary objectForKey:@"noHandphonePasangan"] : @"",
           
           @"tipeProduk" : [dictionary objectForKey:@"tipeProduk"] ? [dictionary objectForKey:@"tipeProduk"] : @"",
           @"tipeKendaraan" : [dictionary objectForKey:@"tipeKendaraan"] ? [dictionary objectForKey:@"tipeKendaraan"] : @"",
           @"tahunKendaraan" : [dictionary objectForKey:@"tahunKendaraan"] ? [dictionary objectForKey:@"tahunKendaraan"] : @"",
           
           @"hargaPerolehan" : [dictionary objectForKey:@"hargaPerolehan"] ? [dictionary objectForKey:@"hargaPerolehan"] : @"",
           @"uangMuka" : [dictionary objectForKey:@"uangMuka"] ? [dictionary objectForKey:@"uangMuka"] : @"",
           @"tenor" : [dictionary objectForKey:@"jangkaWaktuPembiayaan"] ? [dictionary objectForKey:@"jangkaWaktuPembiayaan"] : @"",
           @"angsuran" : [dictionary objectForKey:@"angsuran"] ? [dictionary objectForKey:@"angsuran"] : @"",
           
           @"namaTmpKerja" : [dictionary objectForKey:@"namaTempatKerja"] ? [dictionary objectForKey:@"namaTempatKerja"] : @"",
           @"tlpTmpKerja" : [dictionary objectForKey:@"nomorTeleponTempatKerja"] ? [dictionary objectForKey:@"nomorTeleponTempatKerja"] : @"",
           
           @"namaEcon" : [dictionary objectForKey:@"namaE-con"] ? [dictionary objectForKey:@"namaE-con"] : @"",
           @"noTlpEcon" : [dictionary objectForKey:@"nomorTeleponE-con"] ? [dictionary objectForKey:@"nomorTeleponE-con"] : @"",
           @"kodeAreaTelpTmpKerja" : [dictionary objectForKey:@"kodeAreaTeleponTempatKerja"] ? [dictionary objectForKey:@"kodeAreaTeleponTempatKerja"] : @"",
           
           @"pernyataanPemohon" : @TRUE,
           }];
        
        [param setObject:dataDictionary forKey:@"data"];
        
        [manager POST:[NSString stringWithFormat:@"%@/pengajuandraft/customer/%@", kApiUrl, url] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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


+ (void)postListWorkOrder:(List *)list dictionary:(NSDictionary *)dictionary completion:(void(^)(NSDictionary *dictionary, NSError *error))block{
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithDictionary:
                                  @{@"userid" :[MPMUserInfo getUserInfo][@"userId"],
                                    @"token" : [MPMUserInfo getToken]}];
    
    NSMutableDictionary *dataDictionary = [NSMutableDictionary dictionary];
    NSString *url = @"input";
    @try {
        if (list){
            [dataDictionary setObject:@(list.primaryKey) forKey:@"id"];
            url = @"update";
        }
        
        [dataDictionary addEntriesFromDictionary:
         @{@"kodeCabang" : [dictionary objectForKey:@"cabang"] ? [dictionary objectForKey:@"cabang"] : @"",
           @"namaCalon" : [dictionary objectForKey:@"namaLengkap"] ? [dictionary objectForKey:@"namaLengkap"] : @"",
           @"noKtp" : [dictionary objectForKey:@"noKTP"] ? [dictionary objectForKey:@"noKTP"] : @"",
           @"tmpLahir" : [dictionary objectForKey:@"tempatLahir"] ? [dictionary objectForKey:@"tempatLahir"] : @"",
           @"tglLahir" : [dictionary objectForKey:@"tanggalLahir"] ? [MPMGlobal removeTimeFromString:[dictionary objectForKey:@"tanggalLahir"]] : @"",
           
           @"alamatLegal" : [dictionary objectForKey:@"alamatRumahSesuaiKTP"] ? [dictionary objectForKey:@"alamatRumahSesuaiKTP"] : @"",
           @"alamatLegalRt" : [dictionary objectForKey:@"rTSesuaiKTP"] ? [dictionary objectForKey:@"rTSesuaiKTP"] : @"",
           @"alamatLegalRw" : [dictionary objectForKey:@"rWSesuaiKTP"] ? [dictionary objectForKey:@"rWSesuaiKTP"] : @"",
           @"kodePosAlamatCalon" : [dictionary objectForKey:@"kodeposSesuaiKTP"] ? [dictionary objectForKey:@"kodeposSesuaiKTP"] : @"",
           @"alamatLegalKecamatan" : [dictionary objectForKey:@"kecamatanSesuaiKTP"] ? [dictionary objectForKey:@"kecamatanSesuaiKTP"] : @"",
           @"alamatLegalKelurahan" : [dictionary objectForKey:@"kelurahanSesuaiKTP"] ? [dictionary objectForKey:@"kelurahanSesuaiKTP"] : @"",
           @"alamatLegalKota" : [dictionary objectForKey:@"kotaSesuaiKTP"] ? [dictionary objectForKey:@"kotaSesuaiKTP"] : @"",
           
           @"handphone" : [dictionary objectForKey:@"nomorHandphone"] ? [dictionary objectForKey:@"nomorHandphone"] : @"",
           @"kodeArea" : [dictionary objectForKey:@"kodeArea"] ? [dictionary objectForKey:@"kodeArea"] : @"",
           @"noTlp" : [dictionary objectForKey:@"nomorTelepon"] ? [dictionary objectForKey:@"nomorTelepon"] : @"",
           
           @"cekAlamatSama" : [dictionary objectForKey:@"samaDenganAlamatLegal"] ? @([[dictionary objectForKey:@"samaDenganAlamatLegal"] integerValue]) : @NO,
           @"alamatDomisili" : [dictionary objectForKey:@"alamatDomisili"] ? [dictionary objectForKey:@"alamatDomisili"] : @"",
           @"alamatDomisiliRt" : [dictionary objectForKey:@"rTDomisili"] ? [dictionary objectForKey:@"rTDomisili"] : @"",
           @"alamatDomisiliRw" : [dictionary objectForKey:@"rWDomisili"] ? [dictionary objectForKey:@"rWDomisili"] : @"",
           @"alamatDomisiliKecamatan" : [dictionary objectForKey:@"kodeposDomisili"] ? [dictionary objectForKey:@"kodeposDomisili"] : @"",
           @"alamatDomisiliKelurahan" : [dictionary objectForKey:@"kecamatanDomisili"] ? [dictionary objectForKey:@"kecamatanDomisili"] : @"",
           @"alamatDomisiliKota" : [dictionary objectForKey:@"kelurahanDomisili"] ? [dictionary objectForKey:@"kelurahanDomisili"] : @"",
           @"alamatDomisiliKota" : [dictionary objectForKey:@"kotaDomisili"] ? [dictionary objectForKey:@"kotaDomisili"] : @"",
           
           @"namaIbuKandung" : [dictionary objectForKey:@"namaGadisIbuKandung"] ? [dictionary objectForKey:@"namaGadisIbuKandung"] : @"",
           
           @"namaPasangan" : [dictionary objectForKey:@"namaPasangan"] ? [dictionary objectForKey:@"namaPasangan"] : @"",
           @"noTlpPasangan" : [dictionary objectForKey:@"noHandphonePasangan"] ? [dictionary objectForKey:@"noHandphonePasangan"] : @"",
           
           @"tipeProduk" : [dictionary objectForKey:@"tipeProduk"] ? [dictionary objectForKey:@"tipeProduk"] : @"",
           @"tipeKendaraan" : [dictionary objectForKey:@"tipeKendaraan"] ? [dictionary objectForKey:@"tipeKendaraan"] : @"",
           @"tahunKendaraan" : [dictionary objectForKey:@"tahunKendaraan"] ? [dictionary objectForKey:@"tahunKendaraan"] : @"",
           
           @"hargaPerolehan" : [dictionary objectForKey:@"hargaPerolehan"] ? [dictionary objectForKey:@"hargaPerolehan"] : @"",
           @"uangMuka" : [dictionary objectForKey:@"uangMuka"] ? [dictionary objectForKey:@"uangMuka"] : @"",
           @"tenor" : [dictionary objectForKey:@"jangkaWaktuPembiayaan"] ? [dictionary objectForKey:@"jangkaWaktuPembiayaan"] : @"",
           @"angsuran" : [dictionary objectForKey:@"angsuran"] ? [dictionary objectForKey:@"angsuran"] : @"",
           
           @"namaTmpKerja" : [dictionary objectForKey:@"namaTempatKerja"] ? [dictionary objectForKey:@"namaTempatKerja"] : @"",
           @"tlpTmpKerja" : [dictionary objectForKey:@"nomorTeleponTempatKerja"] ? [dictionary objectForKey:@"nomorTeleponTempatKerja"] : @"",
           
           @"namaEcon" : [dictionary objectForKey:@"namaE-con"] ? [dictionary objectForKey:@"namaE-con"] : @"",
           @"noTlpEcon" : [dictionary objectForKey:@"nomorTeleponE-con"] ? [dictionary objectForKey:@"nomorTeleponE-con"] : @"",
           @"kodeAreaTelpTmpKerja" : [dictionary objectForKey:@"kodeAreaTeleponTempatKerja"] ? [dictionary objectForKey:@"kodeAreaTeleponTempatKerja"] : @"",
           
           @"pernyataanPemohon" : @TRUE,
           }];
        
        [param setObject:dataDictionary forKey:@"data"];
        
        [manager POST:[NSString stringWithFormat:@"%@/pengajuan/customer/%@", kApiUrl, url] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
        if (block) block(nil, error);
    }];
}

@end
