//
//  DisclaimerViewController.h
//  MPMFinance
//
//  Created by Rudy Suharyadi on 5/16/18.
//  Copyright © 2018 MPMFinance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "List.h"
#import "Menu.h"

@interface DisclaimerViewController : UIViewController

@property Menu *parentMenu;
@property NSMutableDictionary *valueDictionary;
@property List *list;

@end
