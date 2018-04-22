//
//  MyProfileContainerViewController.m
//  MPMFinance
//
//  Created by Romin Adi Santoso on 4/22/18.
//  Copyright © 2018 MPMFinance. All rights reserved.
//

#import "MyProfileContainerViewController.h"
#import "MyProfileTableViewController.h"
@interface MyProfileContainerViewController ()
@property MyProfileTableViewController *myProfileVC;
@property (nonatomic) int selectedIndex;
@end

@implementation MyProfileContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.myProfileVC = [storyboard instantiateViewControllerWithIdentifier:@"MyProfileTableViewController"];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [self setNavigationBarHidden:YES animated:NO];
}
- (void)setSelectedIndex:(int)selectedIndex{
    _selectedIndex = selectedIndex;
    if (selectedIndex == 1){
        [self setViewControllers:[NSArray arrayWithObject:[[UIViewController alloc] init]] animated:NO];
         } else {
        [self setViewControllers:[NSArray arrayWithObject:self.myProfileVC] animated:NO];
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
