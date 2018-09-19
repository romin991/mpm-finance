//
//  TrackingViewController.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 24/06/18.
//  Copyright © 2018 MPMFinance. All rights reserved.
//

#import "TrackingViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "APIModel.h"
#import "MapModel.h"

@interface TrackingViewController ()<CLLocationManagerDelegate, GMSMapViewDelegate>

@property GMSMapView *mapView;
@property GMSCameraPosition *camera;
@property CLLocationManager *locationManager;
@property CLLocation *currentLocation;

@end

@implementation TrackingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Tracking Officer";
    
    self.camera = [GMSCameraPosition cameraWithLatitude:0 longitude:0
                                                                 zoom:0];
    self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:self.camera];
    self.mapView.myLocationEnabled = YES;
    self.mapView.delegate = self;
    self.view = self.mapView;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD show];
    [APIModel getAllMarketingWithCompletion:^(NSArray *data, NSError *error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
            [SVProgressHUD dismissWithDelay:1.5 completion:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
        } else {
            [SVProgressHUD dismiss];
            for (NSDictionary *datum in data) {
                GMSMarker *marker = [[GMSMarker alloc] init];
                marker.position = CLLocationCoordinate2DMake([datum[@"lat"] doubleValue], [datum[@"lng"] doubleValue]);
                marker.title = datum[@"fullName"];
                marker.snippet = datum[@"userid"];
                marker.map = weakSelf.mapView;
              marker.userData = datum;
            }
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    self.currentLocation = locations.lastObject;
    self.camera = [GMSCameraPosition cameraWithLatitude:self.currentLocation.coordinate.latitude
                                              longitude:self.currentLocation.coordinate.longitude
                                                   zoom:17];
    [self.mapView animateToCameraPosition:self.camera];
    [self.locationManager stopUpdatingLocation];
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker{
    CLLocationCoordinate2D location = marker.position;
    GMSGeocoder *geocoder = [GMSGeocoder geocoder];
    [geocoder reverseGeocodeCoordinate:location completionHandler:^(GMSReverseGeocodeResponse * _Nullable response, NSError * _Nullable error) {
        GMSAddress *address = response.firstResult;
        marker.snippet = [address.lines componentsJoinedByString:@"\n"];
    }];
    
    self.camera = [GMSCameraPosition cameraWithLatitude:location.latitude
                                              longitude:location.longitude
                                                   zoom:17];
    [self.mapView animateToCameraPosition:self.camera];
    return false;
}

- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker{
  NSMutableArray *locations = [NSMutableArray array];
  marker.map = nil;
  CLLocation *markerLocation = [[CLLocation alloc] initWithLatitude:marker.position.latitude longitude:marker.position.longitude];
  [locations addObject:markerLocation];
  NSLog(@"%@",marker.userData);
  __weak typeof(self) weakSelf = self;
  [APIModel getAllMarketingTrackingDetail:marker.userData[@"userid"] WithCompletion:^(NSArray *data, NSError *error) {
    if (!error) {
      int i = data.count;
      for (NSDictionary *datum in data) {
        CLLocationCoordinate2D location = CLLocationCoordinate2DMake([datum[@"lat"] doubleValue], [datum[@"lng"] doubleValue]);
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake([datum[@"lat"] doubleValue], [datum[@"lng"] doubleValue]);
        marker.title =  [NSString stringWithFormat:@"%i - %@",i, datum[@"fullName"]];
        marker.snippet = datum[@"userid"];
        marker.map = weakSelf.mapView;
        marker.userData = datum;
            CLLocation *locationForLocations = [[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude];
        [locations addObject:locationForLocations];
        i--;
      }
      for (int i = 0; i < (locations.count - 1); i++) {
        CLLocation *origin = locations[i];
        CLLocation *destination = locations[i+1];
        [MapModel fetchPolylineWithOrigin:origin destination:destination completionHandler:^(GMSPolyline *polyLine, NSError *error) {
          if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            [SVProgressHUD dismissWithDelay:1.5];
          } else {
            
            polyLine.strokeWidth = 2.f;
            polyLine.map = weakSelf.mapView;
          }
        }];
      }
    }
  }];
//    CLLocation *destinationLocation = [[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude];
//    self.camera = [GMSCameraPosition cameraWithLatitude:location.latitude longitude:location.longitude zoom:12];
//    [self.mapView animateToCameraPosition:self.camera];
  
//    __weak typeof(self) weakSelf = self;
//    [SVProgressHUD show];
//    [MapModel fetchPolylineWithOrigin:self.currentLocation destination:destinationLocation completionHandler:^(GMSPolyline *polyLine, NSError *error) {
//        if (error) {
//            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
//            [SVProgressHUD dismissWithDelay:1.5];
//        } else {
//            [SVProgressHUD dismiss];
//            polyLine.strokeWidth = 2.f;
//            polyLine.map = weakSelf.mapView;
//        }
//    }];
}



@end
