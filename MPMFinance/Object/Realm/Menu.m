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

+ (Menu *)getMenuForPrimaryKey:(NSString *)primaryKey{
    return [Menu objectForPrimaryKey:primaryKey];
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
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleSupervisor]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleBM]];
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
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleSupervisor]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleBM]];
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
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleBM]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleOfficer]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleSupervisor]];
    [realm addObject:submenu];
    
//======
    submenu = [[Menu alloc] init];
    submenu.imageName = @"ListPengajuanApplikasiSubmenuIcon"; //#IMAGEWARNING
    submenu.primaryKey = kSubmenuMelengkapiData;
    submenu.indonesiaTitle = submenu.primaryKey;
    submenu.sort = 0;
    submenu.menuType = kMenuTypeFormWorkOrder;
    submenu.borderColor = @"F26F21";
    //[submenu.roles addObject:[Role objectForPrimaryKey:kRoleSupervisor]];
    [realm addObject:submenu];
    
//======
    submenu = [[Menu alloc] init];
    submenu.imageName = @"SurveySubmenuIcon"; //#IMAGEWARNING
    submenu.primaryKey = kSubmenuAssignMarketing;
    submenu.indonesiaTitle = submenu.primaryKey;
    submenu.sort = 1;
    submenu.borderColor = @"FF8A65";
    submenu.menuType = kMenuTypeListAssignMarketing;
   // [submenu.roles addObject:[Role objectForPrimaryKey:kRoleSupervisor]];

    [realm addObject:submenu];
    
//==Online Submission===================================================================================================
    submenu = [[Menu alloc] init];
    submenu.imageName = @"ListPengajuanApplikasiSubmenuIcon";
    submenu.primaryKey = kSubmenuListPengajuanApplikasi;
    submenu.indonesiaTitle = submenu.primaryKey;
    submenu.sort = 0;
    submenu.borderColor = @"F26F21";
    submenu.menuType = kMenuTypeList;
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDealer]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleOfficer]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleAgent]];
    
    Menu *menuList = [[Menu alloc] init];
    menuList.primaryKey = kSubmenuListOnlineSubmission;
    menuList.indonesiaTitle = menuList.primaryKey;
    menuList.sort = 0;
    menuList.menuType = kMenuTypeSubmenu;
    
    Action *action = [[Action alloc] init];
    action.name = @"DRAFT";
    action.methodName = @"getNewByUserListWorkOrderPage:completion:"; //pengajuan/getallbyuser with status new
    action.actionType = kActionTypeAPICall;
    [action.roles addObjects:submenu.roles];
    [menuList.dataSources addObject:action];
    
    action = [[Action alloc] init];
    action.name = @"OFFLINE";
    action.methodName = @"";
    action.actionType = kActionQueryDB;
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
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleAgent]];
    
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
    menu.menuType = kMenuTypeListWorkOrder;
    menu.isRootMenu = YES;
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleOfficer]];
    
    Menu *menuList = [[Menu alloc] init];
    menuList.backgroundImageName = @"ListWorkOrderBackground";
    menuList.circleIconImageName = @"ListWorkOrderCircleIcon";
    menuList.primaryKey = kSubmenuListWorkOrder;
    menuList.indonesiaTitle = menuList.primaryKey;
    menuList.sort = 0;
    menuList.menuType = kMenuTypeSubmenu;
    
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
    menu.imageName = @"MonitoringIcon";
    menu.primaryKey = kMenuMonitoring;
    menu.indonesiaTitle = menu.primaryKey;
    menu.sort = 11;
    menu.menuType = kMenuMonitoring;
    menu.isRootMenu = YES;
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleSupervisor]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleBM]];
    [realm addObject:menu];
//=====================================================================================================
    menu = [[Menu alloc] init];
    menu.imageName = @"TrackingMarketingIcon";
    menu.primaryKey = kMenuTrackingMarketing;
    menu.indonesiaTitle = menu.primaryKey;
    menu.sort = 11;
    menu.menuType = kMenuTrackingMarketing;
    menu.isRootMenu = YES;
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleSupervisor]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleBM]];
    [realm addObject:menu];
