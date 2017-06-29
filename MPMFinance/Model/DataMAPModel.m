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
    
    [manager POST:[NSString stringWithFormat:@"%@/datamap/detail",kApiUrl] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"statusCode"] isEqual:@200]) {
            NSDictionary *data = responseObject[@"data"];
            NSDictionary *dictionary;
            @try {
                dictionary = @{@"agama" : data[@"agama"],
                               @"alamatKantor" : data[@"alamat_kantor"],
                               @"alamatKantorKecamatan" : data[@"alamat_kantor_kecamatan"],
                               @"alamatKantorKelurahan" : data[@"alamat_kantor_kelurahan"],
                               @"alamatKantorKodePos" : data[@"alamat_kantor_kode_pos"],
                               @"alamatKantorKodeKota" : data[@"alamat_kantor_kota"],
                               @"alamatKantorPasangan" : data[@"alamat_kantor_pasangan"],
                               @"alamatKantorPasanganKecamatan" : data[@"alamat_kantor_pasangan_kecamatan"],
                               @"alamatKantorPasanganKelurahan" : data[@"alamat_kantor_pasangan_kelurahan"],
                               @"alamatKantorPasanganKodePos" : data[@"alamat_kantor_pasangan_kode_pos"],
                               @"alamatKantorPasanganKota" : data[@"alamat_kantor_pasangan_kota"],
                               @"alamatKantorPasanganRt" : data[@"alamat_kantor_pasangan_rt"],
                               @"alamatKantorPasanganRw" : data[@"alamat_kantor_pasangan_rw"],
                               @"alamatKantorRt" : data[@"alamat_kantor_rt"],
                               @"alamatKantorRw" : data[@"alamat_kantor_rw"],
                               @"alamatKtp" : data[@"alamat_ktp"],
                               @"alamatPengirimanSurat" : data[@"alamat_pengiriman_surat"],
                               @"appPriority" : data[@"app_priority"],
                               @"areaKendaraan" : data[@"area_kendaraan"],
                               @"assetFinanced" : data[@"asset_financed"],
                               @"asuransiDibayar" : data[@"asuransi_dibayar"],
                               @"asuransiJiwaKapitalisasi" : data[@"asuransi_jiwa_kapitalisasi"],
                               @"asuransiJiwaKredit" : data[@"asuransi_jiwa_kredit"],
                               @"asuransiKapitalisasi" : data[@"asuransi_kapitalisasi"],
                               
                               @"banjir" : data[@"banjir"],
                               @"berlakuHingga" : data[@"berlaku_hingga"],
                               @"biayaAdmin" : data[@"biaya_admin"],
                               @"biayaAdminLain" : data[@"biaya_admin_lain"],
                               @"biayaFidusia" : data[@"biaya_fidusia"],
                               @"biayaLain" : data[@"biaya_lain"],
                               @"biayaNotaris" : data[@"biaya_notaris"],
                               @"biayaNotarisProsentasi" : data[@"biaya_notaris_prosentasi"],
                               @"biayaProvisi" : data[@"biaya_provisi"],
                               @"biayaSurvey" : data[@"biaya_survey"],
                               @"bidangUsaha" : data[@"bidang_usaha"],
                               @"bonus" : data[@"bonus"],
                               @"cabangAsuransi" : data[@"cabang_asuransi"],
                               @"caraPembayaran" : data[@"cara_pembayaran"],
                               
                               @"daerah" : data[@"daerah"],
                               @"dataKeluarga" : data[@"data_keluarga"],
                               @"effectiveRate" : data[@"effective_rate"],
                               @"email" : data[@"email"],
                               @"flatRate" : data[@"flat_rate"],
                               @"gajiPokok" : data[@"gaji_pokok"],
                               @"gempaBumi" : data[@"gempa_bumi"],
                               @"hubunganDgnDebitur" : data[@"hubungan_dgn_debitur"],
                               @"hubunganDgnPemohon" : data[@"hubungan_dgn_pemohon"],
                               @"id" : data[@"id"],
                               @"idPengajuan" : data[@"id_pengajuan"],
                               @"insentif" : data[@"insentif"],
                               @"interestType" : data[@"interest_type"],
                               @"jangkaWaktuAsuransi" : data[@"jangka_waktu_asuransi"],
                               @"jarakTempuh" : data[@"jarak_tempuh"],
                               @"jenisPertanggungan" : data[@"jenis_pertanggungan"],
                               @"jenisPertanggunganTlo" : data[@"jenis_pertanggungan_tlo"],
                               @"jmlAsset" : data[@"jml_asset"],
                               @"jmlTanggungan" : data[@"jml_tanggungan"],
                               @"jnsKelamin" : data[@"jns_kelamin"],
                               @"jnsPekerjaan" : data[@"jns_pekerjaan"],
                               @"kewarganegaraaanPasangan" : data[@"kewarganegaraaan_pasangan"],
                               @"kewarganegaraan" : data[@"kewarganegaraan"],
                               @"kodeAplikasi" : data[@"kode_aplikasi"],
                               @"kodeCabang" : data[@"kode_cabang"],
                               @"ktpBerlaku" : data[@"ktp_berlaku"],
                               @"lamaBekerja" : data[@"lama_bekerja"],
                               @"lamaBekerjaSebelumnya" : data[@"lama_bekerja_sebelumnya"],
                               
                               @"lembur" : data[@"lembur"],
                               @"lokasiRumah" : data[@"lokasi_rumah"],
                               @"merek" : data[@"merek"],
                               @"namaAsuransi" : data[@"nama_asuransi"],
                               @"namaBpkb" : data[@"nama_bpkb"],
                               @"namaBranchMarketing" : data[@"nama_branch_marketing"],
                               @"namaLengkap" : data[@"nama_lengkap"],
                               @"namaMarketing" : data[@"nama_marketing"],
                               @"namaPasanganPenjamin" : data[@"nama_pasangan_penjamin"],
                               @"namaPenjamin" : data[@"nama_penjamin"],
                               @"namaPerusahaan" : data[@"nama_perusahaan"],
                               @"namaPerusahaanPasangan" : data[@"nama_perusahaan_pasangan"],
                               @"namaSuplier" : data[@"nama_suplier"],
                               @"newUsed" : data[@"new_used"],
                               @"nilaiKapitalisasi" : data[@"nilai_kapitalisasi"],
                               @"nilaiPertanggungan" : data[@"nilai_pertanggungan"],
                               @"nilaiPertanggunganAsuransi" : data[@"nilai_pertanggungan_asuransi"],
                               @"noCc1" : data[@"no_cc_1"],
                               @"noCc2" : data[@"no_cc_2"],
                               @"noKk" : data[@"no_kk"],
                               @"noKtpPasangan" : data[@"no_ktp_pasangan"],
                               @"noMesin" : data[@"no_mesin"],
                               @"noNpwp" : data[@"no_npwp"],
                               @"noPolisi" : data[@"no_polisi"],
                               @"noRangka" : data[@"no_rangka"],
                               @"noTicketSales" : data[@"no_ticketsales"],
                               @"omsetPerBulan" : data[@"omset_per_bulan"],
                               @"omsetPerBulan2" : data[@"omset_per_bulan_2"],
                               @"omsetPerBulan3" : data[@"omset_per_bulan_3"],
                               @"omsetPerBulan4" : data[@"omset_per_bulan_4"],
                               @"omsetPerBulan5" : data[@"omset_per_bulan_5"],
                               @"omsetPerBulan6" : data[@"omset_per_bulan_6"],
                               
                               @"omsetPerBulanBln" : data[@"omset_per_bulan_bln"],
                               @"omsetPerBulanBln2" : data[@"omset_per_bulan_bln_2"],
                               @"omsetPerBulanBln3" : data[@"omset_per_bulan_bln_3"],
                               @"omsetPerBulanBln4" : data[@"omset_per_bulan_bln_4"],
                               @"omsetPerBulanBln5" : data[@"omset_per_bulan_bln_5"],
                               @"omsetPerBulanBln6" : data[@"omset_per_bulan_bln_6"],
                               @"omsetPerBulanThn" : data[@"omset_per_bulan_thn"],
                               @"omsetPerBulanThn2" : data[@"omset_per_bulan_thn_2"],
                               @"omsetPerBulanThn3" : data[@"omset_per_bulan_thn_3"],
                               @"omsetPerBulanThn4" : data[@"omset_per_bulan_thn_4"],
                               @"omsetPerBulanThn5" : data[@"omset_per_bulan_thn_5"],
                               @"omsetPerBulanThn6" : data[@"omset_per_bulan_thn_6"],
                               @"pa" : data[@"pa"],
                               @"paAmmount" : data[@"pa_ammount"],
                               @"pekerjaan" : data[@"pekerjaan"],
                               @"pemakaianUnit" : data[@"pemakaian_unit"],
                               @"pendapatanLainPerBulan" : data[@"pendapatan_lain_per_bulan"],
                               @"pendapatanPerTahun" : data[@"pendapatan_per_tahun"],
                               @"pendidikanTerakhir" : data[@"pendidikan_terakhir"],
                               @"periodeAsuransi" : data[@"periode_asuransi"],
                               @"periodeAsuransiJiwa" : data[@"periode_asuransi_jiwa"],
                               @"perusahaanAsuransiJiwa" : data[@"perusahaan_asuransi_jiwa"],
                               @"pinjamanLain" : data[@"pinjaman_lain"],
                               @"pinjamanLain2" : data[@"pinjaman_lain_2"],
                               @"pokokHutang" : data[@"pokok_hutang"],
                               @"posisiJabatan" : data[@"posisi_jabatan"],
                               @"premiAsuransiJiwaKredit" : data[@"premi_asuransi_jiwa_kredit"],
                               @"premiAsuransiKerugianKendaraan" : data[@"premi_asuransi_kerugian_kendaraan"],
                               @"product" : data[@"product"],
                               @"productOffering" : data[@"product_offering"],
                               @"silinder" : data[@"silinder"],
                               @"skemaAngsuran" : data[@"skema_angsuran"],
                               
                               @"srcOfApp" : data[@"src_of_app"],
                               @"srcc" : data[@"srcc"],
                               @"statusGrouping" : data[@"status_grouping"],
                               @"statusPekerjaan" : data[@"status_pekerjaan"],
                               @"statusPekerjaanSebelumnya" : data[@"status_pekerjaan_sebelumnya"],
                               @"statusPernikahan" : data[@"status_pernikahan"],
                               @"statusRmh" : data[@"status_rmh"],
                               @"subsidiDp" : data[@"subsidi_dp"],
                               @"sumberAplikasi" : data[@"sumber_aplikasi"],
                               @"sumberDana" : data[@"sumber_dana"],
                               @"tahunMenempati" : data[@"tahun_menempati"],
                               @"tglPerjanjian" : data[@"tgl_perjanjian"],
                               @"tglSelesaiKontrakRmh" : data[@"tgl_selesai_kontrak_rmh"],
                               @"tipeAngsuran" : data[@"tipe_angsuran"],
                               @"tipeAsuransi" : data[@"tipe_asuransi"],
                               @"total" : data[@"total"],
                               @"totalUangDiterimaMpmf" : data[@"total_uang_diterima_mpmf"],
                               @"tpl" : data[@"tpl"],
                               @"tplAmmount" : data[@"tpl_ammount"],
                               @"tujuanPembiayaan" : data[@"tujuan_pembiayaan"],
                               @"tunjanganTetap" : data[@"tunjangan_tetap"],
                               @"warna" : data[@"warna"]
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

+ (void)postDataMAPWithList:(List *)list dictionary:(NSDictionary *)dictionary completion:(void(^)(NSDictionary *dictionary, NSError *error))block{
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithDictionary:
                                  @{@"userid" :[MPMUserInfo getUserInfo][@"userId"],
                                    @"token" : [MPMUserInfo getToken]}];
    
    //try catch??
    NSMutableDictionary *dataDictionary = [NSMutableDictionary dictionary];
//    [dataDictionary setObject:[dictionary objectForKey:@"kodeCabang"] forKey:@"kodeCabang"];
//    [dataDictionary setObject:[dictionary objectForKey:@"namaCalonDebitur"] forKey:@"namaCalon"];
//    [dataDictionary setObject:[dictionary objectForKey:@"noKTP"] forKey:@"noKtp"];
//    [dataDictionary setObject:[dictionary objectForKey:@"tempatLahir"] forKey:@"tmpLahir"];
//    [dataDictionary setObject:[dictionary objectForKey:@"tanggalLahir"] forKey:@"tglLahir"];
//    [dataDictionary setObject:[dictionary objectForKey:@"alamatRumahSesuaiKTP"] forKey:@"alamatLegal"];
//    [dataDictionary setObject:[dictionary objectForKey:@"nomorHandphone"] forKey:@"handphone"];
//    [dataDictionary setObject:[dictionary objectForKey:@"nomorTelepon"] forKey:@"noTlp"];
//    [dataDictionary setObject:[dictionary objectForKey:@"alamatDomisili"] forKey:@"alamatDomisili"];
//    [dataDictionary setObject:[dictionary objectForKey:@"kodePosAlamatDomisili"] forKey:@"kodePosAlamatCalon"];
//    [dataDictionary setObject:[dictionary objectForKey:@"namaGadisIbuKandung"] forKey:@"namaIbuKandung"];
//    
//    [dataDictionary setObject:[dictionary objectForKey:@"namaPasangan"] forKey:@"namaPasangan"];
//    [dataDictionary setObject:[dictionary objectForKey:@"noKTPPasangan"] forKey:@"ktpPasangan"];
//    [dataDictionary setObject:[dictionary objectForKey:@"tempatLahirPasangan"] forKey:@"tmpLahirPasangan"];
//    [dataDictionary setObject:[dictionary objectForKey:@"tanggalLahirPasangan"] forKey:@"tglLahirPasangan"];
//    [dataDictionary setObject:[dictionary objectForKey:@"alamatPasangan"] forKey:@"alamatLegalPasangan"];
//    [dataDictionary setObject:[dictionary objectForKey:@"nomorTeleponPasangan"] forKey:@"noTlpPasangan"];
//    [dataDictionary setObject:[dictionary objectForKey:@"namaGadisIbuKandungPasangan"] forKey:@"namaIbuKandungPasangan"];
//    
//    [dataDictionary setObject:[dictionary objectForKey:@"tipeProduk"] forKey:@"tipeProduk"];
//    [dataDictionary setObject:[dictionary objectForKey:@"tipeKendaraan"] forKey:@"tipeKendaraan"];
//    [dataDictionary setObject:[dictionary objectForKey:@"tahunKendaraan"] forKey:@"tahunKendaraan"];
//    
//    [dataDictionary setObject:[dictionary objectForKey:@"hargaPerolehan"] forKey:@"hargaPerolehan"];
//    [dataDictionary setObject:[dictionary objectForKey:@"uangMuka"] forKey:@"uangMuka"];
//    [dataDictionary setObject:[dictionary objectForKey:@"jangkaWaktuPembiayaan"] forKey:@"tenor"];
//    [dataDictionary setObject:[dictionary objectForKey:@"angsuran"] forKey:@"angsuran"];
//    
//    [dataDictionary setObject:[dictionary objectForKey:@"namaTempatKerja"] forKey:@"namaTmpKerja"];
//    [dataDictionary setObject:[dictionary objectForKey:@"nomorTeleponTempatKerja"] forKey:@"tlpTmpKerja"];
//    
//    [dataDictionary setObject:[dictionary objectForKey:@"namaE-con"] forKey:@"namaEcon"];
//    [dataDictionary setObject:[dictionary objectForKey:@"nomorTeleponE-con"] forKey:@"noTlpEcon"];
    
    NSString *url = @"submitmap";
    if (list){
        [dataDictionary setObject:@(list.primaryKey) forKey:@"id_pengajuan"];
        url = @"update";
    }
    
    [param setObject:dataDictionary forKey:@"data"];
    
    [manager POST:[NSString stringWithFormat:@"%@/datamap/%@", kApiUrl, url] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"statusCode"] isEqual:@200]) {
            if (block) block(responseObject, nil);
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
