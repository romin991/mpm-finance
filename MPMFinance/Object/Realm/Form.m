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
    
    Form *form = [[Form alloc] init];
    form.title = @"Data Pemohon";
    form.sort = 0;
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuListPengajuanApplikasi]];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
    [form.rows addObjects:[self generateFormRowsWithRealm:realm form:form]];
    [realm addObject:form];
    
    form = [[Form alloc] init];
    form.title = @"Data Pasangan";
    form.sort = 1;
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuListPengajuanApplikasi]];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
    [form.rows addObjects:[self generateFormRowsWithRealm:realm form:form]];
    [realm addObject:form];
    
    form = [[Form alloc] init];
    form.title = @"Data Aset";
    form.sort = 2;
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuListPengajuanApplikasi]];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
    [form.rows addObjects:[self generateFormRowsWithRealm:realm form:form]];
    [realm addObject:form];
    
    form = [[Form alloc] init];
    form.title = @"Struktur Pembiayaan";
    form.sort = 3;
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuListPengajuanApplikasi]];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
    [form.rows addObjects:[self generateFormRowsWithRealm:realm form:form]];
    [realm addObject:form];
    
    form = [[Form alloc] init];
    form.title = @"Data Pekerjaan";
    form.sort = 4;
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuListPengajuanApplikasi]];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
    [form.rows addObjects:[self generateFormRowsWithRealm:realm form:form]];
    [realm addObject:form];
    
    form = [[Form alloc] init];
    form.title = @"Data E-con";
    form.sort = 5;
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuListPengajuanApplikasi]];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
    [form.rows addObjects:[self generateFormRowsWithRealm:realm form:form]];
    [realm addObject:form];
    
    [realm commitWriteTransaction];
}

