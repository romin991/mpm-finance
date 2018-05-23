//
//  MPMCustomUI.m
//  MPMFinance
//
//  Created by Romin Adi Santoso on 5/23/18.
//  Copyright © 2018 MPMFinance. All rights reserved.
//

#import "MPMCustomUI.h"

@implementation MPMCustomUI
+ (UIView *)giveBorderTo:(UIView *)view{
    return [self giveBorderTo:view withBorderColor:view.backgroundColor withCornerRadius:5 withRoundingCorners:UIRectCornerAllCorners withBorderWidth:1.0];
}

+ (UIView *)giveBorderTo:(UIView *)view withBorderColor:(UIColor *)borderColor{
    return [self giveBorderTo:view withBorderColor:borderColor withCornerRadius:5 withRoundingCorners:UIRectCornerAllCorners withBorderWidth:1.0];
}

+ (UIView *)giveBorderTo:(UIView *)view withBorderColor:(UIColor *)borderColor withRoundingCorners:(UIRectCorner)corners withSideBorder:(MOSideBorder)sideBorders{
    return [self giveBorderTo:view withBorderColor:borderColor withCornerRadius:5 withRoundingCorners:corners withBorderWidth:1.0 withSideBorder:sideBorders];
}

+ (UIView *)giveBorderTo:(UIView *)view withBorderColor:(UIColor *)borderColor withRoundingCorners:(UIRectCorner)corners{
    return [self giveBorderTo:view withBorderColor:borderColor withCornerRadius:5 withRoundingCorners:corners withBorderWidth:1.0];
}

+ (UIView *)giveBorderTo:(UIView *)view withBorderWidth:(CGFloat)borderWidth{
    return [self giveBorderTo:view withBorderColor:view.backgroundColor withCornerRadius:5 withRoundingCorners:UIRectCornerAllCorners withBorderWidth:borderWidth];
}

+ (UIView *)giveBorderTo:(UIView *)view withCornerRadius:(CGFloat)cornerRadius{
    return [self giveBorderTo:view withBorderColor:view.backgroundColor withCornerRadius:cornerRadius withRoundingCorners:UIRectCornerAllCorners withBorderWidth:1.0];
}

+ (UIView *)giveBorderTo:(UIView *)view withCornerRadius:(CGFloat)cornerRadius withBorderWidth:(CGFloat)borderWidth{
    return [self giveBorderTo:view withBorderColor:view.backgroundColor withCornerRadius:cornerRadius withRoundingCorners:UIRectCornerAllCorners withBorderWidth:borderWidth];
}

+ (UIView *)giveBorderTo:(UIView *)view withBorderColor:(UIColor *)borderColor withBorderWidth:(CGFloat)borderWidth withCornerRadius:(CGFloat)cornerRadius{
    return [self giveBorderTo:view withBorderColor:borderColor withCornerRadius:cornerRadius withRoundingCorners:UIRectCornerAllCorners withBorderWidth:borderWidth];
}

+ (UIView *)giveBorderTo:(UIView *)view withBorderColor:(UIColor *)borderColor withCornerRadius:(CGFloat)cornerRadius{
    return [self giveBorderTo:view withBorderColor:borderColor withCornerRadius:cornerRadius withRoundingCorners:UIRectCornerAllCorners withBorderWidth:1.0];
}

+ (UIView *)giveBorderTo:(UIView *)view withBorderColor:(UIColor *)borderColor withCornerRadius:(CGFloat)cornerRadius withRoundingCorners:(UIRectCorner)corners{
    return [self giveBorderTo:view withBorderColor:borderColor withCornerRadius:cornerRadius withRoundingCorners:corners withBorderWidth:1.0];
}

+ (UIView *)giveBorderTo:(UIView *)view withBorderColor:(UIColor *)borderColor withCornerRadius:(CGFloat)cornerRadius withRoundingCorners:(UIRectCorner)corners withBorderWidth:(CGFloat)borderWidth{
    return [self giveBorderTo:view withBorderColor:borderColor withCornerRadius:cornerRadius withRoundingCorners:corners withBorderWidth:borderWidth withSideBorder:MOSideBorderAll];
}

