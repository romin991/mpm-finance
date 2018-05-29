//
//  SurveyModel.h
//  MPMFinance
//
//  Created by Rudy Suharyadi on 6/7/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "List.h"

@interface SurveyModel : NSObject

+ (void)getSurveyWithID:(NSInteger)pengajuanId completion:(void(^)(NSDictionary *dictionary, NSError *error))block;
+ (void)postSurveyWithList:(List *)list dictionary:(NSDictionary *)dictionary completion:(void(^)(NSDictionary *dictionary, NSError *error))block;
+ (void)postSurveyWithID:(NSInteger)pengajuanId completion:(void(^)(NSDictionary *dictionary, NSError *error))block;

@end
