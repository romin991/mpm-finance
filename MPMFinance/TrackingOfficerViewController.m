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
#import "SMCalloutView.h"

@interface MYTapGestureRecognizer : UITapGestureRecognizer

@property (nonatomic, strong) NSString *data;

@end


// MYTapGestureRecognizer.m

@implementation MYTapGestureRecognizer

@end
@interface CustomMapView : MKMapView
@property (nonatomic, strong) SMCalloutView *calloutView;
@end
@interface TrackingOfficerViewController () <MKMapViewDelegate, SMCalloutViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property NSMutableArray *marketings;
@property (nonatomic, strong) CustomMapView *mapKitWithSMCalloutView;
@property (nonatomic, strong) SMCalloutView *calloutView;
@property (nonatomic, strong) MKPointAnnotation *annotationForSMCalloutView;
@end

@implementation TrackingOfficerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Tracking Officer";
    self.mapKitWithSMCalloutView = [[CustomMapView alloc] initWithFrame:self.view.bounds];
    self.mapKitWithSMCalloutView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.mapKitWithSMCalloutView.delegate = self;
    //[self.mapKitWithSMCalloutView addAnnotation:self.annotationForSMCalloutView];
    [self.view addSubview:self.mapKitWithSMCalloutView];
    // create our custom callout view
    self.calloutView = [SMCalloutView platformCalloutView];
    self.calloutView.delegate = self;
    
    // tell our custom map view about the callout so it can send it touches
    self.mapKitWithSMCalloutView.calloutView = self.calloutView;
    self.marketings = [NSMutableArray array
                       ];
    [APIModel getAllMarketingWithCompletion:^(NSArray *data, NSError *error) {
        if (!error) {
            
            for (NSDictionary *datum in data) {
                MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
                annotation.title = datum[@"fullName"];
                annotation.subtitle = datum[@"userid"];
                annotation.coordinate = CLLocationCoordinate2DMake([datum[@"lat"] doubleValue], [datum[@"lng"] doubleValue]);
                [self.marketings addObject:annotation];
                [self.mapKitWithSMCalloutView addAnnotation:annotation];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //[self.mapView selectAnnotation:annotation animated:YES];
                    
                    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 1000, 1000);
                    self.mapView.region = region;
                    
                });
                
            }
        }
    }];
    // Do any additional setup after loading the view from its nib.
}

//
// MKMapView delegate methods
//

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    // create a proper annotation view, be lazy and don't use the reuse identifier
    MKPinAnnotationView *view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@""];
    
    // if we're using SMCalloutView, we don't want MKMapView to create its own callout!
    view.canShowCallout = NO;
    
    return view;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)annotationView {
    
    if (mapView == self.mapKitWithSMCalloutView) {
        
        // apply the MKAnnotationView's basic properties
        self.calloutView.title = annotationView.annotation.title;
        self.calloutView.subtitle = annotationView.annotation.subtitle;
        
        // Apply the MKAnnotationView's desired calloutOffset (from the top-middle of the view)
        self.calloutView.calloutOffset = annotationView.calloutOffset;
        
        // create a disclosure button for comparison
        UIButton *disclosure = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        MYTapGestureRecognizer *myRecognizer = [[MYTapGestureRecognizer alloc] initWithTarget:self action:@selector(disclosureTapped:)];
        myRecognizer.data = annotationView.annotation.subtitle;
        [disclosure addGestureRecognizer:myRecognizer];
        self.calloutView.rightAccessoryView = disclosure;
        
        // iOS 7 only: Apply our view controller's edge insets to the allowable area in which the callout can be displayed.
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
            self.calloutView.constrainedInsets = UIEdgeInsetsMake(self.topLayoutGuide.length, 0, self.bottomLayoutGuide.length, 0);
        
        // This does all the magic.
        
        
        
        
        CLGeocoder *ceo = [[CLGeocoder alloc]init];
        CLLocation *loc = [[CLLocation alloc]initWithLatitude:annotationView.annotation.coordinate.latitude longitude:annotationView.annotation.coordinate.longitude]; //insert your coordinates
        [ceo reverseGeocodeLocation:loc
                  completionHandler:^(NSArray *placemarks, NSError *error) {
                      CLPlacemark *placemark = [placemarks objectAtIndex:0];
                      if (placemark) {
                          dispatch_async(dispatch_get_main_queue(), ^{
                              NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
                              UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 150)];
                              UITextView *textView = [[UITextView alloc] initWithFrame:view.frame];
                              textView.text = locatedAt;
                              [view addSubview:textView];
                              self.calloutView.subtitleView = view;
                              [self.calloutView presentCalloutFromRect:annotationView.bounds inView:annotationView constrainedToView:self.view animated:YES];
                              
                          });
                      }
                      else {
                          NSLog(@"Could not locate");
                      }
                  }
         ];
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    
    [self.calloutView dismissCalloutAnimated:YES];
}

//
// SMCalloutView delegate methods
//

