//
//  DataMAPFormViewController.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 6/6/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "DataMAPFormViewController.h"
#import <XLForm.h>
#import "Form.h"
#import "DropdownModel.h"
#import "FormModel.h"
#import "FloatLabeledTextFieldCell.h"
#import "ProfileModel.h"
#import "DataMAPModel.h"
#import "PostalCodeValueTransformer.h"
#import "DropdownValueTransformer.h"

@interface DataMAPFormViewController ()

@property RLMResults *forms;

@end

@implementation DataMAPFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    // Do any additional setup after loading the view from its nib.
    
    self.forms = [Form getFormForMenu:self.menu.primaryKey];
    Form *currentForm = [self.forms objectAtIndex:self.index];
    [self setTitle:currentForm.title];
    
    [SVProgressHUD show];
    __block DataMAPFormViewController *weakSelf = self;
    
    if (self.valueDictionary.count == 0) self.valueDictionary = [NSMutableDictionary dictionary];
    
    [self preparingValueWithCompletion:^{
        [self preparingFormDescriptorWithCompletion:^{
            if ([self.title isEqualToString:@"Data Keluarga"]) {
                NSInteger counter = 0;
                for (NSDictionary *data in [weakSelf.valueDictionary objectForKey:@"dataKeluarga"]) {
                    XLFormSectionDescriptor *section = [self.form formSectionAtIndex:counter];
                    counter += 1;
                    [FormModel loadValueFrom:data to:section on:weakSelf partialUpdate:nil];
                }
            } else {
                [FormModel loadValueFrom:weakSelf.valueDictionary on:weakSelf partialUpdate:nil];
            }
            [SVProgressHUD dismiss];
        }];
    }];
}

