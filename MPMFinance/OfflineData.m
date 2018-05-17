//
//  OfflineData.m
//  MPMFinance
//
//  Created by Romin Adi Santoso on 5/16/18.
//  Copyright © 2018 MPMFinance. All rights reserved.
//

#import "OfflineData.h"

@implementation OfflineData
+ (void)save:(NSDictionary *)dict {
    NSString *primary;
    if ([dict objectForKey:@"namaLengkap"]) {
        primary = dict[@"namaLengkap"];
    }
    NSData* data;
    data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];

    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    OfflineData *offline = [[OfflineData alloc] init];
    offline.primaryKey = primary;
    offline.data = data;
    [realm addObject:offline];
    [realm commitWriteTransaction];
}
- (List *)convertToList {
//    @property NSInteger primaryKey;
//    @property NSString *imageURL;
//    @property NSString *title;
//    @property NSString *date;
//    @property NSString *assignee;
//    @property NSString *status;
//    @property NSString *statusColor;
//    @property NSString *type;
    NSDictionary *content = [NSJSONSerialization JSONObjectWithData:self.data options:NSJSONWritingPrettyPrinted error:nil];
    List *list = [[List alloc] init];
    list.imageURL = @"";
    list.title = content[@"namaLengkap"];
    return list;
}
@end
