//
//  MyProfileNavigationViewController.h
//  MPMFinance
//
//  Created by Romin Adi Santoso on 4/22/18.
//  Copyright © 2018 MPMFinance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"

@interface MyProfileNavigationViewController : UIViewController

@property (weak, nonatomic) id<MenuViewDelegate> menuViewDelegate;
- (void)loadListContract;

@end
