//
//  ViewStepMonitoringTableViewCell.h
//  
//
//  Created by Rudy Suharyadi on 07/06/18.
//

#import <UIKit/UIKit.h>

@interface ViewStepMonitoringTableViewCell : UITableViewCell
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *titleLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *checkImageView;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *lineView;

@end
