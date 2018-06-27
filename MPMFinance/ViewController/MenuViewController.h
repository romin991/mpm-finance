//
//  MenuViewController.h
//  MPMFinance
//
//  Created by Rudy Suharyadi on 5/11/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuNavigationViewController.h"

@protocol MenuViewDelegate<NSObject>

- (void)selectMenuAtIndex:(ContainerView)index;
- (void)dismissAll;
- (MenuNavigationViewController *)getContainerViewController;

@end

@interface MenuViewController : UIViewController<MenuViewDelegate>

@end
