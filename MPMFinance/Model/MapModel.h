//
//  MapModel.h
//  MPMFinance
//
//  Created by Rudy Suharyadi on 24/06/18.
//  Copyright © 2018 MPMFinance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>

@interface MapModel : NSObject

+ (void)fetchPolylineWithOrigin:(CLLocation *)origin destination:(CLLocation *)destination completionHandler:(void (^)(GMSPolyline *polyLine, NSError *error))block;

@end
