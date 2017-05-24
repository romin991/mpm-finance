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

#import "FormViewController.h"
#import "workOrderListViewController.h"
#import "SimpleListViewController.h"
#import "SubmenuViewController.h"
@interface HomeViewController ()<KASlideShowDelegate,KASlideShowDataSource>
@property RLMResults *menus;
@property (strong,nonatomic) IBOutlet KASlideShow * slideshow;
@property NSMutableArray * datasource;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.menus = [Menu getMenuForRole:kRoleDedicated];
    // KASlideshow
    [self reloadSlideShow];
    _slideshow.datasource = self;
    _slideshow.delegate = self;
    [_slideshow setDelay:1]; // Delay between transitions
    [_slideshow setTransitionDuration:.5]; // Transition duration
    [_slideshow setTransitionType:KASlideShowTransitionSlideHorizontal]; // Choose a transition type (fade or slide)
    [_slideshow setImagesContentMode:UIViewContentModeScaleAspectFill]; // Choose a content mode for images to display
    [_slideshow addGesture:KASlideShowGestureTap]; // Gesture to go previous/next directly on the image

}
-(void)reloadSlideShow
{
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    [manager POST:[NSString stringWithFormat:@"%@/slider",kApiUrl] parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    _datasource = [@[[NSURL URLWithString:@"https://i.imgur.com/7jDvjyt.jpg"],
                     [NSURL URLWithString:@"https://i.imgur.com/7jDvjyt.jpg"]] mutableCopy];
    
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
    label.text = menu.title;
    
    return cell;
}
#pragma mark - Collection View Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Menu *menu = [self.menus objectAtIndex:indexPath.row];
    if ([menu.menuType isEqualToString:kMenuTypeList]){
        workOrderListViewController *listViewController = [[workOrderListViewController alloc] initWithNibName:@"ListViewController" bundle:nil];
        listViewController.menu = menu;
        [self.navigationController.navigationController pushViewController:listViewController animated:YES];
        
    } else if ([menu.menuType isEqualToString:kMenuTypeSubmenu]){
        SubmenuViewController *submenuViewController = [[SubmenuViewController alloc] init];
        submenuViewController.menu = menu;
        [self.navigationController.navigationController pushViewController:submenuViewController animated:YES];
    }

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
