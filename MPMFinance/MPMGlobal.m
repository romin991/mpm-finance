//
//  MPMGlobal.m
//  MPMFinance
//
//  Created by Romin Adi Santoso on 5/10/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "MPMGlobal.h"
#import <AFHTTPSessionManager.h>
@implementation MPMGlobal

NSString *const kRoleCustomer = @"Customer";
NSString *const kRoleAgent = @"Agent";
NSString *const kRoleDealer = @"Dealer";
NSString *const kRoleSupervisor = @"Supervisor";
NSString *const kRoleOfficer = @"Officer";
NSString *const kRoleDedicated = @"Dedicated";

NSString *const kMenuListWorkOrder = @"List Work Order";
NSString *const kMenuOnlineSubmission = @"Online Submission";
NSString *const kMenuTrackingMarketing = @"Tracking Marketing";
NSString *const kMenuCalculatorMarketing = @"Calculator Marketing";
NSString *const kMenuListMap = @"List Map";
NSString *const kMenuListSurvey = @"List Survey";
NSString *const kMenuDashboard = @"Dashboard";

NSString *const kSubmenuListOnlineSubmission = @"List Online Submission API";
NSString *const kSubmenuListWorkOrder = @"List Work Order API";
NSString *const kSubmenuListMAP = @"List MAP API";
NSString *const kSubmenuListMarketing = @"List Marketing API";

NSString *const kSubmenuFormPengajuanApplikasi = @"Form Pengajuan Applikasi";
NSString *const kSubmenuDataMAP = @"Data MAP";
NSString *const kSubmenuSurvey = @"Survey";
NSString *const kSubmenuMelengkapiData = @"Melengkapi Data";
NSString *const kSubmenuAssignMarketing = @"Assign Marketing";
NSString *const kApiUrl = @"http://oms-api.infomedia-platform.com/mpmfinance";

NSString *const kSubmenuListPengajuanApplikasi = @"List Pengajuan Applikasi";
NSString *const kSubmenuMonitoring = @"Monitoring";

NSString *const kSubmenuDahsyat = @"Dahsyat";
NSString *const kSubmenuUsedCar = @"Used Car";
NSString *const kSubmenuNewCar = @"New Car";

NSString *const kSubmenuYearToDate = @"Year to Date";
NSString *const kSubmenuMonthToDate = @"Month to Date";

NSString *const kMenuTypeFormVertical = @"Vertical";
NSString *const kMenuTypeFormHorizontal = @"Horizontal";
NSString *const kMenuTypeList = @"List";
NSString *const kMenuTypeSubmenu = @"Submenu";
NSString *const kMenuTypeMap = @"Map";

NSString *const kActionTypeForward = @"Forward";
NSString *const kActionTypeAPICall = @"APICall";

+(AFHTTPSessionManager*)sessionManager
{
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [manager.requestSerializer setValue:@"Basic TVBNRmluYW5jZToxbmZvbWVkaWE=" forHTTPHeaderField:@"authorization"];
    return manager;
}
+ (NSString *)encodeToBase64String:(UIImage *)image {
    return [UIImageJPEGRepresentation(image, 0.5) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}
@end
