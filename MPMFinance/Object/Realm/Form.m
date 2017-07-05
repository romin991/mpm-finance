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
    [form.rows addObjects:[FormRow getRowsWithCategoryNumber:0]];
    
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuFormPengajuanApplikasi]];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuListOnlineSubmission]];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
    [realm addObject:form];
    
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Data Pasangan";
    form.sort = 10;
    [form.rows addObjects:[FormRow getRowsWithCategoryNumber:1]];
    
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuFormPengajuanApplikasi]];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuListOnlineSubmission]];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
    [realm addObject:form];

//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Data Aset";
    form.sort = 20;
    [form.rows addObjects:[FormRow getRowsWithCategoryNumber:2]];
    
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuFormPengajuanApplikasi]];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuListOnlineSubmission]];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
    [realm addObject:form];
    
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Struktur Pembiayaan";
    form.sort = 30;
    [form.rows addObjects:[FormRow getRowsWithCategoryNumber:3]];
    
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuFormPengajuanApplikasi]];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuListOnlineSubmission]];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
    [realm addObject:form];
    
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Data Pekerjaan";
    form.sort = 40;
    [form.rows addObjects:[FormRow getRowsWithCategoryNumber:4]];
    
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuFormPengajuanApplikasi]];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuListOnlineSubmission]];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
    [realm addObject:form];
    
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Data E-con";
    form.sort = 50;
    [form.rows addObjects:[FormRow getRowsWithCategoryNumber:5]];
    
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuFormPengajuanApplikasi]];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuListOnlineSubmission]];
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
    [realm addObject:form];
    
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"MAP Data Aplikasi";
    form.sort = 0;
    [form.rows addObjects:[FormRow getRowsWithCategoryNumber:6]];
    
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
    
    FormSection *section = [[FormSection alloc] init];
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
