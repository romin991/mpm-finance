//
//  MyProfileContainerViewController.h
//  MPMFinance
//
//  Created by Romin Adi Santoso on 4/22/18.
//  Copyright © 2018 MPMFinance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyProfileNavigationViewController.h"

@interface MyProfileContainerViewController : UINavigationController

@property (weak, nonatomic) id<MenuViewDelegate> menuViewDelegate;
- (void)setSelectedIndex:(int)selectedIndex;
- (void)loadListContract;

@end
