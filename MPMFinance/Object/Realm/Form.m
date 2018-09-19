//
//  Form.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 5/14/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "Form.h"
#import <XLForm.h>
#import "FloatLabeledTextFieldCell.h"
#import "UploadPhotoTableViewCell.h"
#import "RedzoneTableViewCell.h"

@implementation Form

+ (RLMResults *)getFormForMenu:(NSString *)primaryKey{
    return [[Form objectsWhere:@"ANY menus.primaryKey = %@", primaryKey] sortedResultsUsingKeyPath:@"sort" ascending:YES];
}

+ (RLMResults *)getFormForMenu:(NSString *)primaryKey role:(NSString *)role{
    return [[Form objectsWhere:@"ANY menus.primaryKey = %@ AND ANY roles.name = %@ ", primaryKey, role] sortedResultsUsingKeyPath:@"sort" ascending:YES];
}

#pragma mark - Populate Data
+ (void)generateForms{
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    
//=====================================================================================================
    Form *form = [[Form alloc] init];
    form.title = @"Data Pemohon";
    form.sort = 0;
    
    //===
    FormSection *section = [[FormSection alloc] init];
//    section.title = @"Pilih Cabang";
//    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Cabang" :@"" :@"getAllCabang"]];
//
//    [form.sections addObject:section];
    
    //===
    section = [[FormSection alloc] init];
    section.title = @"Data Pemohon";
    [section.rows addObject:[FormRow new:realm :1 :YES :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nomor KTP*" :@"noKTP" :@"" regex:MPMRegexValidationNumberOnly message:@"No KTP must be number"]];
    [section.rows addObject:[FormRow new:realm :2 :YES :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nama Lengkap Sesuai KTP*" :@"namaLengkap" :@""]];
    [section.rows addObject:[FormRow new:realm :3 :YES :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"Tempat Lahir*" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :4 :YES :YES :XLFormRowDescriptorTypeDateInline :@"Tanggal Lahir*" :@"" :@""]];
    
    [section.rows addObject:[FormRow new:realm :5 :YES :YES :XLFormRowDescriptorTypeSelectorPush :@"Jenis Kelamin" :@"" :@"getJenisKelamin"]];
    
    [form.sections addObject:section];
    
    //===
    section = [[FormSection alloc] init];
    section.title = @"Alamat KTP";
    [section.rows addObject:[FormRow new:realm :5 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Alamat Rumah Sesuai KTP*" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :6 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"RT Sesuai KTP*" :@"" :@"" regex:MPMRegexValidationNumberOnly message:@"RT requires only number"]];
    [section.rows addObject:[FormRow new:realm :7 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"RW Sesuai KTP*" :@"" :@"" regex:MPMRegexValidationNumberOnly message:@"RW requires only number"]];
    [section.rows addObject:[FormRow new:realm :8 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Kelurahan Sesuai KTP*" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :9 :YES :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"Kecamatan Sesuai KTP*" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :10 :YES :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"Kota Sesuai KTP*" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :11 :YES :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"Kodepos Sesuai KTP*" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :12 :YES :NO :XLFormRowDescriptorTypeDateInline :@"Masa Berlaku KTP*" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :13 :YES :YES :XLFormRowDescriptorTypeSelectorPush :@"Kewarganegaraan" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :14 :NO :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Kode Area" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :15 :NO :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nomor Telepon" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :16 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nomor Handphone*" :@"" :@""]];
    
    [form.sections addObject:section];
    
    //===
    section = [[FormSection alloc] init];
    section.title = @"Alamat Domisili";
    [section.rows addObject:[FormRow new:realm :15 :NO :NO :XLFormRowDescriptorTypeBooleanCheck :@"Sama dengan alamat legal" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :16 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Alamat Domisili*" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :17 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"RT Domisili*" :@"" :@"" regex:MPMRegexValidationNumberOnly message:@"RT Domisili requires only number"]];
    [section.rows addObject:[FormRow new:realm :18 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"RW Domisili*" :@"" :@""
                             regex:MPMRegexValidationNumberOnly message:@"RW Domisili requires only number"]];
    [section.rows addObject:[FormRow new:realm :19 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Kelurahan Domisili*" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :20 :YES :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"Kecamatan Domisili*" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :21 :YES :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"Kota Domisili*" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :22 :YES :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"Kodepos Domisili*" :@"" :@""]];
    
    [form.sections addObject:section];
    
    //===
    section = [[FormSection alloc] init];
    section.title = @"Other";
    [section.rows addObject:[FormRow new:realm :23 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nama Gadis Ibu Kandung*" :@"" :@""]];
    
    [form.sections addObject:section];
    
    //===
    section = [[FormSection alloc] init];
    section.title = @"Submit";
    [section.rows addObject:[FormRow new:realm :24 :NO :NO :XLFormRowDescriptorTypeButton :@"Next" :@"" :@""]];
    
    [form.sections addObject:section];
    
    //===
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuFormPengajuanApplikasi]];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuListOnlineSubmission]];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
    
    [form.roles addObject:[Role objectForPrimaryKey:kRoleAgent]];
    [form.roles addObject:[Role objectForPrimaryKey:kRoleDealer]];
    [form.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [form.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [form.roles addObject:[Role objectForPrimaryKey:kRoleOfficer]];
    
    [realm addObject:form];
    
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Data Pasangan";
    form.sort = 10;
    
    //===
    section = [[FormSection alloc] init];
    section.title = @"Data Pasangan";
    [section.rows addObject:[FormRow new:realm :0 :NO :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nomor Identitas" :@"noKTPPasangan" :@""]];
    [section.rows addObject:[FormRow new:realm :1 :NO :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nama Lengkap Sesuai Identitas" :@"namaLengkapPasangan" :@"" regex:MPMRegexValidationAlphabetOnly message:@"Nama Lengkap Pasangan can only contains alphabets"]];
    [section.rows addObject:[FormRow new:realm :2 :NO :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nomor Handphone Pasangan" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :4 :NO :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Tempat Lahir Pasangan" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :5 :NO :NO :XLFormRowDescriptorTypeDateInline:@"Tanggal Lahir Pasangan" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :6 :NO :NO :XLFormRowDescriptorTypeSelectorPush :@"Jenis Kelamin Pasangan" :@"" :@"getJenisKelamin"]];
    [section.rows addObject:[FormRow new:realm :7 :NO :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Alamat Pasangan" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :7 :NO :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"RT Pasangan" :@"" :@"" regex:MPMRegexValidationNumberOnly message:@"RT Pasangan requires only number"]];
    [section.rows addObject:[FormRow new:realm :7 :NO :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"RW Pasangan" :@"" :@"" regex:MPMRegexValidationNumberOnly message:@"RW Pasangan requires only number"]];
    [section.rows addObject:[FormRow new:realm :7 :NO :NO :XLFormRowDescriptorTypeSelectorPush :@"Kelurahan Pasangan" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :7 :NO :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"Kecamatan Pasangan" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :7 :NO :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"Kota Pasangan" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :7 :NO :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"Kode Pos Pasangan" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :7 :NO :NO :XLFormRowDescriptorTypeDateInline :@"Masa Berlaku KTP Pasangan" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :7 :NO :NO :XLFormRowDescriptorTypeSelectorPush :@"Kewarganegaraan Pasangan" :@"" :@""]];
//    [section.rows addObject:[FormRow new:realm :23 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nama Gadis Ibu Kandung Pasangan" :@"" :@""]];
    
    [form.sections addObject:section];
    //===
    section = [[FormSection alloc] init];
    section.title = @"Submit";
    [section.rows addObject:[FormRow new:realm :2 :NO :NO :XLFormRowDescriptorTypeButton :@"Next" :@"" :@""]];
    
    [form.sections addObject:section];
    
    //===
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuFormPengajuanApplikasi]];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuListOnlineSubmission]];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
    
    [form.roles addObject:[Role objectForPrimaryKey:kRoleDealer]];
    [form.roles addObject:[Role objectForPrimaryKey:kRoleAgent]];
    [form.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [form.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [form.roles addObject:[Role objectForPrimaryKey:kRoleOfficer]];
    
    [realm addObject:form];

//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Data Aset";
    form.sort = 20;
    
    //===
    section = [[FormSection alloc] init];
    section.title = @"Data Asset";
    
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Tipe Produk*" :@"" :@"getProduct"]];
    [section.rows addObject:[FormRow new:realm :1 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Tipe Kendaraan*" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :2 :NO :NO :XLFormRowDescriptorTypeSelectorPush :@"Tahun Kendaraan*" :@"" :@""]];
    
    [form.sections addObject:section];
    
    //===
    section = [[FormSection alloc] init];
    section.title = @"Submit";
    [section.rows addObject:[FormRow new:realm :3 :NO :NO :XLFormRowDescriptorTypeButton :@"Next" :@"" :@""]];
    
    [form.sections addObject:section];
    
    //===
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuFormPengajuanApplikasi]];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuListOnlineSubmission]];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
    
    [form.roles addObject:[Role objectForPrimaryKey:kRoleDealer]];
    [form.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [form.roles addObject:[Role objectForPrimaryKey:kRoleAgent]];
    [form.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [form.roles addObject:[Role objectForPrimaryKey:kRoleOfficer]];
    
    [realm addObject:form];
    
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Data Pekerjaan";
    form.sort = 40;
    
    //===
    section = [[FormSection alloc] init];
    section.title = @"Data Pekerjaan";
    [section.rows addObject:[FormRow new:realm :0 :NO :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nama Tempat Kerja" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :1 :NO :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Kode Area Telepon Tempat Kerja" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :2 :NO :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nomor Telepon Tempat Kerja" :@"" :@""]];
    
    [form.sections addObject:section];
    
    //===
    section = [[FormSection alloc] init];
    section.title = @"Submit";
    [section.rows addObject:[FormRow new:realm :3 :NO :NO :XLFormRowDescriptorTypeButton :@"Next" :@"" :@""]];
    
    [form.sections addObject:section];
    
    //===
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuFormPengajuanApplikasi]];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuListOnlineSubmission]];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
    
    [form.roles addObject:[Role objectForPrimaryKey:kRoleDealer]];
    [form.roles addObject:[Role objectForPrimaryKey:kRoleAgent]];
    [form.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [form.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [form.roles addObject:[Role objectForPrimaryKey:kRoleOfficer]];
    
    [realm addObject:form];
    
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Data Emergency Contact";
    form.sort = 50;
   
    //===
    section = [[FormSection alloc] init];
    section.title = @"Data Emergency Contact";
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nama Emergency Contact*" :@"namaEcon" :@""]];
    [section.rows addObject:[FormRow new:realm :1 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nomor Telepon Emergency Contact*" :@"nomorTeleponEcon" :@""]];
    
    [form.sections addObject:section];
    
    //===
    section = [[FormSection alloc] init];
    section.title = @"Submit";
    [section.rows addObject:[FormRow new:realm :2 :NO :NO :XLFormRowDescriptorTypeButton :@"Next" :@"" :@""]];
    
    [form.sections addObject:section];
    
    //===
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuFormPengajuanApplikasi]];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuListOnlineSubmission]];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
    
    [form.roles addObject:[Role objectForPrimaryKey:kRoleDealer]];
    [form.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [form.roles addObject:[Role objectForPrimaryKey:kRoleAgent]];
    [form.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [form.roles addObject:[Role objectForPrimaryKey:kRoleOfficer]];
    
    [realm addObject:form];
    

//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Kartu Kredit / Pinjaman Lain";
    form.sort = 60;
    
    //===
    section = [[FormSection alloc] init];
    section.title = @"Kartu Kredit / Pinjaman Lain";
    [section.rows addObject:[FormRow new:realm :0 :NO :NO :XLFormRowDescriptorTypeSelectorPush :@"Pinjaman Tempat Lain 1" :@"" :@"getPinjamantempatlain"]];
    [section.rows addObject:[FormRow new:realm :1 :NO :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nomor Kartu Kredit atau Kontrak 1" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :2 :NO :NO :XLFormRowDescriptorTypeSelectorPush :@"Pinjaman Tempat Lain 2" :@"" :@"getPinjamantempatlain"]];
    [section.rows addObject:[FormRow new:realm :3 :NO :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nomor Kartu Kredit atau Kontrak 2" :@"" :@""]];
    
    [form.sections addObject:section];
    
    //===
    section = [[FormSection alloc] init];
    section.title = @"Submit";
    [section.rows addObject:[FormRow new:realm :2 :NO :NO :XLFormRowDescriptorTypeButton :@"Next" :@"" :@""]];
    
    [form.sections addObject:section];
    
    //===
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuFormPengajuanApplikasi]];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuListOnlineSubmission]];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
    
    [form.roles addObject:[Role objectForPrimaryKey:kRoleDealer]];
    [form.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [form.roles addObject:[Role objectForPrimaryKey:kRoleAgent]];
    [form.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [form.roles addObject:[Role objectForPrimaryKey:kRoleOfficer]];
    
    [realm addObject:form];
    
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Data Vendor";
    form.sort = 70;
    
    //===
    section = [[FormSection alloc] init];
    section.title = @"Data Vendor";
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeTextView :@"Catatan TV" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :1 :YES :NO :XLFormRowDescriptorTypeTextView :@"Catatan SS" :@"" :@""]];
   
    [form.sections addObject:section];
    
    //===
    section = [[FormSection alloc] init];
    section.title = @"Submit";
    [section.rows addObject:[FormRow new:realm :2 :NO :NO :XLFormRowDescriptorTypeButton :@"Next" :@"" :@""]];
    
    [form.sections addObject:section];
    
    //===
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuFormPengajuanApplikasi]];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuListOnlineSubmission]];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
    
    [form.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    
    [realm addObject:form];
    
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Disclaimer";
    form.sort = 80;
    
    //===
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuFormPengajuanApplikasi]];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuListOnlineSubmission]];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
    
    [form.roles addObject:[Role objectForPrimaryKey:kRoleDealer]];
    [form.roles addObject:[Role objectForPrimaryKey:kRoleAgent]];
    [form.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [form.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [form.roles addObject:[Role objectForPrimaryKey:kRoleOfficer]];
    
    [realm addObject:form];
    
    
    
    
    
    
    
    
    
    
#pragma mark - Data MAP
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"MAP Data Aplikasi";
    form.sort = 0;
    
    //===
    section = [[FormSection alloc] init];
    section.title = @"Data Aplikasi";
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Sumber Aplikasi" :@"" :@"getSumberAplikasi"]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Tujuan Pembiayaan" :@"" :@"tujuanPembiayaan"]];
        [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Jenis Aplikasi" :@"" :@""]]; //ws
    [section.rows addObject:[FormRow new:realm :0 :NO :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nama KP" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeDateInline :@"Tanggal Perjanjian" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :YES :XLFormRowDescriptorTypeSelectorPush :@"Produk" :@"" :@"getProduct"]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Source of Application" :@"" :@""]]; //ws
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Product Offering" :@"" :@""]]; //ws
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Jarak Tempuh" :@"" :@""]]; //ws
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Lokasi Pemakaian Aset" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Application Priority" :@"" :@""]]; //ws
    [section.rows addObject:[FormRow new:realm :0 :NO :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nomor Tiket Telesales" :@"nomorTiketTelesales" :@""]];
    
    [form.sections addObject:section];
    
    //===
    section = [[FormSection alloc] init];
    section.title = @"Submit";
    [section.rows addObject:[FormRow new:realm :0 :NO :NO :XLFormRowDescriptorTypeButton :@"Submit" :@"" :@""]];
    
    [form.sections addObject:section];
    
    //===
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuDataMAP]];
    [realm addObject:form];
    
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Data Pribadi";
    form.sort = 10;
    
    //===
    section = [[FormSection alloc] init];
    section.title = @"Data Pribadi";
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nama Lengkap Sesuai KTP" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nama Panggilan / Alias" :@"namaPanggilan" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Agama" :@"" :@""]]; //ws
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Status Pernikahan" :@"" :@""]]; //ws
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Status Kepemilikan Rumah" :@"" :@""]]; //ws
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeDateInline :@"Tanggal Selesai Kontrak" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Lokasi Rumah" :@"" :@""]]; //ws
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Tahun Menempati" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nomor NPWP" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nomor Kartu Keluarga" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Jumlah Tanggungan" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Pendidikan Terakhir" :@"" :@""]]; //ws
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Alamat Pengiriman Surat" :@"" :@"getAlamatpengirimansurat"]];
    [section.rows addObject:[FormRow new:realm :0 :NO :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Alamat Email" :@"" :@""]];
    
    [form.sections addObject:section];
    
    //===
    section = [[FormSection alloc] init];
    section.title = @"Submit";
    [section.rows addObject:[FormRow new:realm :0 :NO :NO :XLFormRowDescriptorTypeButton :@"Submit" :@"" :@""]];
    
    [form.sections addObject:section];
    
    //===
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuDataMAP]];
    [realm addObject:form];
    
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Data Pekerjaan";
    form.sort = 20;
    
    //===
    section = [[FormSection alloc] init];
    section.title = @"Data Pekerjaan";
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Jenis Pekerjaan" :@"" :@"getJenisPekerjaan"]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Pekerjaan" :@"" :@""]]; //ws
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Status Pekerjaan" :@"" :@"getStatusPekerjaan"]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Bidang Usaha" :@"" :@""]]; //ws
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Posisi Jabatan" :@"" :@""]]; //ws
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Alamat Kantor" :@"" :@""]];
  
  
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Kelurahan" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"Kecamatan" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"Kota" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"Kode Pos" :@"" :@""]];
  [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"RT" :@"" :@""]];
  [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"RW" :@"" :@""]];
    [form.sections addObject:section];
    
    //===
    section = [[FormSection alloc] init];
    section.title = @"Data Pekerjaan";
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Pendapatan per bulan" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Lama Bekerja" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Pendapatan Lainnya per bulan" :@"" :@""]];
    
    [form.sections addObject:section];
    
    //===
    section = [[FormSection alloc] init];
    section.title = @"Data Pekerjaan Sebelumnya";
    section.hidden = [NSString stringWithFormat:@"$lamaBekerja.integerValue > 3 AND $lamaBekerja.integerValue > 0"];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nama Perusahaan" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Status Pekerjaan" :@"statusPekerjaanSebelumnya" :@"getStatusPekerjaan"]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Lama Bekerja (dalam tahun)" :@"lamaBekerjaDalamTahun" :@""]];
    
    [form.sections addObject:section];
    
    //===
    section = [[FormSection alloc] init];
    section.title = @"Wiraswasta";
    //section.hidden = [NSString stringWithFormat:@"$jenisPekerjaan.value.valueData != 47"];
    [section.rows addObject:[FormRow new:realm :0 :YES :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"Tahun1" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"Bulan1" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Omzet1" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"Tahun2" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"Bulan2" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Omzet2" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"Tahun3" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"Bulan3" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Omzet3" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"Tahun4" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"Bulan4" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Omzet4" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"Tahun5" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"Bulan5" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Omzet5" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"Tahun6" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"Bulan6" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Omzet6" :@"" :@""]];
    
    [form.sections addObject:section];
    
    //===
    section = [[FormSection alloc] init];
    section.title = @"PNS / Karyawan Swasta";
    //section.hidden = [NSString stringWithFormat:@"$jenisPekerjaan.value.valueData != 48"];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Gaji Pokok" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Tunjangan Tetap" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Insentif" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Lembur" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Bonus" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"Total" :@"" :@""]];
    
    [form.sections addObject:section];
    
    //===
    section = [[FormSection alloc] init];
    section.title = @"Submit";
    [section.rows addObject:[FormRow new:realm :0 :NO :NO :XLFormRowDescriptorTypeButton :@"Submit" :@"" :@""]];
    
    [form.sections addObject:section];
    
    //===
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuDataMAP]];
    [realm addObject:form];
    
