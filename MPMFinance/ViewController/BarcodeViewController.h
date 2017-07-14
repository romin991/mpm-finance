//
//  BarcodeViewController.h
//  MPMFinance
//
//  Created by Rudy Suharyadi on 7/14/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BarcodeDelegate <NSObject>

- (void)finish;

@end

@interface BarcodeViewController : UIViewController

@property (weak, nonatomic) id<BarcodeDelegate> delegate;

@property NSString *barcodeString;

@end
