//
//  MenuViewController.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 5/11/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuNavigationViewController.h"
#import "MPMUserInfo.h"
@interface MenuViewController ()<UITabBarDelegate>
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
@property (weak, nonatomic) IBOutlet UIView *signInView;
@property MenuNavigationViewController *containerView;
@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tabBar setSelectedItem:[self.tabBar.items objectAtIndex:0]];
    if (![MPMUserInfo getUserInfo])
    {
        [self.tabBar.items[1] setEnabled:NO];
        [self.tabBar.items[3] setEnabled:NO];
        [self.signInView setHidden:NO];
    }
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if (item.tag == 1) {
        [_containerView setSelectedIndex:kHome];
    }
    else if(item.tag == 2){
        [_containerView setSelectedIndex:kHistory];
    }
    else if(item.tag == 3){
        [_containerView setSelectedIndex:kHelp];
    }
    else if(item.tag == 4){
        [_containerView setSelectedIndex:kProfile];
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"embedContainerSegue"]){
        _containerView = (MenuNavigationViewController *)segue.destinationViewController;
        _containerView.parentMainRegister = self;
        
    }
}


@end
