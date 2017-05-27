//
//  MPMUserInfo.h
//  MPMFinance
//
//  Created by Romin Adi Santoso on 5/10/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPMUserInfo : NSObject
+(NSDictionary*)getUserInfo;
+(void)deleteUserInfo;
+(void)save:(NSDictionary*)dictionary;
+(NSInteger)getGroupLevel;
+(NSString*)getToken;
@end
