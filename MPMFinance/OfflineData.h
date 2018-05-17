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
@property NSString *primaryKey; //noRegistrasi
@property NSData *data;
+ (void)save:(NSDictionary *)dict;
- (List *)convertToList;
@end
