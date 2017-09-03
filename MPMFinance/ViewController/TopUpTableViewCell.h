//
//  TopUpTableViewCell.h
//  MPMFinance
//
//  Created by Rudy Suharyadi on 9/3/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopUpTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *noKontrak;
@property (weak, nonatomic) IBOutlet UILabel *noPlat;
@property (weak, nonatomic) IBOutlet UILabel *nama;
@property (weak, nonatomic) IBOutlet UILabel *unit;
@property (weak, nonatomic) IBOutlet UILabel *harga;
@property (weak, nonatomic) IBOutlet UILabel *outstanding;
@property (weak, nonatomic) IBOutlet UILabel *jumlah;

@end
