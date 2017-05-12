//
//  RoleRealm.h
//  MPMFinance
//
//  Created by Rudy Suharyadi on 5/12/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import <Realm/Realm.h>

@interface Role : RLMObject

@property NSString *name;

+ (void)generateRoles;

@end
RLM_ARRAY_TYPE(Role)
