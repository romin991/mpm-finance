
//
//  FormViewController.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 5/14/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "FormViewController.h"
#import "Form.h"
#import <JVFloatLabeledTextField/JVFloatLabeledTextView.h>
#import "FloatLabeledTextFieldCell.h"
#import "SimpleListViewController.h"
#import "WorkOrderModel.h"
#import "DropdownModel.h"
#import "FormModel.h"
#import "ProfileModel.h"
#import "PostalCodeViewController.h"
#import "PostalCodeValueTransformer.h"
#import "AssetViewController.h"
#import "AssetValueTransformer.h"
#import "BarcodeViewController.h"
#import "MenuViewController.h"
#import "FloatLabeledTextFieldCell.h"
#import "SubmenuViewController.h"
#import "OfflineData.h"
#import "DisclaimerViewController.h"
#import "WorkOrderListViewController.h"
#import "AppDelegate.h"
#import <AFNetworking.h>
#import "Reachability.h"
@interface FormViewController ()

@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;
@property (weak, nonatomic) IBOutlet UIView *labelView;

@property RLMResults *forms;
@property BOOL isFromOffline;
@property NSString *idCabang;
@property BOOL isReloadData;
@property (nonatomic) Reachability *hostReachability;
@end

@implementation FormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    CGRect frame = self.tableView.frame;
    frame.origin.y += 44;
    frame.size.height -= 44;
    self.tableView.frame = frame;
    
    // Do any additional setup after loading the view from its nib.
    if ([[MPMUserInfo getRole] isEqualToString:kRoleSupervisor] || [[MPMUserInfo getRole] isEqualToString:kRoleBM]) {
        self.forms = [Form getFormForMenu:self.menu.primaryKey];
    } else {
        self.forms = [Form getFormForMenu:self.menu.primaryKey role:[MPMUserInfo getRole]];
    }
    
    [self setTitle:self.menu.title];
    [self setHorizontalLabel];
  if (self.isFromHistory) {
    [SVProgressHUD show];
  }
  
  
  //Change the host name here to change the server you want to monitor.
  NSString *remoteHostName = @"www.apple.com";
  self.hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
  [self.hostReachability startNotifier];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
  

  if (self.valueDictionary.count == 0)  {
    self.valueDictionary = [NSMutableDictionary dictionary];
  }
  [self reloadData];
}

/*!
 * Called by Reachability whenever status changes.
 */
- (void) reachabilityChanged:(NSNotification *)note
{
  Reachability* curReach = [note object];
  NetworkStatus netStatus = [curReach currentReachabilityStatus];
  if (netStatus == NotReachable) {
    NSLog(@"not reachable");
    [self reloadData];
  } else {
    NSLog(@"reachable to internet!");
    [self reloadData];
  }
  
  
}

- (void)reloadData {
  __block FormViewController *weakSelf = self;
  if (self.isReloadData) {
    [FormModel saveValueFrom:self.form to:self.valueDictionary];
  }
  [self preparingValueWithCompletion:^{
    [self preparingFormDescriptorWithCompletion:^{
      [FormModel loadValueFrom:weakSelf.valueDictionary on:weakSelf partialUpdate:nil];
      [SVProgressHUD dismiss];
    }];
  }];
  self.isReloadData = YES;
  
}
-(BOOL)textField:(XLFormRowDescriptor *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return YES;
}

- (void)preparingValueWithCompletion:(void(^)())block{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    __block FormViewController *weakSelf = self;
    __block NSError *_error = nil;
  if (self.isReloadData) {
    if ([[MPMUserInfo getRole] isEqualToString:kRoleCustomer] && !self.isFromMonitoring) {
      dispatch_group_enter(group);
      [ProfileModel getProfileDataWithCompletion:^(NSDictionary *dictionary, NSError *error) {
        if (error) _error = error;
        if (dictionary && !(weakSelf.isFromHistory || weakSelf.isFromMonitoring || ([weakSelf.valueDictionary objectForKey:@"alamatRumahSesuaiKTP"] && [weakSelf.valueDictionary[@"alamatRumahSesuaiKTP"] length] > 0))) {
          NSLog(@"kjlkjlkewjfklwefjlwekfjweklfjewklfjkljwflkwjefklwj");
          [weakSelf.valueDictionary addEntriesFromDictionary:dictionary];
          
        }
        
        dispatch_group_leave(group);
      }];
    }
    
    dispatch_group_notify(group, queue, ^{
      [weakSelf checkError:_error completion:^{
        if (block) block();
      }];
    });
    return;
  }
    if (self.list && ([self.list.guid isEqualToString:@""] || self.list.guid == nil) && self.isFromHistory == NO) {
        if ([self.parentMenu.primaryKey isEqualToString:kSubmenuListWorkOrder] ||
            [self.parentMenu.primaryKey isEqualToString:kSubmenuMonitoring]) {
            dispatch_group_enter(group);
            [WorkOrderModel getListWorkOrderDetailCompleteDataWithID:self.list.primaryKey completion:^(NSDictionary *response, NSError *error) {
                if (error) _error = error;
                if (response && weakSelf.valueDictionary.count < 1) [weakSelf.valueDictionary addEntriesFromDictionary:response];
              
                dispatch_group_leave(group);
            }];
            
        } else {
            dispatch_group_enter(group);
            [WorkOrderModel getListWorkOrderDetailWithID:self.list.primaryKey completion:^(NSDictionary *response, NSError *error) {
                if (error) _error = error;
                if (response) [weakSelf.valueDictionary addEntriesFromDictionary:response];
                dispatch_group_leave(group);
            }];
        }
    }
  
  if (!self.list) {
    self.list = [[List alloc] init];
    self.list.guid = [[NSUUID UUID] UUIDString];
  }
    
    dispatch_group_notify(group, queue, ^{
      NSString *kewarganegaraan = @"WNI";
      NSString *kewarganegaraanPasangan = @"WNI";
      if ([weakSelf.valueDictionary objectForKey:@"kewarganegaraan"]) {
        kewarganegaraan = weakSelf.valueDictionary[@"kewarganegaraan"];
      }
      if ([weakSelf.valueDictionary objectForKey:@"kewarganegaraanPasangan"]) {
        kewarganegaraanPasangan = weakSelf.valueDictionary[@"kewarganegaraanPasangan"];
      }
        [weakSelf.valueDictionary addEntriesFromDictionary:@{@"kewarganegaraan" : kewarganegaraan,
                                                             @"kewarganegaraanPasangan" : kewarganegaraanPasangan,
                                                             @"kodeCabang" : [MPMUserInfo getIdCabang],
                                                             }];
      
        if ([[MPMUserInfo getRole] isEqualToString:kRoleCustomer] && !self.isFromMonitoring ) {
            dispatch_group_enter(group);
            [ProfileModel getProfileDataWithCompletion:^(NSDictionary *dictionary, NSError *error) {
                if (error) _error = error;
                if (dictionary && !(weakSelf.isFromHistory || weakSelf.isFromMonitoring || ([weakSelf.valueDictionary objectForKey:@"alamatRumahSesuaiKTP"] && [weakSelf.valueDictionary[@"alamatRumahSesuaiKTP"] length] > 0))) {
                  NSLog(@"aaaaabbbbbbbbcccccccccddddddddeeeee");
                  [weakSelf.valueDictionary addEntriesFromDictionary:dictionary];
                
                dispatch_group_leave(group);
                }
            }];
        }
    
        dispatch_group_notify(group, queue, ^{
            [weakSelf checkError:_error completion:^{
                if (block) block();
            }];
        });
    });
}

