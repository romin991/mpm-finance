//
//  MonitoringTableViewCell.m
//  MPMFinance
//
//  Created by Romin Adi Santoso on 5/25/18.
//  Copyright © 2018 MPMFinance. All rights reserved.
//

#import "MonitoringTableViewCell.h"
#import "MPMCustomUI.h"
#import <UIImageView+AFNetworking.h>
@interface MonitoringTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *nama;
@property (weak, nonatomic) IBOutlet UILabel *userid;
@property (weak, nonatomic) IBOutlet UILabel *jumlahWO;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
@implementation MonitoringTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setupWithData:(NSDictionary *)data {
    NSString *urlString = data[@"imageIconIos"];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
   // UIImage *placeholderImage = [UIImage imageNamed:@"placeholder"];
    if ([data objectForKey:@"jumlahwo"]) {
        urlString = data[@"foto"];
        url = [NSURL URLWithString:urlString];
        request = [NSURLRequest requestWithURL:url];
        self.nama.text = data[@"nama"];
        self.userid.text = data[@"userid"];
        self.jumlahWO.text = [NSString stringWithFormat:@"Summary Work Order %@",data[@"jumlahwo"]];
        [self.imageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
            self.imageView.image = image;
            [self setNeedsLayout];
        } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
            NSLog(@"%@",error);
            ;
        }];
    } else {
        urlString = data[@"imageIconIos"];
        self.nama.text = data[@"desc"];
        self.userid.text = @"";
        self.jumlahWO.text = [NSString stringWithFormat:@"Summary Work Order %@",data[@"jumlah"]];
        [self.imageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
            self.imageView.image = image;
            [self setNeedsLayout];
        } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
            NSLog(@"%@",error);
            ;
        }];
        
    }
    
    if([data[@"foto"] length] > 0) {
        
    }
    [MPMCustomUI giveBorderTo:self.backgroundView withBorderColor:UIColorFromRGB(0xF46F02)];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
