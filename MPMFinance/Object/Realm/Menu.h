//
//  Menu.h
//  MPMFinance
//
//  Created by Rudy Suharyadi on 5/11/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import <Realm/Realm.h>
#import "Role.h"

@interface Menu : RLMObject

@property NSString *imageName;
@property NSString *title;
@property int type;

@property RLMArray<Role> *roles;

+ (RLMResults *)getMenuForRole:(NSString *)roleName;
+ (void)generateMenus;

@end