- (void)preparingFormDescriptorWithCompletion:(void(^)())block{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    __block FormViewController *weakSelf = self;
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
        for (XLFormSectionDescriptor *section in _formDescriptor.formSections) {
            for (XLFormRowDescriptor *row in section.formRows) {
                if ([row.tag isEqualToString:@"next"]){
                    row.action.formSelector = @selector(nextButtonClicked:);
                }
                
                if ([row.tag isEqualToString:@"kelurahanSesuaiKTP"] || [row.tag isEqualToString:@"kelurahanDomisili"] || [row.tag isEqualToString:@"kelurahanPasangan"]){
                    row.action.viewControllerNibName = @"PostalCodeViewController";
                    row.valueTransformer = [PostalCodeValueTransformer class];
                }
              if ([row.tag isEqualToString:@"tipeProduk"]) {
                if (![self.tipeProduk isEqual:@(0)] && self.tipeProduk != nil ) {
                  row.disabled = @YES;
                }
              }
                
                if ([row.tag isEqualToString:@"tipeKendaraan"]){
                    row.action.viewControllerNibName = @"AssetViewController";
                    row.valueTransformer = [AssetValueTransformer class];
                  row.height = 100;
                    __block XLFormRowDescriptor *weakRow = row;
                  if (![self.tipeProduk isEqual:@(0)] && self.tipeProduk != nil ) {
                    [self.valueDictionary setValue:self.tipeProduk forKey:@"tipeProduk"];
                  }
                    NSString *idCabang = [self.valueDictionary objectForKey:@"kodeCabang"];
                    NSString *idProduct = [self.valueDictionary objectForKey:@"tipeProduk"];
                    NSString *tipeKendaraan = [self.valueDictionary objectForKey:@"tipeKendaraan"];
                    
                    if (idProduct && idCabang && tipeKendaraan) {
                        dispatch_group_enter(group);
                        [DropdownModel getDropdownWSForAssetWithKeyword:tipeKendaraan idProduct:idProduct idCabang:idCabang completion:^(NSArray *options, NSError *error) {
                            if (error) _error = error;
                            
                            NSMutableArray *optionObjects = [NSMutableArray array];
                            for (Asset *option in options) {
                                [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:option.value displayText:option.name]];
                            }
                            weakRow.selectorOptions = optionObjects;
                            
                            dispatch_group_leave(group);
                        }];
                    }
                }
                
                if ([row.tag isEqualToString:@"tahunKendaraan"]){
                    @try {
                      row.required = YES;
                        NSDate *date = [NSDate date];
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        [dateFormatter setDateFormat:@"yyyy"];
                        NSString *yearString = [dateFormatter stringFromDate:date];
                        NSInteger year = yearString.integerValue;
                        
                        NSMutableArray *optionObjects = [NSMutableArray array];
                        for (int i = 0; i < 16; i++) {
                            [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@(year - i) displayText:[NSString stringWithFormat:@"%li", (long) year - i]]];
                        }
                        row.selectorOptions = optionObjects;
                    } @catch (NSException *exception) {
                        NSLog(@"%@", exception);
                    }
                }
                
                if ([row.tag isEqualToString:@"kewarganegaraan"] || [row.tag isEqualToString:@"kewarganegaraanPasangan"]){
                    @try {
                        NSMutableArray *optionObjects = [NSMutableArray array];
                        [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"WNI" displayText:@"WNI"]];
                        [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@"WNA" displayText:@"WNA"]];
                        row.selectorOptions = optionObjects;
                    } @catch (NSException *exception) {
                        NSLog(@"%@", exception);
                    }
                }
                if ([row.tag isEqualToString:@"tanggalLahir"]) {
                    if ([[row cellForFormController:self] isKindOfClass:XLFormDateCell.class]){
                      
                      
                      NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                      NSDate *currentDate = [NSDate date];
                      NSDateComponents *comps = [[NSDateComponents alloc] init];
                      [comps setYear:-17];
                      NSDate *minDate = [gregorian dateByAddingComponents:comps toDate:currentDate  options:0];
                      [comps setYear:-150];
                      
                      
                      [(XLFormDateCell *)[row cellForFormController:self] setMaximumDate:minDate];
                      
                    }
                } else if ([row.tag isEqualToString:@"tanggalLahirPasangan"]){
                  if ([[row cellForFormController:self] isKindOfClass:XLFormDateCell.class]){
                    NSDate *currentDate = [NSDate date];
                    
                    [(XLFormDateCell *)[row cellForFormController:self] setMaximumDate:currentDate];
                    
                  }
                }
              
                if ([row.tag isEqualToString:@"namaLengkap"]) {
                    ((FloatLabeledTextFieldCell *)[row cellForFormController:self]).mustAlphabetOnly = YES;
                }
                if ([row.tag isEqualToString:@"noKTPPasangan"]) {
                    ((FloatLabeledTextFieldCell *)[row cellForFormController:self]).maximumLength = 16;
                    ((FloatLabeledTextFieldCell *)[row cellForFormController:self]).mustAlphabetNumericOnly = YES;
                  ((FloatLabeledTextFieldCell *)[row cellForFormController:self]).disableSpace = YES;
                }
                if ([row.tag isEqualToString:@"nomorHandphonePasangan"]) {
                    ((FloatLabeledTextFieldCell *)[row cellForFormController:self]).maximumLength = 15;
                  ((FloatLabeledTextFieldCell *)[row cellForFormController:self]).mustNumericOnly = YES;
                }
                if ([row.tag isEqualToString:@"nomorKartuKreditAtauKontrak1"]) {
                    ((FloatLabeledTextFieldCell *)[row cellForFormController:self]).maximumLength = 20;
                    ((FloatLabeledTextFieldCell *)[row cellForFormController:self]).mustNumericOnly = YES;
                }
                if ([row.tag isEqualToString:@"nomorKartuKreditAtauKontrak2"]) {
                    ((FloatLabeledTextFieldCell *)[row cellForFormController:self]).maximumLength = 20;
                    ((FloatLabeledTextFieldCell *)[row cellForFormController:self]).mustNumericOnly = YES;
                }
                if ([row.tag isEqualToString:@"rTPasangan"] || [row.tag isEqualToString:@"rTDomisili"]) {
                    ((FloatLabeledTextFieldCell *)[row cellForFormController:self]).maximumLength = 3;
                }
                if ([row.tag isEqualToString:@"rWPasangan"] || [row.tag isEqualToString:@"rWDomisili"]) {
                    ((FloatLabeledTextFieldCell *)[row cellForFormController:self]).maximumLength = 3;
                }
                if ([row.tag isEqualToString:@"rWPasangan"]) {
                    ((FloatLabeledTextFieldCell *)[row cellForFormController:self]).maximumLength = 3;
                }
                if ([row.tag isEqualToString:@"rWPasangan"]) {
                    ((FloatLabeledTextFieldCell *)[row cellForFormController:self]).maximumLength = 3;
                }
                if ([row.tag isEqualToString:@"kodeAreaTeleponTempatKerja"] || [row.tag isEqualToString:@"kodeArea"]) {
                    ((FloatLabeledTextFieldCell *)[row cellForFormController:self]).maximumLength = 4;
                }
                if ([row.tag isEqualToString:@"nomorTeleponTempatKerja"]) {
                    ((FloatLabeledTextFieldCell *)[row cellForFormController:self]).maximumLength = 15;
                }
                if ([row.tag isEqualToString:@"nomorTeleponEcon"]) {
                    ((FloatLabeledTextFieldCell *)[row cellForFormController:self]).maximumLength = 15;
                }
                if ([row.tag isEqualToString:@"namaGadisIbuKandung"]) {
                    ((FloatLabeledTextFieldCell *)[row cellForFormController:self]).mustAlphabetOnly = YES;
                }
                if ([row.tag isEqualToString:@"namaEcon"]) {
                    ((FloatLabeledTextFieldCell *)[row cellForFormController:self]).mustAlphabetOnly = YES;
                }
                if ([row.tag isEqualToString:@"namaLengkapPasangan"]) {
                    ((FloatLabeledTextFieldCell *)[row cellForFormController:self]).mustAlphabetOnly = YES;
                    ((FloatLabeledTextFieldCell *)[row cellForFormController:self]).maximumLength = 20;
                }
                if ([row.tag isEqualToString:@"rTSesuaiKTP"] ||
                    [row.tag isEqualToString:@"rWSesuaiKTP"] ||
                    [row.tag isEqualToString:@"kodeArea"] ||
                    [row.tag isEqualToString:@"noKTP"] ||
                    [row.tag isEqualToString:@"nomorTelepon"] ||
                    [row.tag isEqualToString:@"nomorHandphone"] ||
                    
                    [row.tag isEqualToString:@"rTDomisili"] ||
                    [row.tag isEqualToString:@"rWDomisili"] ||
                    
                    [row.tag isEqualToString:@"nomorHandphonePasangan"] ||
                    
                    [row.tag isEqualToString:@"rTPasangan"] ||
                    [row.tag isEqualToString:@"rWPasangan"] ||
                    
                    [row.tag isEqualToString:@"hargaPerolehan"] ||
                    [row.tag isEqualToString:@"uangMuka"] ||
                    [row.tag isEqualToString:@"jangkaWaktuPembayaran"] ||
                    [row.tag isEqualToString:@"angsuran"] ||
                    
                    [row.tag isEqualToString:@"kodeAreaTeleponTempatKerja"] ||
                    [row.tag isEqualToString:@"nomorTeleponTempatKerja"] ||
                    [row.tag isEqualToString:@"nomorTeleponEcon"] ||
                    [row.tag isEqualToString:@"nomorKartuKreditAtauKontrak1"] ||
                    [row.tag isEqualToString:@"nomorKartuKreditAtauKontrak2"] 
                    ){
                    
                    //Set keyboard type to numberPad
                    if ([[row cellForFormController:self] isKindOfClass:FloatLabeledTextFieldCell.class]){
                        [(FloatLabeledTextFieldCell *)[row cellForFormController:self] setKeyboardType:UIKeyboardTypeNumberPad];
                        if ([row.tag isEqualToString:@"rTSesuaiKTP"] || [row.tag isEqualToString:@"rWSesuaiKTP"]) {
                            ((FloatLabeledTextFieldCell *)[row cellForFormController:self]).maximumLength = 3;
                        } else if ([row.tag isEqualToString:@"nomorTelepon"]){
                            ((FloatLabeledTextFieldCell *)[row cellForFormController:self]).maximumLength = 15;
                        } else if ([row.tag isEqualToString:@"nomorHandphone"]){
                            ((FloatLabeledTextFieldCell *)[row cellForFormController:self]).maximumLength = 15;
                        } else if ([row.tag isEqualToString:@"noKTP"]){
                            ((FloatLabeledTextFieldCell *)[row cellForFormController:self]).maximumLength = 16;
                          ((FloatLabeledTextFieldCell *)[row cellForFormController:self]).mustNumericOnly = YES;
                        }
                    }
                }
                
                
              if ([row.tag containsString:@"kecamatan"] ||
                  [row.tag containsString:@"kota"] ||
                  [row.tag containsString:@"kodepos"]){
                
              }
              else  if ([[MPMUserInfo getRole] isEqualToString:kRoleDedicated] && [self.list.status isEqualToString:@"Work Order Marketing"]){
                    if ([row.tag isEqualToString:@"noKTP"] ||
                        [row.tag isEqualToString:@"namaLengkap"] ||
                        [row.tag isEqualToString:@"tempatLahir"] ||
                        [row.tag isEqualToString:@"tanggalLahir"] ||
                        [row.tag isEqualToString:@"jenisKelamin"] ||
                        [row.tag isEqualToString:@"alamatRumahSesuaiKTP"] ||
                        [row.tag isEqualToString:@"rTSesuaiKTP"] ||
                        [row.tag isEqualToString:@"rWSesuaiKTP"] ||
                        [row.tag isEqualToString:@"kelurahanSesuaiKTP"] ||
                        [row.tag isEqualToString:@"kecamatanSesuaiKTP"] ||
                        [row.tag isEqualToString:@"masaBerlakuKTP"] ||
                        [row.tag isEqualToString:@"kotaSesuaiKTP"] ||
                        [row.tag isEqualToString:@"kodeposSesuaiKTP"] ||
                        [row.tag isEqualToString:@"kodeposPasangan"] ||
                        [row.tag isEqualToString:@"alamatDomisili"] ||
                        [row.tag isEqualToString:@"rTDomisili"] ||
                        [row.tag isEqualToString:@"rWDomisili"] ||
                        [row.tag isEqualToString:@"kelurahanDomisili"] ||
                        [row.tag isEqualToString:@"kecamatanDomisili"] ||
                        [row.tag isEqualToString:@"kotaDomisili"] ||
                        [row.tag isEqualToString:@"kodeposDomisili"] ||
                        [row.tag isEqualToString:@"namaGadisIbuKandung"] ||
                        [row.tag isEqualToString:@"samaDenganAlamatLegal"] ||
                        [row.tag isEqualToString:@"tipeProduk"]) {
                      row.disabled = @YES;
                    }
                }else if ([[MPMUserInfo getRole] isEqualToString:kRoleCustomer]) {
                  if ([row.tag isEqualToString:@"noKTP"] ||
                      [row.tag isEqualToString:@"namaLengkap"] ||
                      [row.tag isEqualToString:@"tempatLahir"] ||
                      [row.tag isEqualToString:@"tanggalLahir"] ||
                      [row.tag isEqualToString:@"jenisKelamin"] ||
                      [row.tag isEqualToString:@"nomorHandphone"]
                      ) {
                    row.required = NO;
                    row.disabled = @YES;
                  }
                } else {
                  row.disabled = @NO;
                }
              
              if ([row.tag isEqualToString:@"kewarganegaraan"]) {
                row.disabled = @YES;
              }
                NSString *groupLevel = self.list.groupLevel;
                if ((([self.parentMenu.primaryKey isEqualToString:kSubmenuListWorkOrder] &&
                    (([[MPMUserInfo getRole] isEqualToString:kRoleSupervisor] ||
                     [[MPMUserInfo getRole] isEqualToString:kRoleBM]) ||
                     [groupLevel isEqualToString:kGroupLevelOfficer] )) ||
                    [self.parentMenu.primaryKey isEqualToString:kSubmenuMonitoring]) &&
                    ![row.tag isEqualToString:@"next"]
                    ) {
                  //self.isFromHistory = YES;
                    self.isReadOnly = YES;
                    row.disabled = @YES;
                }
                
                if (self.isFromHistory == YES && ![row.tag isEqualToString:@"next"]) {
                    NSLog(@"lalala %@",row.tag);
                    row.disabled = @YES;
                    self.isReadOnly = YES;
                }
              
              if(([[MPMUserInfo getRole] isEqualToString:kRoleDedicated] && [self.list.status isEqualToString:@"Progress MAP & Survey by Marketing"] && ![row.tag isEqualToString:@"next"]))
                {
                  self.isReadOnly = YES;
                  row.disabled = @YES;
                }
              
              if (self.hostReachability.currentReachabilityStatus == NotReachable){
                if ([row.rowType isEqualToString:XLFormRowDescriptorTypeSelectorPush] || [row.tag containsString:@"kodepos"]  || [row.tag isEqualToString:@"kodePosPasangan"] ) {
                    row.disabled = @YES;
                    row.required = NO;
                } else if ([row.tag containsString:@"kecamatan"] || [row.tag containsString:@"kota"] || [row.tag containsString:@"kodepos"] || [row.tag isEqualToString:@"kodePosPasangan"] || [row.tag containsString:@"jenis"] || [row.tag containsString:@"tipe"]) {
                    row.required = NO;
                }
                if ([row.tag containsString:@"kewarganegaraanPasangan"]) {
                  row.disabled = @NO;
                  row.required = YES;
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

- (void)checkError:(NSError *)error completion:(void(^)())block{
//    if (error) {
//        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
//        [SVProgressHUD dismissWithDelay:1.5 completion:^{
//            [self.navigationController popViewControllerAnimated:YES];
//        }];
//    } else {
        block();
//    }
}

- (void)finish{
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[SubmenuViewController class]]) {
            [self.navigationController popToViewController:vc animated:NO];
        }
    }
}

