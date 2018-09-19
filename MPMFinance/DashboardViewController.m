//
//  DashboardViewController.m
//  MPMFinance
//
//  Created by Romin Adi Santoso on 6/7/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "DashboardViewController.h"
#import "KATCircularProgress.h"
@interface DashboardViewController () <UIPickerViewDelegate,UIPickerViewDataSource>

@property (strong, nonatomic) IBOutlet KATCircularProgress *progressChartMonth1;
@property (weak, nonatomic) IBOutlet UIView *flagTotalNewApp;
@property (weak, nonatomic) IBOutlet UIView *flagTotalOnProgress;
@property (weak, nonatomic) IBOutlet UIView *flagTotalSubmitMap;
@property (weak, nonatomic) IBOutlet UIView *flagTotalSubmitSurvey;
@property (weak, nonatomic) IBOutlet UIView *flagTotalProcessConfins;
@property (weak, nonatomic) IBOutlet UIView *flagTotalGoLive;
@property (weak, nonatomic) IBOutlet UIView *flagTotalStopProcess;
@property (weak, nonatomic) IBOutlet UIView *flagTotalNegativeList;
@property (weak, nonatomic) IBOutlet UIView *flagTotalWaitingGetData;

@property (weak, nonatomic) IBOutlet UILabel *txtTotalNewApp;
@property (weak, nonatomic) IBOutlet UILabel *txtTotalOnProgress;
@property (weak, nonatomic) IBOutlet UILabel *txtTotalSubmitMap;
@property (weak, nonatomic) IBOutlet UILabel *txtTotalSubmitSurvey;
@property (weak, nonatomic) IBOutlet UILabel *txtTotalProcessConfins;
@property (weak, nonatomic) IBOutlet UILabel *txtTotalGoLive;
@property (weak, nonatomic) IBOutlet UILabel *txtTotalStopProcess;
@property (weak, nonatomic) IBOutlet UILabel *txtTotalNegativeList;
@property (weak, nonatomic) IBOutlet UILabel *txtTotalWaitingGetData;

@property (weak, nonatomic) IBOutlet UILabel *txtJumlahBulan;


//tahun
@property (strong, nonatomic) IBOutlet KATCircularProgress *progressChartYear;
@property (weak, nonatomic) IBOutlet UIView *flagTotalNewApp2;
@property (weak, nonatomic) IBOutlet UIView *flagTotalOnProgress2;
@property (weak, nonatomic) IBOutlet UIView *flagTotalSubmitMap2;
@property (weak, nonatomic) IBOutlet UIView *flagTotalSubmitSurvey2;
@property (weak, nonatomic) IBOutlet UIView *flagTotalProcessConfins2;
@property (weak, nonatomic) IBOutlet UIView *flagTotalGoLive2;
@property (weak, nonatomic) IBOutlet UIView *flagTotalStopProcess2;
@property (weak, nonatomic) IBOutlet UIView *flagTotalNegativeList2;
@property (weak, nonatomic) IBOutlet UIView *flagTotalWaitingGetData2;

@property (weak, nonatomic) IBOutlet UILabel *txtTotalNewApp2;
@property (weak, nonatomic) IBOutlet UILabel *txtTotalOnProgress2;
@property (weak, nonatomic) IBOutlet UILabel *txtTotalSubmitMap2;
@property (weak, nonatomic) IBOutlet UILabel *txtTotalSubmitSurvey2;
@property (weak, nonatomic) IBOutlet UILabel *txtTotalProcessConfins2;
@property (weak, nonatomic) IBOutlet UILabel *txtTotalGoLive2;
@property (weak, nonatomic) IBOutlet UILabel *txtTotalStopProcess2;
@property (weak, nonatomic) IBOutlet UILabel *txtTotalNegativeList2;
@property (weak, nonatomic) IBOutlet UILabel *txtTotalWaitingGetData2;

@property (weak, nonatomic) IBOutlet UILabel *txtJumlahTahun;

//sumber aplikasi
@property (weak, nonatomic) IBOutlet UIView *flagTotalByCustomer;
@property (weak, nonatomic) IBOutlet UIView *flagTotalByDealer;
@property (weak, nonatomic) IBOutlet UIView *flagTotalByMarketing;
@property (weak, nonatomic) IBOutlet UIView *flagTotalByAgent;

@property (weak, nonatomic) IBOutlet UILabel *txtTotalByCustomer;
@property (weak, nonatomic) IBOutlet UILabel *txtTotalByDealer;
@property (weak, nonatomic) IBOutlet UILabel *txtTotalByMarketing;
@property (weak, nonatomic) IBOutlet UILabel *txtTotalByAgent;

@property (weak, nonatomic) IBOutlet UILabel *txtJumlahBulanSumberAplikasi;
@property (strong, nonatomic) IBOutlet KATCircularProgress *progressChartMonthSumberAplikasi;

//tahun
@property (weak, nonatomic) IBOutlet UIView *flagTotalByCustomer2;
@property (weak, nonatomic) IBOutlet UIView *flagTotalByDealer2;
@property (weak, nonatomic) IBOutlet UIView *flagTotalByMarketing2;
@property (weak, nonatomic) IBOutlet UIView *flagTotalByAgent2;

@property (weak, nonatomic) IBOutlet UILabel *txtTotalByCustomer2;
@property (weak, nonatomic) IBOutlet UILabel *txtTotalByDealer2;
@property (weak, nonatomic) IBOutlet UILabel *txtTotalByMarketing2;
@property (weak, nonatomic) IBOutlet UILabel *txtTotalByAgent2;

@property (weak, nonatomic) IBOutlet UILabel *txtJumlahTahunSumberAplikasi;
@property (strong, nonatomic) IBOutlet KATCircularProgress *progressChartYearSumberAplikasi;


@property (weak, nonatomic) IBOutlet UITextField *txtTipeProduk;
@property UIPickerView *tipeProdukPicker;
@property NSMutableArray *produkArray;

@property (weak, nonatomic) IBOutlet UITextField *txtGroupLevel;
@property UIPickerView *groupLevelPicker;
@property NSMutableArray *groupLevels;

@property (weak, nonatomic) IBOutlet UITextField *txtUser;
@property UIPickerView *userPicker;
@property NSMutableArray *users;

//group level
@property (strong, nonatomic) IBOutlet KATCircularProgress *progressChartMonth2;
@property (weak, nonatomic) IBOutlet UIView *flagTotalNewApp3;
@property (weak, nonatomic) IBOutlet UIView *flagTotalOnProgress3;
@property (weak, nonatomic) IBOutlet UIView *flagTotalSubmitMap3;
@property (weak, nonatomic) IBOutlet UIView *flagTotalSubmitSurvey3;
@property (weak, nonatomic) IBOutlet UIView *flagTotalProcessConfins3;
@property (weak, nonatomic) IBOutlet UIView *flagTotalGoLive3;
@property (weak, nonatomic) IBOutlet UIView *flagTotalStopProcess3;
@property (weak, nonatomic) IBOutlet UIView *flagTotalNegativeList3;
@property (weak, nonatomic) IBOutlet UIView *flagTotalWaitingGetData3;

@property (weak, nonatomic) IBOutlet UILabel *txtTotalNewApp3;
@property (weak, nonatomic) IBOutlet UILabel *txtTotalOnProgress3;
@property (weak, nonatomic) IBOutlet UILabel *txtTotalSubmitMap3;
@property (weak, nonatomic) IBOutlet UILabel *txtTotalSubmitSurvey3;
@property (weak, nonatomic) IBOutlet UILabel *txtTotalProcessConfins3;
@property (weak, nonatomic) IBOutlet UILabel *txtTotalGoLive3;
@property (weak, nonatomic) IBOutlet UILabel *txtTotalStopProcess3;
@property (weak, nonatomic) IBOutlet UILabel *txtTotalNegativeList3;
@property (weak, nonatomic) IBOutlet UILabel *txtTotalWaitingGetData3;

@property (weak, nonatomic) IBOutlet UILabel *txtJumlahBulan2;

@property (strong, nonatomic) IBOutlet KATCircularProgress *progressChartYear2;
@property (weak, nonatomic) IBOutlet UIView *flagTotalNewApp4;
@property (weak, nonatomic) IBOutlet UIView *flagTotalOnProgress4;
@property (weak, nonatomic) IBOutlet UIView *flagTotalSubmitMap4;
@property (weak, nonatomic) IBOutlet UIView *flagTotalSubmitSurvey4;
@property (weak, nonatomic) IBOutlet UIView *flagTotalProcessConfins4;
@property (weak, nonatomic) IBOutlet UIView *flagTotalGoLive4;
@property (weak, nonatomic) IBOutlet UIView *flagTotalStopProcess4;
@property (weak, nonatomic) IBOutlet UIView *flagTotalNegativeList4;
@property (weak, nonatomic) IBOutlet UIView *flagTotalWaitingGetData4;

