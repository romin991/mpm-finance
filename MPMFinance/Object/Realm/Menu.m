//
//  Menu.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 5/11/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "Menu.h"
#define kGroupLevelNil 0
#define kGroupLevelCustomer 2
#define kGroupLevelAgent 3
#define kGroupLevelDealer 4
#define kGroupLevelMarketingOfficer 5
#define kGroupLevelMarketingDedicated 6
#define kGroupLevelMarketingSpv 7
@implementation Menu

+ (NSString *)primaryKey {
    return @"title";
}
+(NSString*)roleCodeToRoleName:(NSInteger)roleCode
{
    NSString *roleName;
    if (roleCode == kGroupLevelCustomer) {
        roleName = kRoleCustomer;
    }
    else if(roleCode == kGroupLevelAgent) {
        roleName = kRoleAgent;
    }
    else if(roleCode == kGroupLevelDealer) {
        roleName = kRoleDealer;
    }
    else if(roleCode == kGroupLevelMarketingOfficer) {
        roleName = kRoleOfficer;
    }
    else if(roleCode == kGroupLevelMarketingDedicated) {
        roleName = kRoleDedicated;
    }
    else if(roleCode == kGroupLevelMarketingSpv) {
        roleName = kRoleSupervisor;
    }
    else if(roleCode == kGroupLevelNil){
        roleName = kNoRole;
    }
    return roleName;
}
+ (RLMResults *)getMenuForRole:(NSInteger)roleCode{
    return [Menu objectsWhere:@"ANY roles.name = %@ and isRootMenu = YES", [Menu roleCodeToRoleName:roleCode]];
}

+ (RLMResults *)getSubmenuForMenu:(NSString *)menuTitle role:(NSInteger)roleCode{
    return [[Menu objectForPrimaryKey:menuTitle].submenus objectsWhere:@"ANY roles.name = %@", [Menu roleCodeToRoleName:roleCode]];
}

#pragma mark - Populate Data
+ (void)generateSubmenusWithRealm:(RLMRealm *)realm{
//=====================================================================================================
    Menu *submenu = [[Menu alloc] init];
    submenu.imageName = @"ListPengajuanApplikasiSubmenuIcon";
    submenu.title = kSubmenuFormPengajuanApplikasi;
    submenu.sort = 0;
    submenu.borderColor = @"F26F21";
    submenu.menuType = kMenuTypeFormHorizontal;
    
    Action *action = [[Action alloc] init];
    action.name = @"Send";
    action.methodName = @"createListWorkOrder:completion:";
    action.actionType = kActionTypeAPICall;
    submenu.rightButtonAction = action;
    
    action = [[Action alloc] init];
    action.name = @"";
    action.methodName = @"getListWorkOrderDetailWithID:completion:";
    action.actionType = kActionTypeAPICall;
    submenu.fetchDataFromAPI = action;
    
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [realm addObject:submenu];
    
//=====================================================================================================
    submenu = [[Menu alloc] init];
    submenu.imageName = @"DataMAPSubmenuIcon";
    submenu.title = kSubmenuDataMAP;
    submenu.sort = 1;
    submenu.borderColor = @"FB9E15";
    submenu.menuType = kMenuTypeFormVertical;
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleOfficer]];
    [realm addObject:submenu];

//=====================================================================================================
    submenu = [[Menu alloc] init];
    submenu.imageName = @"SurveySubmenuIcon";
    submenu.title = kSubmenuSurvey;
    submenu.sort = 2;
    submenu.borderColor = @"FF8A65";
    submenu.menuType = kMenuTypeFormHorizontal;
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleOfficer]];
    [realm addObject:submenu];
    
//=====================================================================================================
    submenu = [[Menu alloc] init];
    submenu.imageName = @"ListPengajuanApplikasiSubmenuIcon";
    submenu.title = kSubmenuMelengkapiData;
    submenu.sort = 0;
    submenu.menuType = kMenuTypeFormHorizontal;
    submenu.borderColor = @"F26F21";
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleSupervisor]];
    [realm addObject:submenu];
    
