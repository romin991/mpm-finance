//
//  OfflineData.m
//  MPMFinance
//
//  Created by Romin Adi Santoso on 5/16/18.
//  Copyright © 2018 MPMFinance. All rights reserved.
//

#import "OfflineData.h"

@implementation OfflineData
- (void)save:(NSDictionary *)dict {
    NSString *primary;
    if ([dict objectForKey:@"noRegistrasi"]) {
        primary = dict[@"noRegistrasi"];
    }
    NSData* data;
    data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];

    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    OfflineData *offline = [[OfflineData alloc] init];
    offline.primaryKey = primary;
    offline.data = data;
    [realm commitWriteTransaction];
}
@end
