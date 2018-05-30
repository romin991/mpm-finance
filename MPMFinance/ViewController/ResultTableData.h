//
//  ResultTableData.h
//  MPMFinance
//
//  Created by Rudy Suharyadi on 30/05/18.
//  Copyright © 2018 MPMFinance. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    ResultTableDataTypeHeader,
    ResultTableDataTypeBold,
    ResultTableDataTypeRightTextAlignmentLeft,
    ResultTableDataTypeSummary,
    ResultTableDataTypeNormal,
} ResultTableDataType;

@interface ResultTableData : NSObject

@property NSString *leftString;
@property NSString *middleString;
@property NSString *rightString;
@property ResultTableDataType type;

@end
