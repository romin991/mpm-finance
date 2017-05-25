//
//  Menu.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 5/11/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "Menu.h"

@implementation Menu

+ (NSString *)primaryKey {
    return @"title";
}

+ (RLMResults *)getMenuForRole:(NSString *)roleName{
    return [Menu objectsWhere:@"ANY roles.name = %@ and isRootMenu = YES", roleName];
}

+ (RLMResults *)getSubmenuForMenu:(NSString *)menuTitle role:(NSString *)roleName{
    return [[Menu objectForPrimaryKey:menuTitle].submenus objectsWhere:@"ANY roles.name = %@", roleName];
}

#pragma mark - Populate Data
+ (void)generateSubmenusWithRealm:(RLMRealm *)realm{
    Menu *submenu = [[Menu alloc] init];
    submenu.imageName = @"ListPengajuanApplikasiSubmenuIcon";
    submenu.title = kSubmenuFormPengajuanApplikasi;
    submenu.sort = 0;
    submenu.menuType = kMenuTypeFormHorizontal;
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [realm addObject:submenu];
    
    submenu = [[Menu alloc] init];
    submenu.imageName = @"DataMAPSubmenuIcon";
    submenu.title = kSubmenuDataMAP;
    submenu.sort = 1;
    submenu.menuType = kMenuTypeFormVertical;
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [realm addObject:submenu];
    
    submenu = [[Menu alloc] init];
    submenu.imageName = @"SurveySubmenuIcon";
    submenu.title = kSubmenuSurvey;
    submenu.sort = 2;
    submenu.menuType = kMenuTypeFormHorizontal;
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [realm addObject:submenu];
    
    submenu = [[Menu alloc] init];
    submenu.imageName = @"";
    submenu.title = kSubmenuMelengkapiData;
    submenu.sort = 0;
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleSupervisor]];
    [realm addObject:submenu];
    
    submenu = [[Menu alloc] init];
    submenu.imageName = @"";
    submenu.title = kSubmenuAssignMarketing;
    submenu.sort = 1;
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleSupervisor]];
    [realm addObject:submenu];
    
    submenu = [[Menu alloc] init];
    submenu.imageName = @"";
    submenu.title = kSubmenuListPengajuanApplikasi;
    submenu.sort = 0;
    submenu.menuType = kMenuTypeList;
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    
    Menu *menuList = [[Menu alloc] init];
    menuList.title = kSubmenuListOnlineSubmission;
    menuList.sort = 0;
    menuList.menuType = kMenuTypeFormHorizontal;
    [menuList.roles addObjects:submenu.roles];
    [realm addObject:menuList];
    
    [submenu.submenus addObject:menuList];
    [realm addObject:submenu];
    
    submenu = [[Menu alloc] init];
    submenu.imageName = @"";
    submenu.title = kSubmenuMonitoring;
    submenu.sort = 1;
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [realm addObject:submenu];
    
    submenu = [[Menu alloc] init];
    submenu.imageName = @"DahsyatIcon";
    submenu.title = kSubmenuDahsyat;
    submenu.sort = 0;
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [realm addObject:submenu];
    
    submenu = [[Menu alloc] init];
    submenu.imageName = @"UsedCarIcon";
    submenu.title = kSubmenuUsedCar;
    submenu.sort = 1;
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [realm addObject:submenu];
    
    submenu = [[Menu alloc] init];
    submenu.imageName = @"NewCarIcon";
    submenu.title = kSubmenuNewCar;
    submenu.sort = 2;
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [realm addObject:submenu];
    
    submenu = [[Menu alloc] init];
    submenu.imageName = @"YearToDateIcon";
    submenu.title = kSubmenuYearToDate;
    submenu.sort = 0;
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [realm addObject:submenu];
    
    submenu = [[Menu alloc] init];
    submenu.imageName = @"MonthToDateIcon";
    submenu.title = kSubmenuMonthToDate;
    submenu.sort = 1;
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [realm addObject:submenu];
}

