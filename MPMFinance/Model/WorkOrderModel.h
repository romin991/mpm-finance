//
//  WorkOrderModel.h
//  MPMFinance
//
//  Created by Rudy Suharyadi on 6/7/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "List.h"

@interface WorkOrderModel : NSObject

+ (void)getListWorkOrderWithPage:(NSInteger)page completion:(void(^)(NSArray *lists, NSError *error))block;
+ (void)getListWorkOrderDetailWithID:(NSInteger)pengajuanId completion:(void(^)(NSDictionary *response, NSError *error))block;
+ (void)postListWorkOrder:(List *)list dictionary:(NSDictionary *)dictionary completion:(void(^)(NSDictionary *dictionary, NSError *error))block;

@end
