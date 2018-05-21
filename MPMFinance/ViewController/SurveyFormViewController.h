//
//  SurveyFormViewController.h
//  MPMFinance
//
//  Created by Rudy Suharyadi on 6/7/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Menu.h"
#import "List.h"
#import <XLForm.h>

@interface SurveyFormViewController : XLFormViewController

@property Menu *menu;
@property NSInteger index;
@property NSMutableDictionary *valueDictionary;
@property List *list;
@property BOOL isReadOnly;

@end