//=====================================================================================================
    menu = [[Menu alloc] init];
    menu.imageName = @"TrackingMarketingIcon";
    menu.primaryKey = kMenuSetAlternate;
    menu.indonesiaTitle = menu.primaryKey;
    menu.sort = 11;
    menu.menuType = kMenuSetAlternate;
    menu.isRootMenu = YES;
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleSupervisor]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleBM]];
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
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleBM]];
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
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleOfficer]];
    
    menuList = [[Menu alloc] init];
    menuList.primaryKey = kSubmenuListMAP;
    menuList.indonesiaTitle = menuList.primaryKey;
    menuList.sort = 0;
    menuList.menuType = kMenuTypeSubmenu;
    
    Action *action = [[Action alloc] init];
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
//    menu = [[Menu alloc] init];
//    menu.imageName = @"DashboardIcon";
//    menu.backgroundImageName = @"DashboardBackground";
//    menu.circleIconImageName = @"DashboardCircleIcon";
//    menu.primaryKey = kMenuDashboard;
//    menu.indonesiaTitle = menu.primaryKey;
//    menu.sort = 50;
//    menu.menuType = kMenuTypeDashboard;
//    menu.isRootMenu = YES;
//    [menu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
//    [menu.roles addObject:[Role objectForPrimaryKey:kRoleSupervisor]];
//    [menu.roles addObject:[Role objectForPrimaryKey:kRoleOfficer]];
//    [menu.roles addObject:[Role objectForPrimaryKey:kRoleDealer]];
//    [menu.submenus addObject:[Menu objectForPrimaryKey:kSubmenuYearToDate]];
//    [menu.submenus addObject:[Menu objectForPrimaryKey:kSubmenuMonthToDate]];
//    [realm addObject:menu];
//    
    
    [self generateSubmenusForCustomerDealerWithRealm:realm];
    [self generateMenusForCustomerDealerWithRealm:realm];
    [realm commitWriteTransaction];
}






+ (void)generateMenusForCustomerDealerWithRealm:(RLMRealm *)realm{
    Menu *menu = [[Menu alloc] init];
    menu.imageName = @"cartIcon";
    menu.primaryKey = kMenuProduct;
    menu.englishTitle = menu.primaryKey;
    menu.indonesiaTitle = @"Produk";
    menu.sort = 20;
    menu.menuType = kMenuTypeSubmenu2;
    menu.isRootMenu = YES;
    [menu.roles addObject:[Role objectForPrimaryKey:kNoRole]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleDealer]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleAgent]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [realm addObject:menu];
    
//=====================================================================================================
    menu = [[Menu alloc] init];
    menu.imageName = @"creditIcon";
    menu.backgroundImageName = @"CalculatorMarketingBackground";
    menu.circleIconImageName = @"CalculatorMarketingCircleIcon";
    menu.primaryKey = kMenuCreditSimulation;
    menu.englishTitle = menu.primaryKey;
    menu.indonesiaTitle = @"Simulasi Kredit";
    menu.sort = 20;
    menu.menuType = kMenuTypeSubmenu;
    menu.isRootMenu = YES;
    [menu.roles addObject:[Role objectForPrimaryKey:kNoRole]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleDealer]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleAgent]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    
    [menu.submenus addObject:[Menu objectForPrimaryKey:kSubmenuCreditSimulationNewBike]];
    [menu.submenus addObject:[Menu objectForPrimaryKey:kSubmenuCreditSimulationNewCar]];
    [menu.submenus addObject:[Menu objectForPrimaryKey:kSubmenuCreditSimulationUsedCar]];
    [menu.submenus addObject:[Menu objectForPrimaryKey:kSubmenuCreditSimulationDahsyat2W]];
    [menu.submenus addObject:[Menu objectForPrimaryKey:kSubmenuCreditSimulationDahsyat4W]];
    [realm addObject:menu];

