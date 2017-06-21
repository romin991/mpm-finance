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

+ (RLMResults *)getMenuForRole:(NSString *)role{
    return [Menu objectsWhere:@"ANY roles.name = %@ and isRootMenu = YES", role];
}

+ (RLMResults *)getSubmenuForMenu:(NSString *)menuTitle role:(NSString *)role{
    return [[Menu objectForPrimaryKey:menuTitle].submenus objectsWhere:@"ANY roles.name = %@", role];
}

+ (RLMResults *)getDataSourcesForMenu:(NSString *)menuTitle role:(NSString *)role{
    return [[Menu objectForPrimaryKey:menuTitle].dataSources objectsWhere:@"ANY roles.name = %@", role];
}

#pragma mark - Populate Data
+ (void)generateSubmenusWithRealm:(RLMRealm *)realm{
//==Work Order===================================================================================================
    Menu *submenu = [[Menu alloc] init];
    submenu.imageName = @"ListPengajuanApplikasiSubmenuIcon";
    submenu.title = kSubmenuFormPengajuanApplikasi;
    submenu.sort = 0;
    submenu.borderColor = @"F26F21";
    submenu.menuType = kMenuTypeFormWorkOrder;
    
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [realm addObject:submenu];
    
//======
    submenu = [[Menu alloc] init];
    submenu.imageName = @"DataMAPSubmenuIcon";
    submenu.title = kSubmenuDataMAP;
    submenu.sort = 1;
    submenu.borderColor = @"FB9E15";
    submenu.menuType = kMenuTypeFormDataMAP;
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleOfficer]];
    [realm addObject:submenu];

//======
    submenu = [[Menu alloc] init];
    submenu.imageName = @"SurveySubmenuIcon";
    submenu.title = kSubmenuSurvey;
    submenu.sort = 2;
    submenu.borderColor = @"FF8A65";
    submenu.menuType = kMenuTypeFormSurvey;
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleOfficer]];
    [realm addObject:submenu];
    
//======
    submenu = [[Menu alloc] init];
    submenu.imageName = @"ListPengajuanApplikasiSubmenuIcon"; //#IMAGEWARNING
    submenu.title = kSubmenuMelengkapiData;
    submenu.sort = 0;
    submenu.menuType = kMenuTypeSubmenu;
    submenu.borderColor = @"F26F21";
    [submenu.submenus addObject:[Menu objectForPrimaryKey:kSubmenuFormPengajuanApplikasi]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleSupervisor]];
    [realm addObject:submenu];
    
//======
    submenu = [[Menu alloc] init];
    submenu.imageName = @"SurveySubmenuIcon"; //#IMAGEWARNING
    submenu.title = kSubmenuAssignMarketing;
    submenu.sort = 1;
    submenu.borderColor = @"FF8A65";
    submenu.menuType = kMenuTypeList;
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleSupervisor]];
    
    Menu *menuList = [[Menu alloc] init];
    menuList.title = kSubmenuListMarketing;
    menuList.sort = 0;
    menuList.menuType = kMenuTypeTrackingMarketing;
    
    Action *action = [[Action alloc] init];
    action.name = @"Get List Marketing";
    action.methodName = @""; //#APIWARNING pengajuan/getallmarketingbyspv with datapengajuanid
    action.actionType = kActionTypeAPICall;
    [action.roles addObjects:submenu.roles];
    
    [menuList.dataSources addObject:action];
    [menuList.roles addObjects:submenu.roles];
    
    [submenu.submenus addObject:menuList];
    [realm addObject:submenu];
    
