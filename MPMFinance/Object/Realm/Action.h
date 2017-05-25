//
//  Action.h
//  MPMFinance
//
//  Created by Rudy Suharyadi on 5/25/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import <Realm/Realm.h>

@interface Action : RLMObject

@property NSString *name;
@property NSString *actionType;
@property NSString *methodName;
@property NSString *className; //jika diperlukan

@end
RLM_ARRAY_TYPE(Action)
