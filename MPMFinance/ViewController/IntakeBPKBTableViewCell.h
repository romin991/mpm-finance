//
//  IntakeBPKBTableViewCell.h
//  MPMFinance
//
//  Created by Rudy Suharyadi on 9/3/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntakeBPKBTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *noKontrak;
@property (weak, nonatomic) IBOutlet UILabel *nama;
@property (weak, nonatomic) IBOutlet UILabel *statusKontrak;
@property (weak, nonatomic) IBOutlet UILabel *pengambilanDocument;

@end