- (NSTimeInterval)calloutView:(SMCalloutView *)calloutView delayForRepositionWithSize:(CGSize)offset {
    
    // When the callout is being asked to present in a way where it or its target will be partially offscreen, it asks us
    // if we'd like to reposition our surface first so the callout is completely visible. Here we scroll the map into view,
    // but it takes some math because we have to deal in lon/lat instead of the given offset in pixels.
    
    CLLocationCoordinate2D coordinate = self.mapKitWithSMCalloutView.centerCoordinate;
    
    // where's the center coordinate in terms of our view?
    CGPoint center = [self.mapKitWithSMCalloutView convertCoordinate:coordinate toPointToView:self.view];
    
    // move it by the requested offset
    center.x -= offset.width;
    center.y -= offset.height;
    
    // and translate it back into map coordinates
    coordinate = [self.mapKitWithSMCalloutView convertPoint:center toCoordinateFromView:self.view];
    
    // move the map!
    [self.mapKitWithSMCalloutView setCenterCoordinate:coordinate animated:YES];
    
    // tell the callout to wait for a while while we scroll (we assume the scroll delay for MKMapView matches UIScrollView)
    return kSMCalloutViewRepositionDelayForUIScrollView;
}

- (void)disclosureTapped:(id)sender {
    MYTapGestureRecognizer *tap = sender;
    for (MKPointAnnotation *annotation in self.marketings) {
        if ([annotation.subtitle isEqualToString:tap.data]) {
            [self.mapKitWithSMCalloutView removeAnnotation:annotation];
            break;
        }
    }
    self.marketings = nil;
    [APIModel getAllMarketingTrackingDetail:tap.data WithCompletion:^(NSArray *data, NSError *error) {
        int i = 1;
        
        for (NSDictionary *dict in data) {
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
            annotation.title = [NSString stringWithFormat:@"%i",i];
            annotation.subtitle = @"";
            annotation.coordinate = CLLocationCoordinate2DMake([dict[@"lat"] doubleValue], [dict[@"lng"] doubleValue]);
            [self.mapKitWithSMCalloutView addAnnotation:annotation];
            
            //annotation.address =
            i++;
        }

    }];
}

@end

//
// Custom Map View
//
// We need to subclass MKMapView in order to present an SMCalloutView that contains interactive
// elements.
//

@interface MKMapView (UIGestureRecognizer)

// this tells the compiler that MKMapView actually implements this method
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch;
@property NSString *body;
@end

@implementation CustomMapView

// override UIGestureRecognizer's delegate method so we can prevent MKMapView's recognizer from firing
// when we interact with UIControl subclasses inside our callout view.
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UIControl class]])
        return NO;
    else
        return [super gestureRecognizer:gestureRecognizer shouldReceiveTouch:touch];
}

// Allow touches to be sent to our calloutview.
// See this for some discussion of why we need to override this: https://github.com/nfarina/calloutview/pull/9
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    UIView *calloutMaybe = [self.calloutView hitTest:[self.calloutView convertPoint:point fromView:self] withEvent:event];
    if (calloutMaybe) return calloutMaybe;
    
    return [super hitTest:point withEvent:event];
}

@end

//-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
//    if ([view isKindOfClass:[DetailTrackingAnnotation class]]) {
//        ;
//    } else {
//        [APIModel getAllMarketingTrackingDetail:view.annotation.subtitle WithCompletion:^(NSArray *data, NSError *error) {
//            int i = 1;
//            for (NSDictionary *dict in data) {
//                CLGeocoder *ceo = [[CLGeocoder alloc]init];
//                CLLocation *loc = [[CLLocation alloc]initWithLatitude:32.00 longitude:21.322]; //insert your coordinates
//                [ceo reverseGeocodeLocation:loc
//                          completionHandler:^(NSArray *placemarks, NSError *error) {
//                              CLPlacemark *placemark = [placemarks objectAtIndex:0];
//                              if (placemark) {
//
//
//                                  NSLog(@"placemark %@",placemark);
//                                  //String to hold address
//                                  NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
//                                  NSLog(@"addressDictionary %@", placemark.addressDictionary);
//
//                                  NSLog(@"placemark %@",placemark.region);
//                                  NSLog(@"placemark %@",placemark.country);  // Give Country Name
//                                  NSLog(@"placemark %@",placemark.locality); // Extract the city name
//                                  NSLog(@"location %@",placemark.name);
//                                  NSLog(@"location %@",placemark.ocean);
//                                  NSLog(@"location %@",placemark.postalCode);
//                                  NSLog(@"location %@",placemark.subLocality);
//
//                                  NSLog(@"location %@",placemark.location);
//                                  //Print the location to console
//                                  NSLog(@"I am currently at %@",locatedAt);
//                              }
//                              else {
//                                  NSLog(@"Could not locate");
//                              }
//                          }
//                 ];
//                DetailTrackingAnnotation *annotation = [[DetailTrackingAnnotation alloc] initWithCoordinate:CLLocationCoordinate2DMake([dict[@"lat"] doubleValue], [dict[@"lng"] doubleValue])];
//                annotation.number = @(i);
//                //annotation.address =
//                i++;
//            }
//
//        }];
//    }
//}

