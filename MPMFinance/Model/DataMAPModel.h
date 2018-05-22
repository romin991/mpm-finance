//
//  DataMAPModel.h
//  MPMFinance
//
//  Created by Rudy Suharyadi on 6/6/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "List.h"

typedef enum {
    DataMAPPostTypeAplikasi,
    DataMAPPostTypePribadi,
    DataMAPPostTypePekerjaan,
    DataMAPPostTypePasangan,
    DataMAPPostTypePekerjaanPasangan,
    DataMAPPostTypeKeluarga,
    DataMAPPostTypeStrukturPembiayaan,
    DataMAPPostTypeAsuransi,
    DataMAPPostTypeAset,
    DataMAPPostTypeEmergencyContact,
    DataMAPPostTypePenjamin,
    DataMAPPostTypeMarketing,
    DataMAPPostTypeRCA,
} PostType;

@interface DataMAPModel : NSObject

+ (void)checkMAPSubmittedWithID:(NSInteger)pengajuanId completion:(void(^)(NSDictionary *response, NSError *error))block;
+ (void)getDataMAPWithID:(NSInteger)pengajuanId completion:(void(^)(NSDictionary *response, NSError *error))block;
+ (void)postDataMAPWithType:(PostType)postType dictionary:(NSDictionary *)dictionary completion:(void(^)(NSDictionary *dictionary, NSError *error))block;
+ (void)postDataMAPWithID:(NSInteger)pengajuanId completion:(void(^)(NSDictionary *dictionary, NSError *error))block;

//+ (void)postDataMAPWithDictionary:(NSDictionary *)dictionary completion:(void(^)(NSDictionary *dictionary, NSError *error))block;

@end
