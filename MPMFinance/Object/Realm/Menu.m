//
//  Menu.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 5/11/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "Menu.h"
#import "MPMUserInfo.h"

@implementation Menu

+ (NSString *)primaryKey {
    return @"primaryKey";
}

+ (NSArray *)ignoredProperties {
    return @[@"title"];
}

+ (RLMResults *)getMenuForRole:(NSString *)role{
    return [Menu objectsWhere:@"ANY roles.name = %@ and isRootMenu = YES", role];
}

+ (RLMResults *)getSubmenuForMenu:(NSString *)primaryKey role:(NSString *)role{
    return [[Menu objectForPrimaryKey:primaryKey].submenus objectsWhere:@"ANY roles.name = %@", role];
}

+ (RLMResults *)getDataSourcesForMenu:(NSString *)primaryKey role:(NSString *)role{
    return [[Menu objectForPrimaryKey:primaryKey].dataSources objectsWhere:@"ANY roles.name = %@", role];
}

- (NSString *)title{
    //if user select english, then return englishTitle, etc
    return self.indonesiaTitle;
}

#pragma mark - Populate Data
+ (void)generateSubmenusWithRealm:(RLMRealm *)realm{
//==Work Order===================================================================================================
    Menu *submenu = [[Menu alloc] init];
    submenu.imageName = @"ListPengajuanApplikasiSubmenuIcon";
    submenu.primaryKey = kSubmenuFormPengajuanApplikasi;
    submenu.indonesiaTitle = submenu.primaryKey;
    submenu.sort = 0;
    submenu.borderColor = @"F26F21";
    submenu.menuType = kMenuTypeFormWorkOrder;
    
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [realm addObject:submenu];
    
//======
    submenu = [[Menu alloc] init];
    submenu.imageName = @"DataMAPSubmenuIcon";
    submenu.primaryKey = kSubmenuDataMAP;
    submenu.indonesiaTitle = submenu.primaryKey;
    submenu.sort = 1;
    submenu.borderColor = @"FB9E15";
    submenu.menuType = kMenuTypeFormDataMAP;
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleOfficer]];
    [realm addObject:submenu];

//======
    submenu = [[Menu alloc] init];
    submenu.imageName = @"SurveySubmenuIcon";
    submenu.primaryKey = kSubmenuSurvey;
    submenu.indonesiaTitle = submenu.primaryKey;
    submenu.sort = 2;
    submenu.borderColor = @"FF8A65";
    submenu.menuType = kMenuTypeFormSurvey;
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleOfficer]];
    [realm addObject:submenu];
    
//======
    submenu = [[Menu alloc] init];
    submenu.imageName = @"ListPengajuanApplikasiSubmenuIcon"; //#IMAGEWARNING
    submenu.primaryKey = kSubmenuMelengkapiData;
    submenu.indonesiaTitle = submenu.primaryKey;
    submenu.sort = 0;
    submenu.menuType = kMenuTypeFormWorkOrder;
    submenu.borderColor = @"F26F21";
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleSupervisor]];
    [realm addObject:submenu];
    
//======
    submenu = [[Menu alloc] init];
    submenu.imageName = @"SurveySubmenuIcon"; //#IMAGEWARNING
    submenu.primaryKey = kSubmenuAssignMarketing;
    submenu.indonesiaTitle = submenu.primaryKey;
    submenu.sort = 1;
    submenu.borderColor = @"FF8A65";
    submenu.menuType = kMenuTypeList;
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleSupervisor]];
    
    Menu *menuList = [[Menu alloc] init];
    menuList.primaryKey = kSubmenuListMarketing;
    menuList.indonesiaTitle = menuList.primaryKey;
    menuList.sort = 0;
    menuList.isOnePageOnly = YES;
    menuList.menuType = kMenuTypeTrackingMarketing;
    
    Action *action = [[Action alloc] init];
    action.name = @"Get List Marketing";
    action.methodName = @"getAllMarketingBySupervisor:completion:"; //pengajuan/getallmarketingbyspv with datapengajuanid
    action.actionType = kActionTypeAPICall;
    [action.roles addObjects:submenu.roles];
    
    [menuList.dataSources addObject:action];
    [menuList.roles addObjects:submenu.roles];
    
    [submenu.submenus addObject:menuList];
    [realm addObject:submenu];
    