- (void)nextButtonClicked:(id)sender{
  
  
    NSString *groupLevel = self.list.groupLevel;
    if (([self.parentMenu.primaryKey isEqualToString:kSubmenuListWorkOrder] &&
          (([[MPMUserInfo getRole] isEqualToString:kRoleSupervisor] ||
            [[MPMUserInfo getRole] isEqualToString:kRoleBM]) ||
           [groupLevel isEqualToString:kGroupLevelOfficer] )) ||
         [self.parentMenu.primaryKey isEqualToString:kSubmenuMonitoring]) {
        
        
    } else {
      if (self.isFromHistory == NO) {
        NSArray *inputErrors = [self validateForm];
        if (inputErrors.count > 0)
        {
          [SVProgressHUD showErrorWithStatus:((NSError *)inputErrors.firstObject).localizedDescription];
          [SVProgressHUD dismissWithDelay:1.5];
          return;
        }
      }
      
    }
    
    NSArray *errors = [self formValidationErrors];
    if ([self.parentMenu.primaryKey isEqualToString:kMenuMonitoring] || [self.parentMenu.primaryKey isEqualToString:kSubmenuListWorkOrder] || self.isFromHistory) {
        errors = nil;
    }
    if (errors.count) {
        [SVProgressHUD showErrorWithStatus:((NSError *)errors.firstObject).localizedDescription];
        [SVProgressHUD dismissWithDelay:1.5];
        
    } else {
      if (!self.isFromHistory) {
        [SVProgressHUD show];
      }
      if(self.isFromHistory == NO)
        [FormModel saveValueFrom:self.form to:self.valueDictionary];
        __weak typeof(self) weakSelf = self;
      
      if (!self.isFromHistory) {
        [WorkOrderModel postDraftWorkOrder:self.list dictionary:self.valueDictionary isOffline:(self.hostReachability.currentReachabilityStatus == NotReachable) completion:^(NSDictionary *dictionary, NSError *error) {
          if (error && error.code != 1) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            [SVProgressHUD dismissWithDelay:1.5];
            
          } else {
            if (weakSelf.list == nil) {
              @try {
                List *list = [[List alloc] init];
                list.primaryKey = [[[dictionary objectForKey:@"data"] objectForKey:@"id"] integerValue];
                if (list.primaryKey) {
                  weakSelf.list = list;
                }
              } @catch (NSException *exception){
                NSLog(@"%@", exception);
              }
            }
            
            if (weakSelf.list.primaryKey == 0) {
              @try {
                weakSelf.list.primaryKey = [[[dictionary objectForKey:@"data"] objectForKey:@"id"] integerValue];
                
              } @catch (NSException *exception){
                NSLog(@"%@", exception);
              }
            }
            
            [SVProgressHUD dismiss];
            
            Form *nextForm = [weakSelf.forms objectAtIndex:self.index + 1];
            if ([nextForm.title isEqualToString:@"Disclaimer"]) {
              //save to object, call delegate, then pop navigation
              DisclaimerViewController *disclaimerVC = [[DisclaimerViewController alloc] init];
              disclaimerVC.valueDictionary = weakSelf.valueDictionary;
              disclaimerVC.list = weakSelf.list;
              disclaimerVC.parentMenu = weakSelf.parentMenu;
              disclaimerVC.menu = weakSelf.menu;
              disclaimerVC.isFromMonitoringPengajuanOnline = weakSelf.isFromMonitoringPengajuanOnline;
              disclaimerVC.isFromMonitoring = weakSelf.isFromMonitoring;
              disclaimerVC.isReadOnly = self.isReadOnly;
              disclaimerVC.isFromHistory = self.isFromHistory;
              if ([weakSelf.list.status isEqualToString:@"Work Order Marketing"] && [[MPMUserInfo getRole] isEqualToString:kRoleDedicated]) {
                disclaimerVC.needToShowWorkOrder = YES;
              }
              [weakSelf.navigationController pushViewController:disclaimerVC animated:true];
              
            } else {
              [weakSelf goToNextForm];
            }
          }
        }];
      } else {
        Form *nextForm = [weakSelf.forms objectAtIndex:self.index + 1];
        if ([nextForm.title isEqualToString:@"Disclaimer"]) {
          //save to object, call delegate, then pop navigation
          DisclaimerViewController *disclaimerVC = [[DisclaimerViewController alloc] init];
          disclaimerVC.valueDictionary = weakSelf.valueDictionary;
          disclaimerVC.list = weakSelf.list;
          disclaimerVC.parentMenu = weakSelf.parentMenu;
          disclaimerVC.menu = weakSelf.menu;
          disclaimerVC.isFromMonitoringPengajuanOnline = weakSelf.isFromMonitoringPengajuanOnline;
          disclaimerVC.isFromMonitoring = weakSelf.isFromMonitoring;
          disclaimerVC.isReadOnly = self.isReadOnly;
          disclaimerVC.isFromHistory = self.isFromHistory;
          if ([weakSelf.list.status isEqualToString:@"Work Order Marketing"] && [[MPMUserInfo getRole] isEqualToString:kRoleDedicated]) {
            disclaimerVC.needToShowWorkOrder = YES;
          }
          [weakSelf.navigationController pushViewController:disclaimerVC animated:true];
          
        } else {
          [weakSelf goToNextForm];
        }
      }
      
    }
}