//=====================================================================================================
    menu = [[Menu alloc] init];
    menu.imageName = @"contactUsIcon";
    menu.primaryKey = kMenuContactUs;
    menu.indonesiaTitle = @"Hubungi Kami";
    menu.englishTitle = menu.primaryKey;
    menu.sort = 20;
    menu.menuType = kMenuTypeContactUs;
    menu.isRootMenu = YES;
    [menu.roles addObject:[Role objectForPrimaryKey:kNoRole]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleDealer]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleAgent]];
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
    [menu.submenus addObject:[Menu objectForPrimaryKey:kSubmenuListPengajuanApplikasi]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleAgent]];
    [menu.submenus addObject:[Menu objectForPrimaryKey:kSubmenuMonitoring]];
    [realm addObject:menu];

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
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleBM]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleAgent]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleOfficer]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleDealer]];
    [menu.submenus addObject:[Menu objectForPrimaryKey:kSubmenuYearToDate]];
    [menu.submenus addObject:[Menu objectForPrimaryKey:kSubmenuMonthToDate]];
    [realm addObject:menu];
//=====================================================================================================
    menu = [[Menu alloc] init];
    menu.imageName = @"topUpIcon";
    menu.backgroundImageName = @"OnlineSubmissionBackground";
    menu.circleIconImageName = @"OnlineSubmissionCircleIcon";
    menu.primaryKey = kMenuTopUp;
    menu.indonesiaTitle = menu.primaryKey;
    menu.englishTitle = @"Top Up";
    menu.sort = 20;
    menu.menuType = kMenuTypeSubmenu;
    menu.isRootMenu = YES;
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [menu.submenus addObject:[Menu objectForPrimaryKey:kSubmenuTopUp]];
    [menu.submenus addObject:[Menu objectForPrimaryKey:kSubmenuHistoryTopUp]];
    [realm addObject:menu];
    
//=====================================================================================================
    menu = [[Menu alloc] init];
    menu.imageName = @"historyTransaksiIcon";
    menu.primaryKey = kMenuHistoryTransaksi;
    menu.indonesiaTitle = menu.primaryKey;
    menu.englishTitle = @"Transaction History";
    menu.sort = 20;
    menu.menuType = kMenuTypeHistory;
    menu.isRootMenu = YES;
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [realm addObject:menu];
    
//=====================================================================================================
    menu = [[Menu alloc] init];
    menu.imageName = @"legalisirBpkb";
    menu.backgroundImageName = @"OnlineSubmissionBackground";
    menu.circleIconImageName = @"OnlineSubmissionCircleIcon";
    menu.primaryKey = kMenuLegalisirFCBPKB;
    menu.indonesiaTitle = menu.primaryKey;
    menu.englishTitle = @"Validation Of Copy BPKB";
    menu.sort = 20;
    menu.menuType = kMenuTypeSubmenu;
    menu.isRootMenu = YES;
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [menu.submenus addObject:[Menu objectForPrimaryKey:kSubmenuLegalizationBPKB]];
    [menu.submenus addObject:[Menu objectForPrimaryKey:kSubmenuHistoryBPKB]];
    [realm addObject:menu];
    
//=====================================================================================================
    menu = [[Menu alloc] init];
    menu.imageName = @"klaimAsuransiIcon";
    menu.backgroundImageName = @"OnlineSubmissionBackground";
    menu.circleIconImageName = @"OnlineSubmissionCircleIcon";
    menu.primaryKey = kMenuKlaimAsuransi;
    menu.indonesiaTitle = menu.primaryKey;
    menu.englishTitle = @"Insurance Claim";
    menu.sort = 20;
    menu.menuType = kMenuTypeSubmenu;
    menu.isRootMenu = YES;
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [menu.submenus addObject:[Menu objectForPrimaryKey:kSubmenuInsuranceClaimForm]];
    [menu.submenus addObject:[Menu objectForPrimaryKey:kSubmenuHistoryInsuranceClaim]];
    [realm addObject:menu];

//=====================================================================================================
    menu = [[Menu alloc] init];
    menu.imageName = @"pelunasanIcon";
    menu.primaryKey = kMenuPelunasanDipercepat;
    menu.indonesiaTitle = menu.primaryKey;
    menu.englishTitle = @"Early Termination";
    menu.sort = 20;
    menu.menuType = kMenuTypeAcceleratedRepayment;
    menu.isRootMenu = YES;
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [realm addObject:menu];
    