//==Online Submission===================================================================================================
    submenu = [[Menu alloc] init];
    submenu.imageName = @"ListPengajuanApplikasiSubmenuIcon";
    submenu.title = kSubmenuListPengajuanApplikasi;
    submenu.sort = 0;
    submenu.borderColor = @"F26F21";
    submenu.menuType = kMenuTypeList;
    [submenu.roles addObject:[Role objectForPrimaryKey:kNoRole]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDealer]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleOfficer]];
    
    menuList = [[Menu alloc] init];
    menuList.title = kSubmenuListOnlineSubmission;
    menuList.sort = 0;
    menuList.menuType = kMenuTypeSubmenu;
    
    action = [[Action alloc] init];
    action.name = @"Get List Work Order";
    action.methodName = @"getNewByUserListWorkOrderPage:completion:"; //pengajuan/getallbyuser with status new
    action.actionType = kActionTypeAPICall;
    [action.roles addObjects:submenu.roles];
    [menuList.dataSources addObject:action];
    
    action = [[Action alloc] init];
    action.name = @"Add";
    action.methodName = @"";
    action.actionType = kActionTypeForward;
    [action.roles addObjects:submenu.roles];
    menuList.rightButtonAction = action;
    
    [menuList.submenus addObject:[Menu objectForPrimaryKey:kSubmenuFormPengajuanApplikasi]];
    [menuList.roles addObjects:submenu.roles];
    
    [submenu.submenus addObject:menuList];
    [realm addObject:submenu];
    
//=========
    submenu = [[Menu alloc] init];
    submenu.imageName = @"MonitoringIcon";
    submenu.title = kSubmenuMonitoring;
    submenu.sort = 1;
    submenu.borderColor = @"558B2F";
    submenu.menuType = kMenuTypeList;
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleOfficer]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDealer]];
    
    menuList = [[Menu alloc] init];
    menuList.title = kSubmenuListMonitoring;
    menuList.sort = 0;
    menuList.menuType = kMenuTypeSubmenu;
    
    action = [[Action alloc] init];
    action.name = @"Get List Work Order";
    action.methodName = @"getMonitoringByUserListWorkOrderPage:completion:"; //pengajuan/getallbyuser with status monitoring
    action.actionType = kActionTypeAPICall;
    [action.roles addObjects:submenu.roles];
    
    [menuList.dataSources addObject:action];
    [menuList.submenus addObject:[Menu objectForPrimaryKey:kSubmenuFormPengajuanApplikasi]]; //#FLOWWARNING maybe not editable for monitoring
    [menuList.roles addObjects:submenu.roles];
    [action.roles addObjects:submenu.roles];
    
    [submenu.submenus addObject:menuList];
    [realm addObject:submenu];
    
//==Calculator Marketing ===================================================================================================
    submenu = [[Menu alloc] init];
    submenu.imageName = @"DahsyatIcon";
    submenu.title = kSubmenuDahsyat;
    submenu.sort = 0;
    submenu.borderColor = @"0091EA";
    submenu.menuType = kMenuTypeFormDahsyat;
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleOfficer]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleSupervisor]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [realm addObject:submenu];
    
//=======
    submenu = [[Menu alloc] init];
    submenu.imageName = @"UsedCarIcon";
    submenu.title = kSubmenuUsedCar;
    submenu.sort = 1;
    submenu.borderColor = @"546E7A";
    submenu.menuType = kMenuTypeFormUsedCar;
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleSupervisor]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleOfficer]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [realm addObject:submenu];
    
//========
    submenu = [[Menu alloc] init];
    submenu.imageName = @"";
    submenu.title = kSubmenuNewCar;
    submenu.sort = 2;
    submenu.borderColor = @"B30808";
    submenu.menuType = kMenuTypeFormNewCar;
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleOfficer]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleSupervisor]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [realm addObject:submenu];
    
//=====================================================================================================
    submenu = [[Menu alloc] init];
    submenu.imageName = @"YearToDateIcon";
    submenu.title = kSubmenuYearToDate;
    submenu.sort = 0;
    submenu.borderColor = @"F26F21";
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleOfficer]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [realm addObject:submenu];
    
//=====================================================================================================
    submenu = [[Menu alloc] init];
    submenu.imageName = @"MonthToDateIcon";
    submenu.title = kSubmenuMonthToDate;
    submenu.sort = 1;
    submenu.borderColor = @"B00000";
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleOfficer]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [realm addObject:submenu];
    
}

