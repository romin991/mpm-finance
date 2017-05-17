//
//  ListViewController.h
//  MPMFinance
//
//  Created by Rudy Suharyadi on 5/15/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "List.h"
#import "Menu.h"

@interface ListViewController : UIViewController

@property Menu *menu;
- (void)setDataSource:(NSArray<List *> *)lists;

@end
