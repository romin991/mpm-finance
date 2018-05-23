//
//  MPMCustomUI.h
//  MPMFinance
//
//  Created by Romin Adi Santoso on 5/23/18.
//  Copyright © 2018 MPMFinance. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_OPTIONS(NSUInteger, MOSideBorder) {
    MOSideBorderLeft     = 1 << 0,
    MOSideBorderTop    = 1 << 1,
    MOSideBorderRight  = 1 << 2,
    MOSideBorderBottom = 1 << 3,
    MOSideBorderAll  = ~0UL
};
@interface MPMCustomUI : NSObject
+ (UIView *)giveBorderTo:(UIView *)view;
+ (UIView *)giveBorderTo:(UIView *)view withBorderColor:(UIColor *)borderColor;
@end