+ (void)generateMenus{
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    
    [self generateSubmenusWithRealm:realm];
    

//==Work Order===================================================================================================
    Menu *menu = [[Menu alloc] init];
    menu.imageName = @"ListWorkOrderIcon";
    menu.title = kMenuListWorkOrder;
    menu.menuType = kMenuTypeList;
    menu.isRootMenu = YES;
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleSupervisor]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleOfficer]];
    
    Menu *menuList = [[Menu alloc] init];
    menuList.backgroundImageName = @"ListWorkOrderBackground";
    menuList.circleIconImageName = @"ListWorkOrderCircleIcon";
    menuList.title = kSubmenuListWorkOrder;
    menuList.sort = 0;
    menuList.menuType = kMenuTypeSubmenu;
    
    Action *action = [[Action alloc] init];
    action.name = @"All";
    action.methodName = @"getAllListWorkOrderPage:completion:"; //datamap/getworkorder with status all
    action.actionType = kActionTypeAPICall;
    [action.roles addObject:[Role objectForPrimaryKey:kRoleOfficer]];
    
    [menuList.dataSources addObject:action];
    
    action = [[Action alloc] init];
    action.name = @"Approve";
    action.methodName = @"getNeedApprovalListWorkOrderPage:completion:"; //datamap/getworkorder with status need approval
    action.actionType = kActionTypeAPICall;
    [action.roles addObject:[Role objectForPrimaryKey:kRoleOfficer]];
    
    [menuList.dataSources addObject:action];
    
    action = [[Action alloc] init];
    action.name = @"Clear";
    action.methodName = @"getAllListWorkOrderPage:completion:"; //datamap/getworkorder with status all
    action.actionType = kActionTypeAPICall;
    [action.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    
    [menuList.dataSources addObject:action];
    
    action = [[Action alloc] init];
    action.name = @"Negative";
    action.methodName = @"getBadUsersListWorkOrderPage:completion:"; //datamap/getworkorder with status badUsers
    action.actionType = kActionTypeAPICall;
    [action.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    
    [menuList.dataSources addObject:action];
    
    action = [[Action alloc] init];
    action.name = @"Clear";
    action.methodName = @"getNewBySupervisorListWorkOrderPage:completion:"; //pengajuan/getallbyspv status new
    action.actionType = kActionTypeAPICall;
    [action.roles addObject:[Role objectForPrimaryKey:kRoleSupervisor]];
    
    [menuList.dataSources addObject:action];
    
    action = [[Action alloc] init];
    action.name = @"Negative";
    action.methodName = @"getBadUsersBySupervisorListWorkOrderPage:completion:"; //pengajuan/getallbyspv status badUsers
    action.actionType = kActionTypeAPICall;
    [action.roles addObject:[Role objectForPrimaryKey:kRoleSupervisor]];
    
    [menuList.dataSources addObject:action];
    
    [menuList.roles addObjects:menu.roles];
    [menuList.submenus addObject:[Menu objectForPrimaryKey:kSubmenuFormPengajuanApplikasi]];
    [menuList.submenus addObject:[Menu objectForPrimaryKey:kSubmenuDataMAP]];
    [menuList.submenus addObject:[Menu objectForPrimaryKey:kSubmenuSurvey]];
    [menuList.submenus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
    [menuList.submenus addObject:[Menu objectForPrimaryKey:kSubmenuAssignMarketing]];
    
    [menu.submenus addObject:menuList];
    [realm addObject:menu];

//=====================================================================================================
    menu = [[Menu alloc] init];
    menu.imageName = @"OnlineSubmissionIcon";
    menu.backgroundImageName = @"OnlineSubmissionBackground";
    menu.circleIconImageName = @"OnlineSubmissionCircleIcon";
    menu.title = kMenuOnlineSubmission;
    menu.sort = 10;
    menu.menuType = kMenuTypeSubmenu;
    menu.isRootMenu = YES;
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleOfficer]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleDealer]];
    [menu.submenus addObject:[Menu objectForPrimaryKey:kSubmenuListPengajuanApplikasi]];
    [menu.submenus addObject:[Menu objectForPrimaryKey:kSubmenuMonitoring]];
    [realm addObject:menu];
    
