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

@interface SurveyFormViewController : UIViewController

@property Menu *menu;
@property NSInteger index;
@property NSMutableDictionary *valueDictionary;
@property List *list;

@end