- (void)preparingFormDescriptorWithCompletion:(void(^)())block{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    __block DataMAPFormViewController *weakSelf = self;
    __block NSError *_error = nil;
    __block XLFormDescriptor *_formDescriptor;
    
    dispatch_group_enter(group);
    Form *currentForm = [self.forms objectAtIndex:self.index];
    [FormModel generate:self.form form:currentForm completion:^(XLFormDescriptor *formDescriptor, NSError *error) {
        if (error) _error = error;
        if (formDescriptor) _formDescriptor = formDescriptor;
        dispatch_group_leave(group);
    }];
    
    dispatch_group_notify(group, queue, ^{
        NSString *idCabang = [self.valueDictionary objectForKey:@"kodeCabang"] ?: @"";
        NSString *idProduct = [self.valueDictionary objectForKey:@"produk"] ?: @"";
        NSString *sumberAplikasi = [self.valueDictionary objectForKey:@"sumberAplikasi"] ?: @"";
        
        if ([self.title isEqualToString:@"Data Keluarga"]) {
            NSInteger familyCount = ((NSArray *)[self.valueDictionary objectForKey:@"dataKeluarga"]).count;
            for (int i = 1; i < familyCount; i++){
                [self addFamilyButtonClicked:nil];
            }
        }
        
        for (XLFormSectionDescriptor *section in _formDescriptor.formSections) {
            for (XLFormRowDescriptor *row in section.formRows) {
                if (self.isReadOnly) {
                    row.disabled = @YES;
                }
                
                if ([row.tag isEqualToString:@"submit"]){
                    row.action.formSelector = @selector(saveButtonClicked:);
                }
                if ([row.tag isEqualToString:@"tambahDataKeluarga"]){
                    row.action.formSelector = @selector(addFamilyButtonClicked:);
                }
                if ([row.tag isEqualToString:@"hapusDataKeluarga"]){
                    row.action.formSelector = @selector(deleteFamilyButtonClicked:);
                }
                
                if ([row.tag isEqualToString:@"kodeCabang"]) {
                    if ([sumberAplikasi integerValue] == 2) {
                        row.title = @"Nama KP";
                    } else if ([sumberAplikasi integerValue] == 1){
                        row.title = @"Kode Cabang";
                    }
                }
                
                //Data Aplikasi
                if ([row.tag isEqualToString:@"jenisAplikasi"]){
                    dispatch_group_enter(group);
                    [DropdownModel getDropdownWSType:@"jenisAplikasi" keyword:@"" idCabang:idCabang additionalURL:@"" completion:^(NSArray *datas, NSError *error) {
                        @try {
                            if (error) {
                                _error = error;
                                
                            } else {
                                NSMutableArray *optionObjects = [NSMutableArray array];
                                for (Data *data in datas) {
                                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:data.value displayText:data.name]];
                                }
                                row.selectorOptions = optionObjects;
                            }
                            
                        } @catch (NSException *exception) {
                            NSLog(@"%@", exception);
                        } @finally {
                            dispatch_group_leave(group);
                            NSLog(@"leave");
                        }
                    }];
                }
                
                if ([row.tag isEqualToString:@"applicationPriority"]){
                    dispatch_group_enter(group);
                    [DropdownModel getDropdownWSType:@"ApplicationPriority" keyword:@"" idCabang:idCabang additionalURL:@"" completion:^(NSArray *datas, NSError *error) {
                        @try {
                            if (error) {
                                _error = error;
                                
                            } else {
                                NSMutableArray *optionObjects = [NSMutableArray array];
                                for (Data *data in datas) {
                                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:data.value displayText:data.name]];
                                }
                                row.selectorOptions = optionObjects;
                            }
                            
                        } @catch (NSException *exception) {
                            NSLog(@"%@", exception);
                        } @finally {
                            dispatch_group_leave(group);
                            NSLog(@"leave");
                        }
                    }];
                }
                
                if ([row.tag isEqualToString:@"sourceOfApplication"]){
                    dispatch_group_enter(group);
                    [DropdownModel getDropdownWSType:@"SourceOfApplication" keyword:@"" idProduct:idProduct idCabang:idCabang additionalURL:@"sourceofapplication" completion:^(NSArray *datas, NSError *error) {
                        @try {
                            if (error) {
                                _error = error;
                                
                            } else {
                                NSMutableArray *optionObjects = [NSMutableArray array];
                                for (Data *data in datas) {
                                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:data.value displayText:data.name]];
                                }
                                row.selectorOptions = optionObjects;
                            }
                            
                        } @catch (NSException *exception) {
                            NSLog(@"%@", exception);
                        } @finally {
                            dispatch_group_leave(group);
                            NSLog(@"leave");
                        }
                    }];
                }
                
                if ([row.tag isEqualToString:@"productOffering"]){
                    dispatch_group_enter(group);
                    [DropdownModel getDropdownWSType:@"Product" keyword:@"" idProduct:idProduct idCabang:idCabang additionalURL:@"productlist" completion:^(NSArray *datas, NSError *error) {
                        @try {
                            if (error) {
                                _error = error;
                                
                            } else {
                                NSMutableArray *optionObjects = [NSMutableArray array];
                                for (Data *data in datas) {
                                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:data.value displayText:data.name]];
                                }
                                row.selectorOptions = optionObjects;
                            }
                            
                        } @catch (NSException *exception) {
                            NSLog(@"%@", exception);
                        } @finally {
                            dispatch_group_leave(group);
                            NSLog(@"leave");
                        }
                    }];
                }
                
                if ([row.tag isEqualToString:@"lokasiPemakaianAset"]){
                    NSMutableArray *optionObjects = [NSMutableArray array];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@(0) displayText:@"Alamat Sesuai KTP"]];
                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@(1) displayText:@"Alamat Domisili"]];
                    row.selectorOptions = optionObjects;
                    
                }
                
                //Data Pribadi
                if ([row.tag isEqualToString:@"agama"]){
                    dispatch_group_enter(group);
                    [DropdownModel getDropdownWSType:@"Agama" keyword:@"" idCabang:idCabang additionalURL:@"" completion:^(NSArray *datas, NSError *error) {
                        @try {
                            if (error) {
                                _error = error;
                                
                            } else {
                                NSMutableArray *optionObjects = [NSMutableArray array];
                                for (Data *data in datas) {
                                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:data.value displayText:data.name]];
                                }
                                row.selectorOptions = optionObjects;
                            }
                            
                        } @catch (NSException *exception) {
                            NSLog(@"%@", exception);
                        } @finally {
                            dispatch_group_leave(group);
                            NSLog(@"leave");
                        }
                    }];
                }
                
                if ([row.tag isEqualToString:@"statusPernikahan"]){
                    dispatch_group_enter(group);
                    [DropdownModel getDropdownWSType:@"StatusPernikahan" keyword:@"" idCabang:idCabang additionalURL:@"" completion:^(NSArray *datas, NSError *error) {
                        @try {
                            if (error) {
                                _error = error;
                                
                            } else {
                                NSMutableArray *optionObjects = [NSMutableArray array];
                                for (Data *data in datas) {
                                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:data.value displayText:data.name]];
                                }
                                row.selectorOptions = optionObjects;
                            }
                            
                        } @catch (NSException *exception) {
                            NSLog(@"%@", exception);
                        } @finally {
                            dispatch_group_leave(group);
                            NSLog(@"leave");
                        }
                    }];
                }
                
                if ([row.tag isEqualToString:@"statusKepemilikanRumah"]){
                    dispatch_group_enter(group);
                    [DropdownModel getDropdownWSType:@"StatusKepemilikanRumah" keyword:@"" idCabang:idCabang additionalURL:@"" completion:^(NSArray *datas, NSError *error) {
                        @try {
                            if (error) {
                                _error = error;
                                
                            } else {
                                NSMutableArray *optionObjects = [NSMutableArray array];
                                for (Data *data in datas) {
                                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:data.value displayText:data.name]];
                                }
                                row.selectorOptions = optionObjects;
                            }
                            
                        } @catch (NSException *exception) {
                            NSLog(@"%@", exception);
                        } @finally {
                            dispatch_group_leave(group);
                            NSLog(@"leave");
                        }
                    }];
                }
                
                if ([row.tag isEqualToString:@"lokasiRumah"]){
                    dispatch_group_enter(group);
                    [DropdownModel getDropdownWSType:@"LokasiRumah" keyword:@"" idCabang:idCabang additionalURL:@"" completion:^(NSArray *datas, NSError *error) {
                        @try {
                            if (error) {
                                _error = error;
                                
                            } else {
                                NSMutableArray *optionObjects = [NSMutableArray array];
                                for (Data *data in datas) {
                                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:data.value displayText:data.name]];
                                }
                                row.selectorOptions = optionObjects;
                            }
                            
                        } @catch (NSException *exception) {
                            NSLog(@"%@", exception);
                        } @finally {
                            dispatch_group_leave(group);
                            NSLog(@"leave");
                        }
                    }];
                }
                
                if ([row.tag isEqualToString:@"pendidikanTerakhir"]){
                    dispatch_group_enter(group);
                    [DropdownModel getDropdownWSType:@"PendidikanTerakhir" keyword:@"" idCabang:idCabang additionalURL:@"" completion:^(NSArray *datas, NSError *error) {
                        @try {
                            if (error) {
                                _error = error;
                                
                            } else {
                                NSMutableArray *optionObjects = [NSMutableArray array];
                                for (Data *data in datas) {
                                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:data.value displayText:data.name]];
                                }
                                row.selectorOptions = optionObjects;
                            }
                            
                        } @catch (NSException *exception) {
                            NSLog(@"%@", exception);
                        } @finally {
                            dispatch_group_leave(group);
                            NSLog(@"leave");
                        }
                    }];
                }
                
                //Data Pekerjaan
                if ([row.tag isEqualToString:@"pekerjaan"]){
                    row.action.viewControllerNibName = @"DropdownWSViewController";
                    row.valueTransformer = [DropdownValueTransformer class];
                    
                    dispatch_group_enter(group);
                    [DropdownModel getDropdownWSType:@"Pekerjaan" keyword:@"" idCabang:idCabang additionalURL:@"" completion:^(NSArray *datas, NSError *error) {
                        @try {
                            if (error) {
                                _error = error;
                                
                            } else {
                                NSMutableArray *optionObjects = [NSMutableArray array];
                                for (Data *data in datas) {
                                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:data.value displayText:data.name]];
                                }
                                row.selectorOptions = optionObjects;
                            }
                            
                        } @catch (NSException *exception) {
                            NSLog(@"%@", exception);
                        } @finally {
                            dispatch_group_leave(group);
                            NSLog(@"leave");
                        }
                    }];
                }
                
                if ([row.tag isEqualToString:@"bidangUsaha"]){
                    row.action.viewControllerNibName = @"DropdownWSViewController";
                    row.valueTransformer = [DropdownValueTransformer class];
                    
                    dispatch_group_enter(group);
                    [DropdownModel getDropdownWSType:@"BidangUsaha" keyword:@"" idCabang:idCabang additionalURL:@"" completion:^(NSArray *datas, NSError *error) {
                        @try {
                            if (error) {
                                _error = error;
                                
                            } else {
                                NSMutableArray *optionObjects = [NSMutableArray array];
                                for (Data *data in datas) {
                                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:data.value displayText:data.name]];
                                }
                                row.selectorOptions = optionObjects;
                            }
                            
                        } @catch (NSException *exception) {
                            NSLog(@"%@", exception);
                        } @finally {
                            dispatch_group_leave(group);
                            NSLog(@"leave");
                        }
                    }];
                }
                
                if ([row.tag isEqualToString:@"posisiJabatan"]){
                    dispatch_group_enter(group);
                    [DropdownModel getDropdownWSType:@"JobPosition" keyword:@"" idCabang:idCabang additionalURL:@"" completion:^(NSArray *datas, NSError *error) {
                        @try {
                            if (error) {
                                _error = error;
                                
                            } else {
                                NSMutableArray *optionObjects = [NSMutableArray array];
                                for (Data *data in datas) {
                                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:data.value displayText:data.name]];
                                }
                                row.selectorOptions = optionObjects;
                            }
                            
                        } @catch (NSException *exception) {
                            NSLog(@"%@", exception);
                        } @finally {
                            dispatch_group_leave(group);
                            NSLog(@"leave");
                        }
                    }];
                }
                
                //Kartu Kredit / PinjamanLain
                
                //Data Pasangan
                
                //Data Pekerjaan Pasangan
                if ([row.tag isEqualToString:@"kodePosKantorPasangan"]){
                    row.action.viewControllerNibName = @"PostalCodeViewController";
                    row.valueTransformer = [PostalCodeValueTransformer class];
                }
                
                //Data Keluarga
                
                //Struktur Pembiayaan
                if ([row.tag isEqualToString:@"caraPembiayaan"]){
                    dispatch_group_enter(group);
                    [DropdownModel getDropdownWSType:@"WayOfPayment" keyword:@"" idCabang:idCabang additionalURL:@"" completion:^(NSArray *datas, NSError *error) {
                        @try {
                            if (error) {
                                _error = error;
                                
                            } else {
                                NSMutableArray *optionObjects = [NSMutableArray array];
                                for (Data *data in datas) {
                                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:data.value displayText:data.name]];
                                }
                                row.selectorOptions = optionObjects;
                            }
                            
                        } @catch (NSException *exception) {
                            NSLog(@"%@", exception);
                        } @finally {
                            dispatch_group_leave(group);
                            NSLog(@"leave");
                        }
                    }];
                }
                
                if ([row.tag isEqualToString:@"interestType"]){
                    dispatch_group_enter(group);
                    [DropdownModel getDropdownWSType:@"InterestType" keyword:@"" idCabang:idCabang additionalURL:@"" completion:^(NSArray *datas, NSError *error) {
                        @try {
                            if (error) {
                                _error = error;
                                
                            } else {
                                NSMutableArray *optionObjects = [NSMutableArray array];
                                for (Data *data in datas) {
                                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:data.value displayText:data.name]];
                                }
                                row.selectorOptions = optionObjects;
                            }
                            
                        } @catch (NSException *exception) {
                            NSLog(@"%@", exception);
                        } @finally {
                            dispatch_group_leave(group);
                            NSLog(@"leave");
                        }
                    }];
                }
                
                if ([row.tag isEqualToString:@"skemaAngsuran"]){
                    dispatch_group_enter(group);
                    [DropdownModel getDropdownWSType:@"SkemaAngsuran" keyword:@"" idCabang:idCabang additionalURL:@"" completion:^(NSArray *datas, NSError *error) {
                        @try {
                            if (error) {
                                _error = error;
                                
                            } else {
                                NSMutableArray *optionObjects = [NSMutableArray array];
                                for (Data *data in datas) {
                                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:data.value displayText:data.name]];
                                }
                                row.selectorOptions = optionObjects;
                            }
                            
                        } @catch (NSException *exception) {
                            NSLog(@"%@", exception);
                        } @finally {
                            dispatch_group_leave(group);
                            NSLog(@"leave");
                        }
                    }];
                }
                
                if ([row.tag isEqualToString:@"tipeAngsuran"]){
                    dispatch_group_enter(group);
                    [DropdownModel getDropdownWSType:@"TipeAngsuran" keyword:@"" idCabang:idCabang additionalURL:@"" completion:^(NSArray *datas, NSError *error) {
                        @try {
                            if (error) {
                                _error = error;
                                
                            } else {
                                NSMutableArray *optionObjects = [NSMutableArray array];
                                for (Data *data in datas) {
                                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:data.value displayText:data.name]];
                                }
                                row.selectorOptions = optionObjects;
                            }
                            
                        } @catch (NSException *exception) {
                            NSLog(@"%@", exception);
                        } @finally {
                            dispatch_group_leave(group);
                            NSLog(@"leave");
                        }
                    }];
                }
                
                //Asuransi
                if ([row.tag isEqualToString:@"namaAsuransi"]){
                    dispatch_group_enter(group);
                    [DropdownModel getDropdownWSType:@"AsuransiKerugian" keyword:@"" idCabang:idCabang additionalURL:@"" completion:^(NSArray *datas, NSError *error) {
                        @try {
                            if (error) {
                                _error = error;
                                
                            } else {
                                NSMutableArray *optionObjects = [NSMutableArray array];
                                for (Data *data in datas) {
                                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:data.value displayText:data.name]];
                                }
                                row.selectorOptions = optionObjects;
                            }
                            
                        } @catch (NSException *exception) {
                            NSLog(@"%@", exception);
                        } @finally {
                            dispatch_group_leave(group);
                            NSLog(@"leave");
                        }
                    }];
                }
                
                if ([row.tag isEqualToString:@"perusahaanAsuransiJiwa"]){
                    dispatch_group_enter(group);
                    [DropdownModel getDropdownWSType:@"AsuransiJiwa" keyword:@"" idCabang:idCabang additionalURL:@"" completion:^(NSArray *datas, NSError *error) {
                        @try {
                            if (error) {
                                _error = error;
                                
                            } else {
                                NSMutableArray *optionObjects = [NSMutableArray array];
                                for (Data *data in datas) {
                                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:data.value displayText:data.name]];
                                }
                                row.selectorOptions = optionObjects;
                            }
                            
                        } @catch (NSException *exception) {
                            NSLog(@"%@", exception);
                        } @finally {
                            dispatch_group_leave(group);
                            NSLog(@"leave");
                        }
                    }];
                }
                
                if ([row.tag isEqualToString:@"asuransiDibayar"]){
                    dispatch_group_enter(group);
                    [DropdownModel getDropdownWSType:@"AsuransiDibayar" keyword:@"" idCabang:idCabang additionalURL:@"" completion:^(NSArray *datas, NSError *error) {
                        @try {
                            if (error) {
                                _error = error;
                                
                            } else {
                                NSMutableArray *optionObjects = [NSMutableArray array];
                                for (Data *data in datas) {
                                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:data.value displayText:data.name]];
                                }
                                row.selectorOptions = optionObjects;
                            }
                            
                        } @catch (NSException *exception) {
                            NSLog(@"%@", exception);
                        } @finally {
                            dispatch_group_leave(group);
                            NSLog(@"leave");
                        }
                    }];
                }
                
                if ([row.tag isEqualToString:@"jangkaWaktuAsuransi"]){
                    dispatch_group_enter(group);
                    [DropdownModel getDropdownWSType:@"JangkaWaktuAsuransi" keyword:@"" idCabang:idCabang additionalURL:@"" completion:^(NSArray *datas, NSError *error) {
                        @try {
                            if (error) {
                                _error = error;
                                
                            } else {
                                NSMutableArray *optionObjects = [NSMutableArray array];
                                for (Data *data in datas) {
                                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:data.value displayText:data.name]];
                                }
                                row.selectorOptions = optionObjects;
                            }
                            
                        } @catch (NSException *exception) {
                            NSLog(@"%@", exception);
                        } @finally {
                            dispatch_group_leave(group);
                            NSLog(@"leave");
                        }
                    }];
                }
                
                if ([row.tag isEqualToString:@"tipeAsuransi"]){
                    dispatch_group_enter(group);
                    [DropdownModel getDropdownWSType:@"TipeAsuransi" keyword:@"" idCabang:idCabang additionalURL:@"" completion:^(NSArray *datas, NSError *error) {
                        @try {
                            if (error) {
                                _error = error;
                                
                            } else {
                                NSMutableArray *optionObjects = [NSMutableArray array];
                                for (Data *data in datas) {
                                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:data.value displayText:data.name]];
                                }
                                row.selectorOptions = optionObjects;
                            }
                            
                        } @catch (NSException *exception) {
                            NSLog(@"%@", exception);
                        } @finally {
                            dispatch_group_leave(group);
                            NSLog(@"leave");
                        }
                    }];
                }
                
                //Data Asset
                if ([row.tag isEqualToString:@"namaSupplier"]){
                    dispatch_group_enter(group);
                    [DropdownModel getDropdownWSType:@"Supplier" keyword:@"" idCabang:idCabang additionalURL:@"" completion:^(NSArray *datas, NSError *error) {
                        @try {
                            if (error) {
                                _error = error;
                                
                            } else {
                                NSMutableArray *optionObjects = [NSMutableArray array];
                                for (Data *data in datas) {
                                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:data.value displayText:data.name]];
                                }
                                row.selectorOptions = optionObjects;
                            }
                            
                        } @catch (NSException *exception) {
                            NSLog(@"%@", exception);
                        } @finally {
                            dispatch_group_leave(group);
                            NSLog(@"leave");
                        }
                    }];
                }
                
                if ([row.tag isEqualToString:@"assetFinanced"]){
                    dispatch_group_enter(group);
                    [DropdownModel getDropdownWSType:@"AssetFinance" keyword:@"" idCabang:idCabang additionalURL:@"" completion:^(NSArray *datas, NSError *error) {
                        @try {
                            if (error) {
                                _error = error;
                                
                            } else {
                                NSMutableArray *optionObjects = [NSMutableArray array];
                                for (Data *data in datas) {
                                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:data.value displayText:data.name]];
                                }
                                row.selectorOptions = optionObjects;
                            }
                            
                        } @catch (NSException *exception) {
                            NSLog(@"%@", exception);
                        } @finally {
                            dispatch_group_leave(group);
                            NSLog(@"leave");
                        }
                    }];
                }
                
                if ([row.tag isEqualToString:@"pemakaianUnit"]){
                    dispatch_group_enter(group);
                    [DropdownModel getDropdownWSType:@"PemakaianUnit" keyword:@"" idCabang:idCabang additionalURL:@"" completion:^(NSArray *datas, NSError *error) {
                        @try {
                            if (error) {
                                _error = error;
                                
                            } else {
                                NSMutableArray *optionObjects = [NSMutableArray array];
                                for (Data *data in datas) {
                                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:data.value displayText:data.name]];
                                }
                                row.selectorOptions = optionObjects;
                            }
                            
                        } @catch (NSException *exception) {
                            NSLog(@"%@", exception);
                        } @finally {
                            dispatch_group_leave(group);
                            NSLog(@"leave");
                        }
                    }];
                }
                
                if ([row.tag isEqualToString:@"areaKendaraan"]){
                    dispatch_group_enter(group);
                    [DropdownModel getDropdownWSType:@"Region" keyword:@"" idCabang:idCabang additionalURL:@"" completion:^(NSArray *datas, NSError *error) {
                        @try {
                            if (error) {
                                _error = error;
                                
                            } else {
                                NSMutableArray *optionObjects = [NSMutableArray array];
                                for (Data *data in datas) {
                                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:data.value displayText:data.name]];
                                }
                                row.selectorOptions = optionObjects;
                            }
                            
                        } @catch (NSException *exception) {
                            NSLog(@"%@", exception);
                        } @finally {
                            dispatch_group_leave(group);
                            NSLog(@"leave");
                        }
                    }];
                }
                
                //Data E-con
                if ([row.tag isEqualToString:@"hubunganEconDenganPemohon"]){
                    dispatch_group_enter(group);
                    [DropdownModel getDropdownWSType:@"HubunganDenganPemohon" keyword:@"" idCabang:idCabang additionalURL:@"" completion:^(NSArray *datas, NSError *error) {
                        @try {
                            if (error) {
                                _error = error;
                                
                            } else {
                                NSMutableArray *optionObjects = [NSMutableArray array];
                                for (Data *data in datas) {
                                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:data.value displayText:data.name]];
                                }
                                row.selectorOptions = optionObjects;
                            }
                            
                        } @catch (NSException *exception) {
                            NSLog(@"%@", exception);
                        } @finally {
                            dispatch_group_leave(group);
                            NSLog(@"leave");
                        }
                    }];
                }
                
                //Map Penjamin
                if ([row.tag isEqualToString:@"hubunganPenjaminDenganPemohon"]){
                    dispatch_group_enter(group);
                    [DropdownModel getDropdownWSType:@"HubunganKeluarga" keyword:@"" idCabang:idCabang additionalURL:@"" completion:^(NSArray *datas, NSError *error) {
                        @try {
                            if (error) {
                                _error = error;
                                
                            } else {
                                NSMutableArray *optionObjects = [NSMutableArray array];
                                for (Data *data in datas) {
                                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:data.value displayText:data.name]];
                                }
                                row.selectorOptions = optionObjects;
                            }
                            
                        } @catch (NSException *exception) {
                            NSLog(@"%@", exception);
                        } @finally {
                            dispatch_group_leave(group);
                            NSLog(@"leave");
                        }
                    }];
                }
                
                //Data Marketing
                if ([row.tag isEqualToString:@"namaKepalaCabang"]){
                    dispatch_group_enter(group);
                    [DropdownModel getDropdownWSType:@"BM" keyword:@"" idCabang:idCabang additionalURL:@"" completion:^(NSArray *datas, NSError *error) {
                        @try {
                            if (error) {
                                _error = error;
                                
                            } else {
                                NSMutableArray *optionObjects = [NSMutableArray array];
                                for (Data *data in datas) {
                                    [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:data.value displayText:data.name]];
                                }
                                row.selectorOptions = optionObjects;
                            }
                            
                        } @catch (NSException *exception) {
                            NSLog(@"%@", exception);
                        } @finally {
                            dispatch_group_leave(group);
                            NSLog(@"leave");
                        }
                    }];
                }
                
                //other setting
                NSArray *tagForKeyboardNumberPad = [NSArray arrayWithObjects:
                                                    @"tahunMenempati", @"nomorNPWP", @"nomorKartuKeluarga", @"jumlahTanggungan",
                                                    @"rT", @"rW",
                                                    @"pendapatanPerBulan", @"lamaBekerja", @"pendapatanLainnyaPerBulan",
                                                    @"rTKantorPasangan", @"rWKantorPasangan",
                                                    @"nomorIndukKependudukan",
                                                    @"hargaKendaraan", @"totalBayarAwal", @"jangkaWaktuPembiayaan", @"angsuran", @"jumlahAset", @"pokokHutang", @"subsidiUangMuka", @"totalUangMukaDiterimaMPMF", @"biayaAdmin", @"biayaAdminLainnya", @"biayaFidusia", @"biayaLain", @"biayaSurvey", @"persentaseBiayaProvisi", @"effectiveRate",
                                                    @"periodeAsuransi", @"nilaiPertanggungan", @"jenisPertanggunganAllRisk", @"jenisPertanggunganTLO", @"asuransiJiwaKreditKapitalisasi", @"asuransiJiwaDibayarDimuka", @"nilaiPertanggunganAsuransiJiwa", @"premiAsuransiKerugianKendaraan", @"premiAsuransiJiwaKredit", @"periodeAsuransiJiwa",
                                                    @"silinder",
                                                    nil];
                if ([tagForKeyboardNumberPad containsObject:row.tag]){
                    //Set keyboard type to numberPad
                    if ([[row cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
                        [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setKeyboardType:UIKeyboardTypeNumberPad];
                    }
                }
            }
        }
        
        dispatch_group_notify(group, queue, ^{
            [weakSelf checkError:_error completion:^{
                if (_formDescriptor) weakSelf.form = _formDescriptor;
                if (block) block();
            }];
        });
    });
}

