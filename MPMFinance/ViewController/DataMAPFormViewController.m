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
#import "RedzoneTableViewCell.h"
#import "PostalCodeViewController.h"
#import "PostalCodeValueTransformer.h"
@interface DataMAPFormViewController ()

@property RLMResults *forms;
@property XLFormSectionDescriptor *refSection;
@property XLFormSectionDescriptor *refSectionPNS;
@property XLFormSectionDescriptor *oldJobSection;
@end

@implementation DataMAPFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    // Do any additional setup after loading the view from its nib.
    
    [[XLFormViewController cellClassesForRowDescriptorTypes] setObject:@"RedzoneTableViewCell" forKey:XLFormRowDescriptorTypeRedzone];
    
    self.forms = [Form getFormForMenu:self.menu.primaryKey];
    Form *currentForm = [self.forms objectAtIndex:self.index];
    [self setTitle:currentForm.title];
    
    [SVProgressHUD show];
    __block DataMAPFormViewController *weakSelf = self;
    
    if (self.valueDictionary.count == 0) self.valueDictionary = [NSMutableDictionary dictionary];
  
  dispatch_group_t group = dispatch_group_create();
  dispatch_queue_t queue = dispatch_get_main_queue();
  dispatch_group_enter(group);
  [self.valueDictionary setObject:[MPMUserInfo getUserInfo][@"username"] forKey:@"namaMarketing"];
    [self preparingValueWithCompletion:^{
        [self preparingFormDescriptorWithCompletion:^{
          dispatch_group_leave(group);
          
            [SVProgressHUD dismiss];
        }];
    }];
  dispatch_group_notify(group, queue, ^{
    if ([self.title isEqualToString:@"Data Keluarga"]) {
      NSInteger counter = 0;
      for (NSDictionary *data in [weakSelf.valueDictionary objectForKey:@"dataKeluarga"]) {
        XLFormSectionDescriptor *section = [self.form formSectionAtIndex:counter];
        counter += 1;
        [self addFamilyButtonClicked:nil];
        [FormModel loadValueFrom:data to:section on:weakSelf partialUpdate:nil];
      }
      if (counter > 0) {
        [self deleteFamilyButtonClicked:nil];
      }
      
    } else {
      if ([self.title isEqualToString:@"Data Aset"]) {
        if ([[weakSelf.valueDictionary objectForKey:@"product"] isEqualToString:@"3"] || [[weakSelf.valueDictionary objectForKey:@"product"] isEqualToString:@"1"] || [[weakSelf.valueDictionary objectForKey:@"product"] isEqualToString:@"9"]) {
            [weakSelf.valueDictionary setObject:@86 forKey:@"newUsed"];
        } else {
          [weakSelf.valueDictionary setObject:@87 forKey:@"newUsed"];
        }
        
      }
      [FormModel loadValueFrom:weakSelf.valueDictionary on:weakSelf partialUpdate:nil];
      
    }
    for (XLFormSectionDescriptor *section in weakSelf.form.formSections) {
      for (XLFormRowDescriptor *row in section.formRows) {
        if (self.isReadOnly) {
          row.disabled = @YES;
        }
      }
    }
  });
  
}


