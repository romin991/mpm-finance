//
//  DropdownValueTransformer.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 23/05/18.
//  Copyright © 2018 MPMFinance. All rights reserved.
//

#import "DropdownValueTransformer.h"
#import <XLForm.h>
#import "Data.h"

@implementation DropdownValueTransformer

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
    if ([value isKindOfClass:Data.class]) {
        Data *data = (Data *)value;
        return [NSString stringWithFormat:@"%@", data.name];
    }
    if ([value isKindOfClass:XLFormOptionsObject.class]) {
        XLFormOptionsObject *object = (XLFormOptionsObject *)value;
        return [NSString stringWithFormat:@"%@", object.displayText];
    }
    return value;
}

@end