- (void)goToNextForm{
    FormViewController *nextFormViewController = [[FormViewController alloc] init];
    nextFormViewController.menu = self.menu;
  nextFormViewController.tipeProduk = self.tipeProduk;
    nextFormViewController.index = self.index + 1;
  nextFormViewController.isFromMonitoringPengajuanOnline = self.isFromMonitoringPengajuanOnline;
  nextFormViewController.isFromMonitoring = self.isFromMonitoring;
    nextFormViewController.valueDictionary = self.valueDictionary;
    nextFormViewController.list = self.list;
    nextFormViewController.parentMenu = self.parentMenu;
  nextFormViewController.isFromHistory = self.isFromHistory;
  nextFormViewController.isReadOnly = self.isReadOnly;
    [self.navigationController pushViewController:nextFormViewController animated:YES];
}

- (void)setHorizontalLabel{
    Form *firstForm;
    Form *secondForm;
    Form *thirdForm;
    
    if (self.forms.count > self.index) firstForm = [self.forms objectAtIndex:self.index];
    if (self.forms.count > self.index + 1) secondForm = [self.forms objectAtIndex:self.index + 1];
    if (self.forms.count > self.index + 2) thirdForm = [self.forms objectAtIndex:self.index + 2];
    
    self.firstLabel.text = firstForm ? firstForm.title : @"";
    self.secondLabel.text = secondForm ? secondForm.title : @"";
    self.thirdLabel.text = thirdForm ? thirdForm.title : @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)formRowDescriptorValueHasChanged:(XLFormRowDescriptor *)formRow oldValue:(id)oldValue newValue:(id)newValue{
    if ([formRow.tag isEqualToString:@"tipeProduk"] && ![newValue isEqual:[NSNull null]]) {
      
        XLFormRowDescriptor *row = [self.form formRowWithTag:@"tahunKendaraan"];
        if (![oldValue isEqual:[NSNull null]]) {
            XLFormRowDescriptor *rowKendaraan = [self.form formRowWithTag:@"tipeKendaraan"];
            rowKendaraan.value = @"";
            row.value = @"";
            [self reloadFormRow:rowKendaraan];
            [self reloadFormRow:row];
        }
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy"];
        NSString *yearString = [dateFormatter stringFromDate:date];
        NSInteger year = yearString.integerValue;
        
        NSMutableArray *optionObjects = [NSMutableArray array];
      NSNumber *finalNewValue = @0;
      if ([newValue isKindOfClass:[NSString class]]) {
        finalNewValue = @([newValue integerValue]);
      } else
      {
        finalNewValue = ((XLFormOptionsObject *)newValue).formValue;
      }
      [self.valueDictionary setValue:finalNewValue forKey:@"tipeProduk"];
        if ([finalNewValue isEqual:@1]) { // new bike
            for (int i = 0; i < 3; i++) {
                [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@(year - i) displayText:[NSString stringWithFormat:@"%li", (long) year - i]]];
            }
        } else if ([finalNewValue isEqual:@3]) { // new car
            for (int i = 0; i < 3; i++) {
                [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@(year - i) displayText:[NSString stringWithFormat:@"%li", (long) year - i]]];
            }
        } else  { // used car
            for (int i = 0; i < 16; i++) {
                [optionObjects addObject:[XLFormOptionsObject formOptionsObjectWithValue:@(year - i) displayText:[NSString stringWithFormat:@"%li", (long) year - i]]];
            }
        }
        
        row.selectorOptions = optionObjects;
    }
    if ([formRow.tag isEqualToString:@"alamatRumahSesuaiKTP"] ||
        [formRow.tag isEqualToString:@"rTSesuaiKTP"] ||
        [formRow.tag isEqualToString:@"rWSesuaiKTP"]){
        
        [self setDomicileAddressValueWithTheSameValueAsLegalAddress];
    }
    
    if ([formRow.tag isEqualToString:@"kelurahanSesuaiKTP"] && newValue != nil && [newValue isKindOfClass:PostalCode.class]) {
        @try {
            PostalCode *postalCode = (PostalCode *)newValue;
            //set value
            self.valueDictionary[@"kelurahanSesuaiKTP"] = postalCode.subDistrict;
            [self.valueDictionary addEntriesFromDictionary:@{@"kecamatanSesuaiKTP" : postalCode.disctrict,
                                                             @"kodeposSesuaiKTP" : postalCode.postalCode,
                                                             @"kotaSesuaiKTP" : postalCode.city,}];
            [FormModel loadValueFrom:self.valueDictionary on:self partialUpdate:
             [NSArray arrayWithObjects:@"kecamatanSesuaiKTP", @"kodeposSesuaiKTP", @"kotaSesuaiKTP",@"kelurahanSesuaiKTP", nil]];
            [self setDomicileAddressValueWithTheSameValueAsLegalAddress];
        } @catch (NSException *exception) {
            NSLog(@"%@", exception);
        }
    }
    
    if ([formRow.tag isEqualToString:@"kelurahanDomisili"] && newValue != nil && [newValue isKindOfClass:PostalCode.class]) {
        @try {
            PostalCode *postalCode = (PostalCode *)newValue;
            //set value
            self.valueDictionary[@"kelurahanDomisili"] = postalCode.subDistrict;
            [self.valueDictionary addEntriesFromDictionary:@{@"kecamatanDomisili" : postalCode.disctrict,
                                                             @"kodeposDomisili" : postalCode.postalCode,
                                                             @"kotaDomisili" : postalCode.city,}];
            
            [FormModel loadValueFrom:self.valueDictionary on:self partialUpdate:
             [NSArray arrayWithObjects:@"kecamatanDomisili", @"kodeposDomisili", @"kotaDomisili",@"kelurahanDomisili", nil]];
        } @catch (NSException *exception) {
            NSLog(@"%@", exception);
        }
    }
    if ([formRow.tag isEqualToString:@"kelurahanPasangan"] && newValue != nil && [newValue isKindOfClass:PostalCode.class]) {
        @try {
            PostalCode *postalCode = (PostalCode *)newValue;
            //set value
          self.valueDictionary[@"kelurahanPasangan"] = postalCode.subDistrict;
            [self.valueDictionary addEntriesFromDictionary:@{@"kecamatanPasangan" : postalCode.disctrict,
                                                             @"kodePosPasangan" : postalCode.postalCode,
                                                             @"kotaPasangan" : postalCode.city,}];
            
            [FormModel loadValueFrom:self.valueDictionary on:self partialUpdate:
             [NSArray arrayWithObjects:@"kecamatanPasangan", @"kodePosPasangan", @"kotaPasangan",@"kelurahanPasangan", nil]];
        } @catch (NSException *exception) {
            NSLog(@"%@", exception);
        }
    }
    
    
    if ([formRow.tag isEqualToString:@"samaDenganAlamatLegal"]){
        if ([newValue boolValue]){
            [self setDomicileAddressValueWithTheSameValueAsLegalAddress];
        } else {
            XLFormRowDescriptor *row = [self.form formRowWithTag:@"alamatDomisili"];
            if (row) {
                row.disabled = (self.isReadOnly || self.isFromHistory) ? @YES : @NO;
                row.value = @"";
                [self reloadFormRow:row];
            }
            
            row = [self.form formRowWithTag:@"rTDomisili"];
            if (row) {
                row.disabled = (self.isReadOnly || self.isFromHistory) ? @YES : @NO;
                row.value = @"";
                [self reloadFormRow:row];
            }
            
            row = [self.form formRowWithTag:@"rWDomisili"];
            if (row) {
              row.disabled = (self.isReadOnly || self.isFromHistory) ? @YES : @NO;
                row.value = @"";
                [self reloadFormRow:row];
            }
            
            row = [self.form formRowWithTag:@"kodeposDomisili"];
            if (row) {
                row.value = nil;
                [self reloadFormRow:row];
            }
            
            row = [self.form formRowWithTag:@"kecamatanDomisili"];
            if (row) {
                row.value = @"";
                [self reloadFormRow:row];
            }
            
            row = [self.form formRowWithTag:@"kelurahanDomisili"];
            if (row) {
                row.disabled = (self.isReadOnly || self.isFromHistory) ? @YES : @NO;
                row.value = @"";
                [self reloadFormRow:row];
            }
            
            row = [self.form formRowWithTag:@"kotaDomisili"];
            if (row) {
                row.value = @"";
                [self reloadFormRow:row];
            }
        }
    }
    
    if ([formRow.tag isEqualToString:@"tipeKendaraan"] && newValue != nil) {
        @try {
//            Asset *asset = (Asset *)newValue;
        } @catch (NSException *exception) {
            NSLog(@"%@", exception);
        }
    }
  
  if (self.isReadOnly) {
    formRow.disabled = @YES;
  }
  
}