//==Online Submission===================================================================================================
    submenu = [[Menu alloc] init];
    submenu.imageName = @"ListPengajuanApplikasiSubmenuIcon";
    submenu.primaryKey = kSubmenuListPengajuanApplikasi;
    submenu.indonesiaTitle = submenu.primaryKey;
    submenu.sort = 0;
    submenu.borderColor = @"F26F21";
    submenu.menuType = kMenuTypeList;
    [submenu.roles addObject:[Role objectForPrimaryKey:kNoRole]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDealer]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleOfficer]];
    
    menuList = [[Menu alloc] init];
    menuList.primaryKey = kSubmenuListOnlineSubmission;
    menuList.indonesiaTitle = menuList.primaryKey;
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
    submenu.primaryKey = kSubmenuMonitoring;
    submenu.indonesiaTitle = submenu.primaryKey;
    submenu.sort = 1;
    submenu.borderColor = @"558B2F";
    submenu.menuType = kMenuTypeList;
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleOfficer]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDealer]];
    
    menuList = [[Menu alloc] init];
    menuList.primaryKey = kSubmenuListMonitoring;
    menuList.indonesiaTitle = menuList.primaryKey;
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
    submenu.primaryKey = kSubmenuDahsyat;
    submenu.indonesiaTitle = submenu.primaryKey;
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
    submenu.primaryKey = kSubmenuUsedCar;
    submenu.indonesiaTitle = submenu.primaryKey;
    submenu.sort = 1;
    submenu.borderColor = @"546E7A";
    submenu.menuType = kMenuTypeFormUsedCar;
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleSupervisor]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleOfficer]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [realm addObject:submenu];
    
//========
    submenu = [[Menu alloc] init];
    submenu.imageName = @"NewCarIcon";
    submenu.primaryKey = kSubmenuNewCar;
    submenu.indonesiaTitle = submenu.primaryKey;
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
    submenu.primaryKey = kSubmenuYearToDate;
    submenu.indonesiaTitle = submenu.primaryKey;
    submenu.sort = 0;
    submenu.borderColor = @"F26F21";
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleOfficer]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [realm addObject:submenu];
    
//=====================================================================================================
    submenu = [[Menu alloc] init];
    submenu.imageName = @"MonthToDateIcon";
    submenu.primaryKey = kSubmenuMonthToDate;
    submenu.indonesiaTitle = submenu.primaryKey;
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
    menu.primaryKey = kMenuListWorkOrder;
    menu.indonesiaTitle = menu.primaryKey;
    menu.menuType = kMenuTypeList;
    menu.isRootMenu = YES;
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleSupervisor]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleOfficer]];
    
    Menu *menuList = [[Menu alloc] init];
    menuList.backgroundImageName = @"ListWorkOrderBackground";
    menuList.circleIconImageName = @"ListWorkOrderCircleIcon";
    menuList.primaryKey = kSubmenuListWorkOrder;
    menuList.indonesiaTitle = menuList.primaryKey;
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
    menu.primaryKey = kMenuOnlineSubmission;
    menu.indonesiaTitle = menu.primaryKey;
    menu.sort = 10;
    menu.menuType = kMenuTypeSubmenu;
    menu.isRootMenu = YES;
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleOfficer]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleDealer]];
    [menu.roles addObject:[Role objectForPrimaryKey:kNoRole]];
    [menu.submenus addObject:[Menu objectForPrimaryKey:kSubmenuListPengajuanApplikasi]];
    [menu.submenus addObject:[Menu objectForPrimaryKey:kSubmenuMonitoring]];
    [realm addObject:menu];
    
//=====================================================================================================
    menu = [[Menu alloc] init];
    menu.imageName = @"TrackingMarketingIcon";
    menu.primaryKey = kMenuTrackingMarketing;
    menu.indonesiaTitle = menu.primaryKey;
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
    menu.primaryKey = kMenuCalculatorMarketing;
    menu.indonesiaTitle = menu.primaryKey;
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
    menu.primaryKey = kMenuListMap;
    menu.indonesiaTitle = menu.primaryKey;
    menu.sort = 30;
    menu.menuType = kMenuTypeList;
    menu.isRootMenu = YES;
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleSupervisor]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleOfficer]];
    
    menuList = [[Menu alloc] init];
    menuList.primaryKey = kSubmenuListMAP;
    menuList.indonesiaTitle = menuList.primaryKey;
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
    menu.primaryKey = kMenuListSurvey;
    menu.indonesiaTitle = menu.primaryKey;
    menu.sort = 40;
    menu.menuType = kMenuTypeList;
    menu.isRootMenu = YES;
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleSupervisor]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleOfficer]];
    
    menuList = [[Menu alloc] init];
    menuList.imageName = @"";
    menuList.primaryKey = kSubmenuListSurvey;
    menuList.indonesiaTitle = menuList.primaryKey;
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
    menu.primaryKey = kMenuDashboard;
    menu.indonesiaTitle = menu.primaryKey;
    menu.sort = 50;
    menu.menuType = kMenuTypeDashboard;
    menu.isRootMenu = YES;
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleSupervisor]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleOfficer]];
    [menu.submenus addObject:[Menu objectForPrimaryKey:kSubmenuYearToDate]];
    [menu.submenus addObject:[Menu objectForPrimaryKey:kSubmenuMonthToDate]];
    [realm addObject:menu];
    
    
    [self generateSubmenusForCustomerDealerWithRealm:realm];
    [self generateMenusForCustomerDealerWithRealm:realm];
    [realm commitWriteTransaction];
}






