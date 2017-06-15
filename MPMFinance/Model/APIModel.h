//
//  APIModel.h
//  MPMFinance
//
//  Created by Rudy Suharyadi on 5/25/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "List.h"

@interface APIModel : NSObject

+ (void)getListWorkOrderPage:(NSInteger)page completion:(void(^)(NSArray *lists, NSError *error))block;
+ (void)getListSurvey:(void(^)(NSArray *lists, NSError *error))block;
+ (void)getListMapDraft:(void(^)(NSArray *lists, NSError *error))block;
+ (void)getListPengembalianBPKB:(void(^)(NSArray *lists, NSError *error))block;

@end