//=====================================================================================================
    menu = [[Menu alloc] init];
    menu.imageName = @"TrackingMarketingIcon";
    menu.title = kMenuTrackingMarketing;
    menu.sort = 11;
    menu.menuType = kMenuTypeMap;
    menu.isRootMenu = YES;
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleSupervisor]];
    [realm addObject:menu];
    
//=====================================================================================================
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
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleOfficer]];
    [menu.submenus addObject:[Menu objectForPrimaryKey:kSubmenuDahsyat]];
    [menu.submenus addObject:[Menu objectForPrimaryKey:kSubmenuUsedCar]];
    [menu.submenus addObject:[Menu objectForPrimaryKey:kSubmenuNewCar]];
    [realm addObject:menu];
    
//=====================================================================================================
    menu = [[Menu alloc] init];
    menu.imageName = @"ListMapIcon";
    menu.title = kMenuListMap;
    menu.sort = 30;
    menu.menuType = kMenuTypeList;
    menu.isRootMenu = YES;
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleSupervisor]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleOfficer]];
    
    menuList = [[Menu alloc] init];
    menuList.title = kSubmenuListMAP;
    menuList.sort = 0;
    menuList.menuType = kMenuTypeSubmenu;
    
    action = [[Action alloc] init];
    action.name = @"Get List Work Order";
    action.methodName = @"getMapDraftListWorkOrderPage:completion:"; //datamap/getworkorder with status listMapDraff
    action.actionType = kActionTypeAPICall;
    [action.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [action.roles addObject:[Role objectForPrimaryKey:kRoleOfficer]];
    
    [menuList.dataSources addObject:action];
    
    action = [[Action alloc] init];
    action.name = @"Get List Work Order";
    action.methodName = @"getMapBySupervisorListWorkOrderPage:completion:"; //pengajuan/getallbyspv status listMap
    action.actionType = kActionTypeAPICall;
    [action.roles addObject:[Role objectForPrimaryKey:kRoleSupervisor]];
    
    [menuList.dataSources addObject:action];
    
    action = [[Action alloc] init];
    action.name = @"Edit";
    action.methodName = @"";
    action.actionType = kActionTypeForward;
    [action.roles addObjects:menu.roles];
    
    [menuList.actions addObject:action];
    
    action = [[Action alloc] init];
    action.name = @"Submit";
    action.methodName = @""; //#APIWARNING datamap/submitmap with status id
    action.actionType = kActionTypeAPICall;
    [action.roles addObjects:menu.roles];
    
    [menuList.actions addObject:action];
    
    [menuList.roles addObjects:menu.roles];
    [menuList.submenus addObject:[Menu objectForPrimaryKey:kSubmenuDataMAP]];
    
    [menu.submenus addObject:menuList];
    [realm addObject:menu];
    
//=====================================================================================================
    menu = [[Menu alloc] init];
    menu.imageName = @"ListSurveyIcon";
    menu.title = kMenuListSurvey;
    menu.sort = 40;
    menu.menuType = kMenuTypeList;
    menu.isRootMenu = YES;
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleSupervisor]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleOfficer]];
    
    menuList = [[Menu alloc] init];
    menuList.imageName = @"";
    menuList.title = kSubmenuListSurvey;
    menuList.sort = 0;
    menuList.menuType = @"";
    
    action = [[Action alloc] init];
    action.name = @"Get List Survey";
    action.methodName = @"getSurveyBySupervisorListWorkOrderPage:completion:"; //pengajuan/getallbyspv status listSurvey
    action.actionType = kActionTypeAPICall;
    [action.roles addObject:[Role objectForPrimaryKey:kRoleSupervisor]];
    
    [menuList.dataSources addObject:action];
    
    action = [[Action alloc] init];
    action.name = @"Get List Survey";
    action.methodName = @"getSurveyDraftListWorkOrderPage:completion:"; //#APIWARNING datamap/getworkorder status listSurveyDraff
    action.actionType = kActionTypeAPICall;
    [action.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [action.roles addObject:[Role objectForPrimaryKey:kRoleOfficer]];
    
    [menuList.dataSources addObject:action];
    
    action = [[Action alloc] init];
    action.name = @"Edit";
    action.methodName = @"";
    action.actionType = kActionTypeForward;
    [action.roles addObjects:menu.roles];
    
    [menuList.actions addObject:action];
    
    action = [[Action alloc] init];
    action.name = @"Submit";
    action.methodName = @""; //#APIWARNING
    action.actionType = kActionTypeAPICall;
    [action.roles addObjects:menu.roles];
    
    [menuList.actions addObject:action];
    
    [menuList.roles addObjects:menu.roles];
    [menuList.submenus addObject:[Menu objectForPrimaryKey:kSubmenuSurvey]];
    
    [menu.submenus addObject:menuList];
    [realm addObject:menu];
    
//=====================================================================================================
    menu = [[Menu alloc] init];
    menu.imageName = @"DashboardIcon";
    menu.backgroundImageName = @"DashboardBackground";
    menu.circleIconImageName = @"DashboardCircleIcon";
    menu.title = kMenuDashboard;
    menu.sort = 50;
    menu.menuType = kMenuTypeDashboard;
    menu.isRootMenu = YES;
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleSupervisor]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleOfficer]];
    [menu.submenus addObject:[Menu objectForPrimaryKey:kSubmenuYearToDate]];
    [menu.submenus addObject:[Menu objectForPrimaryKey:kSubmenuMonthToDate]];
    [realm addObject:menu];
    
    [realm commitWriteTransaction];
}

