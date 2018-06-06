//
//  MPMGlobal.m
//  MPMFinance
//
//  Created by Romin Adi Santoso on 5/10/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "MPMGlobal.h"
#import <AFHTTPSessionManager.h>

@implementation MPMGlobal

//NSString *const kApiUrl = @"http://202.152.10.90:8080/mpmfinancev2"; //prod
NSString *const kApiUrl = @"http://202.152.10.91:8080/mpmfinancev2"; //dev
NSString *const kMPMUrl = @"https://www.mpm-finance.com";
NSString *const kAPIKey = @"AIzaSyCx8uLneXfyNKCV8emCWt-AD4V1kPgrHJw";

NSString *const kRoleCustomer = @"Customer";
NSString *const kRoleAgent = @"Agent";
NSString *const kRoleDealer = @"Dealer";
NSString *const kRoleSupervisor = @"Supervisor";
NSString *const kRoleBM = @"BM";
NSString *const kRoleOfficer = @"Officer";
NSString *const kRoleDedicated = @"Dedicated";
NSString *const kNoRole = @"NotLogin";

NSString *const kMenuListWorkOrder = @"List Work Order";
NSString *const kMenuOnlineSubmission = @"Online Submission";
NSString *const kMenuTrackingMarketing = @"Tracking Officer";
NSString *const kMenuMonitoring = @"Monitoring";
NSString *const kMenuCalculatorMarketing = @"Calculator Marketing";
NSString *const kMenuListMap = @"List Map";
NSString *const kMenuListSurvey = @"List Survey";
NSString *const kMenuDashboard = @"Dashboard";
NSString *const kMenuContactUs = @"Contact Us";
NSString *const kMenuProduct = @"Product";
NSString *const kMenuTopUp = @"Top Up";
NSString *const kMenuHistoryTransaksi = @"Aktivitas Transaksi";
NSString *const kMenuLegalisirFCBPKB = @"Legalisir FC BPKB";
NSString *const kMenuKlaimAsuransi = @"Klaim Asuransi";
NSString *const kMenuCreditSimulation = @"Credit Simulation";
NSString *const kMenuPelunasanDipercepat = @"Pelunasan Dipercepat";
NSString *const kMenuPengembalianBPKB = @"Pengembalian BPKB";
NSString *const kMenuSaranPengaduan = @"Saran & Pengaduan";
NSString *const kMenuCustomerGetCustomer = @"Customer Get Customer";
NSString *const kMenuSetAlternate = @"Set Alternate";
NSString *const kSubmenuListMonitoring = @"List Monitoring API";
NSString *const kSubmenuListOnlineSubmission = @"List Online Submission API";
NSString *const kSubmenuListWorkOrder = @"List Work Order API";
NSString *const kSubmenuListMAP = @"List MAP API";
NSString *const kSubmenuListMarketing = @"List Marketing API";
NSString *const kSubmenuListSurvey = @"List Survey API";
NSString *const kSubmenuListWorkOrderHistory = @"List Work Order History API";
NSString *const kSubmenuListTopUp = @"List Top Up API";
NSString *const kSubmenuListLegalisirBPKB = @"List Legalisir BPKB API";
NSString *const kSubmenuListKlaimAsuransi = @"List Klaim Asuransi API";
NSString *const kSubmenuListPengambilanBPKB = @"List Pengambilan BPKB API";
NSString *const kSubmenuListSaranPengaduan = @"List Saran & Pengaduan API";
NSString *const kSubmenuListCustomerGetCustomer = @"List Customer Get Customer API";

NSString *const kSubmenuFormPengajuanApplikasi = @"Form Pengajuan Applikasi";

NSString *const kSubmenuDataMAP = @"Data MAP";
NSString *const kSubmenuSurvey = @"Survey";
NSString *const kSubmenuMelengkapiData = @"Melengkapi Data";
NSString *const kSubmenuAssignMarketing = @"Assign Marketing";

NSString *const kSubmenuListPengajuanApplikasi = @"List Pengajuan Aplikasi";
NSString *const kSubmenuMonitoring = @"Monitoring ";

NSString *const kSubmenuDahsyat = @"Dahsyat";
NSString *const kSubmenuUsedCar = @"Used Car";
NSString *const kSubmenuNewCar = @"New Car";

