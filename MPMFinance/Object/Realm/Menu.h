//
//  Menu.h
//  MPMFinance
//
//  Created by Rudy Suharyadi on 5/11/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import <Realm/Realm.h>
#import "Role.h"

RLM_ARRAY_TYPE(Menu)
@interface Menu : RLMObject

@property NSString *imageName;
@property NSString *backgroundImageName;
@property NSString *circleIconImageName;
@property NSString *title;
@property NSInteger sort;
@property NSString *menuType;
@property BOOL isRootMenu;

@property RLMArray<Role> *roles;
@property RLMArray<Menu> *submenus;

+ (RLMResults *)getMenuForRole:(NSString *)roleName;
+ (RLMResults *)getSubmenuForMenu:(NSString *)menuTitle role:(NSString *)roleName;
+ (void)generateMenus;

@end