+ (NSMutableArray *)generateFormRowsWithRealm:(RLMRealm *)realm form:(Form *)form{
    NSMutableArray *rows = [NSMutableArray array];
    
    if ([form.title isEqualToString:@"Data Pemohon"]) {
        FormRow *row = [[FormRow alloc] init];
        row.title = @"Nama Calon Debitur";
        row.tag = @"0";
        row.type = XLFormRowDescriptorTypeFloatLabeledTextField;
        row.required = NO;
        row.sort = 0;
        [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuListPengajuanApplikasi]];
        [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
        [realm addObject:row];
        [rows addObject:row];
        
        row = [[FormRow alloc] init];
        row.title = @"No KTP";
        row.tag = @"1";
        row.type = XLFormRowDescriptorTypeFloatLabeledTextField;
        row.required = NO;
        row.sort = 1;
        [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuListPengajuanApplikasi]];
        [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
        [realm addObject:row];
        [rows addObject:row];
        
        row = [[FormRow alloc] init];
        row.title = @"Tempat Lahir";
        row.tag = @"2";
        row.type = XLFormRowDescriptorTypeFloatLabeledTextField;
        row.required = NO;
        row.sort = 2;
        [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuListPengajuanApplikasi]];
        [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
        [realm addObject:row];
        [rows addObject:row];
        
        row = [[FormRow alloc] init];
        row.title = @"Tanggal Lahir";
        row.tag = @"3";
        row.type = XLFormRowDescriptorTypeDateInline;
        row.required = NO;
        row.sort = 3;
        [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuListPengajuanApplikasi]];
        [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
        [realm addObject:row];
        [rows addObject:row];
        
        row = [[FormRow alloc] init];
        row.title = @"Alamat Rumah Sesuai KTP";
        row.tag = @"4";
        row.type = XLFormRowDescriptorTypeFloatLabeledTextField;
        row.required = NO;
        row.sort = 4;
        [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuListPengajuanApplikasi]];
        [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
        [realm addObject:row];
        [rows addObject:row];
    }
    
    if ([form.title isEqualToString:@"Data Pasangan"]) {
        FormRow *row = [[FormRow alloc] init];
        row.title = @"Nama Pasangan";
        row.tag = @"0";
        row.type = XLFormRowDescriptorTypeFloatLabeledTextField;
        row.required = NO;
        row.sort = 0;
        [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuListPengajuanApplikasi]];
        [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
        [realm addObject:row];
        [rows addObject:row];
        
        row = [[FormRow alloc] init];
        row.title = @"No KTP";
        row.tag = @"1";
        row.type = XLFormRowDescriptorTypeFloatLabeledTextField;
        row.required = NO;
        row.sort = 1;
        [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuListPengajuanApplikasi]];
        [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
        [realm addObject:row];
        [rows addObject:row];
        
        row = [[FormRow alloc] init];
        row.title = @"Tempat Lahir";
        row.tag = @"2";
        row.type = XLFormRowDescriptorTypeFloatLabeledTextField;
        row.required = NO;
        row.sort = 2;
        [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuListPengajuanApplikasi]];
        [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
        [realm addObject:row];
        [rows addObject:row];
        
        row = [[FormRow alloc] init];
        row.title = @"Tanggal Lahir";
        row.tag = @"3";
        row.type = XLFormRowDescriptorTypeDateInline;
        row.required = NO;
        row.sort = 3;
        [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuListPengajuanApplikasi]];
        [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
        [realm addObject:row];
        [rows addObject:row];
        
        row = [[FormRow alloc] init];
        row.title = @"Alamat";
        row.tag = @"4";
        row.type = XLFormRowDescriptorTypeFloatLabeledTextField;
        row.required = NO;
        row.sort = 4;
        [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuListPengajuanApplikasi]];
        [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
        [realm addObject:row];
        [rows addObject:row];
    }
    
    if ([form.title isEqualToString:@"Data Aset"]) {
        FormRow *row = [[FormRow alloc] init];
        row.title = @"Tipe Produk";
        row.tag = @"0";
        row.type = XLFormRowDescriptorTypeSelectorPush;
        row.required = NO;
        row.sort = 0;
        [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuListPengajuanApplikasi]];
        [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
        [row.options addObjects:[self generateOptionWithRealm:realm formRow:row]];
        [realm addObject:row];
        [rows addObject:row];
        
        row = [[FormRow alloc] init];
        row.title = @"Tipe Kendaraan";
        row.tag = @"1";
        row.type = XLFormRowDescriptorTypeSelectorPush;
        row.required = NO;
        row.sort = 1;
        [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuListPengajuanApplikasi]];
        [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
        [row.options addObjects:[self generateOptionWithRealm:realm formRow:row]];
        [realm addObject:row];
        [rows addObject:row];
    }
    
    if ([form.title isEqualToString:@"Struktur Pembiayaan"]) {
        FormRow *row = [[FormRow alloc] init];
        row.title = @"Harga Perolehan";
        row.tag = @"0";
        row.type = XLFormRowDescriptorTypeFloatLabeledTextField;
        row.required = NO;
        row.sort = 0;
        [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuListPengajuanApplikasi]];
        [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
        [realm addObject:row];
        [rows addObject:row];
        
        row = [[FormRow alloc] init];
        row.title = @"Uang Muka (DP)";
        row.tag = @"1";
        row.type = XLFormRowDescriptorTypeFloatLabeledTextField;
        row.required = NO;
        row.sort = 1;
        [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuListPengajuanApplikasi]];
        [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
        [realm addObject:row];
        [rows addObject:row];
        
        row = [[FormRow alloc] init];
        row.title = @"Jangka Waktu Pembiayaan";
        row.tag = @"2";
        row.type = XLFormRowDescriptorTypeFloatLabeledTextField;
        row.required = NO;
        row.sort = 2;
        [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuListPengajuanApplikasi]];
        [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
        [realm addObject:row];
        [rows addObject:row];
        
        row = [[FormRow alloc] init];
        row.title = @"Angsuran";
        row.tag = @"3";
        row.type = XLFormRowDescriptorTypeFloatLabeledTextField;
        row.required = NO;
        row.sort = 3;
        [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuListPengajuanApplikasi]];
        [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
        [realm addObject:row];
        [rows addObject:row];
    }
    
    if ([form.title isEqualToString:@"Data Pekerjaan"]) {
        FormRow *row = [[FormRow alloc] init];
        row.title = @"Nama Tempat Kerja";
        row.tag = @"0";
        row.type = XLFormRowDescriptorTypeFloatLabeledTextField;
        row.required = NO;
        row.sort = 0;
        [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuListPengajuanApplikasi]];
        [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
        [realm addObject:row];
        [rows addObject:row];
        
        row = [[FormRow alloc] init];
        row.title = @"Nomor Telepon Tempat Kerja";
        row.tag = @"1";
        row.type = XLFormRowDescriptorTypeFloatLabeledTextField;
        row.required = NO;
        row.sort = 1;
        [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuListPengajuanApplikasi]];
        [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
        [realm addObject:row];
        [rows addObject:row];
    }
    
    if ([form.title isEqualToString:@"Data E-con"]) {
        FormRow *row = [[FormRow alloc] init];
        row.title = @"Nama E-con";
        row.tag = @"0";
        row.type = XLFormRowDescriptorTypeFloatLabeledTextField;
        row.required = NO;
        row.sort = 0;
        [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuListPengajuanApplikasi]];
        [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
        [realm addObject:row];
        [rows addObject:row];
        
        row = [[FormRow alloc] init];
        row.title = @"Nomor Telepon E-con";
        row.tag = @"1";
        row.type = XLFormRowDescriptorTypeFloatLabeledTextField;
        row.required = NO;
        row.sort = 1;
        [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuListPengajuanApplikasi]];
        [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
        [realm addObject:row];
        [rows addObject:row];
        
        row = [[FormRow alloc] init];
        row.title = @"Tambahan";
        row.tag = @"2";
        row.type = XLFormRowDescriptorTypeFloatLabeledTextField;
        row.required = NO;
        row.sort = 2;
        [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuListPengajuanApplikasi]];
        [row.menus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
        [realm addObject:row];
        [rows addObject:row];
    }
    
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
