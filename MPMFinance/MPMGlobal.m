//
//  MPMGlobal.m
//  MPMFinance
//
//  Created by Romin Adi Santoso on 5/10/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "MPMGlobal.h"
#import <AFHTTPSessionManager.h>
#import "ISO8601DateFormatter.h"

@implementation MPMGlobal


NSString *const kAPIKey = @"AIzaSyCx8uLneXfyNKCV8emCWt-AD4V1kPgrHJw";

NSString *const kRoleCustomer = @"Customer";
NSString *const kRoleAgent = @"Agent";
NSString *const kRoleDealer = @"Dealer";
NSString *const kRoleSupervisor = @"Supervisor";
NSString *const kRoleOfficer = @"Officer";
NSString *const kRoleDedicated = @"Dedicated";
NSString *const kNoRole = @"NotLogin";


NSString *const kMenuListWorkOrder = @"List Work Order";
NSString *const kMenuOnlineSubmission = @"Online Submission";
NSString *const kMenuTrackingMarketing = @"Tracking Marketing";
NSString *const kMenuCalculatorMarketing = @"Calculator Marketing";
NSString *const kMenuListMap = @"List Map";
NSString *const kMenuListSurvey = @"List Survey";
NSString *const kMenuDashboard = @"Dashboard";
NSString *const kMenuContactUs = @"Contact Us";
NSString *const kMenuProduct = @"Product";
NSString *const kMenuPengajuanKembali = @"Pengajuan Kembali";
NSString *const kMenuHistoryTransaksi = @"History Transaksi";
NSString *const kMenuLegalisirFCBPKB = @"Legalisir FC BPKB";
NSString *const kMenuKlaimAsuransi = @"Klaim Asuransi";
NSString *const kMenuCreditSimulation = @"Credit Simulation";
NSString *const kMenuPelunasanDipercepat = @"Pelunasan Dipercepat";
NSString *const kMenuPengembalianBPKB = @"Pengembalian BPKB";
NSString *const kMenuSaranPengaduan = @"Saran & Pengaduan";
NSString *const kMenuCustomerGetCustomer = @"Customer Get Customer";

NSString *const kSubmenuListOnlineSubmission = @"List Online Submission API";
NSString *const kSubmenuListWorkOrder = @"List Work Order API";
NSString *const kSubmenuListMAP = @"List MAP API";
NSString *const kSubmenuListMarketing = @"List Marketing API";
NSString *const kSubmenuListSurvey = @"List Survey API";

NSString *const kSubmenuFormPengajuanApplikasi = @"Form Pengajuan Applikasi";
NSString *const kSubmenuDataMAP = @"Data MAP";
NSString *const kSubmenuSurvey = @"Survey";
NSString *const kSubmenuMelengkapiData = @"Melengkapi Data";
NSString *const kSubmenuAssignMarketing = @"Assign Marketing";
NSString *const kApiUrl = @"http://oms-api.infomedia-platform.com/mpmfinance";

NSString *const kSubmenuListPengajuanApplikasi = @"List Pengajuan Aplikasi";
NSString *const kSubmenuMonitoring = @"Monitoring";

NSString *const kSubmenuDahsyat = @"Dahsyat";
NSString *const kSubmenuUsedCar = @"Used Car";
NSString *const kSubmenuNewCar = @"New Car";
NSString *const kSubmenuNewBike = @"New Bike";
NSString *const kSubmenuDahsyat2W = @"Dahsyat 2W";
NSString *const kSubmenuDahsyat4W = @"Dahsyat 4W";
NSString *const kSubmenuProperty = @"Property";

NSString *const kSubmenuYearToDate = @"Year to Date";
NSString *const kSubmenuMonthToDate = @"Month to Date";

NSString *const kMenuTypeFormDataMAP = @"DataMAP";
NSString *const kMenuTypeFormWorkOrder = @"WorkOrder";
NSString *const kMenuTypeFormSurvey = @"Survey";
NSString *const kMenuTypeCreditSimulation = @"Credit Simulation";
NSString *const kMenuTypeContactUs = @"Contact Us";
NSString *const kMenuTypeDashboard = @"Dashboard";
NSString *const kMenuTypeList = @"List";
NSString *const kMenuTypeSubmenu = @"Submenu";
NSString *const kMenuTypeSubmenu2 = @"Submenu2";
NSString *const kMenuTypeMap = @"Map";

NSString *const kActionTypeForward = @"Forward";
NSString *const kActionTypeAPICall = @"APICall";

+(AFHTTPSessionManager*)sessionManager
{
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [manager.requestSerializer setValue:@"Basic TVBNRmluYW5jZToxbmZvbWVkaWE=" forHTTPHeaderField:@"authorization"];
    return manager;
}

