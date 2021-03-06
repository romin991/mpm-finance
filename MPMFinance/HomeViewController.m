//
//  HomeViewController.m
//  MPMFinance
//
//  Created by Romin Adi Santoso on 5/14/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "HomeViewController.h"
#import "Menu.h"
#import "KASlideShow.h"

#import "DashboardViewController.h"
#import "FormViewController.h"
#import "ListViewController.h"
#import "WorkOrderListViewController.h"
#import "SimpleListViewController.h"
#import "SubmenuViewController.h"
#import "SubmenuCollectionViewController.h"
#import "ContactUsViewController.h"
#import "AcceleratedRepaymentFormViewController.h"
#import "ProductViewController.h"
#import "MonitoringViewController.h"
#import "ActivityHistoryViewController.h"
#import "SetAlternateViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "TrackingViewController.h"
@interface HomeViewController ()<KASlideShowDelegate,KASlideShowDataSource, UICollectionViewDelegateFlowLayout,CLLocationManagerDelegate>

@property RLMResults *menus;
@property (weak, nonatomic) IBOutlet UICollectionView *menuCollectionView;
@property (strong,nonatomic) IBOutlet KASlideShow * slideshow;
@property NSMutableArray * datasource;
@property CLLocationManager *locationManager;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  [self refreshUI];
    // KASlideshow
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUI) name:@"UserLoginNotification" object:nil];
    self.datasource = [NSMutableArray array];
    [self reloadSlideShow];
    _slideshow.datasource = self;
    _slideshow.delegate = self;
    [_slideshow setDelay:1]; // Delay between transitions
    [_slideshow setTransitionDuration:.5]; // Transition duration
    [_slideshow setTransitionType:KASlideShowTransitionSlideHorizontal]; // Choose a transition type (fade or slide)
    [_slideshow setImagesContentMode:UIViewContentModeScaleAspectFill]; // Choose a content mode for images to display
    [_slideshow addGesture:KASlideShowGestureTap]; // Gesture to go previous/next directly on the image
  
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
  [_locationManager requestWhenInUseAuthorization];
    [_locationManager startUpdatingLocation];

}
-(void)refreshUI
{
    self.menus = [Menu getMenuForRole:[MPMUserInfo getRole]];
  if (![[MPMUserInfo getRole] isEqualToString:kNoRole]) {
    [NSTimer scheduledTimerWithTimeInterval:5.0f target:self
                                   selector:@selector(updateLocation) userInfo:nil repeats:YES];
    
  }
    [self.menuCollectionView reloadData];
}

- (void) updateLocation {
  if (self.locationManager.location.coordinate.latitude == 0 || ![[MPMUserInfo getRole] isEqualToString:kRoleDedicated]) {
    return;
  }
  AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
  NSDictionary* param = @{@"userid" : [MPMUserInfo getUserInfo][@"userId"],
                          @"token" : [MPMUserInfo getToken],
                          @"data" : @{@"lat" : [NSString stringWithFormat:@"%lf",self.locationManager.location.coordinate.latitude],@"lng" : [NSString stringWithFormat:@"%lf",self.locationManager.location.coordinate.longitude]}
                          };
  [manager POST:[NSString stringWithFormat:@"%@/tracking/insertmarketing",kApiUrl] parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
    
  } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    NSLog(@"%@",responseObject);
    
    
  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    
  }];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
  NSLog(@"OldLocation %f %f", oldLocation.coordinate.latitude, oldLocation.coordinate.longitude);
  NSLog(@"NewLocation %f %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
}

-(void)reloadSlideShow
{
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    [manager POST:[NSString stringWithFormat:@"%@/slider",kApiUrl] parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        dispatch_async(dispatch_get_main_queue(), ^{
            for (NSDictionary *imageDict in responseObject[@"data"]) {
                [_datasource addObject:[NSURL URLWithString:imageDict[@"image"]]];
            }
            [self.slideshow reloadData];
        });
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
   
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - KASlideShow datasource

- (NSObject *)slideShow:(KASlideShow *)slideShow objectAtIndex:(NSUInteger)index
{
    return _datasource[index];
}

- (NSUInteger)slideShowImagesNumber:(KASlideShow *)slideShow
{
    return _datasource.count;
}

#pragma mark - Collection View Data Source
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.view.frame.size.width/4, self.view.frame.size.width/4);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.menus.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = (UICollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    Menu *menu = [self.menus objectAtIndex:indexPath.row];
    
    UIImageView *imageView = (UIImageView *) [cell viewWithTag:1];
    imageView.image = [UIImage imageNamed:menu.imageName];
    
    UILabel *label = (UILabel *) [cell viewWithTag:2];
    label.text = NSLocalizedString(menu.title,@"");
    
    return cell;
}
#pragma mark - Collection View Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Menu *menu = [self.menus objectAtIndex:indexPath.row];
    [self menuSelected:menu];
}

