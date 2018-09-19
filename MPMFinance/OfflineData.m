//
//  OfflineData.m
//  MPMFinance
//
//  Created by Romin Adi Santoso on 5/16/18.
//  Copyright © 2018 MPMFinance. All rights reserved.
//

#import "OfflineData.h"

@implementation OfflineData
+ (void)save:(NSDictionary *)dict into:(NSString*)primary withRemoteId:(NSInteger)remoteId {
    NSData* data;
    data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];

  
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
  OfflineData *offline = primary? [OfflineData searchOfflineData:primary] :  [[OfflineData alloc] init];
  if (!offline) {
    offline = [[OfflineData alloc] init];
    offline.primaryKey = primary;
    offline.userId = [MPMUserInfo getUserInfo][@"userId"];
  }
    offline.data = data;
  if (remoteId > 0) {
    offline.remoteId = remoteId;
  }
    [realm addOrUpdateObject:offline];
    [realm commitWriteTransaction];
  [realm refresh];
}
+(NSString *)primaryKey {
  return @"primaryKey";
}


+ (OfflineData *)searchOfflineData:(NSString *)primaryKey {
  OfflineData *offlineData;
  if (primaryKey != nil && ![primaryKey isEqualToString:@""]){
    RLMResults *array = [OfflineData objectsWhere:@"primaryKey = %@", primaryKey];
    if(array.count > 0) {
      offlineData = [array firstObject];
    }
  }
  return offlineData;
}
+ (OfflineData *)getById:(NSInteger *)remoteId {
  OfflineData *offlineData;
  if (remoteId != nil && remoteId != 0){
    RLMResults *array = [OfflineData objectsWhere:@"remoteId = %i", remoteId];
    if(array.count > 0) {
      offlineData = [array firstObject];
    }
  }
  return offlineData;
}


+ (NSDictionary *)defaultPropertyValues {
  NSString *guid = [[NSUUID UUID] UUIDString];
  
  return @{@"primaryKey" : guid
           };
}

+ (void)deleteOfflineData:(OfflineData *)data {
  if (!data) {
    return;
  }
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm deleteObject:data];
    [realm commitWriteTransaction];
}
+ (void)deleteAll {
  RLMResults *results = [OfflineData objectsWhere:@"userId != %@",[MPMUserInfo getUserInfo][@"userId"]];
  
  RLMRealm *realm = [RLMRealm defaultRealm];
  [realm beginWriteTransaction];
  if (results.count > 0) {
    [realm deleteObjects:results];
  }
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
    list.status = @"Offline";
    list.statusColor = @"blue";
  list.guid = self.primaryKey;
  list.primaryKey = self.remoteId;
    return list;
}
- (NSDictionary *)getDataDictionary {
    NSDictionary *content = [NSJSONSerialization JSONObjectWithData:self.data options:NSJSONWritingPrettyPrinted error:nil];
    return content;
}
@end
