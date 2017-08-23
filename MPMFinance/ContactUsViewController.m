//
//  ContactUsViewController.m
//  MPMFinance
//
//  Created by Romin Adi Santoso on 6/4/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "ContactUsViewController.h"
#import <GoogleMaps/GoogleMaps.h>
@interface ContactUsViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextField *txtSumberAplikasi;
@property (weak, nonatomic) IBOutlet UILabel *lblNamaCabang;
@property (weak, nonatomic) IBOutlet UILabel *lblEmail;
@property (weak, nonatomic) IBOutlet UILabel *lblAlamat;
@property (weak, nonatomic) IBOutlet UILabel *lblKodePos;
@property (weak, nonatomic) IBOutlet UILabel *lblNomorTelpon;
@property GMSMarker *marker;
@property NSArray* dataSumberAplikasi;
@property UIPickerView *pickerView;
@property NSNumber *selectedID;

@property NSString* cabangLatitude;
@property NSString* cabangLongitude;
@end

@implementation ContactUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getAllCabang];
    self.pickerView = [[UIPickerView alloc] init];
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    self.txtSumberAplikasi.inputView = self.pickerView;
    
    GMSCameraPosition *camera =
    [GMSCameraPosition cameraWithLatitude:-37.81969 longitude:144.966085 zoom:4];
    _mapView.camera = camera;
    [self addDefaultMarkers];
    // Do any additional setup after loading the view.
}
-(void)getAllCabang
{
    self.dataSumberAplikasi = @[@{
                                    @"id": @517,
                                    @"value": @"Gresik - Motor"
                                    }, @{
                                    @"id": @538,
                                    @"value": @"Bekasi - Motor"
                                    }, @{
                                    @"id": @542,
                                    @"value": @"Surabaya - Motor"
                                    }, @{
                                    @"id": @544,
                                    @"value": @"Bandung - Motor"
                                    }, @{
                                    @"id": @570,
                                    @"value": @"Probolinggo - Motor"
                                    }, @{
                                    @"id": @580,
                                    @"value": @"Ujung Batu - Motor"
                                    }, @{
                                    @"id": @582,
                                    @"value": @"AIR MOLEK - MOTOR"
                                    }, @{
                                    @"id": @583,
                                    @"value": @"SAMPIT - MOTOR"
                                    }, @{
                                    @"id": @587,
                                    @"value": @"Palangkaraya - Motor"
                                    }, @{
                                    @"id": @588,
                                    @"value": @"BONE - MOTOR"
                                    }, @{
                                    @"id": @817,
                                    @"value": @"Gresik - Mobil"
                                    }, @{
                                    @"id": @838,
                                    @"value": @"Bekasi - Mobil"
                                    }, @{
                                    @"id": @842,
                                    @"value": @"Surabaya - Mobil"
                                    }, @{
                                    @"id": @844,
                                    @"value": @"Bandung - Mobil"
                                    }, @{
                                    @"id": @870,
                                    @"value": @"Probolinggo"
                                    }, @{
                                    @"id": @880,
                                    @"value": @"Ujung Batu"
                                    }, @{
                                    @"id": @882,
                                    @"value": @"Air Molek"
                                    }, @{
                                    @"id": @883,
                                    @"value": @"Sampit"
                                    }, @{
                                    @"id": @887,
                                    @"value": @"Palangkaraya"
                                    }, @{
                                    @"id": @888,
                                    @"value": @"Bone"
                                    }];
}


#pragma mark UIPickerViewDelegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView == self.pickerView) {
        self.txtSumberAplikasi.text = self.dataSumberAplikasi[row][@"value"];
        [self getDetailForCabang:self.dataSumberAplikasi[row][@"id"]];
        
    }
}
-(void)getDetailForCabang:(NSNumber*)cabangID
{
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    NSDictionary* param = @{@"data" : @{@"kodeCabang" : cabangID},
                            @"token" : [MPMUserInfo getToken]? [MPMUserInfo getToken] : @"",
                            @"userid" : [MPMUserInfo getUserInfo]?  [MPMUserInfo getUserInfo][@"id"] : @"0"};
    [manager POST:[NSString stringWithFormat:@"%@/cabang/detail",kApiUrl] parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.lblEmail.text = responseObject[@"data"][@"email"];
            self.lblNamaCabang.text = responseObject[@"data"][@"namaCabang"];
            self.lblAlamat.text = responseObject[@"data"][@"address"];
            self.lblKodePos.text = responseObject[@"data"][@"kodePos"];
            self.lblNomorTelpon.text = responseObject[@"data"][@"telp"];
            [self reloadMapsWithLat:responseObject[@"data"][@"lat"] andLon:responseObject[@"data"][@"lng"]];
            [self.view endEditing:YES];
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ;
    }];
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.dataSumberAplikasi.count;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.dataSumberAplikasi[row][@"value"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)reloadMapsWithLat:(NSString*)lat andLon:(NSString*)lon
{
    dispatch_async(dispatch_get_main_queue(), ^{
        double latitude = lat.doubleValue;
        double longitude = lon.doubleValue;
        GMSCameraPosition *camera =
        [GMSCameraPosition cameraWithLatitude:latitude longitude:longitude zoom:15];
        CLLocationCoordinate2D newLocation = CLLocationCoordinate2DMake(latitude, longitude);
        [_mapView animateToCameraPosition:camera];
        _marker.position = newLocation;
    });
}
- (void)addDefaultMarkers {
    // Add a custom 'glow' marker around Sydney.
    _marker = [[GMSMarker alloc] init];
    _marker.title = @"MPM Office!";
    _marker.position = CLLocationCoordinate2DMake(-33.8683, 151.2086);
    _marker.map = _mapView;
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