//=====================================================================================================
//    form = [[Form alloc] init];
//    form.title = @"Kartu Kredit / Pinjaman Lain";
//    form.sort = 30;
//
//    //===
//    section = [[FormSection alloc] init];
//    section.title = @"Kartu Kredit / Pinjaman Lain";
//    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Pinjaman Tempat Lain 1" :@"" :@"getPinjamantempatlain"]];
//    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nomor Kartu Kredit atau Kontrak 1" :@"" :@""]];
//    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Pinjaman Tempat Lain 2" :@"" :@"getPinjamantempatlain"]];
//    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nomor Kartu Kredit atau Kontrak 2" :@"" :@""]];
//
//    [form.sections addObject:section];
//
//    //===
//    section = [[FormSection alloc] init];
//    section.title = @"Submit";
//    [section.rows addObject:[FormRow new:realm :0 :NO :NO :XLFormRowDescriptorTypeButton :@"Submit" :@"" :@""]];
//
//    [form.sections addObject:section];
//
//    //===
//    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuDataMAP]];
//    [realm addObject:form];
    
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Data Pasangan";
    form.sort = 40;
    
    //===
    section = [[FormSection alloc] init];
    section.title = @"Data Pasangan";
    [section.rows addObject:[FormRow new:realm :0 :YES :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nama Lengkap Sesuai KTP Pasangan" :@"" :@""]];
    
    [form.sections addObject:section];
    
    //===
    section = [[FormSection alloc] init];
    section.title = @"Submit";
    [section.rows addObject:[FormRow new:realm :0 :NO :NO :XLFormRowDescriptorTypeButton :@"Submit" :@"" :@""]];
    
    [form.sections addObject:section];
    
    //===
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuDataMAP]];
    [realm addObject:form];
    
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Data Pekerjaan Pasangan";
    form.sort = 50;
    
    //===
    section = [[FormSection alloc] init];
    section.title = @"Data Pekerjaan Pasangan";
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nama Perusahaan Pasangan" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Alamat Kantor Pasangan" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"RT Kantor Pasangan" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"RW Kantor Pasangan" :@"" :@""]];
  
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Kelurahan Kantor Pasangan" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"Kecamatan Kantor Pasangan" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"Kota Kantor Pasangan" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"Kode Pos Kantor Pasangan" :@"" :@""]];
    [form.sections addObject:section];
    
    //===
    section = [[FormSection alloc] init];
    section.title = @"Submit";
    [section.rows addObject:[FormRow new:realm :0 :NO :NO :XLFormRowDescriptorTypeButton :@"Submit" :@"" :@""]];
    
    [form.sections addObject:section];
    
    //===
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuDataMAP]];
    [realm addObject:form];
    
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Data Keluarga";
    form.sort = 60;
    
    //===
    section = [[FormSection alloc] init];
    section.title = @"Data Keluarga";
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nama" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nomor Induk Kependudukan" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeDateInline:@"Tanggal Lahir" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Hubungan dengan Pemohon" :@"" :@""]];
    [form.sections addObject:section];
    
    //===
    section = [[FormSection alloc] init];
    section.title = @"";
    [section.rows addObject:[FormRow new:realm :0 :NO :NO :XLFormRowDescriptorTypeButton :@"Tambah Data Keluarga" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :NO :NO :XLFormRowDescriptorTypeButton :@"Hapus Data Keluarga" :@"" :@""]];
    
    [form.sections addObject:section];
    
    //===
    section = [[FormSection alloc] init];
    section.title = @"Submit";
    [section.rows addObject:[FormRow new:realm :0 :NO :NO :XLFormRowDescriptorTypeButton :@"Submit" :@"" :@""]];
    
    [form.sections addObject:section];
    
    //===
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuDataMAP]];
    [realm addObject:form];
    
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Struktur Pembiayaan";
    form.sort = 70;
    
    //===
    section = [[FormSection alloc] init];
    section.title = @"Struktur Pembiayaan";
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Harga Kendaraan" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Total Bayar Awal" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Jangka Waktu Pembiayaan" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Angsuran" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Cara Pembiayaan" :@"" :@""]]; //ws
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Jumlah Aset" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Pokok Hutang" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Subsidi Uang Muka" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Total Uang diterima MPMF" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Biaya Admin" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Biaya Admin Lainnya" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Biaya Fidusia" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Biaya Lain" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Biaya Survey" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Persentase Biaya Provisi" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"Biaya Provisi" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Interest Type" :@"" :@""]]; //ws
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Effective Rate" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Skema Angsuran" :@"" :@""]]; //ws
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Tipe Angsuran" :@"" :@""]]; //ws
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Sumber Dana" :@"" :@"getSumberDana"]];
    [form.sections addObject:section];
    
    //===
    section = [[FormSection alloc] init];
    section.title = @"Submit";
    [section.rows addObject:[FormRow new:realm :0 :NO :NO :XLFormRowDescriptorTypeButton :@"Submit" :@"" :@""]];
    
    [form.sections addObject:section];
    
    //===
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuDataMAP]];
    [realm addObject:form];
    
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Asuransi";
    form.sort = 80;
    
    //===
    section = [[FormSection alloc] init];
    section.title = @"Asuransi";
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Nama Asuransi" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Asuransi Dibayar" :@"" :@""]]; //ws
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Jangka Waktu Asuransi" :@"" :@""]]; //ws
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Periode Asuransi" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nilai Pertanggungan" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Jenis Pertanggungan All Risk" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"Jenis Pertanggungan TLO" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"SRCC" :@"" :@"getSrcc"]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Banjir" :@"" :@"getBanjir"]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Gempa Bumi" :@"" :@"getGempaBumi"]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"TPL" :@"" :@"getTpl"]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"PA" :@"" :@"getPa"]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Asuransi Kendaraan Kapitalisasi" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Asuransi Kendaraan Dibayar Dimuka" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Asuransi Jiwa Kredit" :@"" :@"getAsuransiJiwaKredit"]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Asuransi Jiwa Kredit Kapitalisasi" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Asuransi Jiwa Dibayar Dimuka" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nilai Pertanggungan Asuransi Jiwa" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Premi Asuransi Kerugian Kendaraan" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Premi Asuransi Jiwa Kredit" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Perusahaan Asuransi Jiwa" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Tipe Asuransi" :@"" :@""]]; //ws
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Periode Asuransi Jiwa" :@"" :@""]];
    [form.sections addObject:section];
    
    //===
    section = [[FormSection alloc] init];
    section.title = @"Submit";
    [section.rows addObject:[FormRow new:realm :0 :NO :NO :XLFormRowDescriptorTypeButton :@"Submit" :@"" :@""]];
    
    [form.sections addObject:section];
    
    //===
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuDataMAP]];
    [realm addObject:form];
    
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Data Aset";
    form.sort = 90;
    
    //===
    section = [[FormSection alloc] init];
    section.title = @"Data Aset";
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Nama Supplier" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Asset Financed" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"New / Used" :@"newUsed" :@"getNewUsed"]];
    [section.rows addObject:[FormRow new:realm :0 :NO :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"No Rangka" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :NO :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"No Mesin" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Pemakaian Unit" :@"" :@""]]; //ws
    [section.rows addObject:[FormRow new:realm :0 :NO :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Silinder" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :NO :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Warna" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :NO :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nomor Polisi" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nama BPKB" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Area Kendaraan" :@"" :@""]]; //ws
    [form.sections addObject:section];
    
    //===
    section = [[FormSection alloc] init];
    section.title = @"Submit";
    [section.rows addObject:[FormRow new:realm :0 :NO :NO :XLFormRowDescriptorTypeButton :@"Submit" :@"" :@""]];
    
    [form.sections addObject:section];
    
    //===
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuDataMAP]];
    [realm addObject:form];
    
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Data E-con";
    form.sort = 100;
    
    //===
    section = [[FormSection alloc] init];
    section.title = @"Data E-con";
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Hubungan E-con dengan Pemohon" :@"hubunganEconDenganPemohon" :@""]];
    [form.sections addObject:section];
    
    //===
    section = [[FormSection alloc] init];
    section.title = @"Submit";
    [section.rows addObject:[FormRow new:realm :0 :NO :NO :XLFormRowDescriptorTypeButton :@"Submit" :@"" :@""]];
    
    [form.sections addObject:section];
    
    //===
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuDataMAP]];
    [realm addObject:form];
    
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Data Penjamin";
    form.sort = 110;
    
    //===
    section = [[FormSection alloc] init];
    section.title = @"Data Penjamin";
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nama Penjamin" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Hubungan Penjamin dengan Pemohon" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :NO :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nama Pasangan Penjamin" :@"" :@""]];
    [form.sections addObject:section];
    
    //===
    section = [[FormSection alloc] init];
    section.title = @"Submit";
    [section.rows addObject:[FormRow new:realm :0 :NO :NO :XLFormRowDescriptorTypeButton :@"Submit" :@"" :@""]];
    
    [form.sections addObject:section];
    
    //===
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuDataMAP]];
    [realm addObject:form];
    
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Data Marketing";
    form.sort = 120;
    
    //===
    section = [[FormSection alloc] init];
    section.title = @"Data Marketing";
    [section.rows addObject:[FormRow new:realm :0 :YES :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nama Kepala Cabang" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nama Marketing" :@"" :@""]];
    [form.sections addObject:section];
    
    //===
    section = [[FormSection alloc] init];
    section.title = @"Submit";
    [section.rows addObject:[FormRow new:realm :0 :NO :NO :XLFormRowDescriptorTypeButton :@"Submit" :@"" :@""]];
    
    [form.sections addObject:section];
    
    //===
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuDataMAP]];
    [realm addObject:form];
    
    //=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Data RCA";
    form.sort = 130;
    
    //===
    section = [[FormSection alloc] init];
    section.title = @"";
    [section.rows addObject:[FormRow new:realm :0 :YES :YES :XLFormRowDescriptorTypeRedzone :@"Redzone" :@"redzone" :@""]];
    [form.sections addObject:section];
    
    //===
    section = [[FormSection alloc] init];
    section.title = @"Data RCA";
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeTextView :@"RCA" :@"" :@""]];
    [form.sections addObject:section];
    
    //===
    section = [[FormSection alloc] init];
    section.title = @"Submit";
    [section.rows addObject:[FormRow new:realm :0 :NO :NO :XLFormRowDescriptorTypeButton :@"Submit" :@"" :@""]];
    
    [form.sections addObject:section];
    
    //===
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuDataMAP]];
    [realm addObject:form];
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//     [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nama Penjamin" :@"" :@""]];
    
