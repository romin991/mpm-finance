//
//  MyProfileNavigationViewController.m
//  MPMFinance
//
//  Created by Romin Adi Santoso on 4/22/18.
//  Copyright © 2018 MPMFinance. All rights reserved.
//

#import "MyProfileNavigationViewController.h"
#import "MyProfileTableViewController.h"
#import "MyProfileContainerViewController.h"
@interface MyProfileNavigationViewController ()<UITabBarDelegate>
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
@property MyProfileContainerViewController *containerView;
@end

@implementation MyProfileNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if (item.tag == 1) {
        [_containerView setSelectedIndex:0];
    } else {
        [_containerView setSelectedIndex:1];
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"embedProfileContainerSegue"]){
        _containerView = (MyProfileContainerViewController *)segue.destinationViewController;
        _containerView.parentMainRegister = self;
        
    }
}


@end