@property (weak, nonatomic) IBOutlet UILabel *txtTotalNewApp4;
@property (weak, nonatomic) IBOutlet UILabel *txtTotalOnProgress4;
@property (weak, nonatomic) IBOutlet UILabel *txtTotalSubmitMap4;
@property (weak, nonatomic) IBOutlet UILabel *txtTotalSubmitSurvey4;
@property (weak, nonatomic) IBOutlet UILabel *txtTotalProcessConfins4;
@property (weak, nonatomic) IBOutlet UILabel *txtTotalGoLive4;
@property (weak, nonatomic) IBOutlet UILabel *txtTotalStopProcess4;
@property (weak, nonatomic) IBOutlet UILabel *txtTotalNegativeList4;
@property (weak, nonatomic) IBOutlet UILabel *txtTotalWaitingGetData4;

@property (weak, nonatomic) IBOutlet UILabel *txtJumlahYear2;


//dealer level
@property (strong, nonatomic) IBOutlet KATCircularProgress *progressChartMonthDealer;
@property (weak, nonatomic) IBOutlet UIView *flagTotalNewAppDealerMonth;
@property (weak, nonatomic) IBOutlet UIView *flagTotalProgressOfficerDealerMonth;
@property (weak, nonatomic) IBOutlet UIView *flagTotalOfficerCompleteDealerMonth;
@property (weak, nonatomic) IBOutlet UIView *flagTotalAppSubmittedDealerMonth;
@property (weak, nonatomic) IBOutlet UIView *flagTotalContractActiveDealerMonth;
@property (weak, nonatomic) IBOutlet UIView *flagTotalAppStopDealerMonth;

@property (weak, nonatomic) IBOutlet UILabel *txtTotalNewAppDealerMonth;
@property (weak, nonatomic) IBOutlet UILabel *txtTotalProgressOfficerDealerMonth;
@property (weak, nonatomic) IBOutlet UILabel *txtTotalOfficerCompleteDealerMonth;
@property (weak, nonatomic) IBOutlet UILabel *txtTotalAppSubmittedDealerMonth;
@property (weak, nonatomic) IBOutlet UILabel *txtTotalContractActiveDealerMonth;
@property (weak, nonatomic) IBOutlet UILabel *txtTotalAppStopDealerMonth;


@property (weak, nonatomic) IBOutlet UILabel *txtJumlahBulanDealer;

@property (strong, nonatomic) IBOutlet KATCircularProgress *progressChartYearDealer;
@property (weak, nonatomic) IBOutlet UIView *flagTotalNewAppDealerYear;
@property (weak, nonatomic) IBOutlet UIView *flagTotalProgressOfficerDealerYear;
@property (weak, nonatomic) IBOutlet UIView *flagTotalOfficerCompleteDealerYear;
@property (weak, nonatomic) IBOutlet UIView *flagTotalAppSubmittedDealerYear;
@property (weak, nonatomic) IBOutlet UIView *flagTotalContractActiveDealerYear;
@property (weak, nonatomic) IBOutlet UIView *flagTotalAppStopDealerYear;

@property (weak, nonatomic) IBOutlet UILabel *txtTotalNewAppDealerYear;
@property (weak, nonatomic) IBOutlet UILabel *txtTotalProgressOfficerDealerYear;
@property (weak, nonatomic) IBOutlet UILabel *txtTotalOfficerCompleteDealerYear;
@property (weak, nonatomic) IBOutlet UILabel *txtTotalAppSubmittedDealerYear;
@property (weak, nonatomic) IBOutlet UILabel *txtTotalContractActiveDealerYear;
@property (weak, nonatomic) IBOutlet UILabel *txtTotalAppStopDealerYear;


@property (weak, nonatomic) IBOutlet UILabel *txtJumlahTahunDealer;
@property NSDictionary *selectedGroupLevel;



@end

