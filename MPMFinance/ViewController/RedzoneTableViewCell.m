//
//  RedzoneTableViewCell.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 19/06/18.
//  Copyright © 2018 MPMFinance. All rights reserved.
//

#import "RedzoneTableViewCell.h"

NSString * const XLFormRowDescriptorTypeRedzone = @"XLFormRowDescriptorTypeRedzone";

@interface RedzoneTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *redzoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *pepAlertLabel;

@end

@implementation RedzoneTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if ([self.rowDescriptor.value isKindOfClass:NSDictionary.class]) {
        NSDictionary *dictionary = self.rowDescriptor.value;
        if ([[dictionary objectForKey:@"redzone"] isEqualToString:@"1"]) {
            self.redzoneLabel.text = @"Redzone";
        } else {
            self.redzoneLabel.text = @"-";
        }
        if ([[dictionary objectForKey:@"pep"] isEqualToString:@"1"]) {
            self.pepAlertLabel.text = @"PEP Alert";
        } else {
            self.pepAlertLabel.text = @"-";
        }
    }
    [MPMGlobal giveBorderTo:self.redzoneLabel withBorderColor:@"#FF0000" withCornerRadius:5];
    [MPMGlobal giveBorderTo:self.pepAlertLabel withBorderColor:@"#0000FF" withCornerRadius:5];
}

@end
