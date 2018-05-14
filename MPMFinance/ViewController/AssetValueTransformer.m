//
//  AssetValueTransformer.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 7/10/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "AssetValueTransformer.h"
#import "Asset.h"

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
    Asset *asset = (Asset *)value;
    if (asset.value.length < 1) {
        return @"";
    } else{
        return [NSString stringWithFormat:@"%@", asset.value];
    }
}

@end
