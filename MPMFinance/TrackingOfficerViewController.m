//
//  TrackingOfficerViewController.m
//  MPMFinance
//
//  Created by Romin Adi Santoso on 5/25/18.
//  Copyright © 2018 MPMFinance. All rights reserved.
//

#import "TrackingOfficerViewController.h"
#import <MapKit/MapKit.h>
#import "APIModel.h"
#import "DetailTrackingAnnotation.h"
@interface TrackingOfficerViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property NSArray *marketings;
@end

@implementation TrackingOfficerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Tracking Officer";
    [APIModel getAllMarketingWithCompletion:^(NSArray *data, NSError *error) {
        if (!error) {
            self.marketings = data;
            for (NSDictionary *datum in self.marketings) {
                MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
                annotation.title = datum[@"fullName"];
                annotation.subtitle = datum[@"userid"];
                annotation.coordinate = CLLocationCoordinate2DMake([datum[@"lat"] doubleValue], [datum[@"lng"] doubleValue]);
                [self.mapView addAnnotation:annotation];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.mapView selectAnnotation:annotation animated:YES];
                    
                    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 1000, 1000);
                    self.mapView.region = region;
                    
                });
                
            }
        }
    }];
    // Do any additional setup after loading the view from its nib.
}
-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
//    if ([[UIApplication sharedApplication] canOpenURL:
//         [NSURL URLWithString:@"comgooglemaps://"]]) {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"comgooglemaps://?saddr=23.0321,72.5252&daddr=22.9783,72.6002&zoom=14&views=traffic"]];
//    } else {
//        NSLog(@"Can't use comgooglemaps://");
//    }
    if ([view isKindOfClass:[DetailTrackingAnnotation class]]) {
        ;
    } else {
        [APIModel getAllMarketingTrackingDetail:view.annotation.subtitle WithCompletion:^(NSArray *data, NSError *error) {
            int i = 1;
            for (NSDictionary *dict in data) {
                CLGeocoder *ceo = [[CLGeocoder alloc]init];
                CLLocation *loc = [[CLLocation alloc]initWithLatitude:32.00 longitude:21.322]; //insert your coordinates
                [ceo reverseGeocodeLocation:loc
                          completionHandler:^(NSArray *placemarks, NSError *error) {
                              CLPlacemark *placemark = [placemarks objectAtIndex:0];
                              if (placemark) {
                                  
                                  
                                  NSLog(@"placemark %@",placemark);
                                  //String to hold address
                                  NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
                                  NSLog(@"addressDictionary %@", placemark.addressDictionary);
                                  
                                  NSLog(@"placemark %@",placemark.region);
                                  NSLog(@"placemark %@",placemark.country);  // Give Country Name
                                  NSLog(@"placemark %@",placemark.locality); // Extract the city name
                                  NSLog(@"location %@",placemark.name);
                                  NSLog(@"location %@",placemark.ocean);
                                  NSLog(@"location %@",placemark.postalCode);
                                  NSLog(@"location %@",placemark.subLocality);
                                  
                                  NSLog(@"location %@",placemark.location);
                                  //Print the location to console
                                  NSLog(@"I am currently at %@",locatedAt);
                              }
                              else {
                                  NSLog(@"Could not locate");
                              }
                          }
                 ];
                DetailTrackingAnnotation *annotation = [[DetailTrackingAnnotation alloc] initWithCoordinate:CLLocationCoordinate2DMake([dict[@"lat"] doubleValue], [dict[@"lng"] doubleValue])];
                annotation.number = @(i);
                //annotation.address =
                i++;
            }
            
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
