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
    [FormModel generate:self.form form:currentForm completion:^(XLFormDescriptor *formDescriptor, NSError *error) {
        [weakSelf checkError:error completion:^{
            weakSelf.form = formDescriptor;
            [weakSelf postProcessFormDescriptorWithCompletion:^(NSError *error) {
                [weakSelf checkError:error completion:^{
                    [FormModel loadValueFrom:weakSelf.valueDictionary on:weakSelf partialUpdate:nil];
                    [SVProgressHUD dismiss];
                }];
            }];
        }];
    }];
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
    
    [FormModel saveValueFrom:self.form to:self.valueDictionary];
    [SVProgressHUD show];
    __block typeof(self) weakSelf = self;
    [DataMAPModel postDataMAPWithDictionary:self.valueDictionary completion:^(NSDictionary *dictionary, NSError *error) {
        [weakSelf checkError:error completion:^{
            [SVProgressHUD dismiss];
            if (self.delegate) [self.delegate saveDictionary:self.valueDictionary];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }];
}


- (void)postProcessFormDescriptorWithCompletion:(void(^)(NSError *error))block{
    __block dispatch_group_t group = dispatch_group_create();
    __block dispatch_queue_t queue = dispatch_get_main_queue();
    __block NSError *weakError;
    NSString *idCabang = [self.valueDictionary objectForKey:@"kodeCabang"] ?: @"";
    NSString *idProduct = [self.valueDictionary objectForKey:@"produk"] ?: @"";
    
    for (XLFormSectionDescriptor *section in self.form.formSections) {
        for (XLFormRowDescriptor *row in section.formRows) {
            if ([row.tag isEqualToString:@"submit"]){
                row.action.formSelector = @selector(saveButtonClicked:);
            }
            
            //Data Aplikasi
            if ([row.tag isEqualToString:@"jenisAplikasi"]){
                dispatch_group_enter(group);
                [DropdownModel getDropdownWSType:@"jenisAplikasi" keyword:@"" idCabang:idCabang additionalURL:@"" completion:^(NSArray *datas, NSError *error) {
                    @try {
                        if (error) {
                            weakError = error;
                            
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
                            weakError = error;
                            
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
                            weakError = error;
                            
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
                            weakError = error;
                            
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
                            weakError = error;
                            
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
                            weakError = error;
                            
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
                            weakError = error;
                            
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
                            weakError = error;
                            
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
                            weakError = error;
                            
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
                dispatch_group_enter(group);
                [DropdownModel getDropdownWSType:@"Pekerjaan" keyword:@"" idCabang:idCabang additionalURL:@"" completion:^(NSArray *datas, NSError *error) {
                    @try {
                        if (error) {
                            weakError = error;
                            
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
                dispatch_group_enter(group);
                [DropdownModel getDropdownWSType:@"BidangUsaha" keyword:@"" idCabang:idCabang additionalURL:@"" completion:^(NSArray *datas, NSError *error) {
                    @try {
                        if (error) {
                            weakError = error;
                            
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
                            weakError = error;
                            
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
            
            //Data Keluarga
            
            //Struktur Pembiayaan
            if ([row.tag isEqualToString:@"caraPembiayaan"]){
                dispatch_group_enter(group);
                [DropdownModel getDropdownWSType:@"WayOfPayment" keyword:@"" idCabang:idCabang additionalURL:@"" completion:^(NSArray *datas, NSError *error) {
                    @try {
                        if (error) {
                            weakError = error;
                            
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
                            weakError = error;
                            
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
                            weakError = error;
                            
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
                            weakError = error;
                            
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
            if ([row.tag isEqualToString:@"asuransiDibayar"]){
                dispatch_group_enter(group);
                [DropdownModel getDropdownWSType:@"AsuransiDibayar" keyword:@"" idCabang:idCabang additionalURL:@"" completion:^(NSArray *datas, NSError *error) {
                    @try {
                        if (error) {
                            weakError = error;
                            
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
                            weakError = error;
                            
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
                            weakError = error;
                            
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
            if ([row.tag isEqualToString:@"pemakaianUnit"]){
                dispatch_group_enter(group);
                [DropdownModel getDropdownWSType:@"PemakaianUnit" keyword:@"" idCabang:idCabang additionalURL:@"" completion:^(NSArray *datas, NSError *error) {
                    @try {
                        if (error) {
                            weakError = error;
                            
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
                            weakError = error;
                            
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
                            weakError = error;
                            
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
                            weakError = error;
                            
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
        }
    }
    
    dispatch_group_notify(group, queue, ^{
        if (block) block(weakError);
    });
}

- (void)formRowDescriptorValueHasChanged:(XLFormRowDescriptor *)formRow oldValue:(id)oldValue newValue:(id)newValue{
    if ([formRow.tag isEqualToString:@"productOffering"]) {
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