@implementation DashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.progressChartMonth1 setLineWidth:30.0]; // Set Line thickness of the chart.
    [self.progressChartMonth1 setAnimationDuration:2.5]; // Set Animation Duration.
    [self downloadData];
    [self setupUI];
    self.tipeProdukPicker = [[UIPickerView alloc] init];
    self.tipeProdukPicker.dataSource = self;
    self.tipeProdukPicker.delegate = self;
    self.txtTipeProduk.inputView = self.tipeProdukPicker;
    
    self.groupLevelPicker = [[UIPickerView alloc] init];
    self.groupLevelPicker.dataSource = self;
    self.groupLevelPicker.delegate = self;
    self.txtGroupLevel.inputView = self.groupLevelPicker;
    
    self.userPicker = [[UIPickerView alloc] init];
    self.userPicker.dataSource = self;
    self.userPicker.delegate = self;
    self.txtUser.inputView = self.userPicker;
    // Do any additional setup after loading the view.
}
- (void) setupUI{
    self.flagTotalNewApp.backgroundColor = [UIColor cyanColor];
    self.flagTotalOnProgress.backgroundColor = [UIColor blueColor];
    self.flagTotalSubmitMap.backgroundColor = [UIColor redColor];
    self.flagTotalSubmitSurvey.backgroundColor = [UIColor grayColor];
    self.flagTotalProcessConfins.backgroundColor = [UIColor greenColor];
    self.flagTotalGoLive.backgroundColor = [UIColor purpleColor];
    self.flagTotalStopProcess.backgroundColor = [UIColor brownColor];
    self.flagTotalNegativeList.backgroundColor = [UIColor magentaColor];
    self.flagTotalWaitingGetData.backgroundColor = [UIColor orangeColor];
    self.flagTotalNewApp2.backgroundColor = [UIColor cyanColor];
    self.flagTotalOnProgress2.backgroundColor = [UIColor blueColor];
    self.flagTotalSubmitMap2.backgroundColor = [UIColor redColor];
    self.flagTotalSubmitSurvey2.backgroundColor = [UIColor grayColor];
    self.flagTotalProcessConfins2.backgroundColor = [UIColor greenColor];
    self.flagTotalGoLive2.backgroundColor = [UIColor purpleColor];
    self.flagTotalStopProcess2.backgroundColor = [UIColor brownColor];
    self.flagTotalNegativeList2.backgroundColor = [UIColor magentaColor];
    self.flagTotalWaitingGetData2.backgroundColor = [UIColor orangeColor];
    
    self.flagTotalNewApp3.backgroundColor = [UIColor cyanColor];
    self.flagTotalOnProgress3.backgroundColor = [UIColor blueColor];
    self.flagTotalSubmitMap3.backgroundColor = [UIColor redColor];
    self.flagTotalSubmitSurvey3.backgroundColor = [UIColor grayColor];
    self.flagTotalProcessConfins3.backgroundColor = [UIColor greenColor];
    self.flagTotalGoLive3.backgroundColor = [UIColor purpleColor];
    self.flagTotalStopProcess3.backgroundColor = [UIColor brownColor];
    self.flagTotalNegativeList3.backgroundColor = [UIColor magentaColor];
    self.flagTotalWaitingGetData3.backgroundColor = [UIColor orangeColor];
    
    self.flagTotalNewApp4.backgroundColor = [UIColor cyanColor];
    self.flagTotalOnProgress4.backgroundColor = [UIColor blueColor];
    self.flagTotalSubmitMap4.backgroundColor = [UIColor redColor];
    self.flagTotalSubmitSurvey4.backgroundColor = [UIColor grayColor];
    self.flagTotalProcessConfins4.backgroundColor = [UIColor greenColor];
    self.flagTotalGoLive4.backgroundColor = [UIColor purpleColor];
    self.flagTotalStopProcess4.backgroundColor = [UIColor brownColor];
    self.flagTotalNegativeList4.backgroundColor = [UIColor magentaColor];
    self.flagTotalWaitingGetData4.backgroundColor = [UIColor orangeColor];
    
    self.flagTotalByCustomer.backgroundColor = [UIColor cyanColor];
    self.flagTotalByDealer.backgroundColor = [UIColor blueColor];
    self.flagTotalByMarketing.backgroundColor = [UIColor redColor];
    self.flagTotalByAgent.backgroundColor = [UIColor grayColor];
    
    self.flagTotalByCustomer2.backgroundColor = [UIColor cyanColor];
    self.flagTotalByDealer2.backgroundColor = [UIColor blueColor];
    self.flagTotalByMarketing2.backgroundColor = [UIColor redColor];
    self.flagTotalByAgent2.backgroundColor = [UIColor grayColor];
  
  
  self.flagTotalNewAppDealerMonth.backgroundColor = [UIColor cyanColor];
  self.flagTotalProgressOfficerDealerMonth.backgroundColor = [UIColor blueColor];
  self.flagTotalOfficerCompleteDealerMonth.backgroundColor = [UIColor redColor];
  self.flagTotalAppSubmittedDealerMonth.backgroundColor = [UIColor grayColor];
  self.flagTotalContractActiveDealerMonth.backgroundColor = [UIColor greenColor];
  self.flagTotalAppStopDealerMonth.backgroundColor = [UIColor purpleColor];
  
  self.flagTotalNewAppDealerYear.backgroundColor = [UIColor cyanColor];
  self.flagTotalProgressOfficerDealerYear.backgroundColor = [UIColor blueColor];
  self.flagTotalOfficerCompleteDealerYear.backgroundColor = [UIColor redColor];
  self.flagTotalAppSubmittedDealerYear.backgroundColor = [UIColor grayColor];
  self.flagTotalContractActiveDealerYear.backgroundColor = [UIColor greenColor];
  self.flagTotalAppStopDealerYear.backgroundColor = [UIColor purpleColor];
    
}
-(void)downloadData
{
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    NSDictionary* param;
  
    
    NSString *urlString;
    if (![[MPMUserInfo getRole] isEqualToString:kRoleAgent] && ![[MPMUserInfo getRole] isEqualToString:kRoleSupervisor] && ![[MPMUserInfo getRole] isEqualToString:kRoleBM] && ![[MPMUserInfo getRole] isEqualToString:kRoleDealer]) {
        urlString = @"dropdown/produkmarketing";
        param = @{@"userid" : [MPMUserInfo getUserInfo][@"userId"],
                  @"token" : [MPMUserInfo getToken],
                  @"data" : @{}};
    } else {
        urlString = @"dasboard2/getproduct-by-userid";
        param = @{@"userid" : [MPMUserInfo getUserInfo][@"userId"],
                  @"token" : [MPMUserInfo getToken]};
    }
    
    [manager POST:[NSString stringWithFormat:@"%@/%@",kApiUrl,urlString] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.produkArray = [NSMutableArray arrayWithArray:@[@{@"id" : @0,
                               @"value" : @"All"
                               }]];
        [self.produkArray addObjectsFromArray:responseObject[@"data"]];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error.code == 611)
        {
            [SVProgressHUD showErrorWithStatus:@"You need to relogin"];
            [SVProgressHUD dismissWithDelay:1.5];
        }
    }];
    
    if ([[MPMUserInfo getRole] isEqualToString:kRoleSupervisor] || [[MPMUserInfo getRole] isEqualToString:kRoleBM]) {
        urlString = @"dasboard2/spv-list-group-level";
        param = @{@"userid" : [MPMUserInfo getUserInfo][@"userId"],
                  @"token" : [MPMUserInfo getToken]};
        [manager POST:[NSString stringWithFormat:@"%@/%@",kApiUrl,urlString] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            self.groupLevels = [NSMutableArray arrayWithArray:@[@{@"id" : @"",
                                                                  @"value" : @"All"
                                                                  }]];
            [self.groupLevels addObjectsFromArray:responseObject[@"data"]];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (error.code == 611)
            {
                [SVProgressHUD showErrorWithStatus:@"You need to relogin"];
                [SVProgressHUD dismissWithDelay:1.5];
            }
        }];
    }
    
}
- (void)addSliceItemsForProgressChart:(KATCircularProgress*)progress WithTotalReject:(NSString*)rejectString andApprove:(NSString*)approveString {
    //clear the sliceItems array
    NSLog(@"%f %f",[rejectString doubleValue],[approveString doubleValue]);
    [progress.sliceItems removeAllObjects];
    
    //Create Slice items with value and section color
    SliceItem *item1 = [[SliceItem alloc] init];
    item1.itemValue = [rejectString doubleValue]; // value should be a float value
    item1.itemColor = [UIColor redColor]; // color should be a UIColor value
    
    SliceItem *item2 = [[SliceItem alloc] init];
    item2.itemValue = [approveString doubleValue];
    item2.itemColor = [UIColor blueColor];
    
    //Add SliceItems objects to the sliceItems NSMutable array of KATProgressChart.
    [progress.sliceItems addObject:item1];
    [progress.sliceItems addObject:item2];
    [progress reloadData]; // reload the chart.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UIPickerDataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == self.tipeProdukPicker) {
        return self.produkArray.count;
    } else if (pickerView == self.groupLevelPicker) {
        return self.groupLevels.count;
    } else if (pickerView == self.userPicker) {
        return self.users.count;
    }
    else
        return 0;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == self.tipeProdukPicker) {
        return self.produkArray[row][@"value"];
    }
    else if (pickerView == self.groupLevelPicker) {
        return self.groupLevels[row][@"value"];
    }
    else if (pickerView == self.userPicker) {
        return self.users[row][@"nama"];
    }
    else
        return @"";
}

#pragma mark - UIPickerDelegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView == self.tipeProdukPicker) {
        self.txtTipeProduk.text = self.produkArray[row][@"value"];
        [self downloadMarketingByProductDataMonthForId:self.produkArray[row][@"id"]];
        [self downloadMarketingByProductDataYearForId:self.produkArray[row][@"id"]];
        [self downloadSumberAplikasiDataByMonthForId:self.produkArray[row][@"id"]];
        [self downloadSumberAplikasiDataByYearForId:self.produkArray[row][@"id"]];
    } else if (pickerView == self.groupLevelPicker) {
        self.txtGroupLevel.text = self.groupLevels[row][@"value"];
      self.selectedGroupLevel = self.groupLevels[row];
        [self downloadUserList:self.groupLevels[row][@"id"]];
    } else if (pickerView == self.userPicker) {
        self.txtUser.text = self.users[row][@"nama"];
        [self downloadMarketingProductByUserDataMonthForId:@"" groupLevel:self.selectedGroupLevel[@"id"] userId:self.users[row][@"userid"]];
        [self downloadMarketingProductByUserDataYearForId:@"" groupLevel:self.selectedGroupLevel[@"id"] userId:self.users[row][@"userid"]];
        //[self downloadUserList:self.groupLevels[row][@"id"]];
    }
    
    [self.view endEditing:YES];
}

