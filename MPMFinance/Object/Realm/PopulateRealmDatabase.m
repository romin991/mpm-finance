//
//  PopulateRealmDatabase.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 5/11/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "PopulateRealmDatabase.h"
#import "Menu.h"
#import "Role.h"
#import <Realm/Realm.h>

@implementation PopulateRealmDatabase

+ (void)removeAllData{
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm deleteObjects:[Menu allObjects]];
    [realm deleteObjects:[Role allObjects]];
    [realm commitWriteTransaction];
}

+ (void)generateData{
    [Role generateRoles];
    [Menu generateMenus];
}

@end
