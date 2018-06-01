//
//  MPMGlobal.h
//  MPMFinance
//
//  Created by Romin Adi Santoso on 5/10/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//
#import <AFHTTPSessionManager.h>
#import <Foundation/Foundation.h>
#import <SVProgressHUD.h>
#import <CommonCrypto/CommonDigest.h>
#import "ISO8601DateFormatter.h"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface MPMGlobal : NSObject
extern NSString *const kAPIKey;
extern NSString *const kRoleCustomer;
extern NSString *const kRoleAgent;
extern NSString *const kRoleDealer;
extern NSString *const kRoleSupervisor;
extern NSString *const kRoleOfficer;
extern NSString *const kRoleDedicated;
extern NSString *const kRoleBM;
extern NSString *const kNoRole;

extern NSString *const kMenuMonitoring;
extern NSString *const kMenuListWorkOrder;
extern NSString *const kMenuOnlineSubmission;
extern NSString *const kMenuTrackingMarketing;
extern NSString *const kMenuCalculatorMarketing;
extern NSString *const kMenuListMap;
extern NSString *const kMenuListSurvey;
extern NSString *const kMenuDashboard;
extern NSString *const kMenuContactUs;
extern NSString *const kMenuProduct;
extern NSString *const kMenuTopUp;
extern NSString *const kMenuHistoryTransaksi;
extern NSString *const kMenuLegalisirFCBPKB;
extern NSString *const kMenuKlaimAsuransi;
extern NSString *const kMenuCreditSimulation;
extern NSString *const kMenuPelunasanDipercepat;
extern NSString *const kMenuPengembalianBPKB;
extern NSString *const kMenuSaranPengaduan;
extern NSString *const kMenuCustomerGetCustomer;

extern NSString *const kSubmenuListMonitoring;
extern NSString *const kSubmenuListOnlineSubmission;
extern NSString *const kSubmenuListWorkOrder;
extern NSString *const kSubmenuListMAP;
extern NSString *const kSubmenuListMarketing;
extern NSString *const kSubmenuListSurvey;
extern NSString *const kSubmenuListWorkOrderHistory;
extern NSString *const kSubmenuListTopUp;
extern NSString *const kSubmenuListLegalisirBPKB;
extern NSString *const kSubmenuListKlaimAsuransi;
extern NSString *const kSubmenuListPengambilanBPKB;
extern NSString *const kSubmenuListSaranPengaduan;
extern NSString *const kSubmenuListCustomerGetCustomer;

extern NSString *const kSubmenuFormPengajuanApplikasi;
extern NSString *const kSubmenuDataMAP;
extern NSString *const kSubmenuSurvey;
extern NSString *const kSubmenuMelengkapiData;
extern NSString *const kSubmenuAssignMarketing;

extern NSString *const kSubmenuListPengajuanApplikasi;
extern NSString *const kSubmenuMonitoring;

extern NSString *const kSubmenuDahsyat;
extern NSString *const kSubmenuUsedCar;
extern NSString *const kSubmenuNewCar;

extern NSString *const kSubmenuCreditSimulationDahsyat2W;
extern NSString *const kSubmenuCreditSimulationDahsyat4W;
extern NSString *const kSubmenuCreditSimulationNewBike;
extern NSString *const kSubmenuCreditSimulationProperty;
extern NSString *const kSubmenuCreditSimulationUsedCar;
extern NSString *const kSubmenuCreditSimulationNewCar;

extern NSString *const kSubmenuTopUp;
extern NSString *const kSubmenuHistoryTopUp;

extern NSString *const kSubmenuLegalizationBPKB;
extern NSString *const kSubmenuHistoryBPKB;

extern NSString *const kSubmenuInsuranceClaimForm;
extern NSString *const kSubmenuHistoryInsuranceClaim;

extern NSString *const kSubmenuPengambilanBPKB;
extern NSString *const kSubmenuHistoryPengambilanBPKB;

extern NSString *const kSubmenuSaranPengaduan;
extern NSString *const kSubmenuHistorySaranPengaduan;

extern NSString *const kSubmenuCustomerGetCustomer;
extern NSString *const kSubmenuHistoryCustomerGetCustomer;

extern NSString *const kSubmenuYearToDate;
extern NSString *const kSubmenuMonthToDate;

extern NSString *const kMenuTypeTrackingMarketing;
extern NSString *const kMenuTypeFormNewCar;
extern NSString *const kMenuTypeFormUsedCar;
extern NSString *const kMenuTypeFormDahsyat;
extern NSString *const kMenuTypeFormDataMAP;
extern NSString *const kMenuTypeFormWorkOrder;
extern NSString *const kMenuTypeFormSurvey;
extern NSString *const kMenuTypeFormTopUp;
extern NSString *const kMenuTypeFormLegalizationBPKB;
extern NSString *const kMenuTypeFormInsuranceClaim;
extern NSString *const kMenuTypeFormPengambilanBPKB;
extern NSString *const kMenuTypeFormSaranPengaduan;
extern NSString *const kMenuTypeFormCustomerGetCustomer;
extern NSString *const kMenuSetAlternate;
extern NSString *const kMenuTypeListTopUp;
extern NSString *const kMenuTypeListLegalizationBPKB;
extern NSString *const kMenuTypeListInsuranceClaim;
extern NSString *const kMenuTypeListPengambilanBPKB;
extern NSString *const kMenuTypeListSaranPengaduan;
extern NSString *const kMenuTypeListCustomerGetCustomer;

extern NSString *const kMenuTypeList;
extern NSString *const kMenuTypeListWorkOrder;
extern NSString *const kMenuTypeListAssignMarketing;
extern NSString *const kMenuTypeSubmenu;
extern NSString *const kMenuTypeSubmenu2;
extern NSString *const kMenuTypeMap;
extern NSString *const kMenuTypeDashboard;
extern NSString *const kMenuTypeContactUs;
extern NSString *const kMenuTypeHistory;
extern NSString *const kMenuTypeAcceleratedRepayment;
extern NSString *const kMenuTypeCreditSimulation;
extern NSString *const kApiUrl;

extern NSString *const kActionTypeForward;
extern NSString *const kActionQueryDB;
extern NSString *const kActionTypeAPICall;

+ (NSInteger)limitPerPage;
+ (AFHTTPSessionManager*)sessionManager;
+ (NSString *)encodeToBase64String:(UIImage *)image;
+ (UIImage *)decodeFromBase64String:(NSString *)string;
+ (BOOL)isStringAnURL:(NSString *)string;
+ (UIView *)giveBorderTo:(UIView *)view withBorderColor:(NSString *)hexColorString withCornerRadius:(CGFloat)cornerRadius;
+ (UIColor *)colorFromHexString:(NSString *)hexString;
+ (NSString *)removeTimeFromString:(NSString *)object;
+ (NSString *)stringFromDate:(NSDate *)object;
+ (NSDate *)dateFromString:(NSString *)object;
+ (NSString *)MD5fromString:(NSString *)input;
+ (UIImage *)barcodeFromString:(NSString *)string;
+ (UIImage *)qrCodeFromString:(NSString *)string;
+ (NSString *)formatToMoney:(NSNumber *)charge;
+ (NSDate *)dateTimeFromString:(NSString *)object;
+ (NSString *)stringFromDateTime:(NSDate *)object;
@end
