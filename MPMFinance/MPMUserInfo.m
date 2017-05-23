//
//  MPMUserInfo.m
//  MPMFinance
//
//  Created by Romin Adi Santoso on 5/10/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "MPMUserInfo.h"

@implementation MPMUserInfo
+(NSDictionary*)getUserInfo
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    NSDictionary *dictionary = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return dictionary[@"customerProfile"];
}
+(void)save:(NSDictionary *)dictionary
{
    NSData *dataSave = [NSKeyedArchiver archivedDataWithRootObject:dictionary];
    [[NSUserDefaults standardUserDefaults] setObject:dataSave forKey:@"userInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(void)deleteUserInfo
{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"userInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

+(NSInteger)getGroupLevel
{
    NSDictionary* userInfo = [MPMUserInfo getUserInfo];
    return [userInfo[@"groupLevel"] integerValue];
}
@end