//=====================================================================================================
    submenu = [[Menu alloc] init];
    submenu.imageName = @"SurveySubmenuIcon";
    submenu.title = kSubmenuAssignMarketing;
    submenu.sort = 1;
    submenu.borderColor = @"FF8A65";
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleSupervisor]];
    [realm addObject:submenu];
    
//=====================================================================================================
    submenu = [[Menu alloc] init];
    submenu.imageName = @"ListPengajuanApplikasiSubmenuIcon";
    submenu.title = kSubmenuListPengajuanApplikasi;
    submenu.sort = 0;
    submenu.borderColor = @"F26F21";
    submenu.menuType = kMenuTypeList;
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleOfficer]];
    
    Menu *menuList = [[Menu alloc] init];
    menuList.title = kSubmenuListOnlineSubmission;
    menuList.sort = 0;
    menuList.menuType = kMenuTypeSubmenu;
    
    action = [[Action alloc] init];
    action.name = @"Get List Work Order";
    action.methodName = @"getListWorkOrder:";
    action.actionType = kActionTypeAPICall;
    [realm addObject:action];
    
    menuList.fetchDataFromAPI = action;
    
    action = [[Action alloc] init];
    action.name = @"Add";
    action.methodName = @"";
    action.actionType = kActionTypeForward;
    [realm addObject:action];
    menuList.rightButtonAction = action;
    
    [menuList.submenus addObject:[Menu objectForPrimaryKey:kSubmenuFormPengajuanApplikasi]];
    [menuList.roles addObjects:submenu.roles];
    
    action = [[Action alloc] init];
    action.name = @"Send Data";
    action.methodName = @"";
    action.actionType = kActionTypeAPICall;
    [realm addObject:action];
    
    [menuList.actions addObject:action];
    
    action = [[Action alloc] init];
    action.name = @"Edit";
    action.methodName = @"";
    action.actionType = kActionTypeForward;
    [realm addObject:action];
    
    [menuList.actions addObject:action];
    [realm addObject:menuList];
    
    [submenu.submenus addObject:menuList];
    [realm addObject:submenu];
    
//=====================================================================================================
    submenu = [[Menu alloc] init];
    submenu.imageName = @"MonitoringIcon";
    submenu.title = kSubmenuMonitoring;
    submenu.sort = 1;
    submenu.borderColor = @"558B2F";
     [submenu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleOfficer]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [realm addObject:submenu];
    
//=====================================================================================================
    submenu = [[Menu alloc] init];
    submenu.imageName = @"DahsyatIcon";
    submenu.title = kSubmenuDahsyat;
    submenu.sort = 0;
    submenu.borderColor = @"0091EA";
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleOfficer]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleSupervisor]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [realm addObject:submenu];
    
//=====================================================================================================
    submenu = [[Menu alloc] init];
    submenu.imageName = @"UsedCarIcon";
    submenu.title = kSubmenuUsedCar;
    submenu.sort = 1;
    submenu.borderColor = @"546E7A";
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleOfficer]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [realm addObject:submenu];
    
//=====================================================================================================
    submenu = [[Menu alloc] init];
    submenu.imageName = @"";
    submenu.title = kSubmenuProperty;
    submenu.sort = 2;
    submenu.borderColor = @"B30808";
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleOfficer]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [realm addObject:submenu];
    
//=====================================================================================================
    submenu = [[Menu alloc] init];
    submenu.imageName = @"";
    submenu.title = kSubmenuDahsyat4W;
    submenu.sort = 2;
    submenu.borderColor = @"B30808";
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleOfficer]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [realm addObject:submenu];
    
//=====================================================================================================
    submenu = [[Menu alloc] init];
    submenu.imageName = @"";
    submenu.title = kSubmenuDahsyat2W;
    submenu.sort = 2;
    submenu.borderColor = @"B30808";
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleOfficer]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [realm addObject:submenu];
    
