//
//  MenuNavigationViewController.m
//  MPMFinance
//
//  Created by Romin Adi Santoso on 5/14/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "MenuNavigationViewController.h"
#import "HomeViewController.h"
#import "HistoryViewController.h"
@interface MenuNavigationViewController ()
@property HomeViewController *homeVC;
@property HistoryViewController *historyVC;
@property (nonatomic) ContainerView selectedIndex;
@end

@implementation MenuNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.homeVC = [storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    self.historyVC = [storyboard instantiateViewControllerWithIdentifier:@"HistoryViewController"];
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [self setNavigationBarHidden:YES animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setSelectedIndex:(ContainerView)selectedIndex{
    _selectedIndex = selectedIndex;
    if (selectedIndex == kHome){
        [self setViewControllers:[NSArray arrayWithObject:self.homeVC] animated:NO];
    } else if (selectedIndex == kHistory){
        [self setViewControllers:[NSArray arrayWithObject:self.historyVC] animated:NO];
    } else if (selectedIndex == kHelp){
        //[self setViewControllers:[NSArray arrayWithObject:self.numpadViewController] animated:NO];
    } else{
    
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
