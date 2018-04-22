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
@property (weak, nonatomic) MyProfileNavigationViewController *parentMainRegister;
- (void)setSelectedIndex:(int)selectedIndex;
@end
