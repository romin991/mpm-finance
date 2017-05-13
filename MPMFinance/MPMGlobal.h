//
//  MPMGlobal.h
//  MPMFinance
//
//  Created by Romin Adi Santoso on 5/10/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import <Foundation/Foundation.h>
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

extern const int kMenuListWorkOrder;
extern const int kMenuOnlineSubmission;
extern const int kMenuCalculatorMarketing;
extern const int kMenuListMap;
extern const int kMenuListSurvey;
extern const int kMenuDashboard;

@end
