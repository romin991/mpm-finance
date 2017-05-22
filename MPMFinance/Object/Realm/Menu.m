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
    submenu.title = kSubmenuListPengajuanApplikasi;
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
}

+ (void)generateMenus{
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    
    [self generateSubmenusWithRealm:realm];
    
    Menu *menu = [[Menu alloc] init];
    menu.imageName = @"ListWorkOrderIcon";
    menu.backgroundImageName = @"ListWorkOrderBackground";
    menu.circleIconImageName = @"ListWorkOrderCircleIcon";
    menu.title = kMenuListWorkOrder;
    menu.sort = 0;
    menu.menuType = kMenuTypeList;
    menu.isRootMenu = YES;
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleSupervisor]];
    
    Menu *menuList = [[Menu alloc] init];
    menuList.imageName = @"ListWorkOrderIcon";
    menuList.backgroundImageName = @"ListWorkOrderBackground";
    menuList.circleIconImageName = @"ListWorkOrderCircleIcon";
    menuList.title = kSubmenuListWorkOrder;
    menuList.sort = 0;
    menuList.menuType = kMenuTypeSubmenu;
    [menuList.roles addObjects:menu.roles];
    [menuList.submenus addObject:[Menu objectForPrimaryKey:kSubmenuListPengajuanApplikasi]];
    [menuList.submenus addObject:[Menu objectForPrimaryKey:kSubmenuDataMAP]];
    [menuList.submenus addObject:[Menu objectForPrimaryKey:kSubmenuSurvey]];
    [menuList.submenus addObject:[Menu objectForPrimaryKey:kSubmenuMelengkapiData]];
    [menuList.submenus addObject:[Menu objectForPrimaryKey:kSubmenuAssignMarketing]];
    [realm addObject:menuList];
    
    [menu.submenus addObject:menuList];
    [realm addObject:menu];
    
    menu = [[Menu alloc] init];
    menu.imageName = @"OnlineSubmissionIcon";
    menu.title = kMenuOnlineSubmission;
    menu.sort = 10;
    menu.menuType = kMenuTypeSubmenu;
    menu.isRootMenu = YES;
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
//    [menu.submenus addObjects:[self generateSubmenusWithRealm:realm menu:menu]];
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
    menu.title = kMenuCalculatorMarketing;
    menu.sort = 20;
    menu.menuType = kMenuTypeSubmenu;
    menu.isRootMenu = YES;
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleSupervisor]];
//    [menu.submenus addObjects:[self generateSubmenusWithRealm:realm menu:menu]];
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
    menu.isRootMenu = YES;
    [menuList.roles addObjects:menu.roles];
    [menuList.submenus addObject:[Menu objectForPrimaryKey:kSubmenuDataMAP]];
    [realm addObject:menuList];
    
    [menu.submenus addObject:menuList];
    [realm addObject:menu];
    
    menu = [[Menu alloc] init];
    menu.imageName = @"ListSurveyIcon";
    menu.title = kMenuListSurvey;
    menu.sort = 40;
    menu.isRootMenu = YES;
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleSupervisor]];
//    [menu.submenus addObjects:[self generateSubmenusWithRealm:realm menu:menu]];
    [realm addObject:menu];
    
    menu = [[Menu alloc] init];
    menu.imageName = @"DashboardIcon";
    menu.title = kMenuDashboard;
    menu.sort = 50;
    menu.menuType = kMenuTypeSubmenu;
    menu.isRootMenu = YES;
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleSupervisor]];
//    [menu.submenus addObjects:[self generateSubmenusWithRealm:realm menu:menu]];
    [realm addObject:menu];
    
    [realm commitWriteTransaction];
}

+ (NSMutableArray *)generateSubmenusWithRealm:(RLMRealm *)realm menu:(Menu *)menu{
    NSMutableArray *submenus = [NSMutableArray array];
    

//        Menu *submenu = [[Menu alloc] init];
//        submenu.imageName = @"ListPengajuanApplikasiSubmenuIcon";
//        submenu.title = kSubmenuListPengajuanApplikasi;
//        submenu.sort = 0;
//        submenu.menuType = kMenuTypeFormHorizontal;
//        [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
//        [realm addObject:submenu];
//        [submenus addObject:submenu];
//        
//        submenu = [[Menu alloc] init];
//        submenu.imageName = @"DataMAPSubmenuIcon";
//        submenu.title = kSubmenuDataMAP;
//        submenu.sort = 1;
//        submenu.menuType = kMenuTypeFormVertical;
//        [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
//        [realm addObject:submenu];
//        [submenus addObject:submenu];
//        
//        submenu = [[Menu alloc] init];
//        submenu.imageName = @"SurveySubmenuIcon";
//        submenu.title = kSubmenuSurvey;
//        submenu.sort = 2;
//        submenu.menuType = kMenuTypeFormHorizontal;
//        [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
//        [realm addObject:submenu];
//        [submenus addObject:submenu];
//        
//        submenu = [[Menu alloc] init];
//        submenu.imageName = @"";
//        submenu.title = kSubmenuMelengkapiData;
//        submenu.sort = 0;
//        [submenu.roles addObject:[Role objectForPrimaryKey:kRoleSupervisor]];
//        [realm addObject:submenu];
//        [submenus addObject:submenu];
//        
//        submenu = [[Menu alloc] init];
//        submenu.imageName = @"";
//        submenu.title = kSubmenuAssignMarketing;
//        submenu.sort = 1;
//        [submenu.roles addObject:[Role objectForPrimaryKey:kRoleSupervisor]];
//        [realm addObject:submenu];
//        [submenus addObject:submenu];

    
//    if ([menu.title isEqualToString:kMenuOnlineSubmission]) {
//        Menu *submenu = [[Menu alloc] init];
//        submenu.imageName = @"ListPengajuanApplikasiSubmenuIcon";
//        submenu.title = kSubmenuListPengajuanApplikasi;
//        submenu.sort = 0;
//        submenu.menuType = kMenuTypeFormHorizontal;
//        [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
//        [realm addObject:submenu];
//        [submenus addObject:submenu];
//        
//        submenu = [[Menu alloc] init];
//        submenu.imageName = @"";
//        submenu.title = kSubmenuD;
//        submenu.sort = 1;
//        submenu.menuType = kMenuTypeFormVertical;
//        [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
//        [realm addObject:submenu];
//        [submenus addObject:submenu];
//    }
    
    return submenus;
}

@end
