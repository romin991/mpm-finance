//
//  FormRow.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 5/17/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "FormRow.h"
#import <XLForm.h>
#import "FloatLabeledTextFieldCell.h"
#import "Option.h"
#import "NSString+MixedCasing.h"

//XLFormRowDescriptorTypeFloatLabeledTextField
//extern NSString *const XLFormRowDescriptorTypeAccount;
//extern NSString *const XLFormRowDescriptorTypeBooleanCheck;
//extern NSString *const XLFormRowDescriptorTypeBooleanSwitch;
//extern NSString *const XLFormRowDescriptorTypeButton;
//extern NSString *const XLFormRowDescriptorTypeCountDownTimer;
//extern NSString *const XLFormRowDescriptorTypeCountDownTimerInline;
//extern NSString *const XLFormRowDescriptorTypeDate;
//extern NSString *const XLFormRowDescriptorTypeDateInline;
//extern NSString *const XLFormRowDescriptorTypeDatePicker;
//extern NSString *const XLFormRowDescriptorTypeDateTime;
//extern NSString *const XLFormRowDescriptorTypeDateTimeInline;
//extern NSString *const XLFormRowDescriptorTypeDecimal;
//extern NSString *const XLFormRowDescriptorTypeEmail;
//extern NSString *const XLFormRowDescriptorTypeImage;
//extern NSString *const XLFormRowDescriptorTypeInfo;
//extern NSString *const XLFormRowDescriptorTypeInteger;
//extern NSString *const XLFormRowDescriptorTypeMultipleSelector;
//extern NSString *const XLFormRowDescriptorTypeMultipleSelectorPopover;
//extern NSString *const XLFormRowDescriptorTypeName;
//extern NSString *const XLFormRowDescriptorTypeNumber;
//extern NSString *const XLFormRowDescriptorTypePassword;
//extern NSString *const XLFormRowDescriptorTypePhone;
//extern NSString *const XLFormRowDescriptorTypePicker;
//extern NSString *const XLFormRowDescriptorTypeSelectorActionSheet;
//extern NSString *const XLFormRowDescriptorTypeSelectorAlertView;
//extern NSString *const XLFormRowDescriptorTypeSelectorLeftRight;
//extern NSString *const XLFormRowDescriptorTypeSelectorPickerView;
//extern NSString *const XLFormRowDescriptorTypeSelectorPickerViewInline;
//extern NSString *const XLFormRowDescriptorTypeSelectorPopover;
//extern NSString *const XLFormRowDescriptorTypeSelectorPush;
//extern NSString *const XLFormRowDescriptorTypeSelectorSegmentedControl;
//extern NSString *const XLFormRowDescriptorTypeSlider;
//extern NSString *const XLFormRowDescriptorTypeStepCounter;
//extern NSString *const XLFormRowDescriptorTypeText;
//extern NSString *const XLFormRowDescriptorTypeTextView;
//extern NSString *const XLFormRowDescriptorTypeTime;
//extern NSString *const XLFormRowDescriptorTypeTimeInline;
//extern NSString *const XLFormRowDescriptorTypeTwitter;
//extern NSString *const XLFormRowDescriptorTypeURL;
//extern NSString *const XLFormRowDescriptorTypeZipCode;

@implementation FormRow

+ (RLMResults *)getRowsWithCategoryNumber:(NSInteger)category{
    return [FormRow objectsWhere:@"category = %li", category];
}