- (void)setDomicileAddressValueWithTheSameValueAsLegalAddress{
    XLFormRowDescriptor *row = [self.form formRowWithTag:@"samaDenganAlamatLegal"];
    if ([row.value boolValue]) {
        row = [self.form formRowWithTag:@"alamatDomisili"];
        if (row) {
            row.disabled = @YES;
            row.value = [self.form formRowWithTag:@"alamatRumahSesuaiKTP"].value;
            [self reloadFormRow:row];
        }
        
        row = [self.form formRowWithTag:@"rTDomisili"];
        if (row) {
            row.disabled = @YES;
            row.value = [self.form formRowWithTag:@"rTSesuaiKTP"].value;
            [self reloadFormRow:row];
        }
        
        row = [self.form formRowWithTag:@"rWDomisili"];
        if (row) {
            row.disabled = @YES;
            row.value = [self.form formRowWithTag:@"rWSesuaiKTP"].value;
            [self reloadFormRow:row];
        }
        
        row = [self.form formRowWithTag:@"kodeposDomisili"];
        if (row) {
            row.value = [self.form formRowWithTag:@"kodeposSesuaiKTP"].value;
            [self reloadFormRow:row];
        }
        
        row = [self.form formRowWithTag:@"kecamatanDomisili"];
        if (row) {
            row.value = [self.form formRowWithTag:@"kecamatanSesuaiKTP"].value;
            [self reloadFormRow:row];
        }
        
        row = [self.form formRowWithTag:@"kelurahanDomisili"];
        if (row) {
            row.disabled = @YES;
            row.value = [self.form formRowWithTag:@"kelurahanSesuaiKTP"].value;
            [self reloadFormRow:row];
        }
        
        row = [self.form formRowWithTag:@"kotaDomisili"];
        if (row) {
            row.value = [self.form formRowWithTag:@"kotaSesuaiKTP"].value;
            [self reloadFormRow:row];
        }
        
    }
}
#pragma mark - actions

