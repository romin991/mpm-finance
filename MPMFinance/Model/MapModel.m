//
//  MapModel.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 24/06/18.
//  Copyright © 2018 MPMFinance. All rights reserved.
//

#import "MapModel.h"

@implementation MapModel

+ (void)fetchPolylineWithOrigin:(CLLocation *)origin destination:(CLLocation *)destination completionHandler:(void (^)(GMSPolyline *polyLine, NSError *error))block{
    NSString *originString = [NSString stringWithFormat:@"%f,%f", origin.coordinate.latitude, origin.coordinate.longitude];
    NSString *destinationString = [NSString stringWithFormat:@"%f,%f", destination.coordinate.latitude, destination.coordinate.longitude];
    NSString *directionsAPI = @"https://maps.googleapis.com/maps/api/directions/json";
    NSDictionary *params = @{@"origin" : originString,
                             @"destination" : destinationString,
                             @"key" : kAPIKey,
                             };
    
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    [manager GET:directionsAPI parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @try {
            NSArray *routesArray = [responseObject objectForKey:@"routes"];
            
            GMSPolyline *polyline = nil;
            if ([routesArray count] > 0)
            {
                NSDictionary *routeDict = [routesArray objectAtIndex:0];
                NSDictionary *routeOverviewPolyline = [routeDict objectForKey:@"overview_polyline"];
                NSString *points = [routeOverviewPolyline objectForKey:@"points"];
                GMSPath *path = [GMSPath pathFromEncodedPath:points];
                polyline = [GMSPolyline polylineWithPath:path];
            }
            
            if(block) block(polyline, nil);
            
        } @catch (NSException *exception) {
            NSLog(@"%@", exception);
            if (block) block(nil, [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier]
                                                      code:1
                                                  userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(exception.reason, nil)}]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString *errorMessage = error.localizedDescription;
        if (block) block(nil, [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier]
                                                  code:1
                                              userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(errorMessage, nil)}]);
    }];
}

@end