//=====================================================================================================
    menu = [[Menu alloc] init];
    menu.imageName = @"pengembalianBPKBIcon";
    menu.backgroundImageName = @"OnlineSubmissionBackground";
    menu.circleIconImageName = @"OnlineSubmissionCircleIcon";
    menu.primaryKey = kMenuPengembalianBPKB;
    menu.indonesiaTitle = menu.primaryKey;
    menu.englishTitle = @"BPKB Pick Up";
    menu.sort = 20;
    menu.menuType = kMenuTypeSubmenu;
    menu.isRootMenu = YES;
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [menu.submenus addObject:[Menu objectForPrimaryKey:kSubmenuPengambilanBPKB]];
    [menu.submenus addObject:[Menu objectForPrimaryKey:kSubmenuHistoryPengambilanBPKB]];
    [realm addObject:menu];
    
//=====================================================================================================
    menu = [[Menu alloc] init];
    menu.imageName = @"saranIcon";
    menu.backgroundImageName = @"OnlineSubmissionBackground";
    menu.circleIconImageName = @"OnlineSubmissionCircleIcon";
    menu.primaryKey = kMenuSaranPengaduan;
    menu.indonesiaTitle = menu.primaryKey;
    menu.englishTitle = @"Critics and Suggestions";
    menu.sort = 20;
    menu.menuType = kMenuTypeSubmenu;
    menu.isRootMenu = YES;
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [menu.submenus addObject:[Menu objectForPrimaryKey:kSubmenuSaranPengaduan]];
    [menu.submenus addObject:[Menu objectForPrimaryKey:kSubmenuHistorySaranPengaduan]];
    [realm addObject:menu];

//=====================================================================================================
    menu = [[Menu alloc] init];
    menu.imageName = @"customerGetCustomerIcon";
    menu.backgroundImageName = @"OnlineSubmissionBackground";
    menu.circleIconImageName = @"OnlineSubmissionCircleIcon";
    menu.primaryKey = kMenuCustomerGetCustomer;
    menu.indonesiaTitle = menu.primaryKey;
    menu.englishTitle = menu.primaryKey;
    menu.sort = 20;
    menu.menuType = kMenuTypeSubmenu;
    menu.isRootMenu = YES;
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [menu.submenus addObject:[Menu objectForPrimaryKey:kSubmenuCustomerGetCustomer]];
    [menu.submenus addObject:[Menu objectForPrimaryKey:kSubmenuHistoryCustomerGetCustomer]];
    [realm addObject:menu];
}





