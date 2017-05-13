//
//  Menu.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 5/11/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "Menu.h"

@implementation Menu

+ (RLMResults *)getMenuForRole:(NSString *)roleName{
    return [Menu objectsWhere:@"ANY roles.name = %@", roleName];
}

#pragma mark - Populate Data
+ (void)generateMenus{
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    
    Menu *menu = [[Menu alloc] init];
    menu.imageName = @"ListWorkOrderIcon";
    menu.title = @"List Work Order";
    menu.type = kMenuListWorkOrder;
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [realm addObject:menu];
    
    menu = [[Menu alloc] init];
    menu.imageName = @"OnlineSubmissionIcon";
    menu.title = @"Online Submission";
    menu.type = kMenuOnlineSubmission;
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [realm addObject:menu];
    
    menu = [[Menu alloc] init];
    menu.imageName = @"CalculatorMarketingIcon";
    menu.title = @"Calculator Marketing";
    menu.type = kMenuCalculatorMarketing;
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [realm addObject:menu];
    
    menu = [[Menu alloc] init];
    menu.imageName = @"ListMapIcon";
    menu.title = @"List Map";
    menu.type = kMenuListMap;
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [realm addObject:menu];
    
    menu = [[Menu alloc] init];
    menu.imageName = @"ListSurveyIcon";
    menu.title = @"List Survey";
    menu.type = kMenuListSurvey;
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [realm addObject:menu];
    
    menu = [[Menu alloc] init];
    menu.imageName = @"DashboardIcon";
    menu.title = @"Dashboard";
    menu.type = kMenuDashboard;
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [realm addObject:menu];
    
    [realm commitWriteTransaction];
}

@end