+ (void)generateFields{
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    
    //Data Pemohon
    [FormRow new:realm :0 :0 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nama Calon Debitur"];
    [FormRow new:realm :0 :1 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"No KTP"];
    [FormRow new:realm :0 :2 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Tempat Lahir"];
    [FormRow new:realm :0 :3 :NO :XLFormRowDescriptorTypeDateInline :@"Tanggal Lahir"];
    [FormRow new:realm :0 :4 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Alamat Rumah Sesuai KTP"];
    [FormRow new:realm :1 :5 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nomor Telepon"];
    [FormRow new:realm :1 :6 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nomor Handphone"];
    [FormRow new:realm :1 :7 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Alamat Domisili"];
    [FormRow new:realm :1 :8 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Kode Pos Alamat Domisili"];
    [FormRow new:realm :1 :9 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nama Gadis Ibu Kandung"];
    
    //Data Pasangan
    [FormRow new:realm :1 :0 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nama Pasangan"];
    [FormRow new:realm :1 :1 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"No KTP"];
    [FormRow new:realm :1 :2 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Tempat Lahir"];
    [FormRow new:realm :1 :3 :NO :XLFormRowDescriptorTypeDateInline :@"Tanggal Lahir"];
    [FormRow new:realm :1 :4 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Alamat"];
    
    //Data Aset
    [FormRow new:realm :2 :0 :NO :XLFormRowDescriptorTypeSelectorPush :@"Tipe Produk" :2];
    [FormRow new:realm :2 :1 :NO :XLFormRowDescriptorTypeSelectorPush :@"Tipe Kendaraan"];
    [FormRow new:realm :2 :2 :NO :XLFormRowDescriptorTypeSelectorPush :@"Tahun Kendaraan"];
    
    //Struktur Pembiayaan
    [FormRow new:realm :3 :0 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Harga Perolehan"];
    [[FormRow new:realm :3 :1 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Uang Muka (DP)"] setKey:@"uangMuka"];
    [FormRow new:realm :3 :2 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Jangka Waktu Pembiayaan"];
    [FormRow new:realm :3 :3 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Angsuran"];
    
    //Data Pekerjaan
    [FormRow new:realm :4 :0 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nama Tempat Kerja"];
    [FormRow new:realm :4 :1 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nomor Telepon Tempat Kerja"];
    
    //Data E-con
    [FormRow new:realm :5 :0 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nama E-con"];
    [FormRow new:realm :5 :1 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nomor Telepon E-con"];
    [FormRow new:realm :5 :2 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Tambahan"];
    
    //MAP Data Aplikasi
    [FormRow new:realm :6 :0 :NO :XLFormRowDescriptorTypeSelectorPush :@"Sumber Aplikasi" :32];
    [FormRow new:realm :6 :1 :NO :XLFormRowDescriptorTypeSelectorPush :@"Tujuan Pembiayaan" :0];
    [FormRow new:realm :6 :2 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Kode Aplikasi"];
    [FormRow new:realm :6 :3 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Kode Cabang"];
    [FormRow new:realm :6 :4 :NO :XLFormRowDescriptorTypeDateInline :@"Tanggal Perjanjian"];
    [FormRow new:realm :6 :5 :NO :XLFormRowDescriptorTypeSelectorPush :@"Source of application" :1];
    [FormRow new:realm :6 :6 :NO :XLFormRowDescriptorTypeSelectorPush :@"Product" :2];
    [FormRow new:realm :6 :7 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Product Offering"];
    [FormRow new:realm :6 :8 :NO :XLFormRowDescriptorTypeSelectorPush :@"Jarak Tempuh" :3];
    [FormRow new:realm :6 :9 :NO :XLFormRowDescriptorTypeSelectorPush :@"Application Priority" :4];
    [FormRow new:realm :6 :10 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Kode Applikasi"];
    
    //Data Pribadi
    [FormRow new:realm :7 :0 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nama Lengkap"];
    [FormRow new:realm :7 :1 :NO :XLFormRowDescriptorTypeDateInline :@"KTP Berlaku Hingga"];
    [FormRow new:realm :7 :2 :NO :XLFormRowDescriptorTypeSelectorPush :@"Jenis Kelamin" :6];
    [FormRow new:realm :7 :3 :NO :XLFormRowDescriptorTypeSelectorPush :@"Agama" :7];
    [FormRow new:realm :7 :4 :NO :XLFormRowDescriptorTypeSelectorPush :@"Status" :12];
    [FormRow new:realm :7 :5 :NO :XLFormRowDescriptorTypeSelectorPush :@"Status Kepemilikan Rumah" :13];
    [FormRow new:realm :7 :6 :NO :XLFormRowDescriptorTypeDateInline :@"Tanggal Selesai Kontrak Rumah"];
    [FormRow new:realm :7 :7 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Lokasi Rumah" :14];
    [FormRow new:realm :7 :8 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Tahun Menempati"];
    [FormRow new:realm :7 :9 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nomor NPWP"];
    [FormRow new:realm :7 :10 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nomor Kartu Keluarga"];
    [FormRow new:realm :7 :11 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Jumlah Tanggunan"];
    [FormRow new:realm :7 :12 :NO :XLFormRowDescriptorTypeSelectorPush :@"Pendidikan Terakhir" :15];
    [FormRow new:realm :7 :13 :NO :XLFormRowDescriptorTypeSelectorPush :@"Alamat Pengiriman Surat" :16];
    [FormRow new:realm :7 :14 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Email"];
    
    //Data Pekerjaan
    [FormRow new:realm :8 :0 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Pekerjaan"];
    [FormRow new:realm :8 :1 :NO :XLFormRowDescriptorTypeSelectorPush :@"Jenis Pekerjaan" :17];
    [FormRow new:realm :8 :2 :NO :XLFormRowDescriptorTypeSelectorPush :@"Status Pekerjaan" :18];
    [FormRow new:realm :8 :3 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Bidang Usaha"];
    [FormRow new:realm :8 :4 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Posisi Jabatan"];
    [FormRow new:realm :8 :5 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Alamat Kantor"];
    [FormRow new:realm :8 :6 :NO :XLFormRowDescriptorTypeDateInline :@"Lama Bekerja Dari"];
    [FormRow new:realm :8 :7 :NO :XLFormRowDescriptorTypeDateInline :@"Sampai Dengan"];
    [FormRow new:realm :8 :8 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Pendapatan Perbulan"];
    [FormRow new:realm :8 :9 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Omzet Perbulan"];
    [FormRow new:realm :8 :10 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Gaji Pokok"];
    [FormRow new:realm :8 :11 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Tunjangan Tetap"];
    [FormRow new:realm :8 :12 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Insentif"];
    [FormRow new:realm :8 :13 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Lembur"];
    [FormRow new:realm :8 :14 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Bonus"];
    [FormRow new:realm :8 :15 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Pendapatan Pertahun"];
    [FormRow new:realm :8 :16 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nama Perusahaan"];
    
    //Kartu Kredit / Pinjaman Lain
    [FormRow new:realm :9 :0 :NO :XLFormRowDescriptorTypeSelectorPush :@"Pinjaman Tempat Lain" :19];
    [FormRow new:realm :9 :1 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nomor Kartu Kredit 1"];
    [FormRow new:realm :9 :2 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nomot Kartu Kredit 2"];
    
    //Data Pasangan
    [FormRow new:realm :10 :0 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nomor KTP"];
    [FormRow new:realm :10 :1 :NO :XLFormRowDescriptorTypeDateInline :@"KTP Berlaku Hingga"];
    [FormRow new:realm :10 :2 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Kewarganegaraan"];
    [[FormRow new:realm :10 :3 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Alamat (Sesuai Identitas)"] setKey:@"alamat"];
    
    //Data Pekerjaan Pasangan
    [FormRow new:realm :11 :0 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nama Perusahaan"];
    [FormRow new:realm :11 :1 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Alamat Kantor"];
    
    //Data Keluarga
    [FormRow new:realm :12 :0 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nama"];
    [FormRow new:realm :12 :1 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nomor KK"];
    [FormRow new:realm :12 :2 :NO :XLFormRowDescriptorTypeDateInline :@"Tanggal Lahir"];
    [FormRow new:realm :12 :3 :NO :XLFormRowDescriptorTypeSelectorPush :@"Hubungan" :20];
    [FormRow new:realm :12 :4 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nama Sekolah Anak"];
    [FormRow new:realm :12 :5 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Alamat Sekolah Anak"];
    
    //Struktur Pembiayaan
    [FormRow new:realm :13 :0 :NO :XLFormRowDescriptorTypeSelectorPush :@"Cara Pembayaran" :21];
    [FormRow new:realm :13 :1 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Jumlah Asset"];
    [FormRow new:realm :13 :2 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Pokok Hutang"];
    [FormRow new:realm :13 :3 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Subsidi DP"];
    [[FormRow new:realm :13 :4 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Total Uang Muka Diterima MPMF"] setKey:@"totalUangMuka"];
    [FormRow new:realm :13 :5 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Biaya Admin"];
    [FormRow new:realm :13 :6 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Biaya Admin Lainnya"];
    [FormRow new:realm :13 :7 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Biaya Fidusia"];
    [[FormRow new:realm :13 :8 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Biaya Notaris / Presentasi"] setKey:@"biayaNotaris"];
    [FormRow new:realm :13 :9 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Biaya Notaris"];
    [FormRow new:realm :13 :10 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Biaya Lain"];
    [FormRow new:realm :13 :11 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Biaya Survey"];
    [[FormRow new:realm :13 :12 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Biaya Provinsi / Presentasi Provinsi"] setKey:@"biayaProvinsi"];
    [FormRow new:realm :13 :13 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nilai Kapatalisasi"];
    [FormRow new:realm :13 :14 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Asuransi Kapatalisasi"];
    [FormRow new:realm :13 :15 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Flat Rate"];
    [FormRow new:realm :13 :16 :NO :XLFormRowDescriptorTypeSelectorPush :@"Interest Type" :22];
    [FormRow new:realm :13 :17 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Effective Rate"];
    [FormRow new:realm :13 :18 :NO :XLFormRowDescriptorTypeSelectorPush :@"Skema Angsuran" :33];
    [FormRow new:realm :13 :19 :NO :XLFormRowDescriptorTypeSelectorPush :@"Tipe Angsuran" :23];
    [FormRow new:realm :13 :20 :NO :XLFormRowDescriptorTypeSelectorPush :@"Sumber Dana" :24];
    
    //Asuransi
    [FormRow new:realm :14 :0 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nama Asuransi"];
    [FormRow new:realm :14 :1 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Cabang Asuransi"];
    [FormRow new:realm :14 :2 :NO :XLFormRowDescriptorTypeSelectorPush :@"Asuransi Dibayar" :26];
    [FormRow new:realm :14 :3 :NO :XLFormRowDescriptorTypeSelectorPush :@"Jangka Waktu Asuransi" :25];
    [FormRow new:realm :14 :4 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Periode Asuransi"];
    [FormRow new:realm :14 :5 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nilai Pertanggungan"];
    [FormRow new:realm :14 :6 :NO :XLFormRowDescriptorTypeSelectorPush :@"SRCC" :27];
    [FormRow new:realm :14 :7 :NO :XLFormRowDescriptorTypeSelectorPush :@"Banjir" :27];
    [FormRow new:realm :14 :8 :NO :XLFormRowDescriptorTypeSelectorPush :@"Gempar Bumi" :27];
    [FormRow new:realm :14 :9 :NO :XLFormRowDescriptorTypeSelectorPush :@"TPL" :27];
    [FormRow new:realm :14 :10 :NO :XLFormRowDescriptorTypeSelectorPush :@"PA" :27];
    [FormRow new:realm :14 :11 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"TPL Amount"];
    [FormRow new:realm :14 :12 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"PA Amount"];
    [FormRow new:realm :14 :13 :NO :XLFormRowDescriptorTypeSelectorPush :@"Asuransi Jiwa Kredit" :27];
    [FormRow new:realm :14 :14 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Asuransi Jiwa Kredit Kapatalisasi"];
    [FormRow new:realm :14 :15 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nilai Pertanggungan Asuransi Jiwa"];
    [FormRow new:realm :14 :16 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Premi Asuransi Kerugian Kendaraan"];
    [FormRow new:realm :14 :17 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Premi Asuransi Jiwa Kredit"];
    [FormRow new:realm :14 :18 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Perusahaan Asuransi Jiwa"];
    [FormRow new:realm :14 :19 :NO :XLFormRowDescriptorTypeSelectorPush :@"Tipe Asuransi" :8];
    [FormRow new:realm :14 :20 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Periode Asuransi Jiwa"];
    
    //Data Aset
    [FormRow new:realm :15 :0 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nama Supplier"];
    [FormRow new:realm :15 :1 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Asset Financed"];
    [FormRow new:realm :15 :2 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Merk"];
    [FormRow new:realm :15 :3 :NO :XLFormRowDescriptorTypeSelectorPush :@"New / Used" :9];
    [FormRow new:realm :15 :4 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"No Rangka"];
    [FormRow new:realm :15 :5 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"No Mesin"];
    [FormRow new:realm :15 :6 :NO :XLFormRowDescriptorTypeSelectorPush :@"Pemakaian Unit" :10];
    [FormRow new:realm :15 :7 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Silinder"];
    [FormRow new:realm :15 :8 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Warna"];
    [FormRow new:realm :15 :9 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nomor Polisi"];
    [FormRow new:realm :15 :10 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nama BPKP"];
    [FormRow new:realm :15 :11 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Area Kendaraan" :11];
    
    //Data Econ
    [FormRow new:realm :16 :0 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Hubungan dengan Pemohon"];
    
    //MAP Penjamin
    [FormRow new:realm :17 :0 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nama Penjamin"];
    [FormRow new:realm :17 :1 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Hubungan dengan Debitur"];
    [FormRow new:realm :17 :2 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nama Pasangan Penjamin"];
    
    //Data Marketing
    [FormRow new:realm :18 :0 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nama Branch Manager"];
    [FormRow new:realm :18 :1 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nama Marketing"];
    
    [FormRow generateCreditSimulationFieldsWithRealm:realm];
    [FormRow generateListSurveyWithRealm:realm];
    [realm commitWriteTransaction];
}

+ (void)generateListSurveyWithRealm:(RLMRealm *)realm{
    [FormRow new:realm :19 :0 :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nama Calon Debitur"];
    [FormRow new:realm :19 :1 :YES :XLFormRowDescriptorTypeDateInline :@"Tanggal Survey"];
    [FormRow new:realm :19 :2 :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nama Surveyor"];
    [FormRow new:realm :19 :3 :YES :XLFormRowDescriptorTypeSelectorPush :@"Alamat Survey Ditemukan" :27];
    [FormRow new:realm :19 :4 :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"Penjelasan"];
    [FormRow new:realm :19 :5 :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nama"];
    [FormRow new:realm :19 :6 :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"Hubungan"];
    [FormRow new:realm :19 :7 :YES :XLFormRowDescriptorTypeSelectorPush :@"Kebenaran Domisili" :27];
    [FormRow new:realm :19 :8 :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"Penjelasan"];
    [FormRow new:realm :19 :9 :YES :XLFormRowDescriptorTypeSelectorPush :@"Status Kepemilikan Rumah" :13];
    [FormRow new:realm :19 :10 :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"Lama Tinggal"];
    [[FormRow new:realm :19 :11 :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"Jumlah orang yang tinggal serumah"] setKey:@"jumlahOrang"];
    [FormRow new:realm :19 :12 :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"Tambahan"];
    [FormRow new:realm :19 :13 :YES :XLFormRowDescriptorTypeSelectorPush :@"Jumlah Lantai Rumah" :34];
    [FormRow new:realm :19 :14 :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"Fasilitas Rumah"];
    [FormRow new:realm :19 :15 :YES :XLFormRowDescriptorTypeSelectorPush :@"Akses Jalan Masuk" :14];
    [FormRow new:realm :19 :16 :YES :XLFormRowDescriptorTypeSelectorPush :@"Kepemilikan Garasi" : 27];
    [FormRow new:realm :19 :17 :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"Harga"];
    [FormRow new:realm :19 :18 :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"Keterangan Lain"];
    
}

+ (void)generateCalculatorMarketing{
//    [FormRow new:realm :20 :0 :YES :XLFormRowDescriptorType :@"Vehicle Type"];
//    [FormRow new:realm :20 :1 :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"Keterangan Lain"];
}

+ (void)generateCreditSimulationFieldsWithRealm:(RLMRealm*)realm{
    [FormRow new:realm :9 :0 :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"Harga"];
    [FormRow new:realm :9 :1 :YES :XLFormRowDescriptorTypeSelectorPush :@"Lama Pembiayaan" :31];
    [[FormRow new:realm :9 :2 :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nilai Pembiayaan"] setDisabled:YES];
    [[FormRow new:realm :9 :3 :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"Angsuran"] setDisabled:YES];
}

+ (FormRow *)new:(RLMRealm *)realm :(NSInteger)category :(NSInteger)sort :(BOOL)required :(NSString *)type :(NSString *)title{
    return [FormRow new:realm :category :sort :required :NO :type :title :nil :-1];
}

+ (FormRow *)new:(RLMRealm *)realm :(NSInteger)category :(NSInteger)sort :(BOOL)required :(NSString *)type :(NSString *)title :(NSInteger)optionCategory{
    return [FormRow new:realm :category :sort :required :NO :type :title :nil :optionCategory];
}

+ (FormRow *)new:(RLMRealm *)realm :(NSInteger)category :(NSInteger)sort :(BOOL)required :(BOOL)disabled :(NSString *)type :(NSString *)title :(NSString *)key :(NSInteger)optionCategory{
    FormRow *row = [[FormRow alloc] init];
    row.title = title;
    row.type = type;
    row.sort = sort;
    row.category = category;
    row.required = required;
    row.disabled = disabled;
    row.key = (key.length == 0) ? [title camelCased] : [key camelCased];
    if (optionCategory >= 0) {
        RLMResults *options = [Option getOptionWithCategoryNumber:optionCategory];
        [row.options addObjects:options];
    }
    
    [realm addObject:row];
    
    return row;
}

@end
