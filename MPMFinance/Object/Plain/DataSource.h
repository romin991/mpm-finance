//
//  DataSource.h
//  MPMFinance
//
//  Created by Rudy Suharyadi on 6/26/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kDataSourceTypeAll;
extern NSString *const kDataSourceTypeNeedApproval;
extern NSString *const kDataSourceTypeBadUsers;
extern NSString *const kDataSourceTypeSupervisorNew;
extern NSString *const kDataSourceTypeSupervisorBadUsers;

@interface DataSource : NSObject

@property NSString *name;
@property NSString *type;
@property NSString *methodName;
@property NSString *actionName;

@end
