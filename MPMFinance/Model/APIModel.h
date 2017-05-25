//
//  APIModel.h
//  MPMFinance
//
//  Created by Rudy Suharyadi on 5/25/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIModel : NSObject

+ (void)getListWorkOrder:(void(^)(NSArray *lists, NSError *error))block;

@end
