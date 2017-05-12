//
//  RoleRealm.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 5/12/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "Role.h"

@implementation Role

+ (NSString *)primaryKey {
    return @"name";
}

#pragma mark - Populate Data
+ (void)generateRoles{
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm addObject:[self createRoleWithName:kRoleCustomer]];
    [realm addObject:[self createRoleWithName:kRoleAgent]];
    [realm addObject:[self createRoleWithName:kRoleDealer]];
    [realm addObject:[self createRoleWithName:kRoleSupervisor]];
    [realm addObject:[self createRoleWithName:kRoleOfficer]];
    [realm addObject:[self createRoleWithName:kRoleDedicated]];
    [realm commitWriteTransaction];
}

+ (Role *)createRoleWithName:(NSString *)roleName{
    Role *role = [[Role alloc] init];
    role.name = roleName;
    
    return role;
}

@end