NSString *const kSubmenuCreditSimulationNewBike = @"Credit Simulation New Bike";
NSString *const kSubmenuCreditSimulationUsedCar = @"Credit Simulation Used Car";
NSString *const kSubmenuCreditSimulationNewCar = @"Credit Simulation New Car";
NSString *const kSubmenuCreditSimulationDahsyat2W = @"Credit Simulation Dahsyat 2W";
NSString *const kSubmenuCreditSimulationDahsyat4W = @"Credit Simulation Dahsyat 4W";
NSString *const kSubmenuCreditSimulationProperty = @"Credit Simulation Property";

NSString *const kSubmenuTopUp = @"Top Up Submenu";
NSString *const kSubmenuHistoryTopUp = @"History of Top Up";

NSString *const kSubmenuLegalizationBPKB = @"Legalization of BPKB";
NSString *const kSubmenuHistoryBPKB = @"History of BPKB";

NSString *const kSubmenuInsuranceClaimForm = @"Insurance Claim Form";
NSString *const kSubmenuHistoryInsuranceClaim = @"History of Insurance Claim";

NSString *const kSubmenuPengambilanBPKB = @"Pengambilan BPKB";
NSString *const kSubmenuHistoryPengambilanBPKB = @"History pengambilan BPKB";

NSString *const kSubmenuSaranPengaduan = @"Saran dan Pengaduan";
NSString *const kSubmenuHistorySaranPengaduan = @"History Saran dan Pengaduan";

NSString *const kSubmenuCustomerGetCustomer = @"Form Customer Get Customer";
NSString *const kSubmenuHistoryCustomerGetCustomer = @"History Customer Get Customer";

NSString *const kSubmenuYearToDate = @"Year to Date";
NSString *const kSubmenuMonthToDate = @"Month to Date";

NSString *const kMenuTypeTrackingMarketing = @"TrackingMarketing";
NSString *const kMenuTypeFormUsedCar = @"UsedCar";
NSString *const kMenuTypeFormNewCar = @"NewCar";
NSString *const kMenuTypeFormDahsyat = @"Dahsyat";
NSString *const kMenuTypeFormDataMAP = @"DataMAP";
NSString *const kMenuTypeFormWorkOrder = @"WorkOrder";
NSString *const kMenuTypeFormSurvey = @"Survey";
NSString *const kMenuTypeFormTopUp = @"TopUp";
NSString *const kMenuTypeFormLegalizationBPKB = @"LegalizationBPKB";
NSString *const kMenuTypeFormInsuranceClaim = @"InsuranceClaim";
NSString *const kMenuTypeFormPengambilanBPKB = @"PengambilanBPKB";
NSString *const kMenuTypeFormSaranPengaduan = @"SaranPengaduan";
NSString *const kMenuTypeFormCustomerGetCustomer = @"CustomerGetCustomer";
NSString *const kMenuTypeCreditSimulation = @"Credit Simulation";

NSString *const kMenuTypeListTopUp = @"List TopUp";
NSString *const kMenuTypeListLegalizationBPKB = @"List LegalizationBPKB";
NSString *const kMenuTypeListInsuranceClaim = @"List InsuranceClaim";
NSString *const kMenuTypeListPengambilanBPKB = @"List PengambilanBPKB";
NSString *const kMenuTypeListSaranPengaduan = @"List SaranPengaduan";
NSString *const kMenuTypeListCustomerGetCustomer = @"List CustomerGetCustomer";

NSString *const kMenuTypeContactUs = @"Contact Us";
NSString *const kMenuTypeHistory = @"History";
NSString *const kMenuTypeAcceleratedRepayment = @"AcceleratedRepayment";
NSString *const kMenuTypeDashboard = @"Dashboard";
NSString *const kMenuTypeList = @"List";
NSString *const kMenuTypeListWorkOrder = @"List Work Order";
NSString *const kMenuTypeListAssignMarketing = @"List Assign Marketing";
NSString *const kMenuTypeSubmenu = @"Submenu";
NSString *const kMenuTypeSubmenu2 = @"Submenu2";
NSString *const kMenuTypeMap = @"Map";
NSString *const kMenuTypeSetAlternate = @"Set Alternate";

NSString *const kActionTypeForward = @"Forward";
NSString *const kActionTypeAPICall = @"APICall";
NSString *const kActionQueryDB = @"QueryDB";
+ (NSInteger)limitPerPage{
    return 50;
}

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

