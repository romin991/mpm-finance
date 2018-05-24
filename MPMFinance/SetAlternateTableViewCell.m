//
//  SetAlternateTableViewCell.m
//  MPMFinance
//
//  Created by Romin Adi Santoso on 5/23/18.
//  Copyright © 2018 MPMFinance. All rights reserved.
//

#import "SetAlternateTableViewCell.h"
#import "MPMCustomUI.h"
@interface SetAlternateTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *dateTime;
@property (weak, nonatomic) IBOutlet UIView *labelBackground;
@property (weak, nonatomic) IBOutlet UILabel *labelStatus;

@end
@implementation SetAlternateTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setupWithData:(NSDictionary *)data {
    self.title.text = data[@"namaLengkapMkt"];
    self.dateTime.text = data[@"date"];
    
    if ([data[@"isCancel"] isEqual:@1]) {
        self.labelStatus.text = @"Batal";
        self.labelBackground.backgroundColor = [UIColor redColor];
    } else if ([data[@"isExpired"] isEqual:@1]) {
        self.labelStatus.text = @"Kadaluarsa";
        self.labelBackground.backgroundColor = UIColorFromRGB(0x8DA016);
    }  else if ([data[@"isActive"] isEqual:@1]) {
        self.labelStatus.text = @"Active";
        self.labelBackground.backgroundColor = UIColorFromRGB(0x8DA016);
    } else  {
        self.labelStatus.text = @"Tidak Aktif";
        self.labelBackground.backgroundColor = [UIColor lightGrayColor];
    }
    [MPMCustomUI giveBorderTo:self.labelBackground withBorderColor:self.labelBackground.backgroundColor];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
