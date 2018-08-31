//
//  MPMUserInfo.h
//  MPMFinance
//
//  Created by Romin Adi Santoso on 5/10/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPMUserInfo : NSObject

+ (BOOL)isLoggedIn;
+ (NSDictionary *)getUserInfo;
+ (void)deleteUserInfo;
+ (void)save:(NSDictionary *)dictionary;
+ (void)savePassword:(NSString *)password;
+(NSString *)getPassword;
+ (NSString *)getToken;
+ (NSString *)getRole;
+ (NSString *)getIdCabang;

@end