- (void) downloadMarketingByProductDataMonthForId:(NSNumber *)produkId {
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    NSDictionary* param;
        param = @{@"userid" : [MPMUserInfo getUserInfo][@"userId"],
                  @"token" : [MPMUserInfo getToken],
                  @"data" : @{@"tipe" : @"month",
                              @"product_id" : [produkId isEqual:@0] ? @"" : produkId
                              }};
  NSString *urlString = [NSString stringWithFormat:@"%@/dasboard2/marketing-by-product",kApiUrl];
  if ([[MPMUserInfo getRole] isEqualToString:kRoleSupervisor]) {
    urlString = [NSString stringWithFormat:@"%@/dasboard2/spv-by-status-and-product",kApiUrl];
  } else if ([[MPMUserInfo getRole] isEqualToString:kRoleBM]) {
    urlString = [NSString stringWithFormat:@"%@/dasboard2/bm-by-status-and-product",kApiUrl];
  } else if ([[MPMUserInfo getRole] isEqualToString:kRoleDealer] || [[MPMUserInfo getRole] isEqualToString:kRoleAgent]) {
    urlString = [NSString stringWithFormat:@"%@/dasboard2/eksternal",kApiUrl];
  }
        [manager POST:urlString parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
            ;
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject[@"statusCode"] isEqual:@200]) {
              if (![[MPMUserInfo getRole] isEqualToString:kRoleDealer] && ![[MPMUserInfo getRole] isEqualToString:kRoleAgent]) {
                [self.progressChartMonth1.sliceItems removeAllObjects];
                 //Create Slice items with value and section color
                SliceItem *item1 = [[SliceItem alloc] init];
                item1.itemValue = [responseObject[@"data"][@"new_application_precentage"] doubleValue]; // value should be a float value
                item1.itemColor = [UIColor cyanColor]; // color should be a UIColor value
                self.flagTotalNewApp.backgroundColor = [UIColor cyanColor];
                
                SliceItem *item2 = [[SliceItem alloc] init];
                item2.itemValue = [responseObject[@"data"][@"on_proggress_precentage"] doubleValue];
                item2.itemColor = [UIColor blueColor];
                self.flagTotalOnProgress.backgroundColor = [UIColor blueColor];
                
                SliceItem *item3 = [[SliceItem alloc] init];
                item3.itemValue = [responseObject[@"data"][@"submit_map_precentage"] doubleValue];
                item3.itemColor = [UIColor redColor];
                self.flagTotalSubmitMap.backgroundColor = [UIColor redColor];
                
                SliceItem *item4 = [[SliceItem alloc] init];
                item4.itemValue = [responseObject[@"data"][@"submit_survey_precentage"] doubleValue];
                item4.itemColor = [UIColor grayColor];
                self.flagTotalSubmitSurvey.backgroundColor = [UIColor grayColor];
                
                SliceItem *item5 = [[SliceItem alloc] init];
                item5.itemValue = [responseObject[@"data"][@"proccess_confins_precentage"] doubleValue];
                item5.itemColor = [UIColor greenColor];
                self.flagTotalProcessConfins.backgroundColor = [UIColor greenColor];
                
                SliceItem *item6 = [[SliceItem alloc] init];
                item6.itemValue = [responseObject[@"data"][@"go_live_precentage"] doubleValue];
                item6.itemColor = [UIColor purpleColor];
                self.flagTotalGoLive.backgroundColor = [UIColor purpleColor];
                
                SliceItem *item7 = [[SliceItem alloc] init];
                item7.itemValue = [responseObject[@"data"][@"stop_proccess_precentage"] doubleValue];
                item7.itemColor = [UIColor brownColor];
                self.flagTotalStopProcess.backgroundColor = [UIColor brownColor];
                
                SliceItem *item8 = [[SliceItem alloc] init];
                item8.itemValue = [responseObject[@"data"][@"negative_list_precentage"] doubleValue];
                item8.itemColor = [UIColor magentaColor];
                self.flagTotalNegativeList.backgroundColor = [UIColor magentaColor];
                
                SliceItem *item9 = [[SliceItem alloc] init];
                item9.itemValue = [responseObject[@"data"][@"waiting_get_data_precentage"] doubleValue];
                item9.itemColor = [UIColor orangeColor];
                self.flagTotalWaitingGetData.backgroundColor = [UIColor orangeColor];
                
                //Add SliceItems objects to the sliceItems NSMutable array of KATProgressChart.
                [self.progressChartMonth1.sliceItems addObject:item1];
                [self.progressChartMonth1.sliceItems addObject:item2];
                [self.progressChartMonth1.sliceItems addObject:item3];
                [self.progressChartMonth1.sliceItems addObject:item4];
                [self.progressChartMonth1.sliceItems addObject:item5];
                [self.progressChartMonth1.sliceItems addObject:item6];
                [self.progressChartMonth1.sliceItems addObject:item7];
                [self.progressChartMonth1.sliceItems addObject:item8];
                [self.progressChartMonth1.sliceItems addObject:item9];
                [self.progressChartMonth1 reloadData]; // reload the chart.
                
                //todo change the correct color and change the flag color and change the label
                self.txtTotalNewApp.text = [NSString stringWithFormat:@"%@ (%@%%)",responseObject[@"data"][@"new_application_total"],responseObject[@"data"][@"new_application_precentage"] ? responseObject[@"data"][@"new_application_precentage"] : @"0.00"];
                self.txtTotalNegativeList.text = [NSString stringWithFormat:@"%@ (%@%%)",responseObject[@"data"][@"negative_list_total"],responseObject[@"data"][@"negative_list_precentage"]];
                self.txtTotalOnProgress.text = [NSString stringWithFormat:@"%@ (%@%%)",responseObject[@"data"][@"on_proggress_total"],responseObject[@"data"][@"on_proggress_precentage"]];
                self.txtTotalProcessConfins.text = [NSString stringWithFormat:@"%@ (%@%%)",responseObject[@"data"][@"proccess_confins_total"],responseObject[@"data"][@"proccess_confins_precentage"]];
                self.txtTotalStopProcess.text = [NSString stringWithFormat:@"%@ (%@%%)",responseObject[@"data"][@"stop_proccess_total"],responseObject[@"data"][@"stop_proccess_precentage"]];
                self.txtTotalSubmitMap.text = [NSString stringWithFormat:@"%@ (%@%%)",responseObject[@"data"][@"submit_map_total"],responseObject[@"data"][@"submit_map_precentage"]];
                self.txtTotalSubmitSurvey.text = [NSString stringWithFormat:@"%@ (%@%%)",responseObject[@"data"][@"submit_survey_total"],responseObject[@"data"][@"submit_survey_precentage"]];
                self.txtTotalWaitingGetData.text = [NSString stringWithFormat:@"%@ (%@%%)",responseObject[@"data"][@"waiting_get_data_total"],responseObject[@"data"][@"waiting_get_data_precentage"]];
                self.txtTotalGoLive.text = [NSString stringWithFormat:@"%@ (%@%%)",responseObject[@"data"][@"go_live_total"],responseObject[@"data"][@"go_live_precentage"]];
                
                self.txtJumlahBulan.text = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"jumlah"]];
    //            self.txtApproveTahun.text = [NSString stringWithFormat:@"Approve (%@ %%)",responseObject[@"data"][@"approve"]];
    //            self.txtRejectTahun.text = [NSString stringWithFormat:@"Reject (%@ %%)",responseObject[@"data"][@"reject"]];
              } else {
                [self.progressChartMonthDealer.sliceItems removeAllObjects];
                //Create Slice items with value and section color
                SliceItem *item1 = [[SliceItem alloc] init];
                item1.itemValue = [responseObject[@"data"][@"new_application_precentage"] doubleValue]; // value should be a float value
                item1.itemColor = [UIColor cyanColor]; // color should be a UIColor value
                self.flagTotalNewAppDealerMonth.backgroundColor = [UIColor cyanColor];
                
                SliceItem *item2 = [[SliceItem alloc] init];
                item2.itemValue = [responseObject[@"data"][@"progress_officer_precentage"] doubleValue];
                item2.itemColor = [UIColor blueColor];
                self.flagTotalProgressOfficerDealerMonth.backgroundColor = [UIColor blueColor];
                
                SliceItem *item3 = [[SliceItem alloc] init];
                item3.itemValue = [responseObject[@"data"][@"officer_complete_precentage"] doubleValue];
                item3.itemColor = [UIColor redColor];
                self.flagTotalOfficerCompleteDealerMonth.backgroundColor = [UIColor redColor];
                
                SliceItem *item4 = [[SliceItem alloc] init];
                item4.itemValue = [responseObject[@"data"][@"app_submitted_precentage"] doubleValue];
                item4.itemColor = [UIColor grayColor];
                self.flagTotalAppSubmittedDealerMonth.backgroundColor = [UIColor grayColor];
                
                SliceItem *item5 = [[SliceItem alloc] init];
                item5.itemValue = [responseObject[@"data"][@"contract_active_precentage"] doubleValue];
                item5.itemColor = [UIColor greenColor];
                self.flagTotalContractActiveDealerMonth.backgroundColor = [UIColor greenColor];
                
                SliceItem *item6 = [[SliceItem alloc] init];
                item6.itemValue = [responseObject[@"data"][@"app_stop_precentage"] doubleValue];
                item6.itemColor = [UIColor purpleColor];
                self.flagTotalAppStopDealerMonth.backgroundColor = [UIColor purpleColor];
                
                //Add SliceItems objects to the sliceItems NSMutable array of KATProgressChart.
                [self.progressChartMonthDealer.sliceItems addObject:item1];
                [self.progressChartMonthDealer.sliceItems addObject:item2];
                [self.progressChartMonthDealer.sliceItems addObject:item3];
                [self.progressChartMonthDealer.sliceItems addObject:item4];
                [self.progressChartMonthDealer.sliceItems addObject:item5];
                [self.progressChartMonthDealer.sliceItems addObject:item6];
                [self.progressChartMonthDealer reloadData]; // reload the chart.
                
                //todo change the correct color and change the flag color and change the label
                self.txtTotalNewAppDealerMonth.text = [NSString stringWithFormat:@"%@ (%@%%)",responseObject[@"data"][@"new_application_total"],responseObject[@"data"][@"new_application_precentage"] ? responseObject[@"data"][@"new_application_precentage"] : @"0.00"];
                self.txtTotalProgressOfficerDealerMonth.text = [NSString stringWithFormat:@"%@ (%@%%)",responseObject[@"data"][@"progress_officer_total"],responseObject[@"data"][@"progress_officer_precentage"]];
                self.txtTotalOfficerCompleteDealerMonth.text = [NSString stringWithFormat:@"%@ (%@%%)",responseObject[@"data"][@"officer_complete_total"],responseObject[@"data"][@"officer_complete_precentage"]];
                self.txtTotalAppSubmittedDealerMonth.text = [NSString stringWithFormat:@"%@ (%@%%)",responseObject[@"data"][@"app_submitted_total"],responseObject[@"data"][@"app_submitted_precentage"]];
                self.txtTotalContractActiveDealerMonth.text = [NSString stringWithFormat:@"%@ (%@%%)",responseObject[@"data"][@"contract_active_total"],responseObject[@"data"][@"contract_active_precentage"]];
                self.txtTotalAppStopDealerMonth.text = [NSString stringWithFormat:@"%@ (%@%%)",responseObject[@"data"][@"app_stop_total"],responseObject[@"data"][@"app_stop_precentage"]];
                
                self.txtJumlahBulanDealer.text = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"jumlah"]];
              }
            };
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            ;
        }];

    
}