+ (void)generateMenus{
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    
    [self generateSubmenusWithRealm:realm];
    
    Menu *menu = [[Menu alloc] init];
    menu.imageName = @"ListWorkOrderIcon";
    menu.title = kMenuListWorkOrder;
    menu.sort = 0;
    menu.menuType = kMenuTypeList;
    menu.isRootMenu = YES;
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleSupervisor]];
    
    Menu *menuList = [[Menu alloc] init];
    menuList.backgroundImageName = @"ListWorkOrderBackground";
    menuList.circleIconImageName = @"ListWorkOrderCircleIcon";
    menuList.title = kSubmenuListWorkOrder;
    menuList.sort = 0;
    menuList.menuType = kMenuTypeSubmenu;
    menuList.listAPIMethodName = @"getListWorkOrder:";
    [menuList.roles addObjects:menu.roles];
    [menuList.submenus addObject:[Menu objectForPrimaryKey:kSubmenuFormPengajuanApplikasi]];
    [menuList.submenus addObject:[Menu objectForPrimaryKey:kSubmenuDataMAP]];
    [menuList.submenus addObject:[Menu objectForPrimaryKey:kSubmenuSurvey]];
    [menuList.submenus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
    [menuList.submenus addObject:[Menu objectForPrimaryKey:kSubmenuAssignMarketing]];
    [realm addObject:menuList];
    
    [menu.submenus addObject:menuList];
    [realm addObject:menu];
    
    menu = [[Menu alloc] init];
    menu.imageName = @"OnlineSubmissionIcon";
    menu.backgroundImageName = @"OnlineSubmissionBackground";
    menu.circleIconImageName = @"OnlineSubmissionCircleIcon";
    menu.title = kMenuOnlineSubmission;
    menu.sort = 10;
    menu.menuType = kMenuTypeSubmenu;
    menu.isRootMenu = YES;
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [menu.submenus addObject:[Menu objectForPrimaryKey:kSubmenuListPengajuanApplikasi]];
    [menu.submenus addObject:[Menu objectForPrimaryKey:kSubmenuMonitoring]];
    [realm addObject:menu];
    
    menu = [[Menu alloc] init];
    menu.imageName = @"TrackingMarketingIcon";
    menu.title = kMenuTrackingMarketing;
    menu.sort = 11;
    menu.menuType = kMenuTypeList;
    menu.isRootMenu = YES;
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleSupervisor]];
    [realm addObject:menu];
    
    menu = [[Menu alloc] init];
    menu.imageName = @"CalculatorMarketingIcon";
    menu.backgroundImageName = @"CalculatorMarketingBackground";
    menu.circleIconImageName = @"CalculatorMarketingCircleIcon";
    menu.title = kMenuCalculatorMarketing;
    menu.sort = 20;
    menu.menuType = kMenuTypeSubmenu;
    menu.isRootMenu = YES;
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleSupervisor]];
    [menu.submenus addObject:[Menu objectForPrimaryKey:kSubmenuDahsyat]];
    [menu.submenus addObject:[Menu objectForPrimaryKey:kSubmenuUsedCar]];
    [menu.submenus addObject:[Menu objectForPrimaryKey:kSubmenuNewCar]];
    [realm addObject:menu];
    
    menu = [[Menu alloc] init];
    menu.imageName = @"ListMapIcon";
    menu.title = kMenuListMap;
    menu.sort = 30;
    menu.menuType = kMenuTypeList;
    menu.isRootMenu = YES;
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleSupervisor]];
    
    menuList = [[Menu alloc] init];
    menuList.imageName = @"";
    menuList.title = kSubmenuListMAP;
    menuList.sort = 0;
    menuList.menuType = kMenuTypeSubmenu;
    [menuList.roles addObjects:menu.roles];
    [menuList.submenus addObject:[Menu objectForPrimaryKey:kSubmenuDataMAP]];
    [realm addObject:menuList];
    
    [menu.submenus addObject:menuList];
    [realm addObject:menu];
    
    menu = [[Menu alloc] init];
    menu.imageName = @"ListSurveyIcon";
    menu.title = kMenuListSurvey;
    menu.sort = 40;
    menu.menuType = kMenuTypeList;
    menu.isRootMenu = YES;
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleSupervisor]];
    
    menuList = [[Menu alloc] init];
    menuList.imageName = @"";
    menuList.title = kSubmenuListMarketing;
    menuList.sort = 0;
    menuList.menuType = kMenuTypeMap;
    [menuList.roles addObjects:menu.roles];
    [realm addObject:menuList];
    
    [menu.submenus addObject:menuList];
    [realm addObject:menu];
    
    menu = [[Menu alloc] init];
    menu.imageName = @"DashboardIcon";
    menu.backgroundImageName = @"DashboardBackground";
    menu.circleIconImageName = @"DashboardCircleIcon";
    menu.title = kMenuDashboard;
    menu.sort = 50;
    menu.menuType = kMenuTypeSubmenu;
    menu.isRootMenu = YES;
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleSupervisor]];
    [menu.submenus addObject:[Menu objectForPrimaryKey:kSubmenuYearToDate]];
    [menu.submenus addObject:[Menu objectForPrimaryKey:kSubmenuMonthToDate]];
    [realm addObject:menu];
    
    [realm commitWriteTransaction];
}

@end