- (void)preparingFormDescriptorWithCompletion:(void(^)())block{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_main_queue();
    NSString *idCabang = [self.valueDictionary objectForKey:@"kodeCabang"] ?: @"";
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
  dispatch_group_enter(group);
  [DropdownModel getDropdownWSType:@"bm" keyword:@"" idCabang:idCabang additionalURL:@"" completion:^(NSArray *datas, NSError *error) {
    @try {
      if (error) {
        _error = error;
        
      } else {
        for (Data *data in datas) {
          [weakSelf.valueDictionary addEntriesFromDictionary:@{@"namaKepalaCabang": data.name}];
        }
      }
      
    } @catch (NSException *exception) {
      NSLog(@"%@", exception);
    } @finally {
      dispatch_group_leave(group);
      NSLog(@"leave");
    }
  }];
  
    
    dispatch_group_notify(group, queue, ^{
      
        NSString *idProduct = [self.valueDictionary objectForKey:@"produk"] ?: @"";
        
      
      
      
        for (XLFormSectionDescriptor *section in _formDescriptor.formSections) {
          if ([section.title isEqualToString:@"Wiraswasta"]) {
            _refSection = section;
          }
          else if ([section.title isEqualToString:@"PNS / Karyawan Swasta"]) {
            _refSectionPNS = section;
          } else if ([section.title isEqualToString:@"Data Pekerjaan Sebelumnya"]) {
            _oldJobSection = section;
          }
            for (XLFormRowDescriptor *row in section.formRows) {
              [row.cellConfig setObject:[UIFont systemFontOfSize:10.0f] forKey:@"textLabel.font"];
              [row.cellConfig setObject:[UIFont systemFontOfSize:10.0f] forKey:@"detailTextLabel.font"];
              
                if (self.isReadOnly) {
                    row.disabled = @YES;
                  if ([section.title isEqualToString:@"Submit"]) {
                    section.hidden = @YES;
                  }
                }
              
              if ([[MPMGlobal getAllFieldShouldContainThousandSeparator] containsObject:row.tag]) {
                if ([[row cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
                  [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setMaximumLength:9];
                  [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setMustNumericOnly:YES];
                  [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setShouldGiveThousandSeparator:YES];
                }
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
              NSLog(@"%@",row.tag);
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
              if ([row.tag isEqualToString:@"tanggalLahir"]) {
                if ([[row cellForFormController:self] isKindOfClass:XLFormDateCell.class]){
                  [(XLFormDateCell *)[row cellForFormController:self] setMaximumDate:[NSDate date]];
                }
              }
              if ([row.tag isEqualToString:@"newUsed"]) {
                row.disabled = @YES;
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
                  row.height = 110;
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
                  row.height = 80;
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
                  row.height = 100;
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
              if ([row.tag isEqualToString:@"kelurahan"]){
                row.action.viewControllerNibName = @"PostalCodeViewController";
                row.valueTransformer = [PostalCodeValueTransformer class];
              }
                if ([row.tag isEqualToString:@"bidangUsaha"]){
                    row.action.viewControllerNibName = @"DropdownWSViewController";
                    row.valueTransformer = [DropdownValueTransformer class];
                  row.height = 100;
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
                  row.height = 100;
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
                if ([row.tag isEqualToString:@"kelurahanKantorPasangan"]){
                    row.action.viewControllerNibName = @"PostalCodeViewController";
                    row.valueTransformer = [PostalCodeValueTransformer class];
                }
                
                //Data Keluarga
                if ([row.tag isEqualToString:@"hubunganDenganPemohon"]){
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
                  row.height = 100;
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
                  row.height = 100;
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
                  row.height = 100;
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
                  row.height = 100;
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
                  row.height = 120;
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
                
                
              if ([[MPMGlobal getAllFieldShouldContainThousandSeparator] containsObject:row.tag]){
                if ([[row cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
                  ((FloatLabeledTextFieldCell *)[row cellForFormController:self]).shouldGiveThousandSeparator = YES;
                  [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setMaximumLength:10];
                }
              }
                //other setting
                NSArray *tagForKeyboardNumberPad = [NSArray arrayWithObjects:
                                                    @"tahunMenempati", @"nomorNPWP", @"nomorKartuKeluarga", @"jumlahTanggungan",
                                                    @"rT", @"rW",
                                                    @"pendapatanPerBulan", @"lamaBekerja",@"lamaBekerjaDalamTahun", @"pendapatanLainnyaPerBulan",
                                                    @"rTKantorPasangan", @"rWKantorPasangan",
                                                    @"nomorIndukKependudukan",@"totalBayarAwal",
                                                    @"hargaKendaraan", @"totalBayarAwal", @"jangkaWaktuPembiayaan", @"angsuran", @"jumlahAset", @"pokokHutang", @"subsidiUangMuka", @"totalUangMukaDiterimaMPMF", @"biayaAdmin", @"biayaAdminLainnya", @"biayaFidusia", @"biayaLain", @"biayaSurvey",
                                                    @"periodeAsuransi", @"nilaiPertanggungan", @"jenisPertanggunganAllRisk", @"jenisPertanggunganTLO", @"asuransiJiwaKreditKapitalisasi", @"asuransiJiwaDibayarDimuka", @"nilaiPertanggunganAsuransiJiwa", @"premiAsuransiKerugianKendaraan", @"premiAsuransiJiwaKredit", @"periodeAsuransiJiwa",
                                                    @"silinder",
                                                    nil];
                if ([tagForKeyboardNumberPad containsObject:row.tag]){
                    //Set keyboard type to numberPad
                    if ([[row cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
                        [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setKeyboardType:UIKeyboardTypeNumberPad];
                      ((FloatLabeledTextFieldCell *)[row cellForFormController:self]).mustNumericOnly = YES;
                    }
                }
                
                NSArray *tagForMustAlphabetOnly = [NSArray arrayWithObjects:@"namaLengkapSesuaiKTP", @"namaPanggilan", nil];
                if ([tagForMustAlphabetOnly containsObject:row.tag]){
                    if ([[row cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
                        [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setMustAlphabetOnly:YES];
                    }
                }
                
                if ([row.tag isEqualToString:@"tahunMenempati"]){
                    if ([[row cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
                        [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setMaximumLength:4];
                    }
                }
              if ([row.tag isEqualToString:@"silinder"]){
                if ([[row cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
                  [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setMaximumLength:5];
                  ((FloatLabeledTextFieldCell *)[row cellForFormController:self]).mustNumericOnly = YES;
                }
              }
              if ([row.tag isEqualToString:@"pendapatanPerBulan"] || [row.tag isEqualToString:@"pendapatanLainnyaPerBulan"]){
                if ([[row cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
                  [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setMaximumLength:11];
                }
              }
              if ([row.tag isEqualToString:@"omzet1"] || [row.tag isEqualToString:@"omzet2"] || [row.tag isEqualToString:@"omzet3"] || [row.tag isEqualToString:@"omzet4"] || [row.tag isEqualToString:@"omzet5"] || [row.tag isEqualToString:@"omzet6"]){
                if ([[row cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
                  [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setMaximumLength:9];
                  [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setKeyboardType:UIKeyboardTypeNumberPad];
                  ((FloatLabeledTextFieldCell *)[row cellForFormController:self]).mustNumericOnly = YES;
                }
              }
                if ([row.tag isEqualToString:@"nomorNPWP"]){
                    if ([[row cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
                        [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setMaximumLength:15];
                    }
                }
                if ([row.tag isEqualToString:@"nomorKartuKeluarga"]){
                    if ([[row cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
                        [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setMaximumLength:16];
                    }
                }
                if ([row.tag isEqualToString:@"jumlahTanggungan"]){
                    if ([[row cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
                        [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setMaximumLength:2];
                    }
                }
                
                if ([row.tag isEqualToString:@"rT"]){
                    if ([[row cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
                        [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setMaximumLength:3];
                    }
                }
                if ([row.tag isEqualToString:@"rW"]){
                    if ([[row cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
                        [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setMaximumLength:3];
                    }
                }
                if ([row.tag isEqualToString:@"lamaBekerja"] || [row.tag isEqualToString:@"lamaBekerjaDalamTahun"] ){
                    if ([[row cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
                        [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setMaximumLength:4];
                    }
                }
                
                if ([row.tag isEqualToString:@"rTKantorPasangan"]){
                    if ([[row cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
                        [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setMaximumLength:3];
                    }
                }
                if ([row.tag isEqualToString:@"rWKantorPasangan"]){
                    if ([[row cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
                        [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setMaximumLength:3];
                    }
                }
                
                if ([row.tag isEqualToString:@"nomorIndukKependudukan"]){
                    if ([[row cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
                        [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setMaximumLength:16];
                    }
                }
                
                if ([row.tag isEqualToString:@"hargaKendaraan"]){
                    if ([[row cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
                        [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setMaximumLength:11];
                    }
                }
                if ([row.tag isEqualToString:@"uangMuka"]){
                    if ([[row cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
                        [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setMaximumLength:10];
                    }
                }
              if ([row.tag isEqualToString:@"totalBayarAwal"]){
                if ([[row cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
                  [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setMaximumLength:11];
                }
              }
                if ([row.tag isEqualToString:@"jangkaWaktuPembiayaan"]){
                    if ([[row cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
                        [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setMaximumLength:2];
                    }
                }
                if ([row.tag isEqualToString:@"angsuran"]){
                    if ([[row cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
                        [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setMaximumLength:9];
                    }
                }
                if ([row.tag isEqualToString:@"jumlahAset"]){
                    if ([[row cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
                        [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setMaximumLength:3];
                    }
                }
                if ([row.tag isEqualToString:@"pokokHutang"]){
                    if ([[row cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
                        [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setMaximumLength:11];
                    }
                }
                if ([row.tag isEqualToString:@"subsidiUangMuka"]){
                    if ([[row cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
                        [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setMaximumLength:9];
                    }
                }
                if ([row.tag isEqualToString:@"totalUangDiterimaMPMF"]){
                    if ([[row cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
                        [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setMaximumLength:9];
                      [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setKeyboardType:UIKeyboardTypeNumberPad];
                      [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setMustNumericOnly:YES];
                    }
                }
                if ([row.tag isEqualToString:@"biayaAdmin"]){
                    if ([[row cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
                        [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setMaximumLength:9];
                    }
                }
                if ([row.tag isEqualToString:@"biayaAdminLainnya"]){
                    if ([[row cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
                        [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setMaximumLength:9];
                    }
                }
                if ([row.tag isEqualToString:@"biayaFidusia"]){
                    if ([[row cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
                        [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setMaximumLength:9];
                    }
                }
                if ([row.tag isEqualToString:@"biayaLain"]){
                    if ([[row cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
                        [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setMaximumLength:9];
                    }
                }
                if ([row.tag isEqualToString:@"biayaSurvey"]){
                    if ([[row cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
                        [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setMaximumLength:9];
                    }
                }
                if ([row.tag isEqualToString:@"persentaseBiayaProvisi"]){
                    if ([[row cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
                        [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setMaximumLength:7];
                      [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setKeyboardType:UIKeyboardTypeDecimalPad];
                      [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setMustNumericOnly:YES];
                      [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setIsPercentage:YES];
                    }
                }
                if ([row.tag isEqualToString:@"biayaProvisi"]){
                    if ([[row cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
                        [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setMaximumLength:9];
                    }
                }
                if ([row.tag isEqualToString:@"effectiveRate"]){
                    if ([[row cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
                        [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setMaximumLength:7];
                      [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setMustNumericOnly:YES];
                      [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setKeyboardType:UIKeyboardTypeDecimalPad];
                      [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setIsPercentage:YES];
                    }
                }
                
                if ([row.tag isEqualToString:@"periodeAsuransi"]){
                    if ([[row cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
                        [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setMaximumLength:2];
                    }
                }
              if ([row.tag isEqualToString:@"rCA"]){
                if ([[row cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
                  row.height = 150;
                  [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setMaximumLength:3000];
                }
              }
                if ([row.tag isEqualToString:@"nilaiPertanggungan"]){
                    if ([[row cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
                        [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setMaximumLength:11];
                    }
                }
                if ([row.tag isEqualToString:@"jenisPertanggunganAllRisk"]){
                    if ([[row cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
                        [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setMaximumLength:2];
                      [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setKeyboardType:UIKeyboardTypeNumberPad];
                      [(FloatLabeledTextFieldCell *)[row cellForFormController:self]  setMustNumericOnly:YES];
                    }
                }
                if ([row.tag isEqualToString:@"asuransiKendaraanKapitalisasi"] || [row.tag isEqualToString:@"gajiPokok"] || [row.tag isEqualToString:@"tunjanganTetap"] || [row.tag isEqualToString:@"lembur"] || [row.tag isEqualToString:@"insentif"] || [row.tag isEqualToString:@"bonus"] || [row.tag isEqualToString:@"total"]){
                    if ([[row cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
                      [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setMaximumLength:11];
                      [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setKeyboardType:UIKeyboardTypeNumberPad];
                      [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setMustNumericOnly:YES];
                      
                    }
                }
                if ([row.tag isEqualToString:@"asuransiKendaraanDibayarDimuka"]){
                    if ([[row cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
                        [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setMaximumLength:11];
                      [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setKeyboardType:UIKeyboardTypeNumberPad];
                      ((FloatLabeledTextFieldCell *)[row cellForFormController:self]).mustNumericOnly = YES;
                    }
                }
                if ([row.tag isEqualToString:@"asuransiJiwaKreditKapitalisasi"]){
                    if ([[row cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
                        [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setMaximumLength:11];
                    }
                }
                if ([row.tag isEqualToString:@"asuransiJiwaDibayarDimuka"]){
                    if ([[row cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
                        [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setMaximumLength:11];
                    }
                }
                if ([row.tag isEqualToString:@"nilaiPertanggunganAsuransiJiwa"]){
                    if ([[row cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
                        [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setMaximumLength:11];
                    }
                }
                if ([row.tag isEqualToString:@"premiAsuransiKerugianKendaraan"]){
                    if ([[row cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
                        [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setMaximumLength:9];
                    }
                }
                if ([row.tag isEqualToString:@"premiAsuransiJiwaKredit"]){
                    if ([[row cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
                        [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setMaximumLength:9];
                    }
                }
                if ([row.tag isEqualToString:@"periodeAsuransiJiwa"]){
                    if ([[row cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
                        [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setMaximumLength:2];
                    }
                }
                
                if ([row.tag isEqualToString:@"noRangka"] || [row.tag isEqualToString:@"noMesin"] || [row.tag isEqualToString:@"nomorPolisi"]){
                    if ([[row cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
                        [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setMustAlphabetNumericOnly:YES];
                    }
                }
                if ([row.tag isEqualToString:@"warna"] || [row.tag isEqualToString:@"namaBPKB"]){
                    if ([[row cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
                        [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setMustAlphabetOnly:YES];
                    }
                }
                
                if ([row.tag isEqualToString:@"namaPenjamin"] || [row.tag isEqualToString:@"namaPasanganPenjamin"]){
                    if ([[row cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
                        [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setMustAlphabetOnly:YES];
                    }
                }
              NSCalendar *calendar = [NSCalendar currentCalendar];
              NSDateComponents *comps = [NSDateComponents new];
              if ([row.tag isEqualToString:@"tahun6"] || [row.tag isEqualToString:@"bulan6"] ) {
                comps.month = - 1;
                NSDate *date = [calendar dateByAddingComponents:comps toDate:[NSDate date] options:0];
                NSDateComponents *components = [calendar components:NSMonthCalendarUnit|NSYearCalendarUnit fromDate:date]; // Get necessary date
                row.value = [row.tag containsString:@"tahun"]? @(components.year) : @(components.month);
                
                
              } else if ([row.tag isEqualToString:@"tahun5"] || [row.tag isEqualToString:@"bulan5"] ) {
                comps.month = - 2;
                NSDate *date = [calendar dateByAddingComponents:comps toDate:[NSDate date] options:0];
                NSDateComponents *components = [calendar components:NSMonthCalendarUnit|NSYearCalendarUnit fromDate:date]; // Get necessary date
                row.value = [row.tag containsString:@"tahun"]? @(components.year) : @(components.month);
                
              } else if ([row.tag isEqualToString:@"tahun4"] || [row.tag isEqualToString:@"bulan4"] ) {
                comps.month = - 3;
                NSDate *date = [calendar dateByAddingComponents:comps toDate:[NSDate date] options:0];
                NSDateComponents *components = [calendar components:NSMonthCalendarUnit|NSYearCalendarUnit fromDate:date]; // Get necessary date
                row.value = [row.tag containsString:@"tahun"]? @(components.year) : @(components.month);
                
              } else if ([row.tag isEqualToString:@"tahun3"] || [row.tag isEqualToString:@"bulan3"] ) {
                comps.month  = - 4;
                NSDate *date = [calendar dateByAddingComponents:comps toDate:[NSDate date] options:0];
                NSDateComponents *components = [calendar components:NSMonthCalendarUnit|NSYearCalendarUnit fromDate:date]; // Get necessary date
                row.value = [row.tag containsString:@"tahun"]? @(components.year) : @(components.month);
                
              } else if ([row.tag isEqualToString:@"tahun2"] || [row.tag isEqualToString:@"bulan2"] ) {
                comps.month = - 5;
                NSDate *date = [calendar dateByAddingComponents:comps toDate:[NSDate date] options:0];
                NSDateComponents *components = [calendar components:NSMonthCalendarUnit|NSYearCalendarUnit fromDate:date]; // Get necessary date
                row.value = [row.tag containsString:@"tahun"]? @(components.year) : @(components.month);
                
              } else if ([row.tag isEqualToString:@"tahun1"] || [row.tag isEqualToString:@"bulan1"] ) {
                comps.month = - 6;
                NSDate *date = [calendar dateByAddingComponents:comps toDate:[NSDate date] options:0];
                NSDateComponents *components = [calendar components:NSMonthCalendarUnit|NSYearCalendarUnit fromDate:date]; // Get necessary date
                row.value = [row.tag containsString:@"tahun"]? @(components.year) : @(components.month);
                
              }
                if ([row.tag isEqualToString:@"tanggalPerjanjian"]){
                  if ([[row cellForFormController:self] isKindOfClass:XLFormDateCell.class]){
                    NSDate *currentDate = [NSDate date];
                    
                    [(XLFormDateCell *)[row cellForFormController:self] setMaximumDate:currentDate];
                    
                  }
                }
            }
        }
      _refSection.hidden = @YES;
      _refSectionPNS.hidden = @YES;
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
    
    NSArray *inputErrors = [self validateForm];
    if (inputErrors.count > 0) {
        [SVProgressHUD showErrorWithStatus:((NSError *)inputErrors.firstObject).localizedDescription];
        [SVProgressHUD dismissWithDelay:1.5];
    } else {
    
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
}
- (BOOL)validateEmailFormat{
  if ([self.valueDictionary objectForKey:@"alamatEmail"] && [[self.valueDictionary objectForKey:@"alamatEmail"] length] > 0) {
    return [MPMGlobal isValidEmail:self.valueDictionary[@"alamatEmail"]];
  }
  return YES;
}
- (void)submitWithCompletionBlock:(void(^)(NSError *error))block{
  
  if(![self validateEmailFormat]){
    [SVProgressHUD showErrorWithStatus:@"Email Format is Invalid"];
    [SVProgressHUD dismissWithDelay:1.5f];
    return;
  }
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
    } else if ([currentForm.title isEqualToString:@"Struktur Pembiayaan"]) {
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
    }
    else if ([currentForm.title isEqualToString:@"Data RCA"]) {
        [DataMAPModel postDataMAPWithType:DataMAPPostTypeRCA dictionary:self.valueDictionary completion:^(NSDictionary *dictionary, NSError *error) {
            if (block) block(error);
        }];
    } else {
        if (block) block(nil);
    }
}

- (void)addFamilyButtonClicked:(id)sender{
  if (self.form.formSections.count >= 8) {
    return;
  }
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
            if ([[newRow cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
                [(FloatLabeledTextFieldCell *)[newRow cellForFormController:self] setKeyboardType:UIKeyboardTypeNumberPad];
              [(FloatLabeledTextFieldCell *)[newRow cellForFormController:self] setMaximumLength:16];
            }
        }
        if ([newRow.tag isEqualToString:@"tanggalLahir"]) {
            if ([[newRow cellForFormController:self] isKindOfClass:XLFormDateCell.class]){
                [(XLFormDateCell *)[newRow cellForFormController:self] setMaximumDate:[NSDate date]];
            }
        }
        [newSection addFormRow:newRow];
    }
    [self.form addFormSection:newSection atIndex:self.form.formSections.count -2];
}

- (void)deleteFamilyButtonClicked:(id)sender{
  if (self.form.formSections.count <= 3) {
    return;
  }
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
  if ([formRow.tag isEqualToString:@"hubunganPenjaminDenganPemohon"] && ![newValue isEqual:[NSNull null]]){
    if ([((XLFormOptionsObject *) newValue).formValue length] > 0) {
      formRow.title = @"Hubungan Penjamin ...";
    }
    
  }
  if ([formRow.tag isEqualToString:@"hubunganEconDenganPemohon"] && ![newValue isEqual:[NSNull null]]){
    if ([((XLFormOptionsObject *) newValue).formValue length] > 0) {
      formRow.title = @"Hubungan Econ Dengan ...";
    }
    
  }
    if ([formRow.tag isEqualToString:@"sumberAplikasi"] && newValue && ![newValue isKindOfClass:NSNull.class]) {
      
        NSInteger newValueInteger = [((XLFormOptionsObject *)newValue).formValue integerValue];
        if (newValueInteger == 2) {
            XLFormRowDescriptor *row = [self.form formRowWithTag:@"namaKP"];
            row.disabled = @(NO);
            row.required = YES;
            [self updateFormRow:row];
        } else if (newValueInteger == 1){
            XLFormRowDescriptor *row = [self.form formRowWithTag:@"namaKP"];
            row.value = @"";
            row.disabled = @(YES);
        
            row.required = NO;
            [self updateFormRow:row];
        }
    }
  if ([formRow.tag isEqualToString:@"kecamatan"]) {
    NSLog(@"ada");
  }
  if ([formRow.tag isEqualToString:@"kelurahan"] && newValue != nil && [newValue isKindOfClass:PostalCode.class]) {
    @try {
      PostalCode *postalCode = (PostalCode *)newValue;
      //set value
      self.valueDictionary[@"kelurahan"] = postalCode.subDistrict;
      
      [self.valueDictionary addEntriesFromDictionary:@{@"kecamatan" : postalCode.disctrict,
                                                       @"kodePos" : postalCode.postalCode,
                                                       @"kota" : postalCode.city}];
      [FormModel loadValueFrom:self.valueDictionary on:self partialUpdate:
       [NSArray arrayWithObjects:@"kecamatan", @"kodePos", @"kota",@"kelurahan", nil]];
     
    } @catch (NSException *exception) {
      NSLog(@"%@", exception);
    }
  }
  if ([formRow.tag isEqualToString:@"statusKepemilikanRumah"] && newValue && ![newValue isKindOfClass:NSNull.class]) {
    NSString *newValueString = ((XLFormOptionsObject *)newValue).formValue;
    if ([newValueString isEqualToString:@"KR"]) {
      XLFormRowDescriptor *row = [self.form formRowWithTag:@"tanggalSelesaiKontrak"];
      row.required = YES;
      row.disabled = @NO;
      [self updateFormRow:row];
    } else {
      XLFormRowDescriptor *row = [self.form formRowWithTag:@"tanggalSelesaiKontrak"];
      row.disabled = @YES;
      row.required = NO;
      [self updateFormRow:row];
    }
  }
    
    if ([formRow.tag isEqualToString:@"jenisPekerjaan"]) {
      if ([((XLFormOptionsObject *)formRow.value).valueData isEqual:@47]) {
        self.refSection.hidden = @NO;
      } else {
        self.refSection.hidden = @YES;
      }
      if ([((XLFormOptionsObject *)formRow.value).valueData isEqual:@48]) {
        self.refSectionPNS.hidden = @NO;
      } else {
        self.refSectionPNS.hidden = @YES;
      }
      
    }
  if ([formRow.tag isEqualToString:@"lamaBekerja"]) {
    XLFormSectionDescriptor *section;
   // if (self.form.formSections.count == 2) {
    
    
    NSInteger lamaBekerja = ![newValue isKindOfClass:[NSNull class]] ? [newValue integerValue] : 0;
    if (lamaBekerja > 3) {
      
      _oldJobSection.hidden = @YES;
    } else {
            _oldJobSection.hidden = @NO;
    }
    [self.form forceEvaluate];
  }
    if ([formRow.tag isEqualToString:@"kelurahanKantorPasangan"] && newValue != nil && [newValue isKindOfClass:PostalCode.class]) {
        @try {
            PostalCode *postalCode = (PostalCode *)newValue;
            //set value
            [self.valueDictionary addEntriesFromDictionary:@{@"kecamatanKantorPasangan" : postalCode.subDistrict,
                                                             @"kodePosKantorPasangan" : postalCode.postalCode,
                                                             @"kotaKantorPasangan" : postalCode.city,}];
            [FormModel loadValueFrom:self.valueDictionary on:self partialUpdate:
             [NSArray arrayWithObjects:@"kecamatanKantorPasangan", @"kodePosKantorPasangan", @"kotaKantorPasangan", nil]];

        } @catch (NSException *exception) {
            NSLog(@"%@", exception);
        }
    }
    
    if ([formRow.tag isEqualToString:@"persentaseBiayaProvisi"] || [formRow.tag isEqualToString:@"pokokHutang"]) {
      double newValueDouble = 0.0f;
      
      if ([newValue isEqual:[NSNull null]]) {
        newValueDouble = 0.0f;
      } else {
       // newValueDouble = [MPMGlobal doubleValue:newValue];
      }
      double persentage = 0;
      double  pokokHutang = 0;
      if ([formRow.tag isEqualToString:@"persentaseBiayaProvisi"]) {
        XLFormRowDescriptor *row = [self.form formRowWithTag:@"pokokHutang"];
        
        persentage = [[formRow.value stringByReplacingOccurrencesOfString:@"," withString:@"."] doubleValue];
        if ([row.value isKindOfClass:[NSString class]] ) {
          pokokHutang = [[row.value stringByReplacingOccurrencesOfString:@"." withString:@""] doubleValue];
        } else {
          pokokHutang = [row.value doubleValue];
        }
        
      } else {
         XLFormRowDescriptor *row = [self.form formRowWithTag:@"persentaseBiayaProvisi"];
        persentage = [[row.value stringByReplacingOccurrencesOfString:@"," withString:@"."] doubleValue];
        if ([newValue isKindOfClass:[NSString class]] ) {
          pokokHutang = [[newValue stringByReplacingOccurrencesOfString:@"." withString:@""] doubleValue];
        } else {
          pokokHutang = [newValue isEqual:[NSNull null]]? 0 : [newValue doubleValue];
        }
      }
      
      
      XLFormRowDescriptor *biayaProvisiRow = [self.form formRowWithTag:@"biayaProvisi"];
      biayaProvisiRow.value = @((persentage / 100.0)* pokokHutang);
      [self reloadFormRow:biayaProvisiRow];
    }
    
    if ([formRow.tag isEqualToString:@"jenisPertanggunganAllRisk"] || [formRow.tag isEqualToString:@"periodeAsuransi"]) {
        XLFormRowDescriptor *row = [self.form formRowWithTag:@"jenisPertanggunganTLO"];
      XLFormRowDescriptor *periodeAsuransi = [self.form formRowWithTag:@"periodeAsuransi"];
      XLFormRowDescriptor *jenisPertanggungan = [self.form formRowWithTag:@"jenisPertanggunganAllRisk"];
      if ([jenisPertanggungan.value isEqualToString:@""] || [periodeAsuransi.value isEqualToString:@""]) {
        return;
      }
        NSInteger value = ([jenisPertanggungan.value integerValue] * -1) + [periodeAsuransi.value doubleValue];
        row.value = [NSString stringWithFormat:@"%li", (long) value];
        [self reloadFormRow:row];
    }
  
  if ([formRow.tag isEqualToString:@"gajiPokok"] || [formRow.tag isEqualToString:@"tunjanganTetap"] || [formRow.tag isEqualToString:@"lembur"] || [formRow.tag isEqualToString:@"insentif"] || [formRow.tag isEqualToString:@"bonus"] ) {
    XLFormRowDescriptor *gajiPokokRow = [self.form formRowWithTag:@"gajiPokok"];
    XLFormRowDescriptor *tunjanganTetapRow = [self.form formRowWithTag:@"tunjanganTetap"];
    XLFormRowDescriptor *lemburRow = [self.form formRowWithTag:@"lembur"];
    XLFormRowDescriptor *insentifRow = [self.form formRowWithTag:@"insentif"];
    XLFormRowDescriptor *bonusRow = [self.form formRowWithTag:@"bonus"];
    XLFormRowDescriptor *totalRow = [self.form formRowWithTag:@"total"];
    
    double gajiPokok = 0;
    
    if (gajiPokokRow.value) {
      if ([gajiPokokRow.value isKindOfClass:[NSNumber class]]) {
        gajiPokok = [gajiPokokRow.value doubleValue];
      } else
      gajiPokok = [[gajiPokokRow.value stringByReplacingOccurrencesOfString:@"." withString:@""] doubleValue];
    }
    double tunjangan = 0;
    if (tunjanganTetapRow.value) {
      if ([tunjanganTetapRow.value isKindOfClass:[NSNumber class]]) {
        tunjangan = [tunjanganTetapRow.value doubleValue];
      } else
      tunjangan = [[tunjanganTetapRow.value stringByReplacingOccurrencesOfString:@"." withString:@""] doubleValue];
    }
    
    double lembur = 0;
    if (lemburRow.value) {
      if ([lemburRow.value isKindOfClass:[NSNumber class]]) {
        lembur = [lemburRow.value doubleValue];
      } else
      lembur = [[lemburRow.value stringByReplacingOccurrencesOfString:@"." withString:@""] doubleValue];
    }
    double insentif = 0;
    if (insentifRow.value) {
      if ([insentifRow.value isKindOfClass:[NSNumber class]]) {
        insentif = [insentifRow.value doubleValue];
      } else
      insentif = [[insentifRow.value stringByReplacingOccurrencesOfString:@"." withString:@""] doubleValue];
    }
    double bonus = 0;
    if (bonusRow.value) {
      if ([bonusRow.value isKindOfClass:[NSNumber class]]) {
        bonus = [bonusRow.value doubleValue];
      } else
      bonus = [[bonusRow.value stringByReplacingOccurrencesOfString:@"." withString:@""] doubleValue];
    }
    double total = gajiPokok + tunjangan + lembur + insentif + bonus;
    totalRow.value = @(total);
    [self reloadFormRow:totalRow];
    
  }
  
  if (self.isReadOnly) {
    formRow.disabled = @(YES);
  }
  if ([[MPMGlobal getAllFieldShouldContainThousandSeparator] containsObject:formRow.tag]) {
    // Create the decimal style formatter
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setGroupingSeparator:@"."];
    [formatter setMaximumFractionDigits:10];
    if ([formRow.value isKindOfClass:[NSNumber class]]) {
      formRow.value = [formatter stringFromNumber:formRow.value];
    } 
    
  }
}

- (NSArray *)validateForm {
  NSMutableArray * array = [NSMutableArray arrayWithArray:[self formValidationErrors]];
  //notcalled because this is null
  
  if ([self.form formRowWithTag:@"pendapatanPerBulan"]) {
    XLFormRowDescriptor *row = [self.form formRowWithTag:@"pendapatanPerBulan"];
    if ([row.value integerValue] < 1) {
      UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:[self.form indexPathOfFormRow:row]];
      [self animateCell:cell];
      
      return @[[NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier]
                                   code:1
                               userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"Pendapatan Per Bulan tidak boleh 0", nil)}]];
    }
  } if ([self.form formRowWithTag:@"jumlahAset"]) {
    XLFormRowDescriptor *row = [self.form formRowWithTag:@"jumlahAset"];
    if ([row.value integerValue] < 1) {
      UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:[self.form indexPathOfFormRow:row]];
      [self animateCell:cell];
      
      return @[[NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier]
                                   code:1
                               userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"Jumlah Aset tidak boleh 0", nil)}]];
    }
  } if ([self.form formRowWithTag:@"lamaBekerja"]) {
    XLFormRowDescriptor *row = [self.form formRowWithTag:@"lamaBekerja"];
    if ([row.value isEqual:@0] ) {
      UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:[self.form indexPathOfFormRow:row]];
      [self animateCell:cell];
      
      return @[[NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier]
                                   code:1
                               userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"Lama Bekerja tidak boleh 0", nil)}]];
    }
  }   if ([self.form formRowWithTag:@"gajiPokok"]) {
    XLFormRowDescriptor *row = [self.form formRowWithTag:@"gajiPokok"];
    if ([row.value isEqual:@0] ) {
      UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:[self.form indexPathOfFormRow:row]];
      [self animateCell:cell];
      
      return @[[NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier]
                                   code:1
                               userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"Gaji Pokok tidak boleh 0", nil)}]];
    }
  }
  
  
   if ([self.form formRowWithTag:@"omzet1"] || [self.form formRowWithTag:@"omzet2"] || [self.form formRowWithTag:@"omzet3"] || [self.form formRowWithTag:@"omzet4"]|| [self.form formRowWithTag:@"omzet5"] || [self.form formRowWithTag:@"omzet6"]) {
    XLFormRowDescriptor *row = [self.form formRowWithTag:@"omzet1"];
    if ([row.value integerValue] == 0  && row.value) {
      UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:[self.form indexPathOfFormRow:row]];
      [self animateCell:cell];
      
      return @[[NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier]
                                   code:1
                               userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"Omzet 1 tidak boleh 0", nil)}]];
    }
    row = [self.form formRowWithTag:@"omzet2"];
    if ([row.value integerValue] == 0   && row.value ) {
      UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:[self.form indexPathOfFormRow:row]];
      [self animateCell:cell];
      
      return @[[NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier]
                                   code:1
                               userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"Omzet 2 tidak boleh 0", nil)}]];
    }
    row = [self.form formRowWithTag:@"omzet3"];
    if ([row.value integerValue] == 0   && row.value ) {
      UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:[self.form indexPathOfFormRow:row]];
      [self animateCell:cell];
      
      return @[[NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier]
                                   code:1
                               userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"Omzet 1 tidak boleh 0", nil)}]];
    }
    row = [self.form formRowWithTag:@"omzet4"];
    if ([row.value integerValue] == 0   && row.value ) {
      UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:[self.form indexPathOfFormRow:row]];
      [self animateCell:cell];
      
      return @[[NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier]
                                   code:1
                               userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"Omzet 4 tidak boleh 0", nil)}]];
    }
    row = [self.form formRowWithTag:@"omzet5"];
    if ( [row.value integerValue] == 0   && row.value ) {
      UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:[self.form indexPathOfFormRow:row]];
      [self animateCell:cell];
      
      return @[[NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier]
                                   code:1
                               userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"Omzet 5 tidak boleh 0", nil)}]];
    }
    row = [self.form formRowWithTag:@"omzet6"];
    if ([row.value integerValue] == 0    && row.value) {
      UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:[self.form indexPathOfFormRow:row]];
      [self animateCell:cell];
      
      return @[[NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier]
                                   code:1
                               userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"Omzet 6 tidak boleh 0", nil)}]];
    }
  }
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        XLFormValidationStatus * validationStatus = [[obj userInfo] objectForKey:XLValidationStatusErrorKey];
        UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:[self.form indexPathOfFormRow:validationStatus.rowDescriptor]];
        
        [self animateCell:cell];
    }];

    return array;
}


#pragma mark - Helper

-(void)animateCell:(UITableViewCell *)cell
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position.x";
    animation.values =  @[ @0, @20, @-20, @10, @0];
    animation.keyTimes = @[@0, @(1 / 6.0), @(3 / 6.0), @(5 / 6.0), @1];
    animation.duration = 0.3;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.additive = YES;
    
    [cell.layer addAnimation:animation forKey:@"shake"];
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
