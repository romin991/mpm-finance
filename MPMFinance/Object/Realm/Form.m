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
    [section.rows addObject:[FormRow new:realm :1 :YES :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"No KTP" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :2 :YES :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nama Lengkap" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :3 :YES :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"Tempat Lahir" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :4 :YES :YES :XLFormRowDescriptorTypeDateInline :@"Tanggal Lahir" :@"" :@""]];
    
    [section.rows addObject:[FormRow new:realm :5 :YES :YES :XLFormRowDescriptorTypeSelectorPush :@"Jenis Kelamin" :@"" :@"getJenisKelamin"]];
    
    [form.sections addObject:section];
    
    //===
    section = [[FormSection alloc] init];
    section.title = @"Alamat KTP";
    [section.rows addObject:[FormRow new:realm :5 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Alamat Rumah Sesuai KTP" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :6 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"RT Sesuai KTP" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :7 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"RW Sesuai KTP" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :8 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Kodepos Sesuai KTP" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :9 :YES :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"Kecamatan Sesuai KTP" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :10 :YES :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"Kelurahan Sesuai KTP" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :11 :YES :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"Kota Sesuai KTP" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :12 :YES :NO :XLFormRowDescriptorTypeDateInline :@"Masa Berlaku KTP" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :13 :YES :YES :XLFormRowDescriptorTypeSelectorPush :@"Kewarganegaraan" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :14 :NO :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Kode Area" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :15 :NO :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nomor Telepon" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :16 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nomor Handphone" :@"" :@""]];
    
    [form.sections addObject:section];
    
    //===
    section = [[FormSection alloc] init];
    section.title = @"Alamat Domisili";
    [section.rows addObject:[FormRow new:realm :15 :NO :NO :XLFormRowDescriptorTypeBooleanCheck :@"Sama dengan alamat legal" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :16 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Alamat Domisili" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :17 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"RT Domisili" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :18 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"RW Domisili" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :19 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Kodepos Domisili" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :20 :YES :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"Kecamatan Domisili" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :21 :YES :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"Kelurahan Domisili" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :22 :YES :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"Kota Domisili" :@"" :@""]];
    
    [form.sections addObject:section];
    
    //===
    section = [[FormSection alloc] init];
    section.title = @"Other";
    [section.rows addObject:[FormRow new:realm :23 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nama Gadis Ibu Kandung" :@"" :@""]];
    
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
    [section.rows addObject:[FormRow new:realm :0 :NO :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"No KTP Pasangan" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :1 :NO :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nama Lengkap Pasangan" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :2 :NO :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nomor Handphone Pasangan" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :4 :NO :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Tempat Lahir Pasangan" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :5 :NO :NO :XLFormRowDescriptorTypeDateInline:@"Tanggal Lahir Pasangan" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :6 :NO :NO :XLFormRowDescriptorTypeSelectorPush :@"Jenis Kelamin Pasangan" :@"" :@"getJenisKelamin"]];
    [section.rows addObject:[FormRow new:realm :7 :NO :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Alamat Pasangan" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :7 :NO :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"RT Pasangan" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :7 :NO :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"RW Pasangan" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :7 :NO :NO :XLFormRowDescriptorTypeSelectorPush :@"Kode Pos Pasangan" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :7 :NO :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"Kelurahan Pasangan" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :7 :NO :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"Kecamatan Pasangan" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :7 :NO :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"Kota Pasangan" :@"" :@""]];
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
    
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Tipe Produk" :@"" :@"getProduct"]];
    [section.rows addObject:[FormRow new:realm :1 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Tipe Kendaraan" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :2 :NO :NO :XLFormRowDescriptorTypeSelectorPush :@"Tahun Kendaraan" :@"" :@""]];
    
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
//    form = [[Form alloc] init];
//    form.title = @"Struktur Pembiayaan";
//    form.sort = 30;
//
//    //===
//    section = [[FormSection alloc] init];
//    section.title = @"Struktur Pembiayaan";
//    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Harga Perolehan" :@"" :@""]];
//    [section.rows addObject:[FormRow new:realm :1 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Uang Muka" :@"" :@""]];
//    [section.rows addObject:[FormRow new:realm :2 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Jangka Waktu Pembiayaan" :@"" :@""]];
//    [section.rows addObject:[FormRow new:realm :3 :NO :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Angsuran" :@"" :@""]];
//
//    [form.sections addObject:section];
//
//    //===
//    section = [[FormSection alloc] init];
//    section.title = @"Submit";
//    [section.rows addObject:[FormRow new:realm :4 :NO :NO :XLFormRowDescriptorTypeButton :@"Next" :@"" :@""]];
//
//    [form.sections addObject:section];
//
//    //===
//    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuFormPengajuanApplikasi]];
//    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuListOnlineSubmission]];
//    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
//
//    [form.roles addObject:[Role objectForPrimaryKey:kRoleDealer]];
//    [form.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
//    [form.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
//    [form.roles addObject:[Role objectForPrimaryKey:kRoleOfficer]];
//
//    [realm addObject:form];
    
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
    form.title = @"Data E-con";
    form.sort = 50;
   
    //===
    section = [[FormSection alloc] init];
    section.title = @"Data E-con";
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nama E-con" :@"namaEcon" :@""]];
    [section.rows addObject:[FormRow new:realm :1 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nomor Telepon E-con" :@"nomorTeleponEcon" :@""]];
    
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
    [section.rows addObject:[FormRow new:realm :0 :NO :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Catatan TV" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :1 :NO :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Catatan SS" :@"" :@""]];
   
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
    [section.rows addObject:[FormRow new:realm :0 :YES :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"Kode Cabang" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeDateInline :@"Tanggal Perjanjian" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Produk" :@"" :@"getProduct"]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Source of Application" :@"" :@""]]; //ws
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Product Offering" :@"" :@""]]; //ws
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Jarak Tempuh" :@"" :@""]]; //ws
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Lokasi Pemakaian Aset" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Application Priority" :@"" :@""]]; //ws
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nomor Tiket Telesales" :@"" :@""]];
    
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
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeDateInline :@"Masa Berlaku KTP" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Kewarganegaraan" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Jenis Kelamin" :@"" :@"getJenisKelamin"]];
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
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Alamat Email" :@"" :@""]];
    
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
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"RT" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"RW" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Kode Pos" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Kelurahan" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Kecamatan" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Kota" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Lama Bekerja dalam bulan" :@"" :@""]];
    
    [form.sections addObject:section];
    
    //===
    section = [[FormSection alloc] init];
    section.title = @"Data Pekerjaan Sebelumnya";
    section.hidden = [NSString stringWithFormat:@"$lamaBekerjaDalamBulan.integerValue > 3"];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Pendapatan per bulan" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nama Perusahaan" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Status Pekerjaan Sebelumnya" :@"" :@"getStatusPekerjaan"]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Lama Bekerja" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Pendapatan Lainnya per bulan" :@"" :@""]];
    
    [form.sections addObject:section];
    
    //===
    section = [[FormSection alloc] init];
    section.title = @"Wiraswasta";
    section.hidden = [NSString stringWithFormat:@"$jenisPekerjaan.value.valueData != 47"];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Tahun1" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Bulan1" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Omzet1" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Tahun2" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Bulan2" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Omzet2" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Tahun3" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Bulan3" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Omzet3" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Tahun4" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Bulan4" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Omzet4" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Tahun5" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Bulan5" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Omzet5" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Tahun6" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Bulan6" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Omzet6" :@"" :@""]];
    
    [form.sections addObject:section];
    
    //===
    section = [[FormSection alloc] init];
    section.title = @"PNS / Karyawan Swasta";
    section.hidden = [NSString stringWithFormat:@"$jenisPekerjaan.value.valueData != 48"];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Gaji Pokok" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Tunjangan Tetap" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Intensif" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Lembur" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Bonus" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Total" :@"" :@""]];
    
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
    form.title = @"Kartu Kredit / Pinjaman Lain";
    form.sort = 30;
    
    //===
    section = [[FormSection alloc] init];
    section.title = @"Kartu Kredit / Pinjaman Lain";
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Pinjaman Tempat Lain 1" :@"" :@"getPinjamantempatlain"]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nomor Kartu Kredit atau Kontrak 1" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Pinjaman Tempat Lain 2" :@"" :@"getPinjamantempatlain"]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nomor Kartu Kredit atau Kontrak 2" :@"" :@""]];
    
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
    form.title = @"Data Pasangan";
    form.sort = 40;
    
    //===
    section = [[FormSection alloc] init];
    section.title = @"Data Pasangan";
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nama Lengkap Sesuai KTP Pasangan" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nomor KTP Pasangan" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeDateInline :@"Masa Berlaku KTP Pasangan" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Kewarganegaraan Pasangan" :@"" :@""]];
    
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
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Kode Pos Kantor Pasangan" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Kelurahan Kantor Pasangan" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Kecamatan Kantor Pasangan" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Kota Kantor Pasangan" :@"" :@""]];
    
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
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Hubungan dengan Pemohon" :@"" :@"getHubunganKeluarga"]];
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
    form.title = @"Struktur Pembayaran";
    form.sort = 70;
    
    //===
    section = [[FormSection alloc] init];
    section.title = @"Struktur Pembayaran";
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
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Biaya Provisi" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Asuransi Kapitalisasi" :@"" :@""]];
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
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nama Asuransi" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Asuransi Dibayar" :@"" :@""]]; //ws
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Jangka Waktu Asuransi" :@"" :@""]]; //ws
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Periode Asuransi" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nilai Pertanggungan" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Jenis Pertanggungan All Risk" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Jenis Pertanggungan TLO" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"SRCC" :@"" :@"getSrcc"]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Banjir" :@"" :@"getBanjir"]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Gempa Bumi" :@"" :@"getGempaBumi"]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"TPL" :@"" :@"getTpl"]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"PA" :@"" :@"getPa"]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Asuransi Jiwa Kredit" :@"" :@"getAsuransiJiwaKredit"]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Asuransi Jiwa Kredit Kapitalisasi" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nilai Pertanggunan Asuransi Jiwa" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Premi Asuransi Kerugian Kendaraan" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Premi Asuransi Jiwa Kredit" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Perusahaan Asuransi Jiwa" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Tipe Asuransi" :@"" :@""]]; //ws
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
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nama Supplier" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Asset Financed" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"New / Used" :@"newUsed" :@"getNewUsed"]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"No Rangka" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"No Mesin" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Pemakaian Unit" :@"" :@""]]; //ws
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Silinder" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Warna" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nomor Polisi" :@"" :@""]];
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
    form.title = @"MAP Penjamin";
    form.sort = 110;
    
    //===
    section = [[FormSection alloc] init];
    section.title = @"MAP Penjamin";
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nama Penjamin" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Hubungan Penjamin dengan Pemohon" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nama Pasangan Penjamin" :@"" :@""]];
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
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nama Kepala Cabang" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nama Marketing" :@"" :@""]];
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
    form.title = @"Survey";
    form.sort = 130;
    
    section = [[FormSection alloc] init];
    section.title = @"Data Pemohon";
    [section.rows addObjects:[FormRow getRowsWithCategoryNumber:19]];
    [form.sections addObject:section];
    
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuSurvey]];
    [realm addObject:form];

//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Dahsyat";
    form.sort = 0;
    
    section = [[FormSection alloc] init];
    section.title = @"Dahsyat";
    [section.rows addObjects:[FormRow getRowsWithCategoryNumber:20]];
    
    [form.sections addObject:section];
//    [form.rows addObjects:[FormRow getRowsWithCategoryNumber:20]];
    
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuDahsyat]];
    [realm addObject:form];
    
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Used Car";
    form.sort = 0;
    
    section = [[FormSection alloc] init];
    section.title = @"Used Car";
    [section.rows addObjects:[FormRow getRowsWithCategoryNumber:21]];
    
    [form.sections addObject:section];
    //    [form.rows addObjects:[FormRow getRowsWithCategoryNumber:21]];
    
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuUsedCar]];
    [realm addObject:form];
    
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Dahsyat";
    form.sort = 0;
    
    section = [[FormSection alloc] init];
    section.title = @"Dahsyat";
    [section.rows addObjects:[FormRow getRowsWithCategoryNumber:22]];
    
    [form.sections addObject:section];
    //    [form.rows addObjects:[FormRow getRowsWithCategoryNumber:22]];
    
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