+ (void)generateMenusForCustomerDealerWithRealm:(RLMRealm *)realm{
    Menu *menu = [[Menu alloc] init];
    menu.imageName = @"cartIcon";
    menu.primaryKey = kMenuProduct;
    menu.indonesiaTitle = menu.primaryKey;
    menu.sort = 20;
    menu.menuType = kMenuTypeSubmenu2;
    menu.isRootMenu = YES;
    [menu.roles addObject:[Role objectForPrimaryKey:kNoRole]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleDealer]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [realm addObject:menu];
    
//=====================================================================================================
    menu = [[Menu alloc] init];
    menu.imageName = @"creditIcon";
    menu.backgroundImageName = @"CalculatorMarketingBackground";
    menu.circleIconImageName = @"CalculatorMarketingCircleIcon";
    menu.primaryKey = kMenuCreditSimulation;
    menu.indonesiaTitle = menu.primaryKey;
    menu.sort = 20;
    menu.menuType = kMenuTypeSubmenu;
    menu.isRootMenu = YES;
    [menu.roles addObject:[Role objectForPrimaryKey:kNoRole]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleDealer]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    
    [menu.submenus addObject:[Menu objectForPrimaryKey:kSubmenuCreditSimulationNewBike]];
    [menu.submenus addObject:[Menu objectForPrimaryKey:kSubmenuCreditSimulationNewCar]];
    [menu.submenus addObject:[Menu objectForPrimaryKey:kSubmenuCreditSimulationUsedCar]];
    [menu.submenus addObject:[Menu objectForPrimaryKey:kSubmenuCreditSimulationDahsyat2W]];
    [menu.submenus addObject:[Menu objectForPrimaryKey:kSubmenuCreditSimulationDahsyat4W]];
    [menu.submenus addObject:[Menu objectForPrimaryKey:kSubmenuCreditSimulationProperty]];
    [realm addObject:menu];

//=====================================================================================================
    menu = [[Menu alloc] init];
    menu.imageName = @"contactUsIcon";
    menu.primaryKey = kMenuContactUs;
    menu.indonesiaTitle = menu.primaryKey;
    menu.sort = 20;
    menu.menuType = kMenuTypeContactUs;
    menu.isRootMenu = YES;
    [menu.roles addObject:[Role objectForPrimaryKey:kNoRole]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleDealer]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [realm addObject:menu];
    
//=====================================================================================================
    menu = [[Menu alloc] init];
    menu.imageName = @"pengajuanKembaliIcon";
    menu.primaryKey = kMenuPengajuanKembali;
    menu.indonesiaTitle = menu.primaryKey;
    menu.sort = 20;
    menu.menuType = kMenuTypeList;
    menu.isRootMenu = YES;
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleDealer]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [realm addObject:menu];
    
//=====================================================================================================
    menu = [[Menu alloc] init];
    menu.imageName = @"historyTransaksiIcon";
    menu.primaryKey = kMenuHistoryTransaksi;
    menu.indonesiaTitle = menu.primaryKey;
    menu.sort = 20;
    menu.menuType = kMenuTypeList;
    menu.isRootMenu = YES;
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleDealer]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [realm addObject:menu];
    
//=====================================================================================================
    menu = [[Menu alloc] init];
    menu.imageName = @"legalisirBpkb";
    menu.primaryKey = kMenuLegalisirFCBPKB;
    menu.indonesiaTitle = menu.primaryKey;
    menu.sort = 20;
    menu.menuType = kMenuTypeList;
    menu.isRootMenu = YES;
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleDealer]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [realm addObject:menu];
    
//=====================================================================================================
    menu = [[Menu alloc] init];
    menu.imageName = @"klaimAsuransiIcon";
    menu.primaryKey = kMenuKlaimAsuransi;
    menu.indonesiaTitle = menu.primaryKey;
    menu.sort = 20;
    menu.menuType = kMenuTypeList;
    menu.isRootMenu = YES;
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleDealer]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [realm addObject:menu];