- (void) downloadSumberAplikasiDataByMonthForId:(NSNumber *)produkId {
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    NSDictionary* param;
    param = @{@"userid" : [MPMUserInfo getUserInfo][@"userId"],
              @"token" : [MPMUserInfo getToken],
              @"data" : @{@"tipe" : @"month",
                          @"product_id" : [produkId isEqual:@0] ? @"" : produkId
                          }};
  NSString *urlString = [NSString stringWithFormat:@"%@/dasboard2/marketing-by-grouplevel-and-product",kApiUrl];
  if ([[MPMUserInfo getRole] isEqualToString:kRoleSupervisor]) {
    urlString =[NSString stringWithFormat:@"%@/dasboard2/spv-by-sumber-aplikasi",kApiUrl];
  }  else if ([[MPMUserInfo getRole] isEqualToString:kRoleBM]) {
    urlString =[NSString stringWithFormat:@"%@/dasboard2/bm-by-sumber-aplikasi",kApiUrl];
  }
    [manager POST:urlString parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"statusCode"] isEqual:@200]) {
            [self.progressChartMonthSumberAplikasi.sliceItems removeAllObjects];
            //Create Slice items with value and section color
            SliceItem *item1 = [[SliceItem alloc] init];
            item1.itemValue = [responseObject[@"data"][@"by_customer_precentage"] doubleValue]; // value should be a float value
            item1.itemColor = [UIColor cyanColor]; // color should be a UIColor value
            
            
            SliceItem *item2 = [[SliceItem alloc] init];
            item2.itemValue = [responseObject[@"data"][@"by_dealer_precentage"] doubleValue];
            item2.itemColor = [UIColor blueColor];
            
            
            SliceItem *item3 = [[SliceItem alloc] init];
            item3.itemValue = [responseObject[@"data"][@"by_marketing_precentage"] doubleValue];
            item3.itemColor = [UIColor redColor];
            
            SliceItem *item4 = [[SliceItem alloc] init];
            item4.itemValue = [responseObject[@"data"][@"by_agent_precentage"] doubleValue];
            item4.itemColor = [UIColor grayColor];
            
            
            //Add SliceItems objects to the sliceItems NSMutable array of KATProgressChart.
            [self.progressChartMonthSumberAplikasi.sliceItems addObject:item1];
            [self.progressChartMonthSumberAplikasi.sliceItems addObject:item2];
            [self.progressChartMonthSumberAplikasi.sliceItems addObject:item3];
            [self.progressChartMonthSumberAplikasi.sliceItems addObject:item4];
            [self.progressChartMonthSumberAplikasi reloadData]; // reload the chart.
            
            //todo change the correct color and change the flag color and change the label
            self.txtTotalByCustomer.text = [NSString stringWithFormat:@"%@ (%@%%)",responseObject[@"data"][@"by_customer_total"],responseObject[@"data"][@"by_customer_precentage"] ? responseObject[@"data"][@"by_customer_precentage"] : @"0.00"];
            self.txtTotalByDealer.text = [NSString stringWithFormat:@"%@ (%@%%)",responseObject[@"data"][@"by_dealer_total"],responseObject[@"data"][@"by_dealer_precentage"]];
            self.txtTotalByMarketing.text = [NSString stringWithFormat:@"%@ (%@%%)",responseObject[@"data"][@"by_agent_total"],responseObject[@"data"][@"by_agent_precentage"]];
            self.txtTotalByAgent.text = [NSString stringWithFormat:@"%@ (%@%%)",responseObject[@"data"][@"by_marketing_total"],responseObject[@"data"][@"by_marketing_precentage"]];
            
            self.txtJumlahBulanSumberAplikasi.text = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"jumlah"]];
        };
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ;
    }];
    
    
}

- (void) downloadSumberAplikasiDataByYearForId:(NSNumber *)produkId {
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    NSDictionary* param;
    param = @{@"userid" : [MPMUserInfo getUserInfo][@"userId"],
              @"token" : [MPMUserInfo getToken],
              @"data" : @{@"tipe" : @"year",
                          @"product_id" : [produkId isEqual:@0] ? @"" : produkId
                          }};
  
  NSString *urlString = [NSString stringWithFormat:@"%@/dasboard2/marketing-by-grouplevel-and-product",kApiUrl];
  if ([[MPMUserInfo getRole] isEqualToString:kRoleSupervisor]) {
    urlString =[NSString stringWithFormat:@"%@/dasboard2/spv-by-sumber-aplikasi",kApiUrl];
  } else if ([[MPMUserInfo getRole] isEqualToString:kRoleBM]) {
    urlString =[NSString stringWithFormat:@"%@/dasboard2/bm-by-sumber-aplikasi",kApiUrl];
  }
    [manager POST:urlString parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"statusCode"] isEqual:@200]) {
            [self.progressChartYearSumberAplikasi.sliceItems removeAllObjects];
            //Create Slice items with value and section color
            SliceItem *item1 = [[SliceItem alloc] init];
            item1.itemValue = [responseObject[@"data"][@"by_customer_precentage"] doubleValue]; // value should be a float value
            item1.itemColor = [UIColor cyanColor]; // color should be a UIColor value
            
            
            SliceItem *item2 = [[SliceItem alloc] init];
            item2.itemValue = [responseObject[@"data"][@"by_dealer_precentage"] doubleValue];
            item2.itemColor = [UIColor blueColor];
            
            
            SliceItem *item3 = [[SliceItem alloc] init];
            item3.itemValue = [responseObject[@"data"][@"by_marketing_precentage"] doubleValue];
            item3.itemColor = [UIColor redColor];
            
            SliceItem *item4 = [[SliceItem alloc] init];
            item4.itemValue = [responseObject[@"data"][@"by_agent_precentage"] doubleValue];
            item4.itemColor = [UIColor grayColor];
            
            
            //Add SliceItems objects to the sliceItems NSMutable array of KATProgressChart.
            [self.progressChartYearSumberAplikasi.sliceItems addObject:item1];
            [self.progressChartYearSumberAplikasi.sliceItems addObject:item2];
            [self.progressChartYearSumberAplikasi.sliceItems addObject:item3];
            [self.progressChartYearSumberAplikasi.sliceItems addObject:item4];
            [self.progressChartYearSumberAplikasi reloadData]; // reload the chart.
            
            //todo change the correct color and change the flag color and change the label
            self.txtTotalByCustomer2.text = [NSString stringWithFormat:@"%@ (%@%%)",responseObject[@"data"][@"by_customer_total"],responseObject[@"data"][@"by_customer_precentage"] ? responseObject[@"data"][@"by_customer_precentage"] : @"0.00"];
            self.txtTotalByDealer2.text = [NSString stringWithFormat:@"%@ (%@%%)",responseObject[@"data"][@"by_dealer_total"],responseObject[@"data"][@"by_dealer_precentage"]];
            self.txtTotalByMarketing2.text = [NSString stringWithFormat:@"%@ (%@%%)",responseObject[@"data"][@"by_agent_total"],responseObject[@"data"][@"by_agent_precentage"]];
            self.txtTotalByAgent2.text = [NSString stringWithFormat:@"%@ (%@%%)",responseObject[@"data"][@"by_marketing_total"],responseObject[@"data"][@"by_marketing_precentage"]];
            self.txtJumlahTahunSumberAplikasi.text = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"jumlah"]];
        };
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ;
    }];
    
    
}