+ (UIView *)giveBorderTo:(UIView *)view withBorderColor:(UIColor *)borderColor withCornerRadius:(CGFloat)cornerRadius withRoundingCorners:(UIRectCorner)corners withBorderWidth:(CGFloat)borderWidth withSideBorder:(MOSideBorder)sideBorders{
    if (corners == UIRectCornerAllCorners && sideBorders == MOSideBorderAll){
        [view.layer setMasksToBounds:YES];
        [view.layer setCornerRadius:cornerRadius];
        [view.layer setBorderWidth:borderWidth];
        [view.layer setBorderColor:[borderColor CGColor]];
        CAShapeLayer *oldLayer = [view.layer valueForKey:@"CustomLayer"];
        if (oldLayer) [oldLayer removeFromSuperlayer];
        
    } else {
        Boolean left = false;
        Boolean right = false;
        Boolean top = false;
        Boolean bottom = false;
        
        if ((sideBorders & MOSideBorderLeft) == MOSideBorderLeft) left = true;
        if ((sideBorders & MOSideBorderTop) == MOSideBorderTop) top = true;
        if ((sideBorders & MOSideBorderRight) == MOSideBorderRight) right = true;
        if ((sideBorders & MOSideBorderBottom) == MOSideBorderBottom) bottom = true;
        if ((sideBorders & MOSideBorderAll) == MOSideBorderAll) left = top = right = bottom = true;
        
        if ((corners & UIRectCornerBottomLeft) == UIRectCornerBottomLeft) left = bottom = true;
        if ((corners & UIRectCornerBottomRight) == UIRectCornerBottomRight) right = bottom = true;
        if ((corners & UIRectCornerTopLeft) == UIRectCornerTopLeft) left = top = true;
        if ((corners & UIRectCornerTopRight) == UIRectCornerTopRight) right = top = true;
        
        CGFloat x = view.bounds.origin.x - borderWidth / 2;
        CGFloat y = view.bounds.origin.y - borderWidth / 2;
        CGFloat width = view.bounds.size.width + borderWidth;
        CGFloat height = view.bounds.size.height + borderWidth;
        
        if (left) {
            x += borderWidth;
            width -= borderWidth;
        }
        if (top) {
            y += borderWidth;
            height -= borderWidth;
        }
        if (right) {
            width -= borderWidth;
        }
        if (bottom) {
            height -= borderWidth;
        }
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds
                                                       byRoundingCorners:corners
                                                             cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
        
        UIBezierPath *borderPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(x, y, width, height)
                                                         byRoundingCorners:corners
                                                               cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
        
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = view.bounds;
        maskLayer.path = maskPath.CGPath;
        
        CAShapeLayer *borderLayer = [CAShapeLayer layer];
        borderLayer.frame = view.bounds;
        borderLayer.path = borderPath.CGPath;
        borderLayer.strokeColor = [borderColor CGColor];
        borderLayer.lineWidth = borderWidth;
        borderLayer.fillColor = [[UIColor clearColor] CGColor];
        borderLayer.shadowRadius = 5;
        borderLayer.shadowColor = [borderColor CGColor];
        
        CAShapeLayer *oldLayer = [view.layer valueForKey:@"CustomLayer"];
        if (oldLayer) [oldLayer removeFromSuperlayer];
        
        [view.layer setCornerRadius:0];
        [view.layer setBorderWidth:0];
        [view.layer addSublayer:borderLayer];
        [view.layer setValue:borderLayer forKey:@"CustomLayer"];
        [view.layer setMask:maskLayer];
        [view.layer setMasksToBounds:YES];
    }
    [view.layer setShouldRasterize:YES];
    [view.layer setRasterizationScale:[UIScreen mainScreen].scale];
    return view;
}

@end
