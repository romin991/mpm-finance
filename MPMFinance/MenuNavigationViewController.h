//
//  MenuNavigationViewController.h
//  MPMFinance
//
//  Created by Romin Adi Santoso on 5/14/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"
typedef enum{
    kHome,
    kHistory,
    kHelp,
    kProfile
} ContainerView;
@interface MenuNavigationViewController : UINavigationController
@property (weak, nonatomic) MenuViewController *parentMainRegister;
- (void)setSelectedIndex:(ContainerView)selectedIndex;
@end
