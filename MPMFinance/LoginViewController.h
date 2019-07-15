//
//  ViewController.h
//  MPMFinance
//
//  Created by Rudy Suharyadi on 5/10/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"

@protocol LoginDelegate <NSObject>

- (void)loginDidSuccess;

@end
@interface LoginViewController : UIViewController
@property (weak, nonatomic) id<LoginDelegate> loginDelegate;
@property (weak, nonatomic) id<MenuViewDelegate> menuViewDelegate;

@end

