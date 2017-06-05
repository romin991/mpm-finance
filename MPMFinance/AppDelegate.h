//
//  AppDelegate.h
//  MPMFinance
//
//  Created by Rudy Suharyadi on 5/10/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CLLocationManager *locationManager;
- (BOOL)isLocationServiceEnabled;
- (void)checkLocationService;
+ (AppDelegate *)get;
@end