- (void)preparingValueWithCompletion:(void(^)())block{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    __block DataMAPFormViewController *weakSelf = self;
    __block NSError *_error = nil;

    dispatch_group_notify(group, queue, ^{
        [weakSelf checkError:_error completion:^{
            if (block) block();
        }];
    });
}

- (void)checkError:(NSError *)error completion:(void(^)())block{
    if (error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
        [SVProgressHUD dismissWithDelay:1.5 completion:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } else {
        block();
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveButtonClicked:(id)sender{
    //save to this view valueDictionary
    //submit to dataMap
    //if success
    //save valueDictionary to delegate
    //pop view
    //else
    //popup error
    
    if ([self.title isEqualToString:@"Data Keluarga"]) {
        NSMutableArray *familyArray = [NSMutableArray array];
        for (XLFormSectionDescriptor *section in self.form.formSections) {
            if ([section.title isEqualToString:@"Data Keluarga"]) {
                NSMutableDictionary *familyDictionary = [NSMutableDictionary dictionary];
                [FormModel saveValueFromSection:section to:familyDictionary];
                [familyArray addObject:familyDictionary];
            }
        }
        [self.valueDictionary setObject:familyArray forKey:@"dataKeluarga"];
        
    } else {
        [FormModel saveValueFrom:self.form to:self.valueDictionary];
    }
    
    [SVProgressHUD show];
    __block typeof(self) weakSelf = self;
    [self submitWithCompletionBlock:^(NSError *error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
            [SVProgressHUD dismissWithDelay:1.5 completion:nil];
        } else {
            [SVProgressHUD dismiss];
            if (weakSelf.delegate) [weakSelf.delegate saveDictionary:weakSelf.valueDictionary];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
    }];
}

- (void)submitWithCompletionBlock:(void(^)(NSError *error))block{
    Form *currentForm = [self.forms objectAtIndex:self.index];
    if ([currentForm.title isEqualToString:@"MAP Data Aplikasi"]) {
        [DataMAPModel postDataMAPWithType:DataMAPPostTypeAplikasi dictionary:self.valueDictionary completion:^(NSDictionary *dictionary, NSError *error) {
            if (block) block(error);
        }];
    } else if ([currentForm.title isEqualToString:@"Data Pribadi"]) {
        [DataMAPModel postDataMAPWithType:DataMAPPostTypePribadi dictionary:self.valueDictionary completion:^(NSDictionary *dictionary, NSError *error) {
            if (block) block(error);
        }];
    } else if ([currentForm.title isEqualToString:@"Data Pekerjaan"]) {
        [DataMAPModel postDataMAPWithType:DataMAPPostTypePekerjaan dictionary:self.valueDictionary completion:^(NSDictionary *dictionary, NSError *error) {
            if (block) block(error);
        }];
    } else if ([currentForm.title isEqualToString:@"Data Pasangan"]) {
        [DataMAPModel postDataMAPWithType:DataMAPPostTypePasangan dictionary:self.valueDictionary completion:^(NSDictionary *dictionary, NSError *error) {
            if (block) block(error);
        }];
    } else if ([currentForm.title isEqualToString:@"Data Pekerjaan Pasangan"]) {
        [DataMAPModel postDataMAPWithType:DataMAPPostTypePekerjaanPasangan dictionary:self.valueDictionary completion:^(NSDictionary *dictionary, NSError *error) {
            if (block) block(error);
        }];
    } else if ([currentForm.title isEqualToString:@"Data Keluarga"]) {
        [DataMAPModel postDataMAPWithType:DataMAPPostTypeKeluarga dictionary:self.valueDictionary completion:^(NSDictionary *dictionary, NSError *error) {
            if (block) block(error);
        }];
    } else if ([currentForm.title isEqualToString:@"Struktur Pembayaran"]) {
        [DataMAPModel postDataMAPWithType:DataMAPPostTypeStrukturPembiayaan dictionary:self.valueDictionary completion:^(NSDictionary *dictionary, NSError *error) {
            if (block) block(error);
        }];
    } else if ([currentForm.title isEqualToString:@"Asuransi"]) {
        [DataMAPModel postDataMAPWithType:DataMAPPostTypeAsuransi dictionary:self.valueDictionary completion:^(NSDictionary *dictionary, NSError *error) {
            if (block) block(error);
        }];
    } else if ([currentForm.title isEqualToString:@"Data Aset"]) {
        [DataMAPModel postDataMAPWithType:DataMAPPostTypeAset dictionary:self.valueDictionary completion:^(NSDictionary *dictionary, NSError *error) {
            if (block) block(error);
        }];
    } else if ([currentForm.title isEqualToString:@"Data E-con"]) {
        [DataMAPModel postDataMAPWithType:DataMAPPostTypeEmergencyContact dictionary:self.valueDictionary completion:^(NSDictionary *dictionary, NSError *error) {
            if (block) block(error);
        }];
    } else if ([currentForm.title isEqualToString:@"Data Penjamin"]) {
        [DataMAPModel postDataMAPWithType:DataMAPPostTypePenjamin dictionary:self.valueDictionary completion:^(NSDictionary *dictionary, NSError *error) {
            if (block) block(error);
        }];
    } else if ([currentForm.title isEqualToString:@"Data Marketing"]) {
        [DataMAPModel postDataMAPWithType:DataMAPPostTypeMarketing dictionary:self.valueDictionary completion:^(NSDictionary *dictionary, NSError *error) {
            if (block) block(error);
        }];
    } else if ([currentForm.title isEqualToString:@"Data RCA"]) {
        [DataMAPModel postDataMAPWithType:DataMAPPostTypeRCA dictionary:self.valueDictionary completion:^(NSDictionary *dictionary, NSError *error) {
            if (block) block(error);
        }];
    } else {
        if (block) block(nil);
    }
}

- (void)addFamilyButtonClicked:(id)sender{
    XLFormSectionDescriptor *section = [self.form formSectionAtIndex:0];
    XLFormSectionDescriptor *newSection = [XLFormSectionDescriptor formSectionWithTitle:section.title];
    for (XLFormRowDescriptor *row in section.formRows) {
        XLFormRowDescriptor *newRow = [XLFormRowDescriptor formRowDescriptorWithTag:row.tag rowType:row.rowType title:row.title];
        newRow.required = row.required;
        newRow.disabled = row.disabled;
        newRow.hidden = row.hidden;
        newRow.selectorTitle = row.selectorTitle;
        newRow.selectorOptions = row.selectorOptions;
        
        if ([newRow.tag isEqualToString:@"nomorIndukKependudukan"]){
            //Set keyboard type to numberPad
            if ([[row cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
                [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setKeyboardType:UIKeyboardTypeNumberPad];
            }
        }
        
        [newSection addFormRow:newRow];
    }
    [self.form addFormSection:newSection atIndex:self.form.formSections.count -2];
}

- (void)deleteFamilyButtonClicked:(id)sender{
    [self.form removeFormSectionAtIndex:self.form.formSections.count - 3];
}

- (void)formRowDescriptorValueHasChanged:(XLFormRowDescriptor *)formRow oldValue:(id)oldValue newValue:(id)newValue{
    if ([formRow.tag isEqualToString:@"productOffering"] && newValue && ![newValue isKindOfClass:NSNull.class]) {
        __block typeof(self) weakSelf = self;
        NSString *idCabang = [self.valueDictionary objectForKey:@"kodeCabang"] ?: @"";
        NSString *idProductOffering = ((XLFormOptionsObject *)newValue).formValue ?: @"";
        [SVProgressHUD show];
        [DropdownModel getDropdownWSType:@"JarakTempuh" keyword:@"" idProductOffering:idProductOffering idCabang:idCabang additionalURL:@"distancelist" completion:^(NSArray *datas, NSError *error) {
            @try {
                [weakSelf checkError:error completion:^{
                    XLFormRowDescriptor *row = [weakSelf.form formRowWithTag:@"jarakTempuh"];
                    NSMutableArray *optionObjects = [NSMutableArray array];
                    for (Data *data in datas) {
                        [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:data.value displayText:data.name]];
                    }
                    row.selectorOptions = optionObjects;
                    [weakSelf reloadFormRow:row];
                    
                    [FormModel loadValueFrom:weakSelf.valueDictionary on:weakSelf partialUpdate:[NSArray arrayWithObject:@"jarakTempuh"]];
                    [SVProgressHUD dismiss];
                }];
            } @catch (NSException *exception) {
                NSLog(@"%@", exception);
            }
        }];
    }
    
    if ([formRow.tag isEqualToString:@"sumberAplikasi"] && newValue && ![newValue isKindOfClass:NSNull.class]) {
        NSInteger newValueInteger = [((XLFormOptionsObject *)newValue).formValue integerValue];
        if (newValueInteger == 2) {
            XLFormRowDescriptor *row = [self.form formRowWithTag:@"kodeCabang"];
            row.title = @"Nama KP";
            [self reloadFormRow:row];
        } else if (newValueInteger == 1){
            XLFormRowDescriptor *row = [self.form formRowWithTag:@"kodeCabang"];
            row.title = @"Kode Cabang";
            [self reloadFormRow:row];
        }
    }
    
    if ([formRow.tag isEqualToString:@"jenisPekerjaan"] || [formRow.tag isEqualToString:@"lamaBekerja"]) {
        [self.form forceEvaluate];
    }
    
    if ([formRow.tag isEqualToString:@"kodePosKantorPasangan"] && newValue != nil && [newValue isKindOfClass:PostalCode.class]) {
        @try {
            PostalCode *postalCode = (PostalCode *)newValue;
            //set value
            [self.valueDictionary addEntriesFromDictionary:@{@"kecamatanKantorPasangan" : postalCode.subDistrict,
                                                             @"kelurahanKantorPasangan" : postalCode.disctrict,
                                                             @"kotaKantorPasangan" : postalCode.city,}];
            [FormModel loadValueFrom:self.valueDictionary on:self partialUpdate:
             [NSArray arrayWithObjects:@"kecamatanKantorPasangan", @"kelurahanKantorPasangan", @"kotaKantorPasangan", nil]];

        } @catch (NSException *exception) {
            NSLog(@"%@", exception);
        }
    }
    
    if ([formRow.tag isEqualToString:@"persentaseBiayaProvisi"]) {
        NSInteger persentage = [newValue integerValue];
        [self.valueDictionary addEntriesFromDictionary:@{@"biayaProvisi" : @(persentage / 100.0),}];
        [FormModel loadValueFrom:self.valueDictionary on:self partialUpdate:
         [NSArray arrayWithObjects:@"biayaProvisi", nil]];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
