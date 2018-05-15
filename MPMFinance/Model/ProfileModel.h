//
//  ProfileModel.h
//  MPMFinance
//
//  Created by Rudy Suharyadi on 6/15/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProfileModel : NSObject

+ (void)checkTokenWithCompletion:(void (^)(BOOL isExpired))block;
+ (void)getProfileDataWithCompletion:(void(^)(NSDictionary *dictionary, NSError *error))block;
+ (void)login:(NSString *)username password:(NSString *)password completion:(void(^)(NSDictionary *dictionary, NSError *error))block;
+ (void)changePassword:(NSString *)oldPassword password:(NSString *)password completion:(void(^)(NSDictionary *dictionary, NSError *error))block;

@end
