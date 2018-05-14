//
//  MenuViewController.h
//  MPMFinance
//
//  Created by Rudy Suharyadi on 5/11/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MenuViewDelegate<NSObject>

- (void)dismissAll;

@end

@interface MenuViewController : UIViewController

@end
