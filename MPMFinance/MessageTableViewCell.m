//
//  MessageTableViewCell.m
//  MPMFinance
//
//  Created by Romin Adi Santoso on 5/23/18.
//  Copyright © 2018 MPMFinance. All rights reserved.
//

#import "MessageTableViewCell.h"
@interface MessageTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblDot;
@property (weak, nonatomic) IBOutlet UILabel *lblDateTime;

@end
@implementation MessageTableViewCell
//{
//    "id": 33,
//    "idPengajuan": 682,
//    "isiPesan": "Nomor registrasi M818180500022 dengan kode pos 11530 belum termapping pada marketing produk Property",
//    "ket": 12,
//    "isRead": 1,
//    "date": "23-05-2018 04:39:34",
//    "title": "Marketing Tidak Terdaftar"
//}
- (void) setupWith:(NSDictionary*)data {
    if ([data[@"isRead"] isEqual:@1]) {
        [self.lblDot setHidden:YES];
    } else {
        [self.lblDot setHidden:NO];
    }
    self.lblStatus.text = data[@"title"];
    self.lblDateTime.text = data[@"date"];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
