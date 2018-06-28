//
//  PostalCodeValueTransformer.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 7/9/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "PostalCodeValueTransformer.h"
#import "PostalCode.h"
#import <XLForm.h>

@implementation PostalCodeValueTransformer

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
    if ([value isKindOfClass:PostalCode.class]) {
        PostalCode *postalCode = (PostalCode *)value;
        return [NSString stringWithFormat:@"%@", postalCode.disctrict];
    }
    if ([value isKindOfClass:XLFormOptionsObject.class]) {
        XLFormOptionsObject *object = (XLFormOptionsObject *)value;
        return [NSString stringWithFormat:@"%@", object.displayText];
    }
    return value;
}

@end