#pragma mark - Survey
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Survey";
    form.sort = 130;
    
    section = [[FormSection alloc] init];
    section.title = @"Survey";
    [section.rows addObject:[FormRow new:realm :0 :NO :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nama Calon Debitur" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :1 :NO :NO :XLFormRowDescriptorTypeDateInline :@"Tanggal Survey" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :2 :NO :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nama Surveyor" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :3 :NO :NO :XLFormRowDescriptorTypeBooleanCheck :@"Alamat Survey Ditemukan" :@"" :@""]];// :27];
    [section.rows addObject:[FormRow new:realm :4 :NO :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Penjelasan" :@"" :@""]];
    [form.sections addObject:section];
    
    section = [[FormSection alloc] init];
    section.title = @"Observasi Tempat Tinggal";
    [section.rows addObject:[FormRow new:realm :7 :NO :NO :XLFormRowDescriptorTypeSelectorPush :@"Kondisi Tempat Tinggal" :@"" :@"getKondisiTmptTggl"]];
    [section.rows addObject:[FormRow new:realm :7 :NO :NO :XLFormRowDescriptorTypeSelectorPush :@"Lingkungan" :@"" :@"getLingkungan"]];
    [section.rows addObject:[FormRow new:realm :7 :NO :NO :XLFormRowDescriptorTypeSelectorPush :@"Akses Jalan Masuk" :@"" :@"getAksesjalanmasuk"]];
    [section.rows addObject:[FormRow new:realm :7 :NO :NO :XLFormRowDescriptorTypeMultipleSelector :@"Fasilitas Tempat Tinggal Yang Dimiliki" :@"fasilitasRumah" :@"getFasilitasRumah"]];
    [section.rows addObject:[FormRow new:realm :7 :NO :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Fasilitas Tempat Tinggal Lainnya" :@"fasilitasRumahLainnya" :@""]];
    [section.rows addObject:[FormRow new:realm :7 :NO :NO :XLFormRowDescriptorTypeSelectorPush :@"Penampakan Depan Rumah" :@"" :@"getPenampakanDpnRmh"]];
    [section.rows addObject:[FormRow new:realm :7 :NO :NO :XLFormRowDescriptorTypeMultipleSelector :@"Patokan Depan Rumah" :@"patokanDktRmh" :@"getPatokanDpnRmh"]];
    [section.rows addObject:[FormRow new:realm :7 :NO :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Patokan Depan Rumah Lainnya" :@"patokanDktRmhLainnya" :@""]];
    [form.sections addObject:section];
    
    section = [[FormSection alloc] init];
    section.title = @"Informasi Survey Lingkungan";
    [section.rows addObject:[FormRow new:realm :5 :NO :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nama" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :6 :NO :NO :XLFormRowDescriptorTypeSelectorPush :@"Hubungan" :@"" :@"getHubungan_checklist"]];
    [section.rows addObject:[FormRow new:realm :7 :NO :NO :XLFormRowDescriptorTypeBooleanCheck :@"Kebenaran Domisili" :@"" :@""]];// :27];
    [section.rows addObject:[FormRow new:realm :8 :NO :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Penjelasan" :@"ketDomisili" :@""]];
    [section.rows addObject:[FormRow new:realm :9 :NO :NO :XLFormRowDescriptorTypeSelectorPush :@"Status Kepemilikan Rumah" :@"" :@"getStatuskepemilikanrumahSurvey"]];// :13];
    [section.rows addObject:[FormRow new:realm :10 :NO :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Lama Tinggal (dalam tahun)" :@"lamaTinggal" :@""]];
    [section.rows addObject:[FormRow new:realm :11 :NO :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Jumlah orang yang tinggal serumah" :@"jumlahOrang" :@""]];
    [section.rows addObject:[FormRow new:realm :9 :NO :NO :XLFormRowDescriptorTypeSelectorPush :@"Terakhir berinteraksi dengan debitur" :@"" :@"getLastInteraksiDebitur"]];
    [section.rows addObject:[FormRow new:realm :9 :NO :NO :XLFormRowDescriptorTypeSelectorPush :@"Frekuensi didatangi penagih utang" :@"" :@"getFrekuensiDebtCollector"]];
    [section.rows addObject:[FormRow new:realm :7 :NO :NO :XLFormRowDescriptorTypeBooleanCheck :@"Debitur anggota paguyuban / partai / LSM" :@"debiturOrganisasi" :@""]];
    [section.rows addObject:[FormRow new:realm :12 :NO :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nama Organisasi" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :12 :NO :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Informasi Lain" :@"" :@""]];
    [form.sections addObject:section];
    
    //====
    section = [[FormSection alloc] init];
    section.title = @"";
    [section.rows addObject:[FormRow new:realm :0 :NO :NO :XLFormRowDescriptorTypeButton :@"Tambah Informasi Survey Lingkungan" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :NO :NO :XLFormRowDescriptorTypeButton :@"Hapus Informasi Survey Lingkungan" :@"" :@""]];
    
    [form.sections addObject:section];
    
    //====
    section = [[FormSection alloc] init];
    section.title = @"Hasil Pengamatan";
    [section.rows addObject:[FormRow new:realm :19 :NO :NO :XLFormRowDescriptorTypeTakePhoto :@"Foto Rumah Tampak Depan" :@"fotoRmhDpn" :@""]];
    [section.rows addObject:[FormRow new:realm :19 :NO :NO :XLFormRowDescriptorTypeTakePhoto :@"Foto Tampak Jalan Menuju Rumah" :@"fotoJlnRmh" :@""]];
    [section.rows addObject:[FormRow new:realm :19 :NO :NO :XLFormRowDescriptorTypeTakePhoto :@"Foto KTP Debitur" :@"fotoKtpDebitur" :@""]];
    [section.rows addObject:[FormRow new:realm :19 :NO :NO :XLFormRowDescriptorTypeTakePhoto :@"Foto KTP Pasangan" :@"fotoKtpPasangan" :@""]];
    [section.rows addObject:[FormRow new:realm :19 :NO :NO :XLFormRowDescriptorTypeTakePhoto :@"Foto Kartu Keluarga 1" :@"fotoKk1" :@""]];
    [section.rows addObject:[FormRow new:realm :19 :NO :NO :XLFormRowDescriptorTypeTakePhoto :@"Foto Kartu Keluarga 2" :@"fotoKk2" :@""]];
    [section.rows addObject:[FormRow new:realm :19 :NO :NO :XLFormRowDescriptorTypeTakePhoto :@"Foto Bukti Kepemilikan Rumah" :@"fotoBuktiKepemilikanRmh" :@""]];
    [section.rows addObject:[FormRow new:realm :19 :NO :NO :XLFormRowDescriptorTypeTakePhoto :@"Foto Bukti Usaha 1" :@"fotoUsaha1" :@""]];
    [section.rows addObject:[FormRow new:realm :19 :NO :NO :XLFormRowDescriptorTypeTakePhoto :@"Foto Bukti Usaha 2" :@"fotoUsaha2" :@""]];
    [form.sections addObject:section];
    
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuSurvey]];
    [realm addObject:form];

#pragma mark - Calculator
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Dahsyat";
    form.sort = 2;
    
    section = [[FormSection alloc] init];
    section.title = @"Dahsyat";
    
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Vehicle Type" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :1 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Manufacture Year" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :2 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Package" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :3 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Consumer Type" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :4 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"First Installment" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :5 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Tenor" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :6 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Grace Period" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :7 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Grace Period Type" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :8 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Usage" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :9 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Coverage Type" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :10 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Nilai Pertanggungan" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :11 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Provisi" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :12 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Admission Fee" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :13 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Region" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :14 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Life Insurance" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :15 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Purpose of Financing" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :16 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"ORT (Price List)" :@"otrPriceList" :@""]];
    [section.rows addObject:[FormRow new:realm :17 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"% Loan of Value (LTV)" :@"loanOfValue" :@""]];
    [section.rows addObject:[FormRow new:realm :18 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"% Running Rate" :@"runningRate" :@""]];
    [section.rows addObject:[FormRow new:realm :19 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"% Fee Agent" :@"feeAgent" :@""]];
    [section.rows addObject:[FormRow new:realm :20 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Others" :@"others" :@""]];
    [section.rows addObject:[FormRow new:realm :21 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Bulan Pencairan" :@"bulanPencairan" :@""]];
    
    [form.sections addObject:section];
    
    section = [[FormSection alloc] init];
    section.title = @"";
    [section.rows addObject:[FormRow new:realm :22 :NO :NO :XLFormRowDescriptorTypeButton :@"Calculate" :@"calculate" :@""]];
    [form.sections addObject:section];

    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuDahsyat]];
    [realm addObject:form];
    
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Used Car";
    form.sort = 1;
    
    section = [[FormSection alloc] init];
    section.title = @"Used Car";
    
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"OTR Kendaraan" :@"otrKendaraan" :@""]];
    [section.rows addObject:[FormRow new:realm :1 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"DP (%)" :@"dpPercentage" :@""]];
    [section.rows addObject:[FormRow new:realm :2 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"DP (Rupiah)" :@"dpRupiah" :@""]];
    [section.rows addObject:[FormRow new:realm :3 :YES :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"Rate" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :4 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Tahun Kendaraan" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :5 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Tenor" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :6 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Tipe Pembayaran" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :7 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Biaya Provisi" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :8 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Opsi Asuransi Jiwa" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :9 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Opsi Asuransi Jiwa Kapitalisasi" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :10 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Opsi Biaya Administrasi" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :11 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Opsi Biaya Fidusia" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :12 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Opsi Biaya Fidusia Kapitalisasi" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :13 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Wilayah Asuransi Kendaraan" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :14 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Penggunaan" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :15 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Opsi Asuransi Kendaraan" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :16 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Pertanggungan (Insurance by MPM / Sompo)" :@"pertanggungan" :@""]];
    [section.rows addObject:[FormRow new:realm :17 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Pilihan Asuransi Kombinasi Tahun Pertama" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :18 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Pilihan Asuransi Kombinasi Tahun Kedua" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :19 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Pilihan Asuransi Kombinasi Tahun Ketiga" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :20 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Pilihan Asuransi Kombinasi Tahun Keempat" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :21 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Pilihan Asuransi Kombinasi Tahun Kelima" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :22 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Pilihan Asuransi Kombinasi Tahun Keenam" :@"" :@""]];
    
    [form.sections addObject:section];
    
    section = [[FormSection alloc] init];
    section.title = @"Asuransi";
    [section.rows addObject:[FormRow new:realm :21 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nilai Tunai Sebagian" :@"" :@""]];
    [form.sections addObject:section];
    
    section = [[FormSection alloc] init];
    section.title = @"Setting Rate";
    [section.rows addObject:[FormRow new:realm :22 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"% Supplier Rate" :@"supplierRate" :@""]];
    [section.rows addObject:[FormRow new:realm :23 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"% Refund Bunga" :@"refundBunga" :@""]];
    [section.rows addObject:[FormRow new:realm :24 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"% Refund Asuransi" :@"refundAsuransi" :@""]];
    [section.rows addObject:[FormRow new:realm :25 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"% Upping Provisi" :@"uppingProvisi" :@""]];
    [form.sections addObject:section];
    
    section = [[FormSection alloc] init];
    section.title = @"Opsi Komponen Biaya Tunai";
    [section.rows addObject:[FormRow new:realm :26 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Biaya Survey (Jika Ada)" :@"biayaSurvey" :@""]];
    [section.rows addObject:[FormRow new:realm :27 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Biaya Cek / Blokir BPKB (Jika Ada)" :@"biayaCekBlokirBPKB" :@""]];
    [form.sections addObject:section];
    
    section = [[FormSection alloc] init];
    section.title = @"";
    [section.rows addObject:[FormRow new:realm :28 :NO :NO :XLFormRowDescriptorTypeButton :@"Calculate" :@"calculate" :@""]];
    [form.sections addObject:section];

    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuUsedCar]];
    [realm addObject:form];
    
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"New Car";
    form.sort = 0;
    
    section = [[FormSection alloc] init];
    section.title = @"New Car";
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"OTR Kendaraan" :@"otrKendaraan" :@""]];
    [section.rows addObject:[FormRow new:realm :1 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"DP (%)" :@"dpPercentage" :@""]];
    [section.rows addObject:[FormRow new:realm :2 :YES :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"DP (Rupiah)" :@"dpRupiah" :@""]];
    [section.rows addObject:[FormRow new:realm :3 :YES :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"Rate" :@"rate" :@""]];
    [section.rows addObject:[FormRow new:realm :4 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Tenor" :@"tenor" :@""]];
    [section.rows addObject:[FormRow new:realm :5 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Tipe Pembayaran" :@"tipePembayaran" :@""]];
    [section.rows addObject:[FormRow new:realm :6 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Biaya Provisi" :@"biayaProvisi" :@""]];
    [section.rows addObject:[FormRow new:realm :7 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Opsi Asuransi Jiwa" :@"opsiAsuransiJiwa" :@""]];
    [section.rows addObject:[FormRow new:realm :8 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Opsi Asuransi Jiwa Kapitalisasi" :@"opsiAsuransiJiwaKapitalisasi" :@""]];
    [section.rows addObject:[FormRow new:realm :9 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Opsi Biaya Administrasi" :@"opsiBiayaAdministrasi" :@""]];
    [section.rows addObject:[FormRow new:realm :10 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Opsi Biaya Fidusia" :@"opsiBiayaFidusia" :@""]];
    [section.rows addObject:[FormRow new:realm :11 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Opsi Biaya Fidusia Kapitalisasi" :@"opsiBiayaFidusiaKapitalisasi" :@""]];
    [section.rows addObject:[FormRow new:realm :12 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Wilayah Asuransi Kendaraan" :@"wilayahAsuransiKendaraan" :@""]];
    [section.rows addObject:[FormRow new:realm :13 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Opsi Premi" :@"opsiPremi" :@""]];
    [section.rows addObject:[FormRow new:realm :14 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Pertanggungan (Insurance by MPM/Sompo)" :@"pertanggungan" :@""]];
    [section.rows addObject:[FormRow new:realm :15 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Penggunaan" :@"penggunaan" :@""]];
    [section.rows addObject:[FormRow new:realm :16 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Opsi Asuransi Kendaraan" :@"opsiAsuransiKendaraan" :@""]];
    [form.sections addObject:section];
    
    section = [[FormSection alloc] init];
    section.title = @"Asuransi";
    [section.rows addObject:[FormRow new:realm :17 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nilai Tunai Sebagian" :@"nilaiTunaiSebagian" :@""]];
    [form.sections addObject:section];
    
    section = [[FormSection alloc] init];
    section.title = @"Setting Rate";
    [section.rows addObject:[FormRow new:realm :18 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"% Supplier Rate" :@"supplierRate" :@""]];
    [section.rows addObject:[FormRow new:realm :19 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"% Refund Bunga" :@"refundBunga" :@""]];
    [section.rows addObject:[FormRow new:realm :20 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"% Refund Asuransi" :@"refundAsuransi" :@""]];
    [section.rows addObject:[FormRow new:realm :21 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"% Upping Provisi" :@"uppingProvisi" :@""]];
    [form.sections addObject:section];
    
    section = [[FormSection alloc] init];
    section.title = @"Opsi Komponen Biaya Tunai";
    [section.rows addObject:[FormRow new:realm :22 :NO :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Biaya Survey (Jika ada)" :@"biayaSurvey" :@""]];
    [section.rows addObject:[FormRow new:realm :23 :NO :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Biaya Cek / Blokir BPKB (Jika ada)" :@"biayaCekBlokirBPKB" :@""]];
    [form.sections addObject:section];
    
    section = [[FormSection alloc] init];
    section.title = @"";
    [section.rows addObject:[FormRow new:realm :24 :NO :NO :XLFormRowDescriptorTypeButton :@"Calculate" :@"calculate" :@""]];
    [form.sections addObject:section];
    
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuNewCar]];
    [realm addObject:form];

    [self generateFormsForCustomerDealerWithRealm:realm];
    [realm commitWriteTransaction];
}

+ (void)generateFormsForCustomerDealerWithRealm:(RLMRealm *)realm{
//=====================================================================================================
    Form *form = [[Form alloc] init];
    form.title = @"Customer Get Customer";
    form.sort = 0;
    
    FormSection *section = [[FormSection alloc] init];
    section.title = @"Customer Get Customer";
    [section.rows addObjects:[FormRow getRowsWithCategoryNumber:23]];
    
    [form.sections addObject:section];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuCustomerGetCustomer]];
    [realm addObject:form];
    
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Saran & Pengaduan";
    form.sort = 0;
    
    section = [[FormSection alloc] init];
    section.title = @"Saran";
    [section.rows addObjects:[FormRow getRowsWithCategoryNumber:25]];
    
    [form.sections addObject:section];
    
    section = [[FormSection alloc] init];
    section.title = @"Pengaduan";
    [section.rows addObjects:[FormRow getRowsWithCategoryNumber:24]];
    
    [form.sections addObject:section];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuSaranPengaduan]];
    [realm addObject:form];
    
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Pengambilan BPKB";
    form.sort = 0;
    
    section = [[FormSection alloc] init];
    section.title = @"Pengambilan BPKB";
    [section.rows addObjects:[FormRow getRowsWithCategoryNumber:26]];
    
    [form.sections addObject:section];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuPengambilanBPKB]];
    [realm addObject:form];

//=====================================================================================================
    //=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Aktivitas Transaksi";
    form.sort = 0;
    
    [form.menus addObject:[Menu objectForPrimaryKey:kMenuHistoryTransaksi]];
    [realm addObject:form];
    
    //=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Pelunasan Dipercepat";
    form.sort = 0;
    
    section = [[FormSection alloc] init];
    section.title = @"Pelunasan Dipercepat";
    [section.rows addObjects:[FormRow getRowsWithCategoryNumber:27]];
    
    [form.sections addObject:section];
    [form.menus addObject:[Menu objectForPrimaryKey:kMenuPelunasanDipercepat]];
    [realm addObject:form];

//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Klaim Asuransi";
    form.sort = 0;
    
    section = [[FormSection alloc] init];
    section.title = @"Klaim Asuransi";
    [section.rows addObjects:[FormRow getRowsWithCategoryNumber:28]];
    
    [form.sections addObject:section];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuInsuranceClaimForm]];
    [realm addObject:form];

//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Legalisir BPKB";
    form.sort = 0;
    
    section = [[FormSection alloc] init];
    section.title = @"Legalisir BPKB";
    [section.rows addObjects:[FormRow getRowsWithCategoryNumber:29]];
    
    [form.sections addObject:section];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuLegalizationBPKB]];
    [realm addObject:form];
    
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Top Up";
    form.sort = 0;
    
    section = [[FormSection alloc] init];
    section.title = @"Top Up";
    [section.rows addObjects:[FormRow getRowsWithCategoryNumber:30]];
    
    [form.sections addObject:section];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuTopUp]];
    [realm addObject:form];
    
}

@end
