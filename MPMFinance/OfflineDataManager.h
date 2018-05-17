//
//  OfflineDataManager.h
//  MPMFinance
//
//  Created by Romin Adi Santoso on 5/17/18.
//  Copyright © 2018 MPMFinance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OfflineData.h"
@interface OfflineDataManager : NSObject
+ (NSArray *)loadOfflineSubmission:(NSString* )param;
+ (NSArray *)loadAllOfflineSubmission;
@end
