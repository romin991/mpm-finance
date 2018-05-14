//
//  ViewController.h
//  MPMFinance
//
//  Created by Rudy Suharyadi on 5/10/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"

@interface LoginViewController : UIViewController

@property (weak, nonatomic) id<MenuViewDelegate> menuViewDelegate;

@end

