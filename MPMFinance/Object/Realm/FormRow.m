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
    
    //Data Pasangan
    [FormRow new:realm :1 :0 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nama Pasangan"];
    [FormRow new:realm :1 :1 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"No KTP"];
    [FormRow new:realm :1 :2 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Tempat Lahir"];
    [FormRow new:realm :1 :3 :NO :XLFormRowDescriptorTypeDateInline :@"Tanggal Lahir"];
    [FormRow new:realm :1 :4 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Alamat"];
    
    //Data Aset
    [FormRow new:realm :2 :0 :NO :XLFormRowDescriptorTypeSelectorPush :@"Tipe Produk" :2];
    [FormRow new:realm :2 :1 :NO :XLFormRowDescriptorTypeSelectorPush :@"Tipe Kendaraan"];
    
    //Struktur Pembiayaan
    [FormRow new:realm :3 :0 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Harga Perolehan"];
    [FormRow new:realm :3 :1 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Uang Muka (DP)"];
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
    [FormRow new:realm :6 :0 :NO :XLFormRowDescriptorTypeSelectorPush :@"Sumber Aplikasi"];
    [FormRow new:realm :6 :1 :NO :XLFormRowDescriptorTypeSelectorPush :@"Tujuan Pembiayaan" :0];
    [FormRow new:realm :6 :2 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Kode Aplikasi"];
    [FormRow new:realm :6 :3 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Kode Cabang"];
    [FormRow new:realm :6 :4 :NO :XLFormRowDescriptorTypeDateInline :@"Tanggal Perjanjian"];
    [FormRow new:realm :6 :5 :NO :XLFormRowDescriptorTypeSelectorPush :@"Source of application"];
    [FormRow new:realm :6 :6 :NO :XLFormRowDescriptorTypeSelectorPush :@"Product" :2];
    [FormRow new:realm :6 :7 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Product Offering"];
    [FormRow new:realm :6 :8 :NO :XLFormRowDescriptorTypeSelectorPush :@"Jarak Tempuh" :3];
    [FormRow new:realm :6 :9 :NO :XLFormRowDescriptorTypeSelectorPush :@"Application Priority" :4];
    [FormRow new:realm :6 :10 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Kode Applikasi"];
    
    //Data Pribadi
    [FormRow new:realm :7 :0 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nama Lengkap"];
    [FormRow new:realm :7 :1 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"KTP"];
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
    [FormRow new:realm :8 :6 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Lama Bekerja"];
    [FormRow new:realm :8 :7 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Pendapatan Per Tahun"];
    [FormRow new:realm :8 :8 :NO :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nama Perusahaan"];

    [FormRow generateCreditSimulationFieldsWithRealm:realm];
    [realm commitWriteTransaction];
}
+(void)generateCreditSimulationFieldsWithRealm:(RLMRealm*)realm
{
    [FormRow new:realm :9 :0 :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"Harga"];
    [FormRow new:realm :9 :1 :YES :XLFormRowDescriptorTypeSelectorPush :@"Lama Pembiayaan" :31];
    [FormRow new:realm :9 :2 :YES :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"Nilai Pembiayaan" :-1];
    [FormRow new:realm :9 :3 :YES :YES :XLFormRowDescriptorTypeFloatLabeledTextField :@"Angsuran" :-1];
    
}

+ (void)new:(RLMRealm *)realm :(NSInteger)category :(NSInteger)sort :(BOOL)required :(NSString *)type :(NSString *)title{
    [FormRow new:realm :category :sort :required :type :title :-1];
}

+ (void)new:(RLMRealm *)realm :(NSInteger)category :(NSInteger)sort :(BOOL)required :(NSString *)type :(NSString *)title :(NSInteger)optionCategory{
    [FormRow new:realm :category :sort :required :NO :type :title :optionCategory];
}

+ (void)new:(RLMRealm *)realm :(NSInteger)category :(NSInteger)sort :(BOOL)required :(BOOL)disabled :(NSString *)type :(NSString *)title :(NSInteger)optionCategory{
    FormRow *row = [[FormRow alloc] init];
    row.title = title;
    row.type = type;
    row.sort = sort;
    row.category = category;
    row.required = required;
    row.disabled = disabled;
    if (optionCategory >= 0) {
        RLMResults *options = [Option getOptionWithCategoryNumber:optionCategory];
        [row.options addObjects:options];
    }
    
    [realm addObject:row];
}

@end
