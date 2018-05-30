//
//  ResultTableViewCell.h
//  MPMFinance
//
//  Created by Rudy Suharyadi on 30/05/18.
//  Copyright © 2018 MPMFinance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResultTableData.h"

@interface ResultTableViewCell : UITableViewCell

- (void)setupCellWithData:(ResultTableData *)data;

@end