- (void) downloadMarketingByProductDataYearForId:(NSNumber *)produkId {
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    NSDictionary* param;
    param = @{@"userid" : [MPMUserInfo getUserInfo][@"userId"],
              @"token" : [MPMUserInfo getToken],
              @"data" : @{@"tipe" : @"year",
                          @"product_id" : [produkId isEqual:@0] ? @"" : produkId
                          }};
  NSString *urlString = [NSString stringWithFormat:@"%@/dasboard2/marketing-by-product",kApiUrl];
  if ([[MPMUserInfo getRole] isEqualToString:kRoleSupervisor]) {
    urlString = [NSString stringWithFormat:@"%@/dasboard2/spv-by-status-and-product",kApiUrl];
  } else if ([[MPMUserInfo getRole] isEqualToString:kRoleBM]) {
    urlString = [NSString stringWithFormat:@"%@/dasboard2/bm-by-status-and-product",kApiUrl];
  }  else if ([[MPMUserInfo getRole] isEqualToString:kRoleDealer] || [[MPMUserInfo getRole] isEqualToString:kRoleAgent]) {
    urlString = [NSString stringWithFormat:@"%@/dasboard2/eksternal",kApiUrl];
  }
    [manager POST:urlString parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"statusCode"] isEqual:@200]) {
          if (![[MPMUserInfo getRole] isEqualToString:kRoleDealer] && ![[MPMUserInfo getRole] isEqualToString:kRoleAgent]) {
            
          
            [self.progressChartYear.sliceItems removeAllObjects];
            //Create Slice items with value and section color
            SliceItem *item1 = [[SliceItem alloc] init];
            item1.itemValue = [responseObject[@"data"][@"new_application_precentage"] doubleValue]; // value should be a float value
            item1.itemColor = [UIColor cyanColor]; // color should be a UIColor value
            self.flagTotalNewApp2.backgroundColor = [UIColor cyanColor];
            
            SliceItem *item2 = [[SliceItem alloc] init];
            item2.itemValue = [responseObject[@"data"][@"on_proggress_precentage"] doubleValue];
            item2.itemColor = [UIColor blueColor];
            self.flagTotalOnProgress2.backgroundColor = [UIColor blueColor];
            
            SliceItem *item3 = [[SliceItem alloc] init];
            item3.itemValue = [responseObject[@"data"][@"submit_map_precentage"] doubleValue];
            item3.itemColor = [UIColor redColor];
            self.flagTotalSubmitMap2.backgroundColor = [UIColor redColor];
            
            SliceItem *item4 = [[SliceItem alloc] init];
            item4.itemValue = [responseObject[@"data"][@"submit_survey_precentage"] doubleValue];
            item4.itemColor = [UIColor grayColor];
            self.flagTotalSubmitSurvey2.backgroundColor = [UIColor grayColor];
            
            SliceItem *item5 = [[SliceItem alloc] init];
            item5.itemValue = [responseObject[@"data"][@"proccess_confins_precentage"] doubleValue];
            item5.itemColor = [UIColor greenColor];
            self.flagTotalProcessConfins2.backgroundColor = [UIColor greenColor];
            
            SliceItem *item6 = [[SliceItem alloc] init];
            item6.itemValue = [responseObject[@"data"][@"go_live_precentage"] doubleValue];
            item6.itemColor = [UIColor purpleColor];
            self.flagTotalGoLive2.backgroundColor = [UIColor purpleColor];
            
            SliceItem *item7 = [[SliceItem alloc] init];
            item7.itemValue = [responseObject[@"data"][@"stop_proccess_precentage"] doubleValue];
            item7.itemColor = [UIColor brownColor];
            self.flagTotalStopProcess2.backgroundColor = [UIColor brownColor];
            
            SliceItem *item8 = [[SliceItem alloc] init];
            item8.itemValue = [responseObject[@"data"][@"negative_list_precentage"] doubleValue];
            item8.itemColor = [UIColor magentaColor];
            self.flagTotalNegativeList2.backgroundColor = [UIColor magentaColor];
            
            SliceItem *item9 = [[SliceItem alloc] init];
            item9.itemValue = [responseObject[@"data"][@"waiting_get_data_precentage"] doubleValue];
            item9.itemColor = [UIColor orangeColor];
            self.flagTotalWaitingGetData2.backgroundColor = [UIColor orangeColor];
            
            //Add SliceItems objects to the sliceItems NSMutable array of KATProgressChart.
            [self.progressChartYear.sliceItems addObject:item1];
            [self.progressChartYear.sliceItems addObject:item2];
            [self.progressChartYear.sliceItems addObject:item3];
            [self.progressChartYear.sliceItems addObject:item4];
            [self.progressChartYear.sliceItems addObject:item5];
            [self.progressChartYear.sliceItems addObject:item6];
            [self.progressChartYear.sliceItems addObject:item7];
            [self.progressChartYear.sliceItems addObject:item8];
            [self.progressChartYear.sliceItems addObject:item9];
            [self.progressChartYear reloadData]; // reload the chart.
            
            //todo change the correct color and change the flag color and change the label
            self.txtTotalNewApp2.text = [NSString stringWithFormat:@"%@ (%@%%)",responseObject[@"data"][@"new_application_total"],responseObject[@"data"][@"new_application_precentage"] ? responseObject[@"data"][@"new_application_precentage"] : @"0.00"];
            self.txtTotalNegativeList2.text = [NSString stringWithFormat:@"%@ (%@%%)",responseObject[@"data"][@"negative_list_total"],responseObject[@"data"][@"negative_list_precentage"]];
            self.txtTotalOnProgress2.text = [NSString stringWithFormat:@"%@ (%@%%)",responseObject[@"data"][@"on_proggress_total"],responseObject[@"data"][@"on_proggress_precentage"]];
            self.txtTotalProcessConfins2.text = [NSString stringWithFormat:@"%@ (%@%%)",responseObject[@"data"][@"proccess_confins_total"],responseObject[@"data"][@"proccess_confins_precentage"]];
            self.txtTotalStopProcess2.text = [NSString stringWithFormat:@"%@ (%@%%)",responseObject[@"data"][@"stop_proccess_total"],responseObject[@"data"][@"stop_proccess_precentage"]];
            self.txtTotalSubmitMap2.text = [NSString stringWithFormat:@"%@ (%@%%)",responseObject[@"data"][@"submit_map_total"],responseObject[@"data"][@"submit_map_precentage"]];
            self.txtTotalSubmitSurvey2.text = [NSString stringWithFormat:@"%@ (%@%%)",responseObject[@"data"][@"submit_survey_total"],responseObject[@"data"][@"submit_survey_precentage"]];
            self.txtTotalWaitingGetData2.text = [NSString stringWithFormat:@"%@ (%@%%)",responseObject[@"data"][@"waiting_get_data_total"],responseObject[@"data"][@"waiting_get_data_precentage"]];
            self.txtTotalGoLive2.text = [NSString stringWithFormat:@"%@ (%@%%)",responseObject[@"data"][@"go_live_total"],responseObject[@"data"][@"go_live_precentage"]];
            
            self.txtJumlahTahun.text = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"jumlah"]];
          } else {
            [self.progressChartYearDealer.sliceItems removeAllObjects];
            //Create Slice items with value and section color
            SliceItem *item1 = [[SliceItem alloc] init];
            item1.itemValue = [responseObject[@"data"][@"new_application_precentage"] doubleValue]; // value should be a float value
            item1.itemColor = [UIColor cyanColor]; // color should be a UIColor value
            
            SliceItem *item2 = [[SliceItem alloc] init];
            item2.itemValue = [responseObject[@"data"][@"progress_officer_precentage"] doubleValue];
            item2.itemColor = [UIColor blueColor];
            
            SliceItem *item3 = [[SliceItem alloc] init];
            item3.itemValue = [responseObject[@"data"][@"officer_complete_precentage"] doubleValue];
            item3.itemColor = [UIColor redColor];
            
            SliceItem *item4 = [[SliceItem alloc] init];
            item4.itemValue = [responseObject[@"data"][@"app_submitted_precentage"] doubleValue];
            item4.itemColor = [UIColor grayColor];
            
            SliceItem *item5 = [[SliceItem alloc] init];
            item5.itemValue = [responseObject[@"data"][@"contract_active_precentage"] doubleValue];
            item5.itemColor = [UIColor greenColor];
            
            SliceItem *item6 = [[SliceItem alloc] init];
            item6.itemValue = [responseObject[@"data"][@"app_stop_precentage"] doubleValue];
            item6.itemColor = [UIColor purpleColor];
            
            //Add SliceItems objects to the sliceItems NSMutable array of KATProgressChart.
            [self.progressChartYearDealer.sliceItems addObject:item1];
            [self.progressChartYearDealer.sliceItems addObject:item2];
            [self.progressChartYearDealer.sliceItems addObject:item3];
            [self.progressChartYearDealer.sliceItems addObject:item4];
            [self.progressChartYearDealer.sliceItems addObject:item5];
            [self.progressChartYearDealer.sliceItems addObject:item6];
            [self.progressChartYearDealer reloadData]; // reload the chart.
            
            //todo change the correct color and change the flag color and change the label
            self.txtTotalNewAppDealerYear.text = [NSString stringWithFormat:@"%@ (%@%%)",responseObject[@"data"][@"new_application_total"],responseObject[@"data"][@"new_application_precentage"] ? responseObject[@"data"][@"new_application_precentage"] : @"0.00"];
            self.txtTotalProgressOfficerDealerYear.text = [NSString stringWithFormat:@"%@ (%@%%)",responseObject[@"data"][@"progress_officer_total"],responseObject[@"data"][@"progress_officer_precentage"]];
            self.txtTotalOfficerCompleteDealerYear.text = [NSString stringWithFormat:@"%@ (%@%%)",responseObject[@"data"][@"officer_complete_total"],responseObject[@"data"][@"officer_complete_precentage"]];
            self.txtTotalAppSubmittedDealerYear.text = [NSString stringWithFormat:@"%@ (%@%%)",responseObject[@"data"][@"app_submitted_total"],responseObject[@"data"][@"app_submitted_precentage"]];
            self.txtTotalContractActiveDealerYear.text = [NSString stringWithFormat:@"%@ (%@%%)",responseObject[@"data"][@"contract_active_total"],responseObject[@"data"][@"contract_active_precentage"]];
            self.txtTotalAppStopDealerYear.text = [NSString stringWithFormat:@"%@ (%@%%)",responseObject[@"data"][@"app_stop_total"],responseObject[@"data"][@"app_stop_precentage"]];
            
            self.txtJumlahTahunDealer.text = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"jumlah"]];
          }
        };
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ;
    }];
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 91;
    } else if ((indexPath.row == 1 || indexPath.row == 2) && ![[MPMUserInfo getRole] isEqualToString:kRoleDealer] && ![[MPMUserInfo getRole] isEqualToString:kRoleAgent]) {
        return 720;
    } else if (indexPath.row == 3 && (![[MPMUserInfo getRole] isEqualToString:kRoleAgent] && ![[MPMUserInfo getRole] isEqualToString:kRoleDealer])) {
        return 50;
    } else if ((indexPath.row == 4 || indexPath.row == 5) && (![[MPMUserInfo getRole] isEqualToString:kRoleAgent] && ![[MPMUserInfo getRole] isEqualToString:kRoleDealer]) ) {
        return 534;
    } else if (indexPath.row == 6 && (![[MPMUserInfo getRole] isEqualToString:kRoleAgent] && ![[MPMUserInfo getRole] isEqualToString:kRoleDealer] && ![[MPMUserInfo getRole] isEqualToString:kRoleDedicated])) {
        return 137;
    } else if ((indexPath.row == 7 || indexPath.row == 8) && (![[MPMUserInfo getRole] isEqualToString:kRoleAgent] && ![[MPMUserInfo getRole] isEqualToString:kRoleDealer] && ![[MPMUserInfo getRole] isEqualToString:kRoleDedicated])) {
        return 720;
    } else if ((indexPath.row == 9 || indexPath.row == 10) && ([[MPMUserInfo getRole] isEqualToString:kRoleDealer] || [[MPMUserInfo getRole] isEqualToString:kRoleAgent])) {
      return 649;
    }
    else return 0;
}

