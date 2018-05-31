//
//  ResultTableData.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 30/05/18.
//  Copyright © 2018 MPMFinance. All rights reserved.
//

#import "ResultTableData.h"

@implementation ResultTableData

+ (ResultTableData *)addDataWithLeft:(NSString *)left middle:(NSString *)middle right:(NSString *)right type:(ResultTableDataType)type{
    ResultTableData *data;
    @try {
        data = [[ResultTableData alloc] init];
        data.leftString = left;
        data.middleString = middle;
        data.rightString = right;
        data.type = type;
        
    } @catch(NSException *exception) {
        NSLog(@"%@", exception);
    }
    
    return data;
}

@end
