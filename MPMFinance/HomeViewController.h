//
//  HomeViewController.h
//  MPMFinance
//
//  Created by Romin Adi Santoso on 5/14/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Menu.h"

@interface HomeViewController : UIViewController

- (BOOL)isMenuAvailable:(Menu *)menu;

@end
