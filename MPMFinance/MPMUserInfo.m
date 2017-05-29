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
+(NSString*)getToken
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    NSDictionary *dictionary = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSLog(@"%@",dictionary[@"token"]);
    return dictionary[@"token"];
    
}
+(void)save:(NSDictionary *)dictionary
{
    NSData *dataSave = [NSKeyedArchiver archivedDataWithRootObject:dictionary];
    [[NSUserDefaults standardUserDefaults] setObject:dataSave forKey:@"userInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //need notify these UI to be refreshed :
    //-HomeViewcontroller
    //-...
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UserLoginNotification" object:nil];
}
+(void)deleteUserInfo
{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"userInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UserLoginNotification" object:nil];
}

/*
2	customer

3	agent

4	dealer

5	marketing officer

6	marketing dedicated

7	marketing spv
*/
+(NSInteger)getGroupLevel
{
    NSDictionary* userInfo = [MPMUserInfo getUserInfo];
    return [userInfo[@"groupLevel"] integerValue];
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////                     CONTENT OF USER INFO                                /////////////////

//customerProfile =         {
//    address = alamat;
//    "dealer_address" = "";
//    "dealer_name" = "";
//    deviceId = "fcmid here";
//    dob = "2017-05-26";
//    email = "hahaha@coba.com";
//    gender = male;
//    groupLevel = 2;
//    id = 21;
//    isActive = 1;
//    kode = bbbbb;
//    ktp = 12345123;
//    lastLogin = "2017-05-26 22:49:46";
//    loginFrom = mobile;
//    lup = "2017-05-26 15:45:42";
//    password = "";
//    phone = 088362;
//    photo = "http://oms-api.infomedia-platform.com/mpmfinance/profile/getimage/hadi.jpg";
//    placeOfBirth = jakarta;
//    userId = hadi;
//    username = "jangan dihapus";
//};
//token = "eyJraWQiOiIxIiwiYWxnIjoiUlMyNTYifQ.eyJpc3MiOiJnYXJ1ZGFhcGkiLCJleHAiOjE0OTU4MTEyMzcsImp0aSI6ImM2My1ldU5nMzg0N2JmeldHYzIyX3ciLCJpYXQiOjE0OTU4MTA5MzcsIm5iZiI6MTQ5NTgxMDg3Nywic3ViIjoidGVtcGxhdGUiLCJyb2xlcyI6WyJST0xFX1VTRVIiXX0.f5FH_bbIwsx-ZsNMFGNV9ezKoNeVb68oTwhs2jBUZrVBSewdfMnCTHNNpYAU1l_nKe5B2w90zzQhi4vrhaIIx-q1E4q7dqBHykm8Qatd2NaRnTdOq0dO9eJpT4inI09p8oCKpoXjLHq1F0RF-mucbgvZgFpJOXR54sNtlaxcAsLR_qwcOGO-N-ovsEoUUwvPvmIcss9UxyRlMLEgUE3qiiCu6sfmGPR6cZBmL58hWXY_KtX3HshwRphUYZVGJLVlyUjk3j9Z_iG6ntiMcKjRI1SHdgyLz-_R9tp69JGYVJH8kVmMJU8Yf1DNLLOYF67Wn00ROr0LR5Um_0MqJdY59g";
//};

///////////////////////////////////////////////////////////////////////////////////////////////////////////
@end
