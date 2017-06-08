//
//  WorkOrderModel.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 6/7/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "WorkOrderModel.h"

@implementation WorkOrderModel

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
        
        [dataDictionary setObject:[dictionary objectForKey:@"kodeCabang"] forKey:@"kodeCabang"];
        [dataDictionary setObject:[dictionary objectForKey:@"namaCalonDebitur"] forKey:@"namaCalon"];
        [dataDictionary setObject:[dictionary objectForKey:@"noKTP"] forKey:@"noKtp"];
        [dataDictionary setObject:[dictionary objectForKey:@"tempatLahir"] forKey:@"tmpLahir"];
        [dataDictionary setObject:[dictionary objectForKey:@"tanggalLahir"] forKey:@"tglLahir"];
        [dataDictionary setObject:[dictionary objectForKey:@"alamatRumahSesuaiKTP"] forKey:@"alamatLegal"];
        [dataDictionary setObject:[dictionary objectForKey:@"nomorHandphone"] forKey:@"handphone"];
        [dataDictionary setObject:[dictionary objectForKey:@"nomorTelepon"] forKey:@"noTlp"];
        [dataDictionary setObject:[dictionary objectForKey:@"alamatDomisili"] forKey:@"alamatDomisili"];
        [dataDictionary setObject:[dictionary objectForKey:@"kodePosAlamatDomisili"] forKey:@"kodePosAlamatCalon"];
        [dataDictionary setObject:[dictionary objectForKey:@"namaGadisIbuKandung"] forKey:@"namaIbuKandung"];
        
        [dataDictionary setObject:[dictionary objectForKey:@"namaPasangan"] forKey:@"namaPasangan"];
        [dataDictionary setObject:[dictionary objectForKey:@"noKTPPasangan"] forKey:@"ktpPasangan"];
        [dataDictionary setObject:[dictionary objectForKey:@"tempatLahirPasangan"] forKey:@"tmpLahirPasangan"];
        [dataDictionary setObject:[dictionary objectForKey:@"tanggalLahirPasangan"] forKey:@"tglLahirPasangan"];
        [dataDictionary setObject:[dictionary objectForKey:@"alamatPasangan"] forKey:@"alamatLegalPasangan"];
        [dataDictionary setObject:[dictionary objectForKey:@"nomorTeleponPasangan"] forKey:@"noTlpPasangan"];
        [dataDictionary setObject:[dictionary objectForKey:@"namaGadisIbuKandungPasangan"] forKey:@"namaIbuKandungPasangan"];
        
        [dataDictionary setObject:[dictionary objectForKey:@"tipeProduk"] forKey:@"tipeProduk"];
        [dataDictionary setObject:[dictionary objectForKey:@"tipeKendaraan"] forKey:@"tipeKendaraan"];
        [dataDictionary setObject:[dictionary objectForKey:@"tahunKendaraan"] forKey:@"tahunKendaraan"];
        
        [dataDictionary setObject:[dictionary objectForKey:@"hargaPerolehan"] forKey:@"hargaPerolehan"];
        [dataDictionary setObject:[dictionary objectForKey:@"uangMuka"] forKey:@"uangMuka"];
        [dataDictionary setObject:[dictionary objectForKey:@"jangkaWaktuPembiayaan"] forKey:@"tenor"];
        [dataDictionary setObject:[dictionary objectForKey:@"angsuran"] forKey:@"angsuran"];
        
        [dataDictionary setObject:[dictionary objectForKey:@"namaTempatKerja"] forKey:@"namaTmpKerja"];
        [dataDictionary setObject:[dictionary objectForKey:@"nomorTeleponTempatKerja"] forKey:@"tlpTmpKerja"];
        
        [dataDictionary setObject:[dictionary objectForKey:@"namaE-con"] forKey:@"namaEcon"];
        [dataDictionary setObject:[dictionary objectForKey:@"nomorTeleponE-con"] forKey:@"noTlpEcon"];
        
        [param setObject:dataDictionary forKey:@"data"];
        
    } @catch (NSException *exception) {
        NSLog(@"%@", exception);
        if (block) block(nil, [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier]
                                                  code:1
                                              userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(exception.reason, nil)}]);

    } @finally {
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

    }
}

@end
