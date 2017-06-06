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

@interface DataMAPFormViewController : UIViewController

@property Menu *menu;
@property NSInteger index;
@property NSMutableDictionary *valueDictionary;

@property (weak, nonatomic) id<DataMAPViewControllerDelegate> delegate;

@end
