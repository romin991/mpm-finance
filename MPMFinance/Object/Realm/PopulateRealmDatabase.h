//
//  PopulateRealmDatabase.h
//  MPMFinance
//
//  Created by Rudy Suharyadi on 5/11/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PopulateRealmDatabase : NSObject

+ (void)removeAllData;
+ (void)generateData;

@end
