//
//  Menu.h
//  MPMFinance
//
//  Created by Rudy Suharyadi on 5/11/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import <Realm/Realm.h>
#import "Role.h"
#import "Action.h"

RLM_ARRAY_TYPE(Menu)
@interface Menu : RLMObject

@property NSString *primaryKey;
@property NSString *indonesiaTitle;
@property NSString *englishTitle;
@property (nonatomic) NSString *title;

@property NSString *imageName; //for root menu
@property NSString *backgroundImageName; //for menuType submenu (parent)
@property NSString *circleIconImageName; //for menuType submenu (parent)
@property NSString *borderColor; //for menuType submenu (child)
@property NSInteger sort;
@property NSString *menuType;
@property BOOL isRootMenu;
@property BOOL isOnePageOnly; //for menuType list (paginate)
@property Action *rightButtonAction; //for menuType list

@property RLMArray<Role> *roles;
@property RLMArray<Menu> *submenus;
@property RLMArray<Action> *actions; //for menuType list
@property RLMArray<Action> *dataSources; //for menuType list
+ (Menu *)getMenuForPrimaryKey:(NSString *)primaryKey;
+ (RLMResults *)getMenuForRole:(NSString *)role;
+ (RLMResults *)getSubmenuForMenu:(NSString *)primaryKey role:(NSString *)role;
+ (RLMResults *)getDataSourcesForMenu:(NSString *)primaryKey role:(NSString *)role;
+ (void)generateMenus;

@end
