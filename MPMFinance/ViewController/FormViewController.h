//
//  FormViewController.h
//  MPMFinance
//
//  Created by Rudy Suharyadi on 5/14/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Menu.h"
#import "List.h"
#import <XLForm.h>
#import "BarcodeViewController.h"

@interface FormViewController : XLFormViewController <BarcodeDelegate>

@property Menu *parentMenu;
@property Menu *menu;
@property BOOL isFromHistory;
@property NSInteger index;
@property NSMutableDictionary *valueDictionary;
@property List *list;

@end
