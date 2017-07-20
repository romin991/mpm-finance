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
    section.title = @"Pilih Cabang";
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Cabang" :@"" :@"getAllCabang"]];
    
    [form.sections addObject:section];
    
    //===
    section = [[FormSection alloc] init];
    section.title = @"Data Pemohon";
    [section.rows addObject:[FormRow new:realm :1 :YES :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nama Lengkap" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :2 :YES :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"No KTP" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :3 :YES :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"Tempat Lahir" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :4 :YES :YES :XLFormRowDescriptorTypeDateInline :@"Tanggal Lahir" :@"" :@""]];
    
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
    [section.rows addObject:[FormRow new:realm :12 :NO :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Kode Area" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :13 :NO :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nomor Telepon" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :14 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nomor Handphone" :@"" :@""]];
    
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
    [realm addObject:form];
    
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Data Pasangan";
    form.sort = 10;
    
    //===
    section = [[FormSection alloc] init];
    section.title = @"Data Pasangan";
    [section.rows addObject:[FormRow new:realm :0 :NO :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nama Pasangan" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :1 :NO :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"No Handphone Pasangan" :@"" :@""]];
    
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
    [realm addObject:form];

//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Data Aset";
    form.sort = 20;
    
    //===
    section = [[FormSection alloc] init];
    section.title = @"Data Asset";
    
    FormRow *row = [FormRow new:realm :0 :NO :NO :XLFormRowDescriptorTypeSelectorPush :@"Cabang" :@"" :@"getAllCabang"];
    row.disabled = YES;
    [section.rows addObject:row];
    
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Tipe Produk" :@"" :@"getProduct"]];
    [section.rows addObject:[FormRow new:realm :1 :YES :NO :XLFormRowDescriptorTypeSelectorPush :@"Tipe Kendaraan" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :2 :NO :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Tahun Kendaraan" :@"" :@""]];
    
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
    [realm addObject:form];
    
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Struktur Pembiayaan";
    form.sort = 30;
    
    //===
    section = [[FormSection alloc] init];
    section.title = @"Struktur Pembiayaan";
    [section.rows addObject:[FormRow new:realm :0 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Harga Perolehan" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :1 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Uang Muka" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :2 :YES :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Jangka Waktu Pembiayaan" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :3 :NO :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Angsuran" :@"" :@""]];
    
    [form.sections addObject:section];
    
    //===
    section = [[FormSection alloc] init];
    section.title = @"Submit";
    [section.rows addObject:[FormRow new:realm :4 :NO :NO :XLFormRowDescriptorTypeButton :@"Next" :@"" :@""]];
    
    [form.sections addObject:section];
    
    //===
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuFormPengajuanApplikasi]];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuListOnlineSubmission]];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
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
    [realm addObject:form];
    
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Data E-con";
    form.sort = 50;
   
    //===
    section = [[FormSection alloc] init];
    section.title = @"Data E-con";
    [section.rows addObject:[FormRow new:realm :0 :NO :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nama E-con" :@"namaEcon" :@""]];
    [section.rows addObject:[FormRow new:realm :1 :NO :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nomor Telepon E-con" :@"nomorTeleponEcon" :@""]];
    
    [form.sections addObject:section];
    
    //===
    section = [[FormSection alloc] init];
    section.title = @"Submit";
    [section.rows addObject:[FormRow new:realm :2 :NO :NO :XLFormRowDescriptorTypeButton :@"Submit" :@"" :@""]];
    
    [form.sections addObject:section];
    
    //===
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuFormPengajuanApplikasi]];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuListOnlineSubmission]];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
    [realm addObject:form];
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"MAP Data Aplikasi";
    form.sort = 0;
    
    //===
    section = [[FormSection alloc] init];
    section.title = @"Data Aplikasi";
    [section.rows addObject:[FormRow new:realm :0 :NO :NO :XLFormRowDescriptorTypeSelectorPush :@"Sumber Aplikasi" :@"" :@"getSumberAplikasi"]];
    [section.rows addObject:[FormRow new:realm :0 :NO :NO :XLFormRowDescriptorTypeSelectorPush :@"Tujuan Pembiayaan" :@"" :@"tujuanPembiayaan"]];
    [section.rows addObject:[FormRow new:realm :0 :NO :NO :XLFormRowDescriptorTypeSelectorPush :@"Jenis Aplikasi" :@"" :@"jenisaplikasi"]]; //ws
    [section.rows addObject:[FormRow new:realm :0 :YES :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"Kode Cabang" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :NO :NO :XLFormRowDescriptorTypeDateInline :@"Tanggal Perjanjian" :@"" :@""]];
    [section.rows addObject:[FormRow new:realm :0 :NO :NO :XLFormRowDescriptorTypeSelectorPush :@"Produk" :@"" :@"getProduct"]];
    [section.rows addObject:[FormRow new:realm :0 :NO :NO :XLFormRowDescriptorTypeSelectorPush :@"Source of Application" :@"" :@"SourceOfApplication"]]; //ws
    [section.rows addObject:[FormRow new:realm :0 :NO :NO :XLFormRowDescriptorTypeSelectorPush :@"Product Offering" :@"" :@"Product"]]; //ws
    [section.rows addObject:[FormRow new:realm :0 :NO :NO :XLFormRowDescriptorTypeSelectorPush :@"Jarak Tempuh" :@"" :@"JarakTempuh"]]; //ws
    [section.rows addObject:[FormRow new:realm :0 :NO :NO :XLFormRowDescriptorTypeSelectorPush :@"Application Priority" :@"" :@"ApplicationPriority"]]; //ws
    [section.rows addObject:[FormRow new:realm :0 :NO :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nomor Tiket Telesales" :@"" :@""]];
    
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
    [form.rows addObjects:[FormRow getRowsWithCategoryNumber:7]];
    
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuDataMAP]];
    [realm addObject:form];
    
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Data Pekerjaan";
    form.sort = 20;
    [form.rows addObjects:[FormRow getRowsWithCategoryNumber:8]];
    
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuDataMAP]];
    [realm addObject:form];
    
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Kartu Kredit / Pinjaman Lain";
    form.sort = 30;
    [form.rows addObjects:[FormRow getRowsWithCategoryNumber:9]];
    
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuDataMAP]];
    [realm addObject:form];
    
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Data Pasangan";
    form.sort = 40;
    [form.rows addObjects:[FormRow getRowsWithCategoryNumber:10]];
    
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuDataMAP]];
    [realm addObject:form];
    
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Data Pekerjaan Pasangan";
    form.sort = 50;
    [form.rows addObjects:[FormRow getRowsWithCategoryNumber:11]];
    
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuDataMAP]];
    [realm addObject:form];
    
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Data Keluarga";
    form.sort = 60;
    [form.rows addObjects:[FormRow getRowsWithCategoryNumber:12]];
    
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuDataMAP]];
    [realm addObject:form];
    
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Struktur Pembayaran";
    form.sort = 70;
    [form.rows addObjects:[FormRow getRowsWithCategoryNumber:13]];
    
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuDataMAP]];
    [realm addObject:form];
    
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Asuransi";
    form.sort = 80;
    [form.rows addObjects:[FormRow getRowsWithCategoryNumber:14]];
    
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuDataMAP]];
    [realm addObject:form];
    
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Data Aset";
    form.sort = 90;
    [form.rows addObjects:[FormRow getRowsWithCategoryNumber:15]];
    
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuDataMAP]];
    [realm addObject:form];
    
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Data E-con";
    form.sort = 100;
    [form.rows addObjects:[FormRow getRowsWithCategoryNumber:16]];
    
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuDataMAP]];
    [realm addObject:form];
    
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"MAP Penjamin";
    form.sort = 110;
    [form.rows addObjects:[FormRow getRowsWithCategoryNumber:17]];
    
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuDataMAP]];
    [realm addObject:form];
    
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Data Marketing";
    form.sort = 120;
    [form.rows addObjects:[FormRow getRowsWithCategoryNumber:18]];
    
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuDataMAP]];
    [realm addObject:form];
    
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Survey";
    form.sort = 130;
    [form.rows addObjects:[FormRow getRowsWithCategoryNumber:19]];
    
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
    form.title = @"Saran";
    form.sort = 0;
    
    section = [[FormSection alloc] init];
    section.title = @"Saran";
    [section.rows addObjects:[FormRow getRowsWithCategoryNumber:24]];
    
    [form.sections addObject:section];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuSaranPengaduan]];
    [realm addObject:form];
    
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Pengaduan";
    form.sort = 0;
    
    section = [[FormSection alloc] init];
    section.title = @"Pengaduan";
    [section.rows addObjects:[FormRow getRowsWithCategoryNumber:25]];
    
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
