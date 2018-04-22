//
//  MenuViewController.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 5/11/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuNavigationViewController.h"
#import "ProfileModel.h"

@interface MenuViewController ()<UITabBarDelegate>
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
@property (weak, nonatomic) IBOutlet UIView *signInView;
@property NSArray *guestMenu;
@property NSArray *memberMenu;
@property MenuNavigationViewController *containerView;
@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUI) name:@"UserLoginNotification" object:nil];
    self.memberMenu = [[self.tabBar items] mutableCopy];
    NSMutableArray *guestMutableMenu = [[self.tabBar items] mutableCopy];
    [guestMutableMenu removeObjectAtIndex:3];
    [guestMutableMenu removeObjectAtIndex:1];
    self.guestMenu = [[NSArray alloc] initWithArray:guestMutableMenu];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self refreshUI];
    [ProfileModel checkTokenWithCompletion:^(BOOL isExpired) {
        if (isExpired) {
            [MPMUserInfo deleteUserInfo];
            [self refreshUI];
        };
    }];

    
}
-(void)refreshUI
{
    [self.tabBar setSelectedItem:[self.tabBar.items objectAtIndex:0]];
    if (![MPMUserInfo getUserInfo])
    {
        [self.tabBar setItems:_guestMenu animated:true];
        [self.signInView setHidden:NO];
    }
    else
    {
        [self.tabBar setItems:_memberMenu animated:true];
        [self.tabBar.items[1] setEnabled:YES];
        [self.tabBar.items[3] setEnabled:YES];
        [self.signInView setHidden:YES];
    }
    
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
