//
//  OfflineDataManager.m
//  MPMFinance
//
//  Created by Romin Adi Santoso on 5/17/18.
//  Copyright © 2018 MPMFinance. All rights reserved.
//

#import "OfflineDataManager.h"

@implementation OfflineDataManager
+ (NSArray *)loadAllOfflineSubmission {
    RLMResults *result =  [OfflineData allObjects];
    if (result.count > 0) {
        return [result valueForKey:@"self"];
    } else {
        return nil;
    }
}
@end
