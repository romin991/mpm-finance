//
//  List.h
//  MPMFinance
//
//  Created by Rudy Suharyadi on 5/16/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface List : NSObject

@property NSInteger primaryKey;
@property NSString * guid;
@property NSString *imageURL;
@property NSString *title;
@property NSString *date;
@property NSString *assignee;
@property NSString *groupLevel;
@property NSString *status;
@property NSString *statusColor;
@property NSString *type;

@end
