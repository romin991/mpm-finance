//
//  DataMAPFormViewController.h
//  MPMFinance
//
//  Created by Rudy Suharyadi on 6/6/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Menu.h"
#import "SimpleListViewController.h"
#import <XLForm.h>
#import "XLFormBaseDropdownViewController.h"

@interface DataMAPFormViewController : XLFormBaseDropdownViewController

@property Menu *menu;
@property NSInteger index;
@property BOOL isReadOnly;
@property (weak, nonatomic) id<DataMAPViewControllerDelegate> delegate;

@end