-(NSArray *)validateForm
{
  NSArray * array = [NSArray array];
    //notcalled because this is null
    if ([self.form formRowWithTag:@"tanggalLahir"]) {
      if (self.hostReachability.currentReachabilityStatus != NotReachable){
        XLFormRowDescriptor *row = [self.form formRowWithTag:@"tanggalLahir"];
        if ([((NSDate *) row.value) timeIntervalSinceNow] > -536457600 ) {
            UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:[self.form indexPathOfFormRow:row]];
            [self animateCell:cell];
            
            return @[[NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier]
                                         code:1
                                     userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"Minimal 17 Tahun", nil)}]];
        }
      }
    }
     if ([self.form formRowWithTag:@"noKTP"]) {
      XLFormRowDescriptor *row = [self.form formRowWithTag:@"noKTP"];
      if ([row.value length] < 16 && self.hostReachability.currentReachabilityStatus != NotReachable && ![[MPMUserInfo getRole] isEqualToString:kRoleCustomer]) {
        UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:[self.form indexPathOfFormRow:row]];
        [self animateCell:cell];
        
        return @[[NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier]
                                     code:1
                                 userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"No KTP Minimal 16 Karakter", nil)}]];
      }
    }
     if ([self.form formRowWithTag:@"jenisKelaminPasangan"]) {
        XLFormRowDescriptor *namaLengkapPasangan = [self.form formRowWithTag:@"namaLengkapPasangan"];
        XLFormRowDescriptor *nomorHandphonePasangan = [self.form formRowWithTag:@"nomorHandphonePasangan"];
        XLFormRowDescriptor *tempatLahirPasangan = [self.form formRowWithTag:@"tempatLahirPasangan"];
        XLFormRowDescriptor *tanggalLahirPasangan = [self.form formRowWithTag:@"tanggalLahirPasangan"];
        XLFormRowDescriptor *jenisKelaminPasangan = [self.form formRowWithTag:@"jenisKelaminPasangan"];
        XLFormRowDescriptor *alamatPasangan = [self.form formRowWithTag:@"alamatPasangan"];
        XLFormRowDescriptor *rTPasangan = [self.form formRowWithTag:@"rTPasangan"];
        XLFormRowDescriptor *rWPasangan = [self.form formRowWithTag:@"rWPasangan"];
        XLFormRowDescriptor *kelurahanPasangan = [self.form formRowWithTag:@"kelurahanPasangan"];
        XLFormRowDescriptor *masaBerlakuKTPPasangan = [self.form formRowWithTag:@"masaBerlakuKTPPasangan"];
        XLFormRowDescriptor *kewarganegaraanPasangan = [self.form formRowWithTag:@"kewarganegaraanPasangan"];
      XLFormRowDescriptor *kodePosPasangan = [self.form formRowWithTag:@"kodePosPasangan"];
      XLFormRowDescriptor *kotaPasangan = [self.form formRowWithTag:@"kotaPasangan"];
      XLFormRowDescriptor *kecamatanPasangan = [self.form formRowWithTag:@"kecamatanPasangan"];
      XLFormRowDescriptor *noKTPPasangan = [self.form formRowWithTag:@"noKTPPasangan"];
      
        BOOL isThereAnyValueForSpouse = [kodePosPasangan.value length] || [kecamatanPasangan.value length] || [kotaPasangan.value length] ||[noKTPPasangan.value length] || [namaLengkapPasangan.value length] || [nomorHandphonePasangan.value length] || [tempatLahirPasangan.value length] || [alamatPasangan.value length]|| [rTPasangan.value length]|| [rWPasangan.value length]|| [kelurahanPasangan.value length] || masaBerlakuKTPPasangan.value;
        if (isThereAnyValueForSpouse) {
            nomorHandphonePasangan.required = YES;
            namaLengkapPasangan.required = YES;
            tempatLahirPasangan.required = YES;
            tanggalLahirPasangan.required = YES;
         if (!self.hostReachability.currentReachabilityStatus == NotReachable){
            jenisKelaminPasangan.required = YES;
           kelurahanPasangan.required = YES;
           kodePosPasangan.required = YES;
           kotaPasangan.required = YES;
           kecamatanPasangan.required = YES;
          }
          
            alamatPasangan.required = YES;
            kewarganegaraanPasangan.required = YES;
            masaBerlakuKTPPasangan.required = YES;
          
            rTPasangan.required = YES;
            rWPasangan.required = YES;
          
          noKTPPasangan.required = YES;
          
          
            
            
        } else {
            nomorHandphonePasangan.required = NO;
            namaLengkapPasangan.required = NO;
            tempatLahirPasangan.required = NO;
            tanggalLahirPasangan.required = NO;
            jenisKelaminPasangan.required = NO;
            alamatPasangan.required = NO;
            kewarganegaraanPasangan.required = NO;
            masaBerlakuKTPPasangan.required = NO;
            kelurahanPasangan.required = NO;
            rTPasangan.required = NO;
            rWPasangan.required = NO;
          kodePosPasangan.required = NO;
          noKTPPasangan.required = NO;
          kotaPasangan.required = NO;
          kecamatanPasangan.required = NO;
          
            
        }
        
    } else if ([self.form formRowWithTag:@"pinjamanTempatLain1"]){
      XLFormRowDescriptor *pinjamanTempatLain1 = [self.form formRowWithTag:@"pinjamanTempatLain1"];
      XLFormRowDescriptor *nomorKartuKreditAtauKontrak1 = [self.form formRowWithTag:@"nomorKartuKreditAtauKontrak1"];
      XLFormRowDescriptor *pinjamanTempatLain2 = [self.form formRowWithTag:@"pinjamanTempatLain2"];
      XLFormRowDescriptor *nomorKartuKreditAtauKontrak2 = [self.form formRowWithTag:@"nomorKartuKreditAtauKontrak2"];
      if (![pinjamanTempatLain1.value isKindOfClass:[NSString class]] && pinjamanTempatLain1.value != nil) {
        nomorKartuKreditAtauKontrak1.required = YES;
      }
      else {
        nomorKartuKreditAtauKontrak1.required = NO;
      }
      if (![pinjamanTempatLain2.value isKindOfClass:[NSString class]] && pinjamanTempatLain2.value != nil) {
        nomorKartuKreditAtauKontrak2.required = YES;
      } else {
        nomorKartuKreditAtauKontrak2.required = NO;
      }
      
    } else if ([self.form formRowWithTag:@"namaTempatKerja"]){
      XLFormRowDescriptor *namaTempatKerja = [self.form formRowWithTag:@"namaTempatKerja"];
      XLFormRowDescriptor *kodeAreaTeleponTempatKerja = [self.form formRowWithTag:@"kodeAreaTeleponTempatKerja"];
      XLFormRowDescriptor *nomorTeleponTempatKerja = [self.form formRowWithTag:@"nomorTeleponTempatKerja"];
      if ([[MPMUserInfo getRole] isEqualToString:kRoleDedicated]) {
        namaTempatKerja.required = YES;
        kodeAreaTeleponTempatKerja.required = YES;
        nomorTeleponTempatKerja.required = YES;
      }
      
    }
  if(![self.list.status isEqualToString:@"Progress MAP & Survey by Marketing"] && self.isFromHistory == NO && self.isReadOnly == NO) {
    array = [self formValidationErrors];
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