- (void) downloadUserList:(NSNumber *)userLevel {
    self.txtUser.text = @"";
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    NSDictionary* param;
    param = @{@"userid" : [MPMUserInfo getUserInfo][@"userId"],
              @"token" : [MPMUserInfo getToken],
              @"data" : @{
                          @"user_level" : userLevel
                          }};
  NSString *urlString;
  if ([[MPMUserInfo getRole] isEqualToString:kRoleSupervisor]) {
    urlString = [NSString stringWithFormat:@"%@/dasboard2/spv-list-users",kApiUrl];
  } else {
    urlString = [NSString stringWithFormat:@"%@/dasboard2/bm-list-users",kApiUrl];
  }
    [manager POST:urlString parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"statusCode"] isEqual:@200]) {
            self.users = [NSMutableArray arrayWithArray:@[@{@"id" : @0,
                                                                  @"nama" : @"All"
                                                                  }]];
            [self.users addObjectsFromArray:responseObject[@"data"]];
        };
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ;
    }];
    
    
}


- (void) downloadMarketingProductByUserDataMonthForId:(NSString *)produkId groupLevel:(NSString *)groupLevel userId:(NSNumber *)userId {
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    NSDictionary* param;
    param = @{@"userid" : [MPMUserInfo getUserInfo][@"userId"],
              @"token" : [MPMUserInfo getToken],
              @"data" : @{@"tipe" : @"month",
                          @"product_id" : produkId,
                          @"group_level" : groupLevel? groupLevel : @"",
                          @"user_id" : userId? userId : @""
                          }};
  NSString *urlString;
  if ([[MPMUserInfo getRole] isEqualToString:kRoleSupervisor]) {
    urlString = [NSString stringWithFormat:@"%@/dasboard2/spv-by-status-and-product-per-users",kApiUrl];
  } else if ([[MPMUserInfo getRole] isEqualToString:kRoleBM]) {
    urlString = [NSString stringWithFormat:@"%@/dasboard2/bm-by-status-and-product-per-users",kApiUrl];
  }
    [manager POST:urlString parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"statusCode"] isEqual:@200]) {
            [self.progressChartMonth2.sliceItems removeAllObjects];
            //Create Slice items with value and section color
            SliceItem *item1 = [[SliceItem alloc] init];
            item1.itemValue = [responseObject[@"data"][@"new_application_precentage"] doubleValue]; // value should be a float value
            item1.itemColor = [UIColor cyanColor]; // color should be a UIColor value
            SliceItem *item2 = [[SliceItem alloc] init];
            item2.itemValue = [responseObject[@"data"][@"on_proggress_precentage"] doubleValue];
            item2.itemColor = [UIColor blueColor];
            
            SliceItem *item3 = [[SliceItem alloc] init];
            item3.itemValue = [responseObject[@"data"][@"submit_map_precentage"] doubleValue];
            item3.itemColor = [UIColor redColor];
            
            SliceItem *item4 = [[SliceItem alloc] init];
            item4.itemValue = [responseObject[@"data"][@"submit_survey_precentage"] doubleValue];
            item4.itemColor = [UIColor grayColor];
            
            SliceItem *item5 = [[SliceItem alloc] init];
            item5.itemValue = [responseObject[@"data"][@"proccess_confins_precentage"] doubleValue];
            item5.itemColor = [UIColor greenColor];
            
            SliceItem *item6 = [[SliceItem alloc] init];
            item6.itemValue = [responseObject[@"data"][@"go_live_precentage"] doubleValue];
            item6.itemColor = [UIColor purpleColor];
            
            SliceItem *item7 = [[SliceItem alloc] init];
            item7.itemValue = [responseObject[@"data"][@"stop_proccess_precentage"] doubleValue];
            item7.itemColor = [UIColor brownColor];
            
            SliceItem *item8 = [[SliceItem alloc] init];
            item8.itemValue = [responseObject[@"data"][@"negative_list_precentage"] doubleValue];
            item8.itemColor = [UIColor magentaColor];
            
            SliceItem *item9 = [[SliceItem alloc] init];
            item9.itemValue = [responseObject[@"data"][@"waiting_get_data_precentage"] doubleValue];
            item9.itemColor = [UIColor orangeColor];
            
            //Add SliceItems objects to the sliceItems NSMutable array of KATProgressChart.
            [self.progressChartMonth2.sliceItems addObject:item1];
            [self.progressChartMonth2.sliceItems addObject:item2];
            [self.progressChartMonth2.sliceItems addObject:item3];
            [self.progressChartMonth2.sliceItems addObject:item4];
            [self.progressChartMonth2.sliceItems addObject:item5];
            [self.progressChartMonth2.sliceItems addObject:item6];
            [self.progressChartMonth2.sliceItems addObject:item7];
            [self.progressChartMonth2.sliceItems addObject:item8];
            [self.progressChartMonth2.sliceItems addObject:item9];
            [self.progressChartMonth2 reloadData]; // reload the chart.
            
            //todo change the correct color and change the flag color and change the label
            self.txtTotalNewApp3.text = [NSString stringWithFormat:@"%@ (%@%%)",responseObject[@"data"][@"new_application_total"],responseObject[@"data"][@"new_application_precentage"] ? responseObject[@"data"][@"new_application_precentage"] : @"0.00"];
            self.txtTotalNegativeList3.text = [NSString stringWithFormat:@"%@ (%@%%)",responseObject[@"data"][@"negative_list_total"],responseObject[@"data"][@"negative_list_precentage"]];
            self.txtTotalOnProgress3.text = [NSString stringWithFormat:@"%@ (%@%%)",responseObject[@"data"][@"on_proggress_total"],responseObject[@"data"][@"on_proggress_precentage"]];
            self.txtTotalProcessConfins3.text = [NSString stringWithFormat:@"%@ (%@%%)",responseObject[@"data"][@"proccess_confins_total"],responseObject[@"data"][@"proccess_confins_precentage"]];
            self.txtTotalStopProcess3.text = [NSString stringWithFormat:@"%@ (%@%%)",responseObject[@"data"][@"stop_proccess_total"],responseObject[@"data"][@"stop_proccess_precentage"]];
            self.txtTotalSubmitMap3.text = [NSString stringWithFormat:@"%@ (%@%%)",responseObject[@"data"][@"submit_map_total"],responseObject[@"data"][@"submit_map_precentage"]];
            self.txtTotalSubmitSurvey3.text = [NSString stringWithFormat:@"%@ (%@%%)",responseObject[@"data"][@"submit_survey_total"],responseObject[@"data"][@"submit_survey_precentage"]];
            self.txtTotalWaitingGetData3.text = [NSString stringWithFormat:@"%@ (%@%%)",responseObject[@"data"][@"waiting_get_data_total"],responseObject[@"data"][@"waiting_get_data_precentage"]];
            self.txtTotalGoLive3.text = [NSString stringWithFormat:@"%@ (%@%%)",responseObject[@"data"][@"go_live_total"],responseObject[@"data"][@"go_live_precentage"]];
            
            self.txtJumlahBulan2.text = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"jumlah"]];
            //            self.txtApproveTahun.text = [NSString stringWithFormat:@"Approve (%@ %%)",responseObject[@"data"][@"approve"]];
            //            self.txtRejectTahun.text = [NSString stringWithFormat:@"Reject (%@ %%)",responseObject[@"data"][@"reject"]];
        };
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ;
    }];
    
    
}