- (void)menuSelected:(Menu *)menu{
    if ([menu.menuType isEqualToString:kMenuTypeList]){
        ListViewController *listViewController = [[ListViewController alloc] initWithNibName:@"ListViewController" bundle:nil];
        listViewController.menu = menu;
        [self.navigationController.navigationController pushViewController:listViewController animated:YES];
        
    } else if ([menu.menuType isEqualToString:kMenuTypeListWorkOrder]){
        WorkOrderListViewController *listViewController = [[WorkOrderListViewController alloc] initWithNibName:@"WorkOrderListViewController" bundle:nil];
        listViewController.menu = menu;
        [self.navigationController.navigationController pushViewController:listViewController animated:YES];
        
    } else if ([menu.menuType isEqualToString:kMenuTypeSubmenu]){
        SubmenuViewController *submenuViewController = [[SubmenuViewController alloc] init];
        submenuViewController.menu = menu;
        [self.navigationController.navigationController pushViewController:submenuViewController animated:YES];
        
    } else if ([menu.menuType isEqualToString:kMenuTypeContactUs]){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ContactUsViewController *submenuCollectionViewController = [storyboard instantiateViewControllerWithIdentifier:@"ContactUsViewController"];
        [self.navigationController.navigationController pushViewController:submenuCollectionViewController animated:YES];
        
    } else if ([menu.menuType isEqualToString:kMenuTypeDashboard]){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DashboardViewController *submenuCollectionViewController = [storyboard instantiateViewControllerWithIdentifier:@"DashboardViewController"];
        [self.navigationController.navigationController pushViewController:submenuCollectionViewController animated:YES];
        
    } else if ([menu.menuType isEqualToString:kMenuTypeAcceleratedRepayment]){
        AcceleratedRepaymentFormViewController *acceleratedRepaymentFormViewController = [[AcceleratedRepaymentFormViewController alloc] init];
        acceleratedRepaymentFormViewController.menu = menu;
        [self.navigationController.navigationController pushViewController:acceleratedRepaymentFormViewController animated:YES];
        
    } else if ([menu.menuType isEqualToString:kMenuTypeSubmenu2]) {
        if ([menu.primaryKey isEqualToString:kMenuProduct]) {
            ProductViewController *productVC = [[ProductViewController alloc] init];
            [self.navigationController.navigationController pushViewController:productVC animated:YES];
        }
    } else if ([menu.menuType isEqualToString:kMenuTypeHistory]) {
        ActivityHistoryViewController *legalizationBPKBViewController = [[ActivityHistoryViewController alloc] init];
        legalizationBPKBViewController.menu = menu;
        [self.navigationController.navigationController pushViewController:legalizationBPKBViewController animated:YES];
        
    } else if ([menu.menuType isEqualToString:kMenuSetAlternate]) {
        SetAlternateViewController *vc = [[SetAlternateViewController alloc] init];
        [self.navigationController.navigationController pushViewController:vc animated:YES];
        
    } else if ([menu.menuType isEqualToString:kMenuMonitoring]) {
        MonitoringViewController *vc = [[MonitoringViewController alloc] init];
        [self.navigationController.navigationController pushViewController:vc animated:YES];
        
    } else if ([menu.menuType isEqualToString:kMenuTrackingMarketing]) {
        TrackingViewController *vc = [[TrackingViewController alloc] init];
        [self.navigationController.navigationController pushViewController:vc animated:YES];
        
    }
}

- (BOOL)isMenuAvailable:(Menu *)menu {
    NSInteger index = [self.menus indexOfObject:menu];
    if (index != NSNotFound) {
        return YES;
    }
    return NO;
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