+ (void)generateSubmenusForCustomerDealerWithRealm:(RLMRealm *)realm{
//==CreditSimulation===================================================================================================
    Menu *submenu = [[Menu alloc] init];
    submenu.imageName = @"NewBike";
    submenu.primaryKey = kSubmenuCreditSimulationNewBike;
    submenu.indonesiaTitle = @"Pembiayaan Motor Baru";
    submenu.englishTitle = @"New Bike";
    submenu.menuType = kMenuTypeCreditSimulation;
    submenu.sort = 2;
    submenu.borderColor = @"F26F21";
    [submenu.roles addObject:[Role objectForPrimaryKey:kNoRole]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDealer]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [realm addObject:submenu];
    
    //==========
    submenu = [[Menu alloc] init];
    submenu.imageName = @"NewCarIcon";
    submenu.primaryKey = kSubmenuCreditSimulationNewCar;
    submenu.indonesiaTitle = @"Pembiayaan Mobil Baru";
    submenu.englishTitle = @"New Car";
    submenu.sort = 2;
    submenu.menuType = kMenuTypeCreditSimulation;
    submenu.borderColor = @"B30808";
    [submenu.roles addObject:[Role objectForPrimaryKey:kNoRole]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDealer]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [realm addObject:submenu];
    
    //==========
    submenu = [[Menu alloc] init];
    submenu.imageName = @"UsedCarIcon";
    submenu.primaryKey = kSubmenuCreditSimulationUsedCar;
    submenu.indonesiaTitle = @"Pembiayaan Mobil Bekas";
    submenu.englishTitle = @"Used Car";
    submenu.sort = 2;
    submenu.menuType = kMenuTypeCreditSimulation;
    submenu.borderColor = @"546E7A";
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDealer]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kNoRole]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [realm addObject:submenu];
    
    //==========
    submenu = [[Menu alloc] init];
    submenu.imageName = @"";
    submenu.primaryKey = kSubmenuCreditSimulationDahsyat2W;
    submenu.indonesiaTitle = @"Dahsyat - Multiguna Motor";
    submenu.englishTitle = @"Dahsyat - Multipurpose Bike";
    submenu.sort = 2;
    submenu.menuType = kMenuTypeCreditSimulation;
    submenu.borderColor = @"1875D1";
    [submenu.roles addObject:[Role objectForPrimaryKey:kNoRole]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDealer]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [realm addObject:submenu];
    
    //==========
    submenu = [[Menu alloc] init];
    submenu.imageName = @"";
    submenu.primaryKey = kSubmenuCreditSimulationDahsyat4W;
    submenu.indonesiaTitle = @"Dahsyat - Multiguna Mobil";
    submenu.englishTitle = @"Dahsyat - Multipurpose Car";
    submenu.sort = 2;
    submenu.menuType = kMenuTypeCreditSimulation;
    submenu.borderColor = @"1875D1";
    [submenu.roles addObject:[Role objectForPrimaryKey:kNoRole]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDealer]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [realm addObject:submenu];
    
    //==========
    submenu = [[Menu alloc] init];
    submenu.imageName = @"Property";
    submenu.primaryKey = kSubmenuCreditSimulationProperty;
    submenu.indonesiaTitle = @"Properti";
    submenu.englishTitle = @"Property";
    submenu.sort = 2;
    submenu.menuType = kMenuTypeCreditSimulation;
    submenu.borderColor = @"33691E";
    [submenu.roles addObject:[Role objectForPrimaryKey:kNoRole]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDealer]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [realm addObject:submenu];

//==SubmissionBack================================================================================
    submenu = [[Menu alloc] init];
    submenu.imageName = @"pengajuanKembaliIcon";
    submenu.primaryKey = kSubmenuTopUp;
    submenu.indonesiaTitle = submenu.primaryKey;
    submenu.englishTitle = submenu.primaryKey;
    submenu.sort = 2;
    submenu.menuType = kMenuTypeFormTopUp;
    submenu.borderColor = @"0091EA";
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDealer]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [realm addObject:submenu];
    
    //==========
    submenu = [[Menu alloc] init];
    submenu.imageName = @"HistorySubmenuIcon";
    submenu.primaryKey = kSubmenuHistoryTopUp;
    submenu.indonesiaTitle = submenu.primaryKey;
#warning blm diisi
    submenu.englishTitle = @"";
    submenu.sort = 2;
    submenu.menuType = kMenuTypeListTopUp;
    submenu.borderColor = @"33691E";
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDealer]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [realm addObject:submenu];
    
//==Legalisir BPKB===========================================================================================
    submenu = [[Menu alloc] init];
    submenu.imageName = @"ListPengajuanApplikasiSubmenuIcon";
    submenu.primaryKey = kSubmenuLegalizationBPKB;
    submenu.indonesiaTitle = submenu.primaryKey;
#warning blm diisi
    submenu.englishTitle = submenu.primaryKey;
    submenu.sort = 2;
    submenu.menuType = kMenuTypeFormLegalizationBPKB;
    submenu.borderColor = @"F26F21";
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDealer]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [realm addObject:submenu];
    
    //===========
    submenu = [[Menu alloc] init];
    submenu.imageName = @"HistorySubmenuIcon";
    submenu.primaryKey = kSubmenuHistoryBPKB;
    submenu.indonesiaTitle = submenu.primaryKey;
#warning blm diisi
    submenu.englishTitle = @"";
    submenu.sort = 2;
    submenu.menuType = kMenuTypeListLegalizationBPKB;
    submenu.borderColor = @"33691E";
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDealer]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [realm addObject:submenu];
    
//==Insurance Claim===========================================================================================
    submenu = [[Menu alloc] init];
    submenu.imageName = @"ListPengajuanApplikasiSubmenuIcon";
    submenu.primaryKey = kSubmenuInsuranceClaimForm;
    submenu.indonesiaTitle = submenu.primaryKey;
