//
//  DataMAPModel.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 6/6/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "DataMAPModel.h"

@implementation DataMAPModel

+ (void)checkMAPSubmittedWithID:(NSInteger)pengajuanId completion:(void(^)(NSDictionary *response, NSError *error))block{
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    NSDictionary* param = @{@"userid" : [MPMUserInfo getUserInfo][@"userId"],
                            @"token" : [MPMUserInfo getToken],
                            @"data" : @{@"id_pengajuan" : @(pengajuanId)}
                            };
    NSLog(@"%@",param);
    [manager POST:[NSString stringWithFormat:@"%@/datamap/cekmapsubmitted",kApiUrl] parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @try {
            NSInteger code = [[responseObject objectForKey:@"statusCode"] integerValue];
            NSString *message = [responseObject objectForKey:@"message"];
            if (code == 200) {
                NSDictionary *data = responseObject[@"data"];
                
                if (block) block(data, nil);
                
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

+ (void)getDataMAPWithID:(NSInteger)pengajuanId completion:(void(^)(NSDictionary *response, NSError *error))block{
    
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    NSDictionary* param = @{@"userid" : [MPMUserInfo getUserInfo][@"userId"],
                            @"token" : [MPMUserInfo getToken],
                            @"data" : @{@"dataPengajuanId" : @(pengajuanId)}
                            };
    
    [manager POST:[NSString stringWithFormat:@"%@/datamap/detail",kApiUrl] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"statusCode"] isEqual:@200]) {
            NSDictionary *data = responseObject[@"data"];
            NSMutableDictionary *dictionary;
            @try {
                
                dictionary = [NSMutableDictionary dictionaryWithDictionary:@{
                               @"id" : @([data[@"id"] integerValue]),
                               @"idPengajuan" : @([data[@"id_pengajuan"] integerValue]),
                               @"sumberAplikasi" : @([data[@"sumber_aplikasi"] integerValue]),
                               @"tujuanPembiayaan" : @([data[@"tujuan_pembiayaan"] integerValue]),
                               @"jenisAplikasi" : data[@"kode_aplikasi"],
                               @"kodeCabang" : data[@"kode_cabang"],
                               @"namaKP" : data[@"nama_kp"],
                               @"tanggalPerjanjian" : data[@"tgl_perjanjian"],
                               @"produk" : @([data[@"product"] integerValue]),
                               @"sourceOfApplication" : data[@"src_of_app"],
                               @"productOffering" : data[@"product_offering"],
                               @"jarakTempuh" : data[@"jarak_tempuh"],
                               @"lokasiPemakaianAset" : @([data[@"daerah"] integerValue]),
                               @"applicationPriority" : data[@"app_priority"],
                               @"nomorTiketTelesales" : data[@"no_ticketsales"],
                               
                               @"namaLengkapSesuaiKTP" : data[@"nama_lengkap"],
                               @"namaPanggilan" : data[@"nama_alias"],
                               @"agama" : data[@"agama"],
                               @"statusPernikahan" : data[@"status_pernikahan"],
                               @"statusKepemilikanRumah" : data[@"status_rmh"],
                               @"tanggalSelesaiKontrak" : data[@"tgl_selesai_kontrak_rmh"],
                               @"lokasiRumah" : data[@"lokasi_rumah"],
                               @"tahunMenempati" : data[@"tahun_menempati"],
                               @"nomorNPWP" : data[@"no_npwp"],
                               @"nomorKartuKeluarga" : data[@"no_kk"],
                               @"jumlahTanggungan" : data[@"jml_tanggungan"],
                               @"pendidikanTerakhir" : data[@"pendidikan_terakhir"],
                               @"alamatPengirimanSurat" : @([data[@"alamat_pengiriman_surat"] integerValue]),
                               @"alamatEmail" : data[@"email"],
                               
                               @"jenisPekerjaan" : @([data[@"jns_pekerjaan"] integerValue]),
                               @"pekerjaan" : data[@"pekerjaan"],
                               @"statusPekerjaan" : @([data[@"status_pekerjaan"] integerValue]),
                               @"bidangUsaha" : data[@"bidang_usaha"],
                               @"posisiJabatan" : data[@"posisi_jabatan"],
                               @"alamatKantor" : data[@"alamat_kantor"],
                               @"rT" : data[@"alamat_kantor_rt"],
                               @"rW" : data[@"alamat_kantor_rw"],
                               @"kodePos" : data[@"alamat_kantor_kode_pos"],
                               @"kelurahan" : data[@"alamat_kantor_kelurahan"],
                               @"kecamatan" : data[@"alamat_kantor_kecamatan"],
                               @"kota" : data[@"alamat_kantor_kota"],
                               @"lamaBekerjaDalamBulan" : data[@"lama_bekerja"],
                               
                               @"pendapatanPerBulan" : data[@"pendapatan_per_bulan"],
                               @"lamaBekerja" : data[@"lama_bekerja"],
                               @"pendapatanLainnyaPerBulan" : data[@"pendapatan_lain_per_bulan"],
                               
                               @"tahun1" : data[@"omset_per_bulan_thn"],
                               @"bulan1" : data[@"omset_per_bulan_bln"],
                               @"omzet1" : data[@"omset_per_bulan"],
                               @"tahun2" : data[@"omset_per_bulan_thn_2"],
                               @"bulan2" : data[@"omset_per_bulan_bln_2"],
                               @"omzet2" : data[@"omset_per_bulan_2"],
                               @"tahun3" : data[@"omset_per_bulan_thn_3"],
                               @"bulan3" : data[@"omset_per_bulan_bln_3"],
                               @"omzet3" : data[@"omset_per_bulan_3"],
                               @"tahun4" : data[@"omset_per_bulan_thn_4"],
                               @"bulan4" : data[@"omset_per_bulan_bln_4"],
                               @"omzet4" : data[@"omset_per_bulan_4"],
                               @"tahun5" : data[@"omset_per_bulan_thn_5"],
                               @"bulan5" : data[@"omset_per_bulan_bln_5"],
                               @"omzet5" : data[@"omset_per_bulan_5"],
                               @"tahun6" : data[@"omset_per_bulan_thn_6"],
                               @"bulan6" : data[@"omset_per_bulan_bln_6"],
                               @"omzet6" : data[@"omset_per_bulan_6"],
                               
                               @"gajiPokok" : data[@"gaji_pokok"],
                               @"tunjanganPokok" : data[@"tunjangan_tetap"],
                               @"intensif" : data[@"insentif"],
                               @"lembur" : data[@"lembur"],
                               @"bonus" : data[@"bonus"],
                               @"total" : data[@"total"],
                               
                               @"namaLengkapSesuaiKTPPasangan" : data[@"nama_pasangan_sesuai_ktp"],
                               
                               @"namaPerusahaanPasangan" : data[@"nama_perusahaan_pasangan"],
                               @"alamatKantorPasangan" : data[@"alamat_kantor_pasangan"],
                               @"rTKantorPasangan" : data[@"alamat_kantor_pasangan_rt"],
                               @"rWKantorPasangan" : data[@"alamat_kantor_pasangan_rw"],
                               @"kodePosKantorPasangan" : data[@"alamat_kantor_pasangan_kode_pos"],
                               @"kelurahanKantorPasangan" : data[@"alamat_kantor_pasangan_kelurahan"],
                               @"kecamatanKantorPasangan" : data[@"alamat_kantor_pasangan_kecamatan"],
                               @"kotaKantorPasangan" : data[@"alamat_kantor_pasangan_kota"],
                               
                               @"caraPembiayaan" : data[@"cara_pembayaran"],
                               @"jumlahAset" : data[@"jml_asset"],
                               @"pokokHutang" : data[@"pokok_hutang"],
                               @"subsidiUangMuka" : data[@"subsidi_dp"],
                               @"totalUangDiterimaMPMF" : data[@"total_uang_diterima_mpmf"],
                               @"biayaAdmin" : data[@"biaya_admin"],
                               @"biayaAdminLainnya" : data[@"biaya_admin_lain"],
                               @"biayaFidusia" : data[@"biaya_fidusia"],
                               @"biayaLain" : data[@"biaya_lain"],
                               @"biayaSurvey" : data[@"biaya_survey"],
                               @"persentaseBiayaProvisi" : data[@"persentase_biaya_provisi"],
                               @"biayaProvisi" : data[@"biaya_provisi"],
                               @"asuransiKapitalisasi" : data[@"asuransi_kapitalisasi"],
                               @"interestType" : data[@"interest_type"],
                               @"effectiveRate" : data[@"effective_rate"],
                               @"skemaAngsuran" : data[@"skema_angsuran"],
                               @"tipeAngsuran" : data[@"tipe_angsuran"],
                               @"sumberDana" : @([data[@"sumber_dana"] integerValue]),
                               @"hargaKendaraan" : data[@"harga_kendaraan"],
                               @"totalBayarAwal" : data[@"uang_muka"],
                               @"jangkaWaktuPembiayaan" : data[@"jangka_waktu_pembiayaan"],
                               @"angsuran" : data[@"angsuran"],
                               
                               @"namaAsuransi" : data[@"nama_asuransi"],
                               @"asuransiDibayar" : data[@"asuransi_dibayar"],
                               @"jangkaWaktuAsuransi" : data[@"jangka_waktu_asuransi"],
                               @"periodeAsuransi" : data[@"periode_asuransi"],
                               @"nilaiPertanggungan" : data[@"nilai_pertanggungan"],
                               @"jenisPertanggunganAllRisk" : data[@"jenis_pertanggungan"],
                               @"jenisPertanggunganTLO" : data[@"jenis_pertanggungan_tlo"],
                               @"sRCC" : @([data[@"srcc"] integerValue]),
                               @"banjir" : @([data[@"banjir"] integerValue]),
                               @"gempaBumi" : @([data[@"gempa_bumi"] integerValue]),
                               @"tPL" : @([data[@"tpl"] integerValue]),
                               @"pA" : @([data[@"pa"] integerValue]),
                               @"asuransiJiwaKredit" : @([data[@"asuransi_jiwa_kredit"] integerValue]),
                               @"asuransiJiwaKreditKapitalisasi" : data[@"asuransi_jiwa_kapitalisasi"],
                               @"nilaiPertanggunganAsuransiJiwa" : data[@"nilai_pertanggungan_asuransi"],
                               @"premiAsuransiKerugianKendaraan" : data[@"premi_asuransi_kerugian_kendaraan"],
                               @"premiAsuransiJiwaKredit" : data[@"premi_asuransi_jiwa_kredit"],
                               @"perusahaanAsuransiJiwa" : data[@"perusahaan_asuransi_jiwa"],
                               @"tipeAsuransi" : data[@"tipe_asuransi"],
                               @"asuransiKendaraanKapitalisasi" : data[@"asuransi_kendaraan_kapitalisasi"],
                               @"asuransiKendaraanDibayarDimuka" : data[@"asuransi_kendaraan_dp"],
                               @"asuransiJiwaDibayarDimuka" : data[@"asuransi_jiwa_dp"],
                               @"periodeAsuransiJiwa" : data[@"periode_asuransi_jiwa"],
                               
                               @"namaSupplier" : data[@"nama_suplier"],
                               @"assetFinanced" : data[@"asset_financed"],
                               @"newUsed" : @([data[@"new_used"] integerValue]),
                               @"noRangka" : data[@"no_rangka"],
                               @"noMesin" : data[@"no_mesin"],
                               @"pemakaianUnit" : data[@"pemakaian_unit"],
                               @"silinder" : data[@"silinder"],
                               @"warna" : data[@"warna"],
                               @"nomorPolisi" : data[@"no_polisi"],
                               @"namaBPKB" : data[@"nama_bpkb"],
                               @"areaKendaraan" : data[@"area_kendaraan"],
                               
                               @"hubunganEconDenganPemohon" : data[@"hubungan_dgn_pemohon"],
                               
                               @"namaPenjamin" : data[@"nama_penjamin"],
                               @"hubunganPenjaminDenganPemohon" : data[@"hubungan_dgn_debitur"],
                               @"namaPasanganPenjamin" : data[@"nama_pasangan_penjamin"],
                               
                               @"namaKepalaCabang" : data[@"nama_branch_marketing"],
                               @"namaMarketing" : data[@"nama_marketing"],
                               @"rca" : data[@"rca"],
                               
                               @"statusGrouping" : data[@"status_grouping"],
                               }];
                
                NSMutableArray *families = [NSMutableArray array];
                for (id familyData in data[@"data_keluarga"]) {
                    [families addObject:@{@"nama" : familyData[@"nama"],
                                          @"nomorIndukKependudukan" : familyData[@"no_kk"],
                                          @"tanggalLahir" : familyData[@"tgl_lahir_keluarga"],
                                          @"hubunganDenganPemohon" : familyData[@"hubungan"],
                                          }];
                }
                
                [dictionary setObject:families forKey:@"dataKeluarga"];
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

+ (void)postDataMAPWithType:(PostType)postType dictionary:(NSDictionary *)dictionary completion:(void(^)(NSDictionary *dictionary, NSError *error))block{
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithDictionary:
                                  @{@"userid" :[MPMUserInfo getUserInfo][@"userId"],
                                    @"token" : [MPMUserInfo getToken]}];
    
    NSMutableDictionary *dataDictionary = [NSMutableDictionary dictionary];
    @try {
        NSString *url;
        
        if (postType == DataMAPPostTypeAplikasi) {
            url = [NSString stringWithFormat:@"%@/datamap/update/aplikasi", kApiUrl];
            
            [dataDictionary addEntriesFromDictionary:
             @{@"id_pengajuan" : [dictionary objectForKey:@"idPengajuan"] ? [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"idPengajuan"]] : @"",
               @"sumber_aplikasi" : [dictionary objectForKey:@"sumberAplikasi"] ? [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"sumberAplikasi"]] : @"",
               @"tujuan_pembiayaan" : [dictionary objectForKey:@"tujuanPembiayaan"] ? [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"tujuanPembiayaan"]] : @"",
               @"kode_aplikasi" : [dictionary objectForKey:@"jenisAplikasi"] ?: @"",
               @"kode_cabang" : [dictionary objectForKey:@"kodeCabang"] ?: @"",
               @"tgl_perjanjian" : [dictionary objectForKey:@"tanggalPerjanjian"] ? [MPMGlobal removeTimeFromString:[dictionary objectForKey:@"tanggalPerjanjian"]] : @"",
               @"product" : [dictionary objectForKey:@"produk"] ? [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"produk"]] : @"",
               @"src_of_app" : [dictionary objectForKey:@"sourceOfApplication"] ?: @"",
               @"product_offering" : [dictionary objectForKey:@"productOffering"] ?: @"",
               @"jarak_tempuh" : [dictionary objectForKey:@"jarakTempuh"] ?: @"",
               @"daerah" : [dictionary objectForKey:@"lokasiPemakaianAset"] ? [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"lokasiPemakaianAset"]] : @"",
               @"app_priority" : [dictionary objectForKey:@"applicationPriority"] ?: @"",
               @"no_ticketsales" : [dictionary objectForKey:@"nomorTiketTelesales"] ?: @"",
               @"nama_kp" : [dictionary objectForKey:@"namaKP"] ?: @"",
               
               }];
            
        } else if (postType == DataMAPPostTypePribadi) {
            url = [NSString stringWithFormat:@"%@/datamap/update/pribadi", kApiUrl];
            
            [dataDictionary addEntriesFromDictionary:
             @{@"id_pengajuan" : [dictionary objectForKey:@"idPengajuan"] ?: @"",
               @"nama_lengkap" : [dictionary objectForKey:@"namaLengkapSesuaiKTP"] ?: @"",
               @"nama_alias" : [dictionary objectForKey:@"namaPanggilan"] ?: @"",
               @"agama" : [dictionary objectForKey:@"agama"] ?: @"",
               @"status_pernikahan" : [dictionary objectForKey:@"statusPernikahan"] ?: @"",
               @"status_rmh" : [dictionary objectForKey:@"statusKepemilikanRumah"] ?: @"",
               @"tgl_selesai_kontrak_rmh" : [dictionary objectForKey:@"tanggalSelesaiKontrak"] ?: @"",
               @"lokasi_rumah" : [dictionary objectForKey:@"lokasiRumah"] ?: @"",
               @"tahun_menempati" : [dictionary objectForKey:@"tahunMenempati"] ?: @"",
               @"no_npwp" : [dictionary objectForKey:@"nomorNPWP"] ?: @"",
               @"no_kk" : [dictionary objectForKey:@"nomorKartuKeluarga"] ?: @"",
               @"jml_tanggungan" : [dictionary objectForKey:@"jumlahTanggungan"] ?: @"",
               @"pendidikan_terakhir" : [dictionary objectForKey:@"pendidikanTerakhir"] ?: @"",
               @"alamat_pengiriman_surat" : [dictionary objectForKey:@"alamatPengirimanSurat"] ?: @"",
               @"email" : [dictionary objectForKey:@"alamatEmail"] ?: @"",
               }];
            
        } else if (postType == DataMAPPostTypePekerjaan) {
            url = [NSString stringWithFormat:@"%@/datamap/update/pekerjaan", kApiUrl];
            
            [dataDictionary addEntriesFromDictionary:
             @{@"id_pengajuan" : [dictionary objectForKey:@"idPengajuan"] ?: @"",
               @"jns_pekerjaan" : [dictionary objectForKey:@"jenisPekerjaan"] ?: @"",
               @"pekerjaan" : [dictionary objectForKey:@"pekerjaan"] ?: @"",
               @"status_pekerjaan" : [dictionary objectForKey:@"statusPekerjaan"] ?: @"",
               @"bidang_usaha" : [dictionary objectForKey:@"bidangUsaha"] ?: @"",
               @"posisi_jabatan" : [dictionary objectForKey:@"posisiJabatan"] ?: @"",
               @"alamat_kantor" : [dictionary objectForKey:@"alamatKantor"] ?: @"",
               @"alamat_kantor_rt" : [dictionary objectForKey:@"rT"] ?: @"",
               @"alamat_kantor_rw" : [dictionary objectForKey:@"rW"] ?: @"",
               @"alamat_kantor_kode_pos" : [dictionary objectForKey:@"kodePos"] ?: @"",
               @"alamat_kantor_kelurahan" : [dictionary objectForKey:@"kelurahan"] ?: @"",
               @"alamat_kantor_kecamatan" : [dictionary objectForKey:@"kecamatan"] ?: @"",
               @"alamat_kantor_kota" : [dictionary objectForKey:@"kota"] ?: @"",
               @"lama_bekerja" : [dictionary objectForKey:@"lamaBekerjaDalamBulan"] ?: @"",
               
               @"pendapatan_per_tahun" : [dictionary objectForKey:@"pendapatanPerBulan"] ?: @"",
               @"lama_bekerja" : [dictionary objectForKey:@"lamaBekerja"] ?: @"",
               @"pendapatan_lain_per_bulan" : [dictionary objectForKey:@"pendapatanLainnyaPerBulan"] ?: @"",
               
               @"omset_per_bulan_thn" : [dictionary objectForKey:@"tahun1"] ?: @"",
               @"omset_per_bulan_bln" : [dictionary objectForKey:@"bulan1"] ?: @"",
               @"omset_per_bulan" : [dictionary objectForKey:@"omzet1"] ?: @"",
               @"omset_per_bulan_thn_2" : [dictionary objectForKey:@"tahun2"] ?: @"",
               @"omset_per_bulan_bln_2" : [dictionary objectForKey:@"bulan2"] ?: @"",
               @"omset_per_bulan_2" : [dictionary objectForKey:@"omzet2"] ?: @"",
               @"omset_per_bulan_thn_3" : [dictionary objectForKey:@"tahun3"] ?: @"",
               @"omset_per_bulan_bln_3" : [dictionary objectForKey:@"bulan3"] ?: @"",
               @"omset_per_bulan_3" : [dictionary objectForKey:@"omzet3"] ?: @"",
               @"omset_per_bulan_thn_4" : [dictionary objectForKey:@"tahun4"] ?: @"",
               @"omset_per_bulan_bln_4" : [dictionary objectForKey:@"bulan4"] ?: @"",
               @"omset_per_bulan_4" : [dictionary objectForKey:@"omzet4"] ?: @"",
               @"omset_per_bulan_thn_5" : [dictionary objectForKey:@"tahun5"] ?: @"",
               @"omset_per_bulan_bln_5" : [dictionary objectForKey:@"bulan5"] ?: @"",
               @"omset_per_bulan_5" : [dictionary objectForKey:@"omzet5"] ?: @"",
               @"omset_per_bulan_thn_6" : [dictionary objectForKey:@"tahun6"] ?: @"",
               @"omset_per_bulan_bln_6" : [dictionary objectForKey:@"bulan6"] ?: @"",
               @"omset_per_bulan_6" : [dictionary objectForKey:@"omzet6"] ?: @"",
               
               @"gaji_pokok" : [dictionary objectForKey:@"gajiPokok"] ?: @"",
               @"tunjangan_tetap" : [dictionary objectForKey:@"tunjanganPokok"] ?: @"",
               @"insentif" : [dictionary objectForKey:@"intensif"] ?: @"",
               @"lembur" : [dictionary objectForKey:@"lembur"] ?: @"",
               @"bonus" : [dictionary objectForKey:@"bonus"] ?: @"",
               @"total" : [dictionary objectForKey:@"total"] ?: @"",
               }];
            
        } else if (postType == DataMAPPostTypePasangan) {
            url = [NSString stringWithFormat:@"%@/datamap/update/pasangan", kApiUrl];
            
            [dataDictionary addEntriesFromDictionary:
             @{@"id_pengajuan" : [dictionary objectForKey:@"idPengajuan"] ?: @"",
               @"nama_pasangan_sesuai_ktp" : [dictionary objectForKey:@"namaLengkapSesuaiKTPPasangan"] ?: @"",
               }];
            
        } else if (postType == DataMAPPostTypePekerjaanPasangan) {
            url = [NSString stringWithFormat:@"%@/datamap/update/pasangan/pekerjaan", kApiUrl];
            
            [dataDictionary addEntriesFromDictionary:
             @{@"id_pengajuan" : [dictionary objectForKey:@"idPengajuan"] ?: @"",
               @"nama_perusahaan_pasangan" : [dictionary objectForKey:@"namaPerusahaanPasangan"] ?: @"",
               @"alamat_kantor_pasangan" : [dictionary objectForKey:@"alamatKantorPasangan"] ?: @"",
               @"alamat_kantor_pasangan_rt" : [dictionary objectForKey:@"rTKantorPasangan"] ?: @"",
               @"alamat_kantor_pasangan_rw" : [dictionary objectForKey:@"rWKantorPasangan"] ?: @"",
               @"alamat_kantor_pasangan_kode_pos" : [dictionary objectForKey:@"kodePosKantorPasangan"] ?: @"",
               @"alamat_kantor_pasangan_kelurahan" : [dictionary objectForKey:@"kelurahanKantorPasangan"] ?: @"",
               @"alamat_kantor_pasangan_kecamatan" : [dictionary objectForKey:@"kecamatanKantorPasangan"] ?: @"",
               @"alamat_kantor_pasangan_kota" : [dictionary objectForKey:@"kotaKantorPasangan"] ?: @"",
               }];
            
        } else if (postType == DataMAPPostTypeKeluarga) {
            url = [NSString stringWithFormat:@"%@/datamap/update/datakeluarga", kApiUrl];
            
            [dataDictionary addEntriesFromDictionary:
             @{@"id_pengajuan" : [dictionary objectForKey:@"idPengajuan"] ?: @"",
               }];
            
            NSMutableArray *families = [NSMutableArray array];
            for (id familyData in dictionary[@"dataKeluarga"]) {
                [families addObject:@{@"nama" : familyData[@"nama"],
                                      @"no_kk" : familyData[@"nomorIndukKependudukan"],
                                      @"tgl_lahir_keluarga" : familyData[@"tanggalLahir"],
                                      @"hubungan" : familyData[@"hubunganDenganPemohon"],
                                      }];
            }
            
            [dataDictionary setObject:families forKey:@"data_keluarga"];
            
        } else if (postType == DataMAPPostTypeStrukturPembiayaan) {
            url = [NSString stringWithFormat:@"%@/datamap/update/strukturpembiayaan", kApiUrl];
            
            [dataDictionary addEntriesFromDictionary:
             @{@"id_pengajuan" : [dictionary objectForKey:@"idPengajuan"] ?: @"",
               @"cara_pembayaran" : [dictionary objectForKey:@"caraPembiayaan"] ?: @"",
               @"jml_asset" : [dictionary objectForKey:@"jumlahAset"] ?: @"",
               @"pokok_hutang" : [dictionary objectForKey:@"pokokHutang"] ?: @"",
               @"subsidi_dp" : [dictionary objectForKey:@"subsidiUangMuka"] ?: @"",
               @"total_uang_diterima_mpmf" : [dictionary objectForKey:@"totalUangDiterimaMPMF"] ?: @"",
               @"biaya_admin" : [dictionary objectForKey:@"biayaAdmin"] ?: @"",
               @"biaya_admin_lain" : [dictionary objectForKey:@"biayaAdminLainnya"] ?: @"",
               @"biaya_fidusia" : [dictionary objectForKey:@"biayaFidusia"] ?: @"",
               @"biaya_lain" : [dictionary objectForKey:@"biayaLain"] ?: @"",
               @"biaya_survey" : [dictionary objectForKey:@"biayaSurvey"] ?: @"",
               @"persentase_biaya_provisi" : [dictionary objectForKey:@"persentaseBiayaProvisi"] ?: @"",
               @"biaya_notaris_prosentasi" : @"",
               @"biaya_provisi" : [dictionary objectForKey:@"biayaProvisi"] ?: @"",
               @"asuransi_kapitalisasi" : [dictionary objectForKey:@"asuransiKapitalisasi"] ?: @"",
               @"interest_type" : [dictionary objectForKey:@"interestType"] ?: @"",
               @"effective_rate" : [dictionary objectForKey:@"effectiveRate"] ?: @"",
               @"skema_angsuran" : [dictionary objectForKey:@"skemaAngsuran"] ?: @"",
               @"tipe_angsuran" : [dictionary objectForKey:@"tipeAngsuran"] ?: @"",
               @"sumber_dana" : [dictionary objectForKey:@"sumberDana"] ?: @"",
               @"jangka_waktu_pembiayaan" : [dictionary objectForKey:@"jangkaWaktuPembiayaan"] ?: @"",
               @"angsuran" : [dictionary objectForKey:@"angsuran"] ?: @"",
               @"uang_muka" : [dictionary objectForKey:@"totalBayarAwal"] ?: @"",
               @"harga_kendaraan" : [dictionary objectForKey:@"hargaKendaraan"] ?: @"",
               }];
            
        } else if (postType == DataMAPPostTypeAsuransi) {
            url = [NSString stringWithFormat:@"%@/datamap/update/asuransi", kApiUrl];
            
            [dataDictionary addEntriesFromDictionary:
             @{@"id_pengajuan" : [dictionary objectForKey:@"idPengajuan"] ?: @"",
               @"nama_asuransi" : [dictionary objectForKey:@"namaAsuransi"] ?: @"",
               @"asuransi_dibayar" : [dictionary objectForKey:@"asuransiDibayar"] ?: @"",
               @"jangka_waktu_asuransi" : [dictionary objectForKey:@"jangkaWaktuAsuransi"] ?: @"",
               @"periode_asuransi" : [dictionary objectForKey:@"periodeAsuransi"] ?: @"",
               @"nilai_pertanggungan" : [dictionary objectForKey:@"nilaiPertanggungan"] ?: @"",
               @"jenis_pertanggungan" : [dictionary objectForKey:@"jenisPertanggunganAllRisk"] ?: @"",
               @"jenis_pertanggungan_tlo" : [dictionary objectForKey:@"jenisPertanggunganTLO"] ?: @"",
               @"srcc" : [dictionary objectForKey:@"sRCC"] ?: @"",
               @"banjir" : [dictionary objectForKey:@"banjir"] ?: @"",
               @"gempa_bumi" : [dictionary objectForKey:@"gempaBumi"] ?: @"",
               @"tpl" : [dictionary objectForKey:@"tPL"] ?: @"",
               @"pa" : [dictionary objectForKey:@"pA"] ?: @"",
               @"asuransi_jiwa_kredit" : [dictionary objectForKey:@"asuransiJiwaKredit"] ?: @"",
               @"asuransi_jiwa_kapitalisasi" : [dictionary objectForKey:@"asuransiJiwaKreditKapitalisasi"] ?: @"",
               @"nilai_pertanggungan_asuransi" : [dictionary objectForKey:@"nilaiPertanggunganAsuransiJiwa"] ?: @"",
               @"premi_asuransi_kerugian_kendaraan" : [dictionary objectForKey:@"premiAsuransiKerugianKendaraan"] ?: @"",
               @"premi_asuransi_jiwa_kredit" : [dictionary objectForKey:@"premiAsuransiJiwaKredit"] ?: @"",
               @"perusahaan_asuransi_jiwa" : [dictionary objectForKey:@"perusahaanAsuransiJiwa"] ?: @"",
               @"tipe_asuransi" : [dictionary objectForKey:@"tipeAsuransi"] ?: @"",
               @"asuransi_kendaraan_kapitalisasi" : [dictionary objectForKey:@"asuransiKendaraanKapitalisasi"] ?: @"",
               @"asuransi_kendaraan_dp" : [dictionary objectForKey:@"asuransiKendaraanDibayarDimuka"] ?: @"",
               @"asuransi_jiwa_dp" : [dictionary objectForKey:@"asuransiJiwaDibayarDimuka"] ?: @"",
               @"jangka_waktu_asuransi" : [dictionary objectForKey:@"periodeAsuransiJiwa"] ?: @"",
               }];
            
        } else if (postType == DataMAPPostTypeAset) {
            url = [NSString stringWithFormat:@"%@/datamap/update/aset", kApiUrl];
            
            [dataDictionary addEntriesFromDictionary:
             @{@"id_pengajuan" : [dictionary objectForKey:@"idPengajuan"] ?: @"",
               @"nama_suplier" : [dictionary objectForKey:@"namaSupplier"] ?: @"",
               @"asset_financed" : [dictionary objectForKey:@"assetFinanced"] ?: @"",
               @"new_used" : [dictionary objectForKey:@"newUsed"] ?: @"",
               @"no_rangka" : [dictionary objectForKey:@"noRangka"] ?: @"",
               @"no_mesin" : [dictionary objectForKey:@"noMesin"] ?: @"",
               @"pemakaian_unit" : [dictionary objectForKey:@"pemakaianUnit"] ?: @"",
               @"silinder" : [dictionary objectForKey:@"silinder"] ?: @"",
               @"warna" : [dictionary objectForKey:@"warna"] ?: @"",
               @"no_polisi" : [dictionary objectForKey:@"nomorPolisi"] ?: @"",
               @"nama_bpkb" : [dictionary objectForKey:@"namaBPKB"] ?: @"",
               @"area_kendaraan" : [dictionary objectForKey:@"areaKendaraan"] ?: @"",
               }];
            
        } else if (postType == DataMAPPostTypeEmergencyContact) {
            url = [NSString stringWithFormat:@"%@/datamap/update/emergency", kApiUrl];
            
            [dataDictionary addEntriesFromDictionary:
             @{@"id_pengajuan" : [dictionary objectForKey:@"idPengajuan"] ?: @"",
               @"hubungan_dgn_pemohon" : [dictionary objectForKey:@"hubunganEconDenganPemohon"] ?: @"",
               }];
            
        } else if (postType == DataMAPPostTypePenjamin) {
            url = [NSString stringWithFormat:@"%@/datamap/update/penjamin", kApiUrl];
            
            [dataDictionary addEntriesFromDictionary:
             @{@"id_pengajuan" : [dictionary objectForKey:@"idPengajuan"] ?: @"",
               @"nama_penjamin" : [dictionary objectForKey:@"namaPenjamin"] ?: @"",
               @"hubungan_dgn_debitur" : [dictionary objectForKey:@"hubunganPenjaminDenganPemohon"] ?: @"",
               @"nama_pasangan_penjamin" : [dictionary objectForKey:@"namaPasanganPenjamin"] ?: @"",
               }];
            
        } else if (postType == DataMAPPostTypeMarketing) {
            url = [NSString stringWithFormat:@"%@/datamap/update/marketing", kApiUrl];
            
            [dataDictionary addEntriesFromDictionary:
             @{@"id_pengajuan" : [dictionary objectForKey:@"idPengajuan"] ?: @"",
               @"nama_branch_marketing" : [dictionary objectForKey:@"namaKepalaCabang"] ?: @"",
               @"nama_marketing" : [dictionary objectForKey:@"namaMarketing"] ?: @"",
               }];
            
        } else if (postType == DataMAPPostTypeRCA) {
            url = [NSString stringWithFormat:@"%@/datamap/update/rca", kApiUrl];
            
            [dataDictionary addEntriesFromDictionary:
             @{@"id_pengajuan" : [dictionary objectForKey:@"idPengajuan"] ?: @"",
               @"rca" : [dictionary objectForKey:@"rca"] ?: @"",
               }];
            
        }
        
        [param setObject:dataDictionary forKey:@"data"];
        
        [manager POST:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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

+ (void)postDataMAPWithID:(NSInteger)pengajuanId completion:(void(^)(NSDictionary *dictionary, NSError *error))block{
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithDictionary:
                                  @{@"userid" :[MPMUserInfo getUserInfo][@"userId"],
                                    @"token" : [MPMUserInfo getToken],
                                    @"data" : @{@"id_pengajuan" : @(pengajuanId)}
                                    }];
    @try {
        [manager POST:[NSString stringWithFormat:@"%@/datamap/submitmap", kApiUrl] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
