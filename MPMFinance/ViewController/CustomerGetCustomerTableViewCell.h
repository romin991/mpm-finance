//
//  CustomerGetCustomerTableViewCell.h
//  MPMFinance
//
//  Created by Rudy Suharyadi on 9/3/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerGetCustomerTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nama;
@property (weak, nonatomic) IBOutlet UILabel *noHP;
@property (weak, nonatomic) IBOutlet UILabel *email;
@property (weak, nonatomic) IBOutlet UILabel *alamat;
@property (weak, nonatomic) IBOutlet UILabel *merk;
@property (weak, nonatomic) IBOutlet UILabel *tahunKendaraan;

@end