//=====================================================================================================
    menu = [[Menu alloc] init];
    menu.imageName = @"pelunasanIcon";
    menu.primaryKey = kMenuPelunasanDipercepat;
    menu.indonesiaTitle = menu.primaryKey;
    menu.sort = 20;
    menu.menuType = kMenuTypeList;
    menu.isRootMenu = YES;
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleDealer]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [realm addObject:menu];
    
//=====================================================================================================
    menu = [[Menu alloc] init];
    menu.imageName = @"pengembalianBPKBIcon";
    menu.primaryKey = kMenuPengembalianBPKB;
    menu.indonesiaTitle = menu.primaryKey;
    menu.sort = 20;
    menu.menuType = kMenuTypeList;
    menu.isRootMenu = YES;
    Action *action = [[Action alloc] init];
    action.name = @"Get List Pengembalian BPKB";
    action.methodName = @"getListPengembalianBPKB:";
    action.actionType = kActionTypeAPICall;
    [realm addObject:action];
    [menu.dataSources addObject:action];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleDealer]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [realm addObject:menu];
    
//=====================================================================================================
    menu = [[Menu alloc] init];
    menu.imageName = @"saranIcon";
    menu.primaryKey = kMenuSaranPengaduan;
    menu.indonesiaTitle = menu.primaryKey;
    menu.sort = 20;
    menu.menuType = kMenuTypeList;
    menu.isRootMenu = YES;
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleDealer]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [realm addObject:menu];

//=====================================================================================================
    menu = [[Menu alloc] init];
    menu.imageName = @"customerGetCustomerIcon";
    menu.primaryKey = kMenuCustomerGetCustomer;
    menu.indonesiaTitle = menu.primaryKey;
    menu.sort = 20;
    menu.menuType = kMenuTypeList;
    menu.isRootMenu = YES;
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleDealer]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [realm addObject:menu];
}





+ (void)generateSubmenusForCustomerDealerWithRealm:(RLMRealm *)realm{
    //=====================================================================================================
    Menu *submenu = [[Menu alloc] init];
    submenu.imageName = @"";
    submenu.primaryKey = kSubmenuCreditSimulationNewBike;
    submenu.menuType = kMenuTypeCreditSimulation;
    submenu.sort = 2;
    submenu.borderColor = @"B30808";
    [submenu.roles addObject:[Role objectForPrimaryKey:kNoRole]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleOfficer]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [realm addObject:submenu];
    
    //=====================================================================================================
    submenu = [[Menu alloc] init];
    submenu.imageName = @"NewCarIcon";
    submenu.primaryKey = kSubmenuCreditSimulationNewCar;
    submenu.sort = 2;
    submenu.menuType = kMenuTypeCreditSimulation;
    submenu.borderColor = @"B30808";
    [submenu.roles addObject:[Role objectForPrimaryKey:kNoRole]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleOfficer]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [realm addObject:submenu];
    
    //=====================================================================================================
    submenu = [[Menu alloc] init];
    submenu.imageName = @"";
    submenu.primaryKey = kSubmenuCreditSimulationUsedCar;
    submenu.sort = 2;
    submenu.menuType = kMenuTypeCreditSimulation;
    submenu.borderColor = @"B30808";
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleOfficer]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kNoRole]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [realm addObject:submenu];
    
    //=====================================================================================================
    submenu = [[Menu alloc] init];
    submenu.imageName = @"";
    submenu.primaryKey = kSubmenuCreditSimulationDahsyat2W;
    submenu.sort = 2;
    submenu.menuType = kMenuTypeCreditSimulation;
    submenu.borderColor = @"B30808";
    [submenu.roles addObject:[Role objectForPrimaryKey:kNoRole]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleOfficer]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [realm addObject:submenu];
    
    //=====================================================================================================
    submenu = [[Menu alloc] init];
    submenu.imageName = @"";
    submenu.primaryKey = kSubmenuCreditSimulationDahsyat4W;
    submenu.sort = 2;
    submenu.menuType = kMenuTypeCreditSimulation;
    submenu.borderColor = @"B30808";
    [submenu.roles addObject:[Role objectForPrimaryKey:kNoRole]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleOfficer]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [realm addObject:submenu];
    
    //=====================================================================================================
    submenu = [[Menu alloc] init];
    submenu.imageName = @"";
    submenu.primaryKey = kSubmenuCreditSimulationProperty;
    submenu.sort = 2;
    submenu.menuType = kMenuTypeCreditSimulation;
    submenu.borderColor = @"B30808";
    [submenu.roles addObject:[Role objectForPrimaryKey:kNoRole]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleOfficer]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [realm addObject:submenu];
    
    
    
    
    
}

@end
