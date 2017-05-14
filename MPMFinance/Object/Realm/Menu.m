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
    menu.title = kMenuListWorkOrder;
    menu.sort = 0;
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [menu.submenus addObjects:[self generateSubmenusWithRealm:realm menu:menu]];
    [realm addObject:menu];
    
    menu = [[Menu alloc] init];
    menu.imageName = @"OnlineSubmissionIcon";
    menu.title = kMenuOnlineSubmission;
    menu.sort = 1;
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [realm addObject:menu];
    
    menu = [[Menu alloc] init];
    menu.imageName = @"CalculatorMarketingIcon";
    menu.title = kMenuCalculatorMarketing;
    menu.sort = 2;
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [realm addObject:menu];
    
    menu = [[Menu alloc] init];
    menu.imageName = @"ListMapIcon";
    menu.title = kMenuListMap;
    menu.sort = 3;
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [realm addObject:menu];
    
    menu = [[Menu alloc] init];
    menu.imageName = @"ListSurveyIcon";
    menu.title = kMenuListSurvey;
    menu.sort = 4;
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [realm addObject:menu];
    
    menu = [[Menu alloc] init];
    menu.imageName = @"DashboardIcon";
    menu.title = kMenuDashboard;
    menu.sort = 5;
    [menu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
    [realm addObject:menu];
    
    [realm commitWriteTransaction];
}

+ (NSMutableArray *)generateSubmenusWithRealm:(RLMRealm *)realm menu:(Menu *)menu{
    NSMutableArray *submenus = [NSMutableArray array];
    
    if ([menu.title isEqualToString:kMenuListWorkOrder]) {
        Menu *submenu = [[Menu alloc] init];
        submenu.imageName = @"";
        submenu.title = kSubmenuListPengajuanApplikasi;
        submenu.sort = 0;
        submenu.parentMenu = menu;
        [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
        [realm addObject:submenu];
        [submenus addObject:submenu];
        
        submenu = [[Menu alloc] init];
        submenu.imageName = @"";
        submenu.title = kSubmenuDataMAP;
        submenu.sort = 1;
        submenu.parentMenu = menu;
        [submenu.roles addObject:[Role objectForPrimaryKey:kRoleDedicated]];
        [realm addObject:submenu];
        [submenus addObject:submenu];
        
        submenu = [[Menu alloc] init];
        submenu.imageName = @"";
        submenu.title = kSubmenuSurvey;
        submenu.sort = 2;
        submenu.parentMenu = menu;
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
    
    return submenus;
}

@end
