//
//  CustomerModel.h
//  MPMFinance
//
//  Created by Rudy Suharyadi on 6/28/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Data.h"

@interface CustomerModel : NSObject

//pengajuan/getNoKontrak
+ (void)getListContractNumberWithCompletion:(void(^)(NSArray *datas, NSError *error))block;

@end