+ (void)generateMenusForCustomerDealerWithRealm:(RLMRealm *)realm{
    //=====================================================================================================
    Menu *submenu = [[Menu alloc] init];
    submenu.imageName = @"";
    submenu.title = kSubmenuDahsyat4W;
    submenu.sort = 2;
    submenu.menuType = kMenuTypeCreditSimulation;
    submenu.borderColor = @"B30808";
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleOfficer]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kNoRole]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [realm addObject:submenu];
    
    //=====================================================================================================
    submenu = [[Menu alloc] init];
    submenu.imageName = @"";
    submenu.title = kSubmenuDahsyat2W;
    submenu.sort = 2;
    submenu.menuType = kMenuTypeCreditSimulation;
    submenu.borderColor = @"B30808";
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleOfficer]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kNoRole]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [realm addObject:submenu];
    
    //=====================================================================================================
    submenu = [[Menu alloc] init];
    submenu.imageName = @"";
    submenu.title = kSubmenuNewBike;
    submenu.menuType = kMenuTypeCreditSimulation;
    submenu.sort = 2;
    submenu.borderColor = @"B30808";
    [submenu.roles addObject:[Role objectForPrimaryKey:kNoRole]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleOfficer]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [realm addObject:submenu];
    
    //=====================================================================================================
    //    submenu = [[Menu alloc] init];
    //    submenu.imageName = @"NewCarIcon";
    //    submenu.title = kSubmenuNewCar;
    //    submenu.sort = 2;
    //    submenu.menuType = kMenuTypeCreditSimulation;
    //    submenu.borderColor = @"B30808";
    //    [submenu.roles addObject:[Role objectForPrimaryKey:kNoRole]];
    //    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleOfficer]];
    //    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    //    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    //    [realm addObject:submenu];
    
    
    
    
    Menu *menu = [[Menu alloc] init];
    menu.imageName = @"cartIcon";
    menu.title = kMenuProduct;
    menu.sort = 20;
    menu.menuType = kMenuListMap;
    menu.isRootMenu = YES;
    [menu.roles addObject:[Role objectForPrimaryKey:kNoRole]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleDealer]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [realm addObject:menu];
    
    menu = [[Menu alloc] init];
    menu.imageName = @"creditIcon";
    menu.backgroundImageName = @"CalculatorMarketingBackground";
    menu.circleIconImageName = @"CalculatorMarketingCircleIcon";
    menu.title = kMenuCreditSimulation;
    menu.sort = 20;
    menu.menuType = kMenuTypeSubmenu;
    menu.isRootMenu = YES;
    [menu.roles addObject:[Role objectForPrimaryKey:kNoRole]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleDealer]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleSupervisor]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    
    [menu.submenus addObject:[Menu objectForPrimaryKey:kSubmenuNewBike]];
    [menu.submenus addObject:[Menu objectForPrimaryKey:kSubmenuNewCar]];
    [menu.submenus addObject:[Menu objectForPrimaryKey:kSubmenuUsedCar]];
    [menu.submenus addObject:[Menu objectForPrimaryKey:kSubmenuDahsyat2W]];
    [menu.submenus addObject:[Menu objectForPrimaryKey:kSubmenuDahsyat4W]];
    [menu.submenus addObject:[Menu objectForPrimaryKey:kSubmenuProperty]];
    [realm addObject:menu];

    menu = [[Menu alloc] init];
    menu.imageName = @"contactUsIcon";
    menu.title = kMenuContactUs;
    menu.sort = 20;
    menu.menuType = kMenuTypeContactUs;
    menu.isRootMenu = YES;
    [menu.roles addObject:[Role objectForPrimaryKey:kNoRole]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleDealer]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [realm addObject:menu];
    
    menu = [[Menu alloc] init];
    menu.imageName = @"pengajuanKembaliIcon";
    menu.title = kMenuPengajuanKembali;
    menu.sort = 20;
    menu.menuType = kMenuTypeList;
    menu.isRootMenu = YES;
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [realm addObject:menu];
    
    menu = [[Menu alloc] init];
    menu.imageName = @"historyTransaksiIcon";
    menu.title = kMenuHistoryTransaksi;
    menu.sort = 20;
    menu.menuType = kMenuTypeList;
    menu.isRootMenu = YES;
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [realm addObject:menu];
    
    menu = [[Menu alloc] init];
    menu.imageName = @"legalisirBpkb";
    menu.title = kMenuLegalisirFCBPKB;
    menu.sort = 20;
    menu.menuType = kMenuTypeList;
    menu.isRootMenu = YES;
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [realm addObject:menu];
    
    menu = [[Menu alloc] init];
    menu.imageName = @"klaimAsuransiIcon";
    menu.title = kMenuKlaimAsuransi;
    menu.sort = 20;
    menu.menuType = kMenuTypeList;
    menu.isRootMenu = YES;
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [realm addObject:menu];
    
    menu = [[Menu alloc] init];
    menu.imageName = @"pelunasanIcon";
    menu.title = kMenuPelunasanDipercepat;
    menu.sort = 20;
    menu.menuType = kMenuTypeList;
    menu.isRootMenu = YES;
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [realm addObject:menu];
    
    menu = [[Menu alloc] init];
    menu.imageName = @"pengembalianBPKBIcon";
    menu.title = kMenuPengembalianBPKB;
    menu.sort = 20;
    menu.menuType = kMenuTypeList;
    menu.isRootMenu = YES;
    Action *action = [[Action alloc] init];
    action.name = @"Get List Pengembalian BPKB";
    action.methodName = @"getListPengembalianBPKB:";
    action.actionType = kActionTypeAPICall;
    [realm addObject:action];
    [menu.dataSources addObject:action];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [realm addObject:menu];
    
    menu = [[Menu alloc] init];
    menu.imageName = @"saranIcon";
    menu.title = kMenuSaranPengaduan;
    menu.sort = 20;
    menu.menuType = kMenuTypeList;
    menu.isRootMenu = YES;
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [realm addObject:menu];
    
    menu = [[Menu alloc] init];
    menu.imageName = @"customerGetCustomerIcon";
    menu.title = kMenuCustomerGetCustomer;
    menu.sort = 20;
    menu.menuType = kMenuTypeList;
    menu.isRootMenu = YES;
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [realm addObject:menu];
}

@end
