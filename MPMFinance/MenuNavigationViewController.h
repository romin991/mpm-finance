//
//  MenuNavigationViewController.h
//  MPMFinance
//
//  Created by Romin Adi Santoso on 5/14/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    kHome,
    kHistory,
    kHelp,
    kProfile
} ContainerView;

@protocol MenuViewDelegate;
@interface MenuNavigationViewController : UINavigationController

@property (weak, nonatomic) id<MenuViewDelegate> menuViewDelegate;
- (void)setSelectedIndex:(ContainerView)selectedIndex;
- (UIViewController *)getSelectedViewController;

@end