#warning blm diisi
    submenu.englishTitle = @"";
    submenu.sort = 2;
    submenu.menuType = kMenuTypeFormInsuranceClaim;
    submenu.borderColor = @"F26F21";
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDealer]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [realm addObject:submenu];
    
    //=======
    submenu = [[Menu alloc] init];
    submenu.imageName = @"HistorySubmenuIcon";
    submenu.primaryKey = kSubmenuHistoryInsuranceClaim;
    submenu.indonesiaTitle = submenu.primaryKey;
#warning blm diisi
    submenu.englishTitle = @"";
    submenu.sort = 2;
    submenu.menuType = kMenuTypeListInsuranceClaim;
    submenu.borderColor = @"33691E";
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDealer]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [realm addObject:submenu];
    
//==Pengambilan BPKB=========================================================================================
    submenu = [[Menu alloc] init];
    submenu.imageName = @"ListPengajuanApplikasiSubmenuIcon";
    submenu.primaryKey = kSubmenuPengambilanBPKB;
    submenu.indonesiaTitle = submenu.primaryKey;
#warning blm diisi
    submenu.englishTitle = @"";
    submenu.sort = 2;
    submenu.menuType = kMenuTypeFormPengambilanBPKB;
    submenu.borderColor = @"F26F21";
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDealer]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [realm addObject:submenu];
    
    //==========
    submenu = [[Menu alloc] init];
    submenu.imageName = @"HistorySubmenuIcon";
    submenu.primaryKey = kSubmenuHistoryPengambilanBPKB;
    submenu.indonesiaTitle = submenu.primaryKey;
#warning blm diisi
    submenu.englishTitle = @"";
    submenu.sort = 2;
    submenu.menuType = kMenuTypeListPengambilanBPKB;
    submenu.borderColor = @"33691E";
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDealer]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [realm addObject:submenu];
    
//==Saran dan Pengaduan ===================================================================================
    submenu = [[Menu alloc] init];
    submenu.imageName = @"ListPengajuanApplikasiSubmenuIcon";
    submenu.primaryKey = kSubmenuSaranPengaduan;
    submenu.indonesiaTitle = submenu.primaryKey;
#warning blm diisi
    submenu.englishTitle = @"";
    submenu.sort = 2;
    submenu.menuType = kMenuTypeFormSaranPengaduan;
    submenu.borderColor = @"F26F21";
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDealer]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [realm addObject:submenu];
    
    //==========
    submenu = [[Menu alloc] init];
    submenu.imageName = @"HistorySubmenuIcon";
    submenu.primaryKey = kSubmenuHistorySaranPengaduan;
    submenu.indonesiaTitle = submenu.primaryKey;
#warning blm diisi
    submenu.englishTitle = @"";
    submenu.sort = 2;
    submenu.menuType = kMenuTypeListSaranPengaduan;
    submenu.borderColor = @"33691E";
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDealer]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [realm addObject:submenu];
    
//==Customer get customer ===============================================================================
    submenu = [[Menu alloc] init];
    submenu.imageName = @"ListPengajuanApplikasiSubmenuIcon";
    submenu.primaryKey = kSubmenuCustomerGetCustomer;
    submenu.indonesiaTitle = submenu.primaryKey;
#warning blm diisi
    submenu.englishTitle = @"";
    submenu.sort = 2;
    submenu.menuType = kMenuTypeFormCustomerGetCustomer;
    submenu.borderColor = @"F26F21";
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDealer]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [realm addObject:submenu];
    
    //==========
    submenu = [[Menu alloc] init];
    submenu.imageName = @"HistorySubmenuIcon";
    submenu.primaryKey = kSubmenuHistoryCustomerGetCustomer;
    submenu.indonesiaTitle = submenu.primaryKey;
#warning blm diisi
    submenu.englishTitle = @"";
    submenu.sort = 2;
    submenu.menuType = kMenuTypeListCustomerGetCustomer;
    submenu.borderColor = @"33691E";
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDealer]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [realm addObject:submenu];
}

@end