- (void) downloadMarketingProductByUserDataYearForId:(NSString *)produkId groupLevel:(NSString *)groupLevel userId:(NSNumber *)userId {
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    NSDictionary* param;
    param = @{@"userid" : [MPMUserInfo getUserInfo][@"userId"],
              @"token" : [MPMUserInfo getToken],
              @"data" : @{@"tipe" : @"year",
                          @"product_id" : produkId,
                          @"group_level" : groupLevel? groupLevel : @"",
                          @"user_id" : userId? userId : @""
                          }};
  NSString *urlString;
  if ([[MPMUserInfo getRole] isEqualToString:kRoleSupervisor]) {
    urlString = [NSString stringWithFormat:@"%@/dasboard2/spv-by-status-and-product-per-users",kApiUrl];
  } else if ([[MPMUserInfo getRole] isEqualToString:kRoleBM]) {
    urlString = [NSString stringWithFormat:@"%@/dasboard2/bm-by-status-and-product-per-users",kApiUrl];
  }
    [manager POST:urlString parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"statusCode"] isEqual:@200]) {
            [self.progressChartYear2.sliceItems removeAllObjects];
            //Create Slice items with value and section color
            SliceItem *item1 = [[SliceItem alloc] init];
            item1.itemValue = [responseObject[@"data"][@"new_application_precentage"] doubleValue]; // value should be a float value
            item1.itemColor = [UIColor cyanColor]; // color should be a UIColor value
            
            SliceItem *item2 = [[SliceItem alloc] init];
            item2.itemValue = [responseObject[@"data"][@"on_proggress_precentage"] doubleValue];
            item2.itemColor = [UIColor blueColor];
            
            SliceItem *item3 = [[SliceItem alloc] init];
            item3.itemValue = [responseObject[@"data"][@"submit_map_precentage"] doubleValue];
            item3.itemColor = [UIColor redColor];
            
            SliceItem *item4 = [[SliceItem alloc] init];
            item4.itemValue = [responseObject[@"data"][@"submit_survey_precentage"] doubleValue];
            item4.itemColor = [UIColor grayColor];
            
            SliceItem *item5 = [[SliceItem alloc] init];
            item5.itemValue = [responseObject[@"data"][@"proccess_confins_precentage"] doubleValue];
            item5.itemColor = [UIColor greenColor];
            
            SliceItem *item6 = [[SliceItem alloc] init];
            item6.itemValue = [responseObject[@"data"][@"go_live_precentage"] doubleValue];
            item6.itemColor = [UIColor purpleColor];
            
            SliceItem *item7 = [[SliceItem alloc] init];
            item7.itemValue = [responseObject[@"data"][@"stop_proccess_precentage"] doubleValue];
            item7.itemColor = [UIColor brownColor];
            
            SliceItem *item8 = [[SliceItem alloc] init];
            item8.itemValue = [responseObject[@"data"][@"negative_list_precentage"] doubleValue];
            item8.itemColor = [UIColor magentaColor];
            
            SliceItem *item9 = [[SliceItem alloc] init];
            item9.itemValue = [responseObject[@"data"][@"waiting_get_data_precentage"] doubleValue];
            item9.itemColor = [UIColor orangeColor];
            
            //Add SliceItems objects to the sliceItems NSMutable array of KATProgressChart.
            [self.progressChartYear2.sliceItems addObject:item1];
            [self.progressChartYear2.sliceItems addObject:item2];
            [self.progressChartYear2.sliceItems addObject:item3];
            [self.progressChartYear2.sliceItems addObject:item4];
            [self.progressChartYear2.sliceItems addObject:item5];
            [self.progressChartYear2.sliceItems addObject:item6];
            [self.progressChartYear2.sliceItems addObject:item7];
            [self.progressChartYear2.sliceItems addObject:item8];
            [self.progressChartYear2.sliceItems addObject:item9];
            [self.progressChartYear2 reloadData]; // reload the chart.
            
            //todo change the correct color and change the flag color and change the label
            self.txtTotalNewApp4.text = [NSString stringWithFormat:@"%@ (%@%%)",responseObject[@"data"][@"new_application_total"],responseObject[@"data"][@"new_application_precentage"] ? responseObject[@"data"][@"new_application_precentage"] : @"0.00"];
            self.txtTotalNegativeList4.text = [NSString stringWithFormat:@"%@ (%@%%)",responseObject[@"data"][@"negative_list_total"],responseObject[@"data"][@"negative_list_precentage"]];
            self.txtTotalOnProgress4.text = [NSString stringWithFormat:@"%@ (%@%%)",responseObject[@"data"][@"on_proggress_total"],responseObject[@"data"][@"on_proggress_precentage"]];
            self.txtTotalProcessConfins4.text = [NSString stringWithFormat:@"%@ (%@%%)",responseObject[@"data"][@"proccess_confins_total"],responseObject[@"data"][@"proccess_confins_precentage"]];
            self.txtTotalStopProcess4.text = [NSString stringWithFormat:@"%@ (%@%%)",responseObject[@"data"][@"stop_proccess_total"],responseObject[@"data"][@"stop_proccess_precentage"]];
            self.txtTotalSubmitMap4.text = [NSString stringWithFormat:@"%@ (%@%%)",responseObject[@"data"][@"submit_map_total"],responseObject[@"data"][@"submit_map_precentage"]];
            self.txtTotalSubmitSurvey4.text = [NSString stringWithFormat:@"%@ (%@%%)",responseObject[@"data"][@"submit_survey_total"],responseObject[@"data"][@"submit_survey_precentage"]];
            self.txtTotalWaitingGetData4.text = [NSString stringWithFormat:@"%@ (%@%%)",responseObject[@"data"][@"waiting_get_data_total"],responseObject[@"data"][@"waiting_get_data_precentage"]];
            self.txtTotalGoLive4.text = [NSString stringWithFormat:@"%@ (%@%%)",responseObject[@"data"][@"go_live_total"],responseObject[@"data"][@"go_live_precentage"]];
            
            self.txtJumlahYear2.text = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"jumlah"]];
            //            self.txtApproveTahun.text = [NSString stringWithFormat:@"Approve (%@ %%)",responseObject[@"data"][@"approve"]];
            //            self.txtRejectTahun.text = [NSString stringWithFormat:@"Reject (%@ %%)",responseObject[@"data"][@"reject"]];
        };
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ;
    }];
    
    
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
