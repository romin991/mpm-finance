//
//  DetailTrackingAnnotation.m
//  MPMFinance
//
//  Created by Romin Adi Santoso on 5/25/18.
//  Copyright © 2018 MPMFinance. All rights reserved.
//

#import "DetailTrackingAnnotation.h"

@implementation DetailTrackingAnnotation

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    self = [super init];
    if(self) {
        self.coordinate = coordinate;
    
    }
    return self;
}
@end
