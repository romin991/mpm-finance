//
//  PostalCodeTableViewCell.h
//  MPMFinance
//
//  Created by Rudy Suharyadi on 7/9/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostalCodeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *postalCode;
@property (weak, nonatomic) IBOutlet UILabel *subDistrict;
@property (weak, nonatomic) IBOutlet UILabel *district;
@property (weak, nonatomic) IBOutlet UILabel *city;

@end
