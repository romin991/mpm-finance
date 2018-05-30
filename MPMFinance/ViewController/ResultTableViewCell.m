//
//  ResultTableViewCell.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 30/05/18.
//  Copyright © 2018 MPMFinance. All rights reserved.
//

#import "ResultTableViewCell.h"

@interface ResultTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *middleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;

@end

@implementation ResultTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupCellWithData:(ResultTableData *)data{
    if (data) {
        self.leftLabel.text = data.leftString;
        self.middleLabel.text = data.middleString;
        self.rightLabel.text = data.rightString;
        
        [self.rightLabel setTextColor:[UIColor lightGrayColor]];
        [self.rightLabel setTextAlignment:NSTextAlignmentRight];
        [self.leftLabel setTextColor:[UIColor lightGrayColor]];
        
        [self.leftLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:14]];
        [self.middleLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:14]];
        [self.rightLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:14]];
        
        if (data.type == ResultTableDataTypeBold) {
            [self.leftLabel setFont:[UIFont fontWithName:@"Avenir-Heavy" size:14]];
            [self.middleLabel setFont:[UIFont fontWithName:@"Avenir-Heavy" size:14]];
            [self.rightLabel setFont:[UIFont fontWithName:@"Avenir-Heavy" size:14]];
            
        } else if (data.type == ResultTableDataTypeHeader) {
            [self.leftLabel setTextColor:[UIColor blueColor]];
            
        } else if (data.type == ResultTableDataTypeRightTextAlignmentLeft) {
            [self.rightLabel setTextAlignment:NSTextAlignmentLeft];
            
        } else if (data.type == ResultTableDataTypeSummary){
            [self.leftLabel setTextColor:[UIColor blueColor]];
            [self.rightLabel setTextColor:[UIColor redColor]];
            
        }
    }
}

@end
