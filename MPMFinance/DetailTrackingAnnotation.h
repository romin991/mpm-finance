//
//  DetailTrackingAnnotation.h
//  MPMFinance
//
//  Created by Romin Adi Santoso on 5/25/18.
//  Copyright © 2018 MPMFinance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface DetailTrackingAnnotation : MKAnnotationView
@property NSNumber *number;
@property NSString *address;
@property CLLocationCoordinate2D coordinate;
- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;
@end
