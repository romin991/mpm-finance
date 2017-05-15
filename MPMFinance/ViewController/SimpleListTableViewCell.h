//
//  SimpleListTableViewCell.h
//  MPMFinance
//
//  Created by Rudy Suharyadi on 5/15/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimpleListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *checkmark;

@end
