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
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface MPMGlobal : NSObject

extern NSString *const kRoleCustomer;
extern NSString *const kRoleAgent;
extern NSString *const kRoleDealer;
extern NSString *const kRoleSupervisor;
extern NSString *const kRoleOfficer;
extern NSString *const kRoleDedicated;

extern NSString *const kMenuListWorkOrder;
extern NSString *const kMenuOnlineSubmission;
extern NSString *const kMenuTrackingMarketing;
extern NSString *const kMenuCalculatorMarketing;
extern NSString *const kMenuListMap;
extern NSString *const kMenuListSurvey;
extern NSString *const kMenuDashboard;

extern NSString *const kSubmenuListOnlineSubmission;
extern NSString *const kSubmenuListWorkOrder;
extern NSString *const kSubmenuListMAP;

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

extern NSString *const kSubmenuYearToDate;
extern NSString *const kSubmenuMonthToDate;

extern NSString *const kMenuTypeFormVertical;
extern NSString *const kMenuTypeFormHorizontal;
extern NSString *const kMenuTypeList;
extern NSString *const kMenuTypeSubmenu;
extern NSString *const kMenuTypeMap;
extern NSString *const kApiUrl;

+(AFHTTPSessionManager*)sessionManager;
+ (NSString *)encodeToBase64String:(UIImage *)image;
@end