//=====================================================================================================
    submenu = [[Menu alloc] init];
    submenu.imageName = @"";
    submenu.title = kSubmenuNewBike;
    submenu.menuType = kMenuTypeFormHorizontal;
    submenu.sort = 2;
    submenu.borderColor = @"B30808";
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleOfficer]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [realm addObject:submenu];
    
//=====================================================================================================
    submenu = [[Menu alloc] init];
    submenu.imageName = @"NewCarIcon";
    submenu.title = kSubmenuNewCar;
    submenu.sort = 2;
    submenu.borderColor = @"B30808";
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleOfficer]];
    [submenu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
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
    

//=====================================================================================================
    Menu *menu = [[Menu alloc] init];
    menu.imageName = @"ListWorkOrderIcon";
    menu.title = kMenuListWorkOrder;
    menu.sort = 0;
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
    action.name = @"Get List Work Order";
    action.methodName = @"getListWorkOrder:";
    action.actionType = kActionTypeAPICall;
    [realm addObject:action];
    
    menuList.fetchDataFromAPI = action;
    [menuList.roles addObjects:menu.roles];
    [menuList.submenus addObject:[Menu objectForPrimaryKey:kSubmenuFormPengajuanApplikasi]];
    [menuList.submenus addObject:[Menu objectForPrimaryKey:kSubmenuDataMAP]];
    [menuList.submenus addObject:[Menu objectForPrimaryKey:kSubmenuSurvey]];
    [menuList.submenus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
    [menuList.submenus addObject:[Menu objectForPrimaryKey:kSubmenuAssignMarketing]];
    [realm addObject:menuList];
    
    [menu.submenus addObject:menuList];
    [realm addObject:menu];

//=====================================================================================================
    menu = [[Menu alloc] init];
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
    menu.menuType = kMenuTypeList;
    menu.isRootMenu = YES;
    [menu.roles addObject:[Role objectForPrimaryKey:kNoRole]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleDealer]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
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
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleCustomer]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleOfficer]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleDealer]];
    [menu.submenus addObject:[Menu objectForPrimaryKey:kSubmenuListPengajuanApplikasi]];
    [menu.submenus addObject:[Menu objectForPrimaryKey:kSubmenuMonitoring]];
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
    action = [[Action alloc] init];
    action.name = @"Get List Pengembalian BPKB";
    action.methodName = @"getListPengembalianBPKB:";
    action.actionType = kActionTypeAPICall;
    [realm addObject:action];
    menu.fetchDataFromAPI = action;
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
    
    
    menu = [[Menu alloc] init];
    menu.imageName = @"TrackingMarketingIcon";
    menu.title = kMenuTrackingMarketing;
    menu.sort = 11;
    menu.menuType = kMenuTypeList;
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
    menuList.imageName = @"";
    menuList.title = kSubmenuListMAP;
    menuList.sort = 0;
    menuList.menuType = kMenuTypeSubmenu;
    [menuList.roles addObjects:menu.roles];
    [menuList.submenus addObject:[Menu objectForPrimaryKey:kSubmenuDataMAP]];
    [realm addObject:menuList];
    
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
    menuList.title = kSubmenuListMarketing;
    menuList.sort = 0;
    menuList.menuType = kMenuTypeMap;
    action = [[Action alloc] init];
    action.name = @"Get List Survey";
    action.methodName = @"getListSurvey:";
    action.actionType = kActionTypeAPICall;
    menuList.fetchDataFromAPI = action;
    [menuList.roles addObjects:menu.roles];
    [realm addObject:menuList];
    
    [menu.submenus addObject:menuList];
    [realm addObject:menu];
    
//=====================================================================================================
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
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleOfficer]];
    [menu.submenus addObject:[Menu objectForPrimaryKey:kSubmenuYearToDate]];
    [menu.submenus addObject:[Menu objectForPrimaryKey:kSubmenuMonthToDate]];
    [realm addObject:menu];
    
    [realm commitWriteTransaction];
}

@end
