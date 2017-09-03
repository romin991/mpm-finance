//
//  SuggestionComplaintModel.h
//  MPMFinance
//
//  Created by Rudy Suharyadi on 7/5/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SuggestionComplaintModel : NSObject

//mpmapi/profilecustomerinfo
+ (void)getProfileDataWithAgreementNo:(NSString *)agreementNo completion:(void(^)(NSDictionary *dictionary, NSError *error))block;
+ (void)postSuggestionWithDictionary:(NSDictionary *)dictionary completion:(void(^)(NSDictionary *dictionary, NSError *error))block;
+ (void)postComplainWithDictionary:(NSDictionary *)dictionary completion:(void(^)(NSDictionary *dictionary, NSError *error))block;
+ (void)getListSuggestionCompletion:(void(^)(NSArray *responses, NSError *error))block;
+ (void)getListComplainCompletion:(void(^)(NSArray *responses, NSError *error))block;

@end
