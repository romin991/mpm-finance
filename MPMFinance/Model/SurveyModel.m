//
//  SurveyModel.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 6/7/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "SurveyModel.h"

@implementation SurveyModel

+ (void)getListSurveySince:(NSInteger)offset completion:(void(^)(NSArray *lists, NSError *error))block{
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    NSDictionary* param = @{@"userid" : [MPMUserInfo getUserInfo][@"userId"],
                            @"token" : [MPMUserInfo getToken],
                            @"data" : @{@"status" : @"listSurveyDraff",
                                        @"limit" : @([MPMGlobal limitPerPage]),
                                        @"offset" : @(offset)}};
    NSLog(@"%@",param);
    [manager POST:[NSString stringWithFormat:@"%@/datamap/getworkorder", kApiUrl] parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @try {
            NSInteger code = [[responseObject objectForKey:@"statusCode"] integerValue];
            NSString *message = [responseObject objectForKey:@"message"];
            if (code == 200) {
                NSMutableArray *lists = [NSMutableArray array];
                for (NSDictionary* listDict in responseObject[@"data"]) {
                    List *list = [[List alloc] init];
                    list.primaryKey = [listDict[@"id"] integerValue];
                    list.title = listDict[@"noRegistrasi"];
                    list.date = listDict[@"tanggal"];
                    list.assignee = listDict[@"namaPengaju"];
                    list.status = listDict[@"status"];
                    list.type = listDict[@"tipeProduk"];
                    list.statusColor = listDict[@"color"];
                    list.imageURL = listDict[@"imageIconIos"];
                    [lists addObject:list];
                }
                
                if (block) block(lists, nil);
                
            } else {
                if (block) block(nil, [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier]
                                                          code:code
                                                      userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(message, nil)}]);
            }
            
        } @catch (NSException *exception) {
            NSLog(@"%@", exception);
            if (block) block(nil, [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier]
                                                      code:1
                                                  userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(exception.reason, nil)}]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        if (block) block(nil, error);
        
    }];
}

+ (void)getSurveyWithID:(NSInteger)pengajuanId completion:(void(^)(NSDictionary *dictionary, NSError *error))block{
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    NSDictionary* param = @{@"userid" : [MPMUserInfo getUserInfo][@"userId"],
                            @"token" : [MPMUserInfo getToken],
                            @"data" : @{@"dataPengajuanId" : @(pengajuanId)}
                            };
    
    [manager POST:[NSString stringWithFormat:@"%@/survey/detail", kApiUrl] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @try {
            NSInteger code = [[responseObject objectForKey:@"statusCode"] integerValue];
            NSString *message = [responseObject objectForKey:@"message"];
            if (code == 200) {
                NSDictionary *data = [responseObject objectForKey:@"data"];
                NSDictionary *informanSurvey = [data objectForKey:@"informanSurvey"][0];
                NSDictionary *dictionary = @{@"namaCalonDebitur" : [data objectForKey:@"namaCablon"],
                                             @"tanggalSurvey" : [data objectForKey:@"tglSurvey"],
                                             @"namaSurveyor" : [data objectForKey:@"namaSurveyor"],
                                             @"penjelasan" : [data objectForKey:@"ketSurvey"],
                                             
//                                             @"nama" : [informanSurvey objectForKey:@"namaInforman"],
                                             @"hubungan" : [informanSurvey objectForKey:@"hubungan"],
                                             @"kebenaranDomisili" : [informanSurvey objectForKey:@"kebenaranDomisili"],
                                             @"keteranganDomisili" : [informanSurvey objectForKey:@"ketDomisili"],
                                             @"statusKepemilikanRumah" : [informanSurvey objectForKey:@"statusRmh"],
                                             @"lamaTinggal" : [informanSurvey objectForKey:@"lamaTinggal"],
                                             @"jumlahOrang" : [informanSurvey objectForKey:@"jmlOrgTglDirmh"],
                                             @"tambahan" : [informanSurvey objectForKey:@"ketDomisili"],
                                             
                                             @"jumlahLantaiRumah" : [data objectForKey:@"jmlLantaiRmh"],
                                             @"fasilitasRumah" : [data objectForKey:@"fasilitasRumah"],
                                             @"aksesJalanMasuk" : [data objectForKey:@"aksesJlnMsk"],
                                             @"kepemilikanGarasi" : [data objectForKey:@"adaGarasi"],
                                             @"keteranganLain" : [data objectForKey:@"ketLain"],
                                             };
                
                if (block) block(dictionary, nil);
                
            } else {
                if (block) block(nil, [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier]
                                                          code:code
                                                      userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(message, nil)}]);
            }
            
        } @catch (NSException *exception) {
            NSLog(@"%@", exception);
            if (block) block(nil, [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier]
                                                      code:1
                                                  userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(exception.reason, nil)}]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) block(nil, error);
    }];
}

+ (void)postSurveyWithList:(List *)list dictionary:(NSDictionary *)dictionary completion:(void(^)(NSDictionary *dictionary, NSError *error))block{
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithDictionary:
                                  @{@"userid" :[MPMUserInfo getUserInfo][@"userId"],
                                    @"token" : [MPMUserInfo getToken]}];
    
    NSMutableDictionary *dataDictionary = [NSMutableDictionary dictionary];
    
    @try {
        [dataDictionary setObject:[dictionary objectForKey:@"localIpad"] forKey:@"server"];
        
        [param setObject:dataDictionary forKey:@"data"];
    } @catch (NSException *exception) {
        NSLog(@"%@", exception);
        if (block) block(nil, [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier]
                                                  code:1
                                              userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(exception.reason, nil)}]);
    } @finally {
        [manager POST:[NSString stringWithFormat:@"%@/survey/insert", kApiUrl] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            @try {
                NSInteger code = [[responseObject objectForKey:@"statusCode"] integerValue];
                NSString *message = [responseObject objectForKey:@"message"];
                if (code == 200) {
                    if (block) block(responseObject, nil);
                    
                } else {
                    if (block) block(nil, [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier]
                                                              code:code
                                                          userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(message, nil)}]);
                }
                
            } @catch (NSException *exception) {
                NSLog(@"%@", exception);
                if (block) block(nil, [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier]
                                                          code:1
                                                      userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(exception.reason, nil)}]);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (block) block(nil, error);
        }];
    }
}

@end
