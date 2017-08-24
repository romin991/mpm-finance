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
                                    @"id": @882,
                                    @"value": @"Air Molek"
                                    }, @{
                                    @"id": @851,
                                    @"value": @"Balikpapan"
                                    }, @{
                                    @"id": @868,
                                    @"value": @"Banda Aceh"
                                    }, @{
                                    @"id": @844,
                                    @"value": @"Bandung"
                                    }, @{
                                    @"id": @865,
                                    @"value": @"Banjarmasin"
                                    }, @{
                                    @"id": @814,
                                    @"value": @"Batam"
                                    }, @{
                                    @"id": @838,
                                    @"value": @"Bekasi"
                                    }, @{
                                    @"id": @881,
                                    @"value": @"Bengkulu"
                                    }, @{
                                    @"id": @886,
                                    @"value": @"Berau"
                                    }, @{
                                    @"id": @813,
                                    @"value": @"Blitar"
                                    }, @{
                                    @"id": @841,
                                    @"value": @"Bogor"
                                    }, @{
                                    @"id": @818,
                                    @"value": @"Bojonegoro"
                                    }, @{
                                    @"id": @888,
                                    @"value": @"Bone"
                                    }, @{
                                    @"id": @866,
                                    @"value": @"Bukittinggi"
                                    }, @{
                                    @"id": @840,
                                    @"value": @"Cempaka Mas"
                                    }, @{
                                    @"id": @898,
                                    @"value": @"Cikarang"
                                    }, @{
                                    @"id": @896,
                                    @"value": @"Cilegon"
                                    }, @{
                                    @"id": @856,
                                    @"value": @"Cirebon"
                                    }, @{
                                    @"id": @850,
                                    @"value": @"Denpasar"
                                    }, @{
                                    @"id": @875,
                                    @"value": @"Depok"
                                    }, @{
                                    @"id": @872,
                                    @"value": @"Duri"
                                    }, @{
                                    @"id": @816,
                                    @"value": @"Gianyar"
                                    }, @{
                                    @"id": @879,
                                    @"value": @"Gorontalo"
                                    }, @{
                                    @"id": @817,
                                    @"value": @"Gresik"
                                    }, @{
                                    @"id": @863,
                                    @"value": @"Jambi"
                                    }, @{
                                    @"id": @805,
                                    @"value": @"Jember"
                                    }, @{
                                    @"id": @873,
                                    @"value": @"Karawang"
                                    }, @{
                                    @"id": @862,
                                    @"value": @"Kediri"
                                    }, @{
                                    @"id": @839,
                                    @"value": @"Kedoya"
                                    }, @{
                                    @"id": @878,
                                    @"value": @"Kendari"
                                    }, @{
                                    @"id": @829,
                                    @"value": @"Kepanjen"
                                    }, @{
                                    @"id": @890,
                                    @"value": @"Kotawaringin"
                                    }, @{
                                    @"id": @824,
                                    @"value": @"Kupang "
                                    }, @{
                                    @"id": @864,
                                    @"value": @"Lampung"
                                    }, @{
                                    @"id": @893,
                                    @"value": @"Lampung Tengah"
                                    }, @{
                                    @"id": @806,
                                    @"value": @"Madiun"
                                    }, @{
                                    @"id": @853,
                                    @"value": @"Makassar"
                                    }, @{
                                    @"id": @849,
                                    @"value": @"Malang"
                                    }, @{
                                    @"id": @854,
                                    @"value": @"Manado"
                                    }, @{
                                    @"id": @876,
                                    @"value": @"Mataram"
                                    }, @{
                                    @"id": @843,
                                    @"value": @"Medan"
                                    }, @{
                                    @"id": @820,
                                    @"value": @"Mojokerto"
                                    }, @{
                                    @"id": @895,
                                    @"value": @"Muara Bungo"
                                    }, @{
                                    @"id": @857,
                                    @"value": @"Padang"
                                    }, @{
                                    @"id": @887,
                                    @"value": @"Palangkaraya"
                                    }, @{
                                    @"id": @858,
                                    @"value": @"Palembang"
                                    }, @{
                                    @"id": @885,
                                    @"value": @"Palopo"
                                    }, @{
                                    @"id": @884,
                                    @"value": @"Palu"
                                    }, @{
                                    @"id": @871,
                                    @"value": @"Panam"
                                    }, @{
                                    @"id": @830,
                                    @"value": @"Pandaan"
                                    }, @{
                                    @"id": @867,
                                    @"value": @"Pangkal Pinang"
                                    }, @{
                                    @"id": @834,
                                    @"value": @"Pare"
                                    }, @{
                                    @"id": @892,
                                    @"value": @"Paser"
                                    }, @{
                                    @"id": @815,
                                    @"value": @"Pasuruan"
                                    }, @{
                                    @"id": @848,
                                    @"value": @"Pekanbaru"
                                    }, @{
                                    @"id": @859,
                                    @"value": @"Pematang Siantar"
                                    }, @{
                                    @"id": @897,
                                    @"value": @"Pontianak"
                                    }, @{
                                    @"id": @812,
                                    @"value": @"Praya"
                                    }, @{
                                    @"id": @870,
                                    @"value": @"Probolinggo"
                                    }, @{
                                    @"id": @877,
                                    @"value": @"Purwokerto"
                                    }, @{
                                    @"id": @860,
                                    @"value": @"Rantau Prapat"
                                    }, @{
                                    @"id": @835,
                                    @"value": @"Rawamangun"
                                    }, @{
                                    @"id": @894,
                                    @"value": @"Rokan Hilir"
                                    }, @{
                                    @"id": @852,
                                    @"value": @"Samarinda"
                                    }, @{
                                    @"id": @883,
                                    @"value": @"Sampit"
                                    }, @{
                                    @"id": @891,
                                    @"value": @"Sangatta"
                                    }, @{
                                    @"id": @811,
                                    @"value": @"Selong"
                                    }, @{
                                    @"id": @845,
                                    @"value": @"Semarang"
                                    }, @{
                                    @"id": @855,
                                    @"value": @"Serpong"
                                    }, @{
                                    @"id": @807,
                                    @"value": @"Sidoarjo"
                                    }, @{
                                    @"id": @821,
                                    @"value": @"Singaraja"
                                    }, @{
                                    @"id": @825,
                                    @"value": @"Soe"
                                    }, @{
                                    @"id": @846,
                                    @"value": @"Solo"
                                    }, @{
                                    @"id": @889,
                                    @"value": @"Solok"
                                    }, @{
                                    @"id": @874,
                                    @"value": @"Sukabumi"
                                    }, @{
                                    @"id": @842,
                                    @"value": @"Surabaya"
                                    }, @{
                                    @"id": @809,
                                    @"value": @"Tabanan"
                                    }, @{
                                    @"id": @836,
                                    @"value": @"Tangerang"
                                    }, @{
                                    @"id": @828,
                                    @"value": @"Tanjung"
                                    }, @{
                                    @"id": @808,
                                    @"value": @"Tulungagung"
                                    }, @{
                                    @"id": @880,
                                    @"value": @"Ujung Batu"
                                    }, @{
                                    @"id": @827,
                                    @"value": @"Waikabubak"
                                    }, @{
                                    @"id": @826,
                                    @"value": @"Waingapu"
                                    }, @{
                                    @"id": @847,
                                    @"value": @"Yogyakarta"
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
