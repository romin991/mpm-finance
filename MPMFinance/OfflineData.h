//
//  OfflineData.h
//  MPMFinance
//
//  Created by Romin Adi Santoso on 5/16/18.
//  Copyright © 2018 MPMFinance. All rights reserved.
//

#import <Realm.h>
#import "List.h"
@interface OfflineData : RLMObject
@property NSInteger remoteId;
@property NSString *userId;
@property NSString *primaryKey; //local id (increment)
@property NSData *data;
@property NSDate *saveDate;
- (NSDictionary *)getDataDictionary;
+ (void)save:(NSDictionary *)dict into:(NSString*)primary withRemoteId:(NSInteger)remoteId;
- (List *)convertToList;
+ (OfflineData *)searchOfflineData:(NSString *)primaryKey;
+ (OfflineData *)getById:(NSInteger *)remoteId;
+ (void) deleteAll;
+ (void)deleteOfflineData:(OfflineData *)data;
@end
