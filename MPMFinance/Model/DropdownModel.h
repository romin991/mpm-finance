//
//  DropdownModel.h
//  MPMFinance
//
//  Created by Rudy Suharyadi on 6/6/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Option.h"
#import "PostalCode.h"
#import "Asset.h"
#import "Data.h"

@interface DropdownModel : NSObject

+ (void)getDropdownForType:(NSString *)type completion:(void(^)(NSArray *options, NSError *error))block;
+ (void)getDropdownWSType:(NSString *)type keyword:(NSString *)keyword idCabang:(NSString *)idCabang additionalURL:(NSString *)additionalURL completion:(void(^)(NSArray *datas, NSError *error))block;
+ (void)getDropdownWSType:(NSString *)type keyword:(NSString *)keyword idProduct:(NSString *)idProduct idCabang:(NSString *)idCabang additionalURL:(NSString *)additionalURL completion:(void(^)(NSArray *datas, NSError *error))block;
+ (void)getDropdownWSType:(NSString *)type keyword:(NSString *)keyword idProductOffering:(NSString *)idProductOffering idCabang:(NSString *)idCabang additionalURL:(NSString *)additionalURL completion:(void(^)(NSArray *datas, NSError *error))block;

+ (void)getDropdownWSForPostalCodeWithKeyword:(NSString *)keyword idCabang:(NSString *)idCabang completion:(void(^)(NSArray *options, NSError *error))block;
+ (void)getDropdownWSForAssetWithKeyword:(NSString *)keyword idProduct:(NSString *)idProduct idCabang:(NSString *)idCabang completion:(void(^)(NSArray *options, NSError *error))block;

@end
