//
//  WorkOderTableViewCell.m
//  MPMFinance
//
//  Created by Romin Adi Santoso on 5/26/18.
//  Copyright © 2018 MPMFinance. All rights reserved.
//
#import "MPMCustomUI.h"
#import <UIImageView+AFNetworking.h>
#import "WorkOderTableViewCell.h"
@interface WorkOderTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageIcon;
@property (weak, nonatomic) IBOutlet UILabel *registrationId;
@property (weak, nonatomic) IBOutlet UILabel *namaPengaju;
@property (weak, nonatomic) IBOutlet UILabel *groupLevel;
@property (weak, nonatomic) IBOutlet UILabel *status;

@end
@implementation WorkOderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setupWithData:(NSDictionary *)data {
    NSString *urlString = data[@"imageIconIos"];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    urlString = data[@"imageIconIos"];
    self.registrationId.text = data[@"noRegistrasi"];
    self.namaPengaju.text = data[@"namaPengaju"];
    self.groupLevel.text = data[@"groupLevel"];
    self.status.text = data[@"status"];
    [self.imageIcon setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        self.imageIcon.image = image;
        [self setNeedsLayout];
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        ;
    }];
    

    
    [MPMCustomUI giveBorderTo:self.backgroundView withBorderColor:UIColorFromRGB(0xF46F02)];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
