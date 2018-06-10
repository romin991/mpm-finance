//
//  WorkOrderListTableViewCell.h
//  MPMFinance
//
//  Created by Rudy Suharyadi on 6/26/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorkOrderListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *assignee;
@property (weak, nonatomic) IBOutlet UILabel *groupLevel;
@property (weak, nonatomic) IBOutlet UILabel *status;

@end
