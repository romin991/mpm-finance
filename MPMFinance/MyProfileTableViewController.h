//
//  MyProfileTableViewController.h
//  MPMFinance
//
//  Created by Romin Adi Santoso on 5/17/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"

@interface MyProfileTableViewController : UITableViewController

@property (weak, nonatomic) id<MenuViewDelegate> menuViewDelegate;

@end
