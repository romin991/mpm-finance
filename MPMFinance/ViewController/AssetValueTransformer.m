//
//  AssetValueTransformer.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 7/10/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "AssetValueTransformer.h"
#import "Asset.h"
#import <XLForm.h>

@implementation AssetValueTransformer

+ (Class)transformedValueClass
{
    return [NSString class];
}

+ (BOOL)allowsReverseTransformation
{
    return NO;
}

- (id)transformedValue:(id)value
{
    if (!value) return nil;
    if ([value isKindOfClass:Asset.class]) {
        Asset *asset = (Asset *)value;
        return [NSString stringWithFormat:@"%@", asset.name];
    }
    if ([value isKindOfClass:XLFormOptionsObject.class]) {
        XLFormOptionsObject *object = (XLFormOptionsObject *)value;
        return [NSString stringWithFormat:@"%@", object.displayText];
    }
    return value;
}

@end
