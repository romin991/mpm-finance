//
//  ProductDetailViewController.h
//  MPMFinance
//
//  Created by Romin Adi Santoso on 4/24/18.
//  Copyright © 2018 MPMFinance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductDetailViewController : UIViewController
@property NSString *contentString;
@property (weak, nonatomic) IBOutlet UITextView *content;
@end
