//
//  SimpleListViewController.h
//  MPMFinance
//
//  Created by Rudy Suharyadi on 5/15/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Menu.h"
#import "List.h"

@protocol DataMAPViewControllerDelegate <NSObject>

- (void)saveDictionary:(NSDictionary *)dictionary;

@end

@interface SimpleListViewController : UIViewController <DataMAPViewControllerDelegate>

@property Menu *menu;
@property NSString *navigationTitle;
@property List *list;

@property BOOL isReadOnly;

@end
