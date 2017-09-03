//
//  InsuranceClaimTableViewCell.h
//  MPMFinance
//
//  Created by Rudy Suharyadi on 9/3/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InsuranceClaimTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *noKontrak;
@property (weak, nonatomic) IBOutlet UILabel *noPlat;
@property (weak, nonatomic) IBOutlet UILabel *insco;
@property (weak, nonatomic) IBOutlet UILabel *tanggal;

@end