+ (UIImage *)decodeFromBase64String:(NSString *)string{
    return [[UIImage alloc] initWithData:[[NSData alloc] initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters]];
}

+ (BOOL)isStringAnURL:(NSString *)string{
    return ([string hasPrefix:@"http://"] || [string hasPrefix:@"https://"]);
}

+ (UIView *)giveBorderTo:(UIView *)view withBorderColor:(NSString *)hexColorString withCornerRadius:(CGFloat)cornerRadius{
    UIColor* borderColor = [MPMGlobal colorFromHexString:hexColorString];
    return [self giveBorderTo:view withBorderColor:borderColor withCornerRadius:cornerRadius withRoundingCorners:UIRectCornerAllCorners withBorderWidth:1.0];
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
    [formatter setUseMillisecondPrecision:NO];
    
    return formatter;
}

+ (NSString *)removeTimeFromString:(NSString *)object{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"dd-MM-yyyy";
    if (object == nil || [object isKindOfClass:[NSNull class]]) return object;
    NSDate *date = [formatter dateFromString:object];
    return [formatter stringFromDate:date];
}

+ (NSString *)stringFromDate:(NSDate *)object{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"dd-MM-yyyy";
    NSDate *date = object;
    if (date == nil || [date isKindOfClass:[NSNull class]]) return [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:0]];
    else return [formatter stringFromDate:date];
}

+ (NSDate *)dateFromString:(NSString *)object{
   // ISO8601DateFormatter *formatter = [self getISO8601DateFormatter];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"dd-MM-yyyy";
    NSString *string = object;
    if (string == nil || [string isKindOfClass:[NSNull class]])
        return [NSDate dateWithTimeIntervalSince1970:0];
    else
        return [formatter dateFromString:string];
}
+ (NSDate *)dateTimeFromString:(NSString *)object{
    // ISO8601DateFormatter *formatter = [self getISO8601DateFormatter];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"dd-MM-yyyy HH:mm:ss";
    NSString *string = object;
    if (string == nil || [string isKindOfClass:[NSNull class]])
        return [NSDate dateWithTimeIntervalSince1970:0];
    else
        return [formatter dateFromString:string];
}
+ (NSString *)stringFromDateTime:(NSDate *)object{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"dd-MM-yyyy HH:mm:ss";
    NSDate *date = object;
    if (date == nil || [date isKindOfClass:[NSNull class]]) return [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:0]];
    else return [formatter stringFromDate:date];
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

+ (UIImage *)barcodeFromString:(NSString *)string size:(CGSize)outputSize{
    NSData *data = [string dataUsingEncoding:NSASCIIStringEncoding];
    CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    [filter setValue:data forKey:@"inputMessage"];
    
    CIImage *image = filter.outputImage;
    CGRect rect = CGRectIntegral(image.extent);
    
    CGAffineTransform transform = CGAffineTransformMakeScale(outputSize.width / rect.size.width, outputSize.height / rect.size.height);
    CIImage *output = [filter.outputImage imageByApplyingTransform: transform];
    
    return [UIImage imageWithCIImage:output];
}

+ (UIImage *)qrCodeFromString:(NSString *)string size:(CGSize)outputSize{
    NSData *data = [string dataUsingEncoding:NSISOLatin1StringEncoding]; // recommended encoding
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setValue:data forKey:@"inputMessage"];
    [filter setValue:@"M" forKey:@"inputCorrectionLevel"];
    
    CIImage *image = filter.outputImage;
    CGRect rect = CGRectIntegral(image.extent);
    
    CGAffineTransform transform = CGAffineTransformMakeScale(outputSize.width / rect.size.width, outputSize.height / rect.size.height);
    CIImage *output = [filter.outputImage imageByApplyingTransform: transform];
    
    return [UIImage imageWithCIImage:output];
}

+ (NSString *)formatToMoney:(NSNumber *)charge{
    
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    [nf setGroupingSeparator:@"."];
    nf.usesGroupingSeparator = YES;
    nf.numberStyle = NSNumberFormatterDecimalStyle;
    [nf setMaximumFractionDigits:0];
    nf.roundingMode = NSNumberFormatterRoundHalfUp;
    return [nf stringFromNumber:charge];
}
@end
