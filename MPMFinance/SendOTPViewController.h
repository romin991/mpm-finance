//
//  sendOTPViewController.h
//  MPMFinance
//
//  Created by Romin Adi Santoso on 6/20/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"

@interface SendOTPViewController : UIViewController

@property NSString *userId;
@property NSString *password;
@property (weak, nonatomic) id<MenuViewDelegate> menuViewDelegate;

@end
