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
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuDataMAP]];
    [realm addObject:form];
    
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Kartu Kredit / Pinjaman Lain";
    form.sort = 30;
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuDataMAP]];
    [realm addObject:form];
    
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Data Pasangan";
    form.sort = 40;
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuDataMAP]];
    [realm addObject:form];
    
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Data Pekerjaan Pasangan";
    form.sort = 50;
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuDataMAP]];
    [realm addObject:form];
    
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Data Keluarga";
    form.sort = 60;
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuDataMAP]];
    [realm addObject:form];
    
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Struktur Pembayaran";
    form.sort = 70;
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuDataMAP]];
    [realm addObject:form];
    
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Asuransi";
    form.sort = 80;
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuDataMAP]];
    [realm addObject:form];
    
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Data Aset";
    form.sort = 90;
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuDataMAP]];
    [realm addObject:form];
    
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Data E-con";
    form.sort = 100;
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuDataMAP]];
    [realm addObject:form];
    
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"MAP Penjamin";
    form.sort = 110;
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuDataMAP]];
    [realm addObject:form];
    
//=====================================================================================================
    form = [[Form alloc] init];
    form.title = @"Data Marketing";
    form.sort = 120;
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuDataMAP]];
    [realm addObject:form];
    
//=====================================================================================================
    form = [[Form alloc] init];
    form.sort = 130;
    [form.rows addObjects:[FormRow getRowsWithCategoryNumber:9]];
    
    [form.menus addObject:[Menu objectForPrimaryKey:kSubmenuNewBike]];
    [realm addObject:form];

    
    [realm commitWriteTransaction];
}

@end
