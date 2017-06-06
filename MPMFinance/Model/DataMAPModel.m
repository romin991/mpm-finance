//
//  DataMAPModel.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 6/6/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "DataMAPModel.h"

@implementation DataMAPModel

+ (void)getDataMAPWithID:(NSInteger)pengajuanId completion:(void(^)(NSDictionary *response, NSError *error))block{
    
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    NSDictionary* param = @{@"userid" : [MPMUserInfo getUserInfo][@"userId"],
                            @"token" : [MPMUserInfo getToken],
                            @"data" : @{@"dataPengajuanId" : @(pengajuanId)}
                            };
    
    [manager POST:[NSString stringWithFormat:@"%@/pengajuan/detail",kApiUrl] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"statusCode"] isEqual:@200]) {
            NSDictionary *data = responseObject[@"data"];
            NSDictionary *dictionary;
            @try {
                dictionary = @{@"kodeCabang" : data[@"kodeCabang"],
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
            } @catch (NSException *exception) {
                NSLog(@"%@", exception);
            } @finally {
                if (block) block(dictionary, nil);
            }
            
        } else {
            NSInteger code = 0;
            NSString *message = @"";
            @try {
                if (responseObject[@"statusCode"]) code = [responseObject[@"statusCode"] integerValue];
                if (responseObject[@"message"]) message = responseObject[@"message"];
            } @catch (NSException *exception) {
                NSLog(@"%@", exception);
            } @finally {
                if (block) block(nil, [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier]
                                                          code:code
                                                      userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(message, nil)}]);
            }
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) block(nil, error);
    }];
}

@end
