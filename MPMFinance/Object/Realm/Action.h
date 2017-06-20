//
//  Action.h
//  MPMFinance
//
//  Created by Rudy Suharyadi on 5/25/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import <Realm/Realm.h>
#import "Role.h"

@interface Action : RLMObject

@property NSString *name;
@property NSString *actionType;
@property NSString *methodName;
@property RLMArray<Role> *roles;

@end
RLM_ARRAY_TYPE(Action)
