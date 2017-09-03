//
//  ComplainTableViewCell.h
//  MPMFinance
//
//  Created by Rudy Suharyadi on 9/3/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComplainTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *noKontrak;
@property (weak, nonatomic) IBOutlet UILabel *tanggal;
@property (weak, nonatomic) IBOutlet UILabel *nama;
@property (weak, nonatomic) IBOutlet UILabel *noTelp;
@property (weak, nonatomic) IBOutlet UILabel *noTelpBaru;
@property (weak, nonatomic) IBOutlet UILabel *noHP;
@property (weak, nonatomic) IBOutlet UILabel *noHPBaru;
@property (weak, nonatomic) IBOutlet UILabel *email;
@property (weak, nonatomic) IBOutlet UILabel *alamat;
@property (weak, nonatomic) IBOutlet UILabel *kategoriMasalah;
@property (weak, nonatomic) IBOutlet UILabel *kronologiMasalah;
@property (weak, nonatomic) IBOutlet UILabel *penjelasanMasalah;

@end