+ (NSString *)encodeToBase64String:(UIImage *)image {
    return [UIImageJPEGRepresentation(image, 0.5) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

+ (UIView *)giveBorderTo:(UIView *)view withBorderColor:(NSString *)hexColorString withCornerRadius:(CGFloat)cornerRadius{
    UIColor* borderColor = [MPMGlobal colorFromHexString:hexColorString];
    return [self giveBorderTo:view withBorderColor:borderColor withCornerRadius:cornerRadius withRoundingCorners:UIRectCornerAllCorners withBorderWidth:1.0];
}
+(void)checkTokenWithCompletion:(void (^)(BOOL isExpired))block
{
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    [manager POST:[NSString stringWithFormat:@"%@/login/checktoken",kApiUrl] parameters:@{@"userid" : [MPMUserInfo getUserInfo][@"userId"],@"token" : [MPMUserInfo getToken]} progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        if (block) {
            block(NO);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ;
        if(block){
            block(YES);
        }
    }];
}

+ (UIView *)giveBorderTo:(UIView *)view withBorderColor:(UIColor *)borderColor withCornerRadius:(CGFloat)cornerRadius withRoundingCorners:(UIRectCorner)corners withBorderWidth:(CGFloat)borderWidth{
    if (corners == UIRectCornerAllCorners){
        [view.layer setMasksToBounds:YES];
        [view.layer setCornerRadius:cornerRadius];
        [view.layer setBorderWidth:borderWidth];
        [view.layer setBorderColor:[borderColor CGColor]];
        CAShapeLayer *oldLayer = [view.layer valueForKey:@"CustomLayer"];
        if (oldLayer) [oldLayer removeFromSuperlayer];
    } else {
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds
                                                       byRoundingCorners:corners
                                                             cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
        
        UIBezierPath *borderPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(view.bounds.origin.x + (borderWidth / 2), view.bounds.origin.y + (borderWidth / 2), view.bounds.size.width - borderWidth, view.bounds.size.height - borderWidth)
                                                         byRoundingCorners:corners
                                                               cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
        
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = view.bounds;
        maskLayer.path = maskPath.CGPath;
        
        CAShapeLayer *borderLayer = [CAShapeLayer layer];
        borderLayer.frame = view.bounds;
        borderLayer.path = borderPath.CGPath;
        borderLayer.strokeColor = [borderColor CGColor];
        borderLayer.lineWidth = borderWidth;
        borderLayer.fillColor = [[UIColor clearColor] CGColor];
        
        CAShapeLayer *oldLayer = [view.layer valueForKey:@"CustomLayer"];
        if (oldLayer) [oldLayer removeFromSuperlayer];
        
        [view.layer setCornerRadius:0];
        [view.layer setBorderWidth:0];
        [view.layer addSublayer:borderLayer];
        [view.layer setValue:borderLayer forKey:@"CustomLayer"];
        [view.layer setMask:maskLayer];
        [view.layer setMasksToBounds:YES];
    }
    [view.layer setShouldRasterize:YES];
    [view.layer setRasterizationScale:[UIScreen mainScreen].scale];
    return view;
}

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    if (hexString.length > 0) {
        unsigned rgbValue = 0;
        NSScanner *scanner = [NSScanner scannerWithString:hexString];
        [scanner setScanLocation:1]; // bypass '#' character
        [scanner scanHexInt:&rgbValue];
        return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
    } else {
        return [UIColor grayColor];
    }
}

+ (ISO8601DateFormatter *)getISO8601DateFormatter{
    NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:25200];
    ISO8601DateFormatter *formatter = [[ISO8601DateFormatter alloc] init];
    [formatter setDefaultTimeZone:timeZone];
    [formatter setIncludeTime:YES];
    [formatter setTimeZoneSeparator:ISO8601DefaultTimeSeparatorCharacter];
    [formatter setUseMillisecondPrecision:YES];
    
    return formatter;
}

+ (NSString *)stringFromDate:(NSDate *)object{
    ISO8601DateFormatter *formatter = [self getISO8601DateFormatter];
    NSDate *date = object;
    if (date == nil || [date isKindOfClass:[NSNull class]]) return [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:0]];
    else return [formatter stringFromDate:date];
}

+ (NSDate *)dateFromString:(NSString *)object{
    ISO8601DateFormatter *formatter = [self getISO8601DateFormatter];
    NSString *string = object;
    if (string == nil || [string isKindOfClass:[NSNull class]]) return [NSDate dateWithTimeIntervalSince1970:0];
    else return [formatter dateFromString:string];
}

+ (NSString *)MD5fromString:(NSString *)input {
    
    const char * pointer = [input UTF8String];
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(pointer, (CC_LONG)strlen(pointer), md5Buffer);
    
    NSMutableString *string = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [string appendFormat:@"%02x",md5Buffer[i]];
    
    return string;
}

@end
