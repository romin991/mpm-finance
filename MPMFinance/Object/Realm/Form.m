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

+ (RLMResults *)getFormForMenu:(NSString *)menuTitle{
    return [[Form objectsWhere:@"ANY menus.title = %@", menuTitle] sortedResultsUsingKeyPath:@"sort" ascending:YES];
}

#pragma mark - Populate Data
+ (void)generateForms{
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    
//=====================================================================================================
    Form *form = [[Form alloc] init];
    form.title = @"Data Pemohon";
    form.sort = 0;
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuFormPengajuanApplikasi]];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuListOnlineSubmission]];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
    
    FormRow *row = [[FormRow alloc] init];
    row.title = @"Nama Calon Debitur";
    row.tag = @"0";
    row.type = XLFormRowDescriptorTypeFloatLabeledTextField;
    row.required = NO;
    row.sort = 0;
    [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuFormPengajuanApplikasi]];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuListOnlineSubmission]];
    [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
    [realm addObject:row];
    [form.rows addObject:row];
    
    row = [[FormRow alloc] init];
    row.title = @"No KTP";
    row.tag = @"1";
    row.type = XLFormRowDescriptorTypeFloatLabeledTextField;
    row.required = NO;
    row.sort = 10;
    [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuFormPengajuanApplikasi]];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuListOnlineSubmission]];
    [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
    [realm addObject:row];
    [form.rows addObject:row];
    
    row = [[FormRow alloc] init];
    row.title = @"Tempat Lahir";
    row.tag = @"2";
    row.type = XLFormRowDescriptorTypeFloatLabeledTextField;
    row.required = NO;
    row.sort = 20;
    [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuFormPengajuanApplikasi]];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuListOnlineSubmission]];
    [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
    [realm addObject:row];
    [form.rows addObject:row];
    
    row = [[FormRow alloc] init];
    row.title = @"Tanggal Lahir";
    row.tag = @"3";
    row.type = XLFormRowDescriptorTypeDateInline;
    row.required = NO;
    row.sort = 30;
    [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuFormPengajuanApplikasi]];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuListOnlineSubmission]];
    [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
    [realm addObject:row];
    [form.rows addObject:row];
    
    row = [[FormRow alloc] init];
    row.title = @"Alamat Rumah Sesuai KTP";
    row.tag = @"4";
    row.type = XLFormRowDescriptorTypeFloatLabeledTextField;
    row.required = NO;
    row.sort = 40;
    [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuFormPengajuanApplikasi]];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuListOnlineSubmission]];
    [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
    [realm addObject:row];
    [form.rows addObject:row];
    [realm addObject:form];
    
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Data Pasangan";
    form.sort = 10;
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuFormPengajuanApplikasi]];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuListOnlineSubmission]];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
    
    row = [[FormRow alloc] init];
    row.title = @"Nama Pasangan";
    row.tag = @"0";
    row.type = XLFormRowDescriptorTypeFloatLabeledTextField;
    row.required = NO;
    row.sort = 0;
    [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuFormPengajuanApplikasi]];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuListOnlineSubmission]];
    [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
    [realm addObject:row];
    [form.rows addObject:row];
    
    row = [[FormRow alloc] init];
    row.title = @"No KTP";
    row.tag = @"1";
    row.type = XLFormRowDescriptorTypeFloatLabeledTextField;
    row.required = NO;
    row.sort = 10;
    [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuFormPengajuanApplikasi]];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuListOnlineSubmission]];
    [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
    [realm addObject:row];
    [form.rows addObject:row];
    
    row = [[FormRow alloc] init];
    row.title = @"Tempat Lahir";
    row.tag = @"2";
    row.type = XLFormRowDescriptorTypeFloatLabeledTextField;
    row.required = NO;
    row.sort = 20;
    [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuFormPengajuanApplikasi]];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuListOnlineSubmission]];
    [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
    [realm addObject:row];
    [form.rows addObject:row];
    
    row = [[FormRow alloc] init];
    row.title = @"Tanggal Lahir";
    row.tag = @"3";
    row.type = XLFormRowDescriptorTypeDateInline;
    row.required = NO;
    row.sort = 30;
    [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuFormPengajuanApplikasi]];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuListOnlineSubmission]];
    [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
    [realm addObject:row];
    [form.rows addObject:row];
    
    row = [[FormRow alloc] init];
    row.title = @"Alamat";
    row.tag = @"4";
    row.type = XLFormRowDescriptorTypeFloatLabeledTextField;
    row.required = NO;
    row.sort = 40;
    [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuFormPengajuanApplikasi]];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuListOnlineSubmission]];
    [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
    [realm addObject:row];
    [form.rows addObject:row];
    [realm addObject:form];

//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Data Aset";
    form.sort = 20;
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuFormPengajuanApplikasi]];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuListOnlineSubmission]];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
    
    row = [[FormRow alloc] init];
    row.title = @"Tipe Produk";
    row.tag = @"0";
    row.type = XLFormRowDescriptorTypeSelectorPush;
    row.required = NO;
    row.sort = 0;
    [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuFormPengajuanApplikasi]];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuListOnlineSubmission]];
    [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
    [row.options addObjects:[self generateOptionWithRealm:realm formRow:row]];
    [realm addObject:row];
    [form.rows addObject:row];
    
    row = [[FormRow alloc] init];
    row.title = @"Tipe Kendaraan";
    row.tag = @"1";
    row.type = XLFormRowDescriptorTypeSelectorPush;
    row.required = NO;
    row.sort = 10;
    [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuFormPengajuanApplikasi]];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuListOnlineSubmission]];
    [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
    [row.options addObjects:[self generateOptionWithRealm:realm formRow:row]];
    [realm addObject:row];
    [form.rows addObject:row];
    [realm addObject:form];
    
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Struktur Pembiayaan";
    form.sort = 30;
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuFormPengajuanApplikasi]];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuListOnlineSubmission]];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
    
    row = [[FormRow alloc] init];
    row.title = @"Harga Perolehan";
    row.tag = @"0";
    row.type = XLFormRowDescriptorTypeFloatLabeledTextField;
    row.required = NO;
    row.sort = 0;
    [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuFormPengajuanApplikasi]];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuListOnlineSubmission]];
    [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
    [realm addObject:row];
    [form.rows addObject:row];
    
    row = [[FormRow alloc] init];
    row.title = @"Uang Muka (DP)";
    row.tag = @"1";
    row.type = XLFormRowDescriptorTypeFloatLabeledTextField;
    row.required = NO;
    row.sort = 10;
    [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuFormPengajuanApplikasi]];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuListOnlineSubmission]];
    [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
    [realm addObject:row];
    [form.rows addObject:row];
    
    row = [[FormRow alloc] init];
    row.title = @"Jangka Waktu Pembiayaan";
    row.tag = @"2";
    row.type = XLFormRowDescriptorTypeFloatLabeledTextField;
    row.required = NO;
    row.sort = 20;
    [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuFormPengajuanApplikasi]];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuListOnlineSubmission]];
    [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
    [realm addObject:row];
    [form.rows addObject:row];
    
    row = [[FormRow alloc] init];
    row.title = @"Angsuran";
    row.tag = @"3";
    row.type = XLFormRowDescriptorTypeFloatLabeledTextField;
    row.required = NO;
    row.sort = 30;
    [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuFormPengajuanApplikasi]];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuListOnlineSubmission]];
    [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
    [realm addObject:row];
    [form.rows addObject:row];
    [realm addObject:form];
    
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Data Pekerjaan";
    form.sort = 40;
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuFormPengajuanApplikasi]];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuListOnlineSubmission]];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
    
    row = [[FormRow alloc] init];
    row.title = @"Nama Tempat Kerja";
    row.tag = @"0";
    row.type = XLFormRowDescriptorTypeFloatLabeledTextField;
    row.required = NO;
    row.sort = 0;
    [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuFormPengajuanApplikasi]];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuListOnlineSubmission]];
    [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
    [realm addObject:row];
    [form.rows addObject:row];
    
    row = [[FormRow alloc] init];
    row.title = @"Nomor Telepon Tempat Kerja";
    row.tag = @"1";
    row.type = XLFormRowDescriptorTypeFloatLabeledTextField;
    row.required = NO;
    row.sort = 10;
    [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuFormPengajuanApplikasi]];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuListOnlineSubmission]];
    [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
    [realm addObject:row];
    [form.rows addObject:row];
    [realm addObject:form];
    
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Data E-con";
    form.sort = 50;
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuFormPengajuanApplikasi]];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuListOnlineSubmission]];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
    
    row = [[FormRow alloc] init];
    row.title = @"Nama E-con";
    row.tag = @"0";
    row.type = XLFormRowDescriptorTypeFloatLabeledTextField;
    row.required = NO;
    row.sort = 0;
    [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuFormPengajuanApplikasi]];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuListOnlineSubmission]];
    [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
    [realm addObject:row];
    [form.rows addObject:row];
    
    row = [[FormRow alloc] init];
    row.title = @"Nomor Telepon E-con";
    row.tag = @"1";
    row.type = XLFormRowDescriptorTypeFloatLabeledTextField;
    row.required = NO;
    row.sort = 10;
    [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuFormPengajuanApplikasi]];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuListOnlineSubmission]];
    [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
    [realm addObject:row];
    [form.rows addObject:row];
    
    row = [[FormRow alloc] init];
    row.title = @"Tambahan";
    row.tag = @"2";
    row.type = XLFormRowDescriptorTypeFloatLabeledTextField;
    row.required = NO;
    row.sort = 20;
    [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuFormPengajuanApplikasi]];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuListOnlineSubmission]];
    [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
    [realm addObject:row];
    [form.rows addObject:row];
    [realm addObject:form];
    
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"MAP Data Aplikasi";
    form.sort = 0;
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuDataMAP]];
    [form.rows addObjects:[self generateFormRowsWithRealm:realm form:form]];
    [realm addObject:form];
    
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Data Pribadi";
    form.sort = 10;
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuDataMAP]];
    [form.rows addObjects:[self generateFormRowsWithRealm:realm form:form]];
    [realm addObject:form];
    
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Data Pekerjaan";
    form.sort = 20;
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuDataMAP]];
    [form.rows addObjects:[self generateFormRowsWithRealm:realm form:form]];
    [realm addObject:form];
    
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Kartu Kredit / Pinjaman Lain";
    form.sort = 30;
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuDataMAP]];
    [form.rows addObjects:[self generateFormRowsWithRealm:realm form:form]];
    [realm addObject:form];
    
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Data Pasangan";
    form.sort = 40;
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuDataMAP]];
    [form.rows addObjects:[self generateFormRowsWithRealm:realm form:form]];
    [realm addObject:form];
    
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Data Pekerjaan Pasangan";
    form.sort = 50;
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuDataMAP]];
    [form.rows addObjects:[self generateFormRowsWithRealm:realm form:form]];
    [realm addObject:form];
    
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Data Keluarga";
    form.sort = 60;
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuDataMAP]];
    [form.rows addObjects:[self generateFormRowsWithRealm:realm form:form]];
    [realm addObject:form];
    
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Struktur Pembayaran";
    form.sort = 70;
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuDataMAP]];
    [form.rows addObjects:[self generateFormRowsWithRealm:realm form:form]];
    [realm addObject:form];
    
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Asuransi";
    form.sort = 80;
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuDataMAP]];
    [form.rows addObjects:[self generateFormRowsWithRealm:realm form:form]];
    [realm addObject:form];
    
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Data Aset";
    form.sort = 90;
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuDataMAP]];
    [form.rows addObjects:[self generateFormRowsWithRealm:realm form:form]];
    [realm addObject:form];
    
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Data E-con";
    form.sort = 100;
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuDataMAP]];
    [form.rows addObjects:[self generateFormRowsWithRealm:realm form:form]];
    [realm addObject:form];
    
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"MAP Penjamin";
    form.sort = 110;
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuDataMAP]];
    [form.rows addObjects:[self generateFormRowsWithRealm:realm form:form]];
    [realm addObject:form];
    
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Data Marketing";
    form.sort = 120;
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuDataMAP]];
    [form.rows addObjects:[self generateFormRowsWithRealm:realm form:form]];
    [realm addObject:form];
    
    [realm commitWriteTransaction];
}

+ (NSMutableArray *)generateFormRowsWithRealm:(RLMRealm *)realm form:(Form *)form{
    NSMutableArray *rows = [NSMutableArray array];
    
    return rows;
}

+ (NSMutableArray *)generateOptionWithRealm:(RLMRealm *)realm formRow:(FormRow *)formRow{
    NSMutableArray *options = [NSMutableArray array];
    
    if ([formRow.title isEqualToString:@"Tipe Produk"]) {
        Option *option = [[Option alloc] init];
        option.name = @"SUV";
        [realm addObject:option];
        [options addObject:option];
        
        option = [[Option alloc] init];
        option.name = @"SUV";
        [realm addObject:option];
        [options addObject:option];
    }
    
    if ([formRow.title isEqualToString:@"Tipe Kendaraan"]) {
        Option *option = [[Option alloc] init];
        option.name = @"SUV";
        [realm addObject:option];
        [options addObject:option];
        
        option = [[Option alloc] init];
        option.name = @"SUV";
        [realm addObject:option];
        [options addObject:option];
    }
    
    return options;
}

@end
