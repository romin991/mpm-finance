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
    return [Menu objectsWhere:@"ANY roles.name = %@ and parentMenu = nil", roleName];
}

+ (RLMResults *)getSubmenuForMenu:(NSString *)menuTitle role:(NSString *)roleName{
    return [Menu objectsWhere:@"ANY roles.name = %@ and parentMenu.title = %@", roleName, menuTitle];
}

#pragma mark - Populate Data
+ (void)generateMenus{
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    
    Menu *menu = [[Menu alloc] init];
    menu.imageName = @"ListWorkOrderIcon";
    menu.backgroundImageName = @"ListWorkOrderBackground";
    menu.circleIconImageName = @"ListWorkOrderCircleIcon";
    menu.title = kMenuListWorkOrder;
    menu.sort = 0;
    menu.menuType = kMenuTypeList;
    menu.menuTypeNext = kMenuTypeSubmenu;
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleSupervisor]];
    [menu.submenus addObjects:[self generateSubmenusWithRealm:realm menu:menu]];
    [realm addObject:menu];
    
    menu = [[Menu alloc] init];
    menu.imageName = @"OnlineSubmissionIcon";
    menu.title = kMenuOnlineSubmission;
    menu.sort = 10;
    menu.menuType = kMenuTypeSubmenu;
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [menu.submenus addObjects:[self generateSubmenusWithRealm:realm menu:menu]];
    [realm addObject:menu];
    
    menu = [[Menu alloc] init];
    menu.imageName = @"TrackingMarketingIcon";
    menu.title = kMenuTrackingMarketing;
    menu.sort = 11;
    menu.menuType = kMenuTypeList;
    menu.menuTypeNext = kMenuTypeMap;
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleSupervisor]];
    [realm addObject:menu];
    
    menu = [[Menu alloc] init];
    menu.imageName = @"CalculatorMarketingIcon";
    menu.title = kMenuCalculatorMarketing;
    menu.sort = 20;
    menu.menuType = kMenuTypeSubmenu;
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleSupervisor]];
    [menu.submenus addObjects:[self generateSubmenusWithRealm:realm menu:menu]];
    [realm addObject:menu];
    
    menu = [[Menu alloc] init];
    menu.imageName = @"ListMapIcon";
    menu.title = kMenuListMap;
    menu.sort = 30;
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleSupervisor]];
    [menu.submenus addObjects:[self generateSubmenusWithRealm:realm menu:menu]];
    [realm addObject:menu];
    
    menu = [[Menu alloc] init];
    menu.imageName = @"ListSurveyIcon";
    menu.title = kMenuListSurvey;
    menu.sort = 40;
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleSupervisor]];
    [menu.submenus addObjects:[self generateSubmenusWithRealm:realm menu:menu]];
    [realm addObject:menu];
    
    menu = [[Menu alloc] init];
    menu.imageName = @"DashboardIcon";
    menu.title = kMenuDashboard;
    menu.sort = 50;
    menu.menuType = kMenuTypeSubmenu;
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleSupervisor]];
    [menu.submenus addObjects:[self generateSubmenusWithRealm:realm menu:menu]];
    [realm addObject:menu];
    
    [realm commitWriteTransaction];
}

+ (NSMutableArray *)generateSubmenusWithRealm:(RLMRealm *)realm menu:(Menu *)menu{
    NSMutableArray *submenus = [NSMutableArray array];
    
    if ([menu.title isEqualToString:kMenuListWorkOrder]) {
        Menu *submenu = [[Menu alloc] init];
        submenu.imageName = @"ListPengajuanApplikasiSubmenuIcon";
        submenu.title = kSubmenuListPengajuanApplikasi;
        submenu.sort = 0;
        submenu.parentMenu = menu;
        submenu.menuType = kMenuTypeFormHorizontal;
        [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
        [realm addObject:submenu];
        [submenus addObject:submenu];
        
        submenu = [[Menu alloc] init];
        submenu.imageName = @"DataMAPSubmenuIcon";
        submenu.title = kSubmenuDataMAP;
        submenu.sort = 1;
        submenu.parentMenu = menu;
        submenu.menuType = kMenuTypeFormVertical;
        [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
        [realm addObject:submenu];
        [submenus addObject:submenu];
        
        submenu = [[Menu alloc] init];
        submenu.imageName = @"SurveySubmenuIcon";
        submenu.title = kSubmenuSurvey;
        submenu.sort = 2;
        submenu.parentMenu = menu;
        submenu.menuType = kMenuTypeFormHorizontal;
        [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
        [realm addObject:submenu];
        [submenus addObject:submenu];
        
        submenu = [[Menu alloc] init];
        submenu.imageName = @"";
        submenu.title = kSubmenuMelengkapiData;
        submenu.sort = 0;
        submenu.parentMenu = menu;
        [submenu.roles addObject:[Role objectForPrimaryKey:kRoleSupervisor]];
        [realm addObject:submenu];
        [submenus addObject:submenu];
        
        submenu = [[Menu alloc] init];
        submenu.imageName = @"";
        submenu.title = kSubmenuAssignMarketing;
        submenu.sort = 1;
        submenu.parentMenu = menu;
        [submenu.roles addObject:[Role objectForPrimaryKey:kRoleSupervisor]];
        [realm addObject:submenu];
        [submenus addObject:submenu];
    }
    
//    if ([menu.title isEqualToString:kMenuOnlineSubmission]) {
//        Menu *submenu = [[Menu alloc] init];
//        submenu.imageName = @"ListPengajuanApplikasiSubmenuIcon";
//        submenu.title = kSubmenuListPengajuanApplikasi;
//        submenu.sort = 0;
//        submenu.parentMenu = menu;
//        submenu.menuType = kMenuTypeFormHorizontal;
//        [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
//        [realm addObject:submenu];
//        [submenus addObject:submenu];
//        
//        submenu = [[Menu alloc] init];
//        submenu.imageName = @"";
//        submenu.title = kSubmenuD;
//        submenu.sort = 1;
//        submenu.parentMenu = menu;
//        submenu.menuType = kMenuTypeFormVertical;
//        [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
//        [realm addObject:submenu];
//        [submenus addObject:submenu];
//    }
    
    return submenus;
}

@end
