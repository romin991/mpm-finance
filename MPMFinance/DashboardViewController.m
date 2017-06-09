//
//  DashboardViewController.m
//  MPMFinance
//
//  Created by Romin Adi Santoso on 6/7/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "DashboardViewController.h"
#import "KATCircularProgress.h"
@interface DashboardViewController ()

@property (strong, nonatomic) IBOutlet KATCircularProgress *progressChart;
@property (weak, nonatomic) IBOutlet UILabel *txtApproveBulan;
@property (weak, nonatomic) IBOutlet UILabel *txtRejectBulan;
@property (weak, nonatomic) IBOutlet UILabel *txtJumlahBulan;
@property (weak, nonatomic) IBOutlet KATCircularProgress *progressChartTahun;
@property (weak, nonatomic) IBOutlet UILabel *txtJumlahTahun;
@property (weak, nonatomic) IBOutlet UILabel *txtRejectTahun;

@property (weak, nonatomic) IBOutlet UILabel *txtApproveTahun;
@end

@implementation DashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.progressChart setLineWidth:30.0]; // Set Line thickness of the chart.
    [self.progressChart setAnimationDuration:2.5]; // Set Animation Duration.
    [self downloadData];
    // Do any additional setup after loading the view.
}

-(void)downloadData
{
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    NSDictionary* param = @{@"userid" : [MPMUserInfo getUserInfo][@"userId"],
                            @"token" : [MPMUserInfo getToken],
                            @"data" : @{@"tipe" : @"month"}};
    [manager POST:[NSString stringWithFormat:@"%@/dasboard",kApiUrl] parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"statusCode"] isEqual:@200]) {
            [self addSliceItemsForProgressChart:self.progressChart WithTotalReject:responseObject[@"data"][@"reject"] andApprove:responseObject[@"data"][@"approve"]];
            self.txtJumlahBulan.text = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"jumlah"]];
            self.txtApproveBulan.text = [NSString stringWithFormat:@"Approve (%@ %%)",responseObject[@"data"][@"approve"]];
            self.txtRejectBulan.text = [NSString stringWithFormat:@"Reject (%@ %%)",responseObject[@"data"][@"reject"]];
        };
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ;
    }];
    
    param = @{@"userid" : [MPMUserInfo getUserInfo][@"userId"],
              @"token" : [MPMUserInfo getToken],
              @"data" : @{@"tipe" : @"year"}};
    [manager POST:[NSString stringWithFormat:@"%@/dasboard",kApiUrl] parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"statusCode"] isEqual:@200]) {
            [self addSliceItemsForProgressChart:self.progressChartTahun WithTotalReject:responseObject[@"data"][@"reject"] andApprove:responseObject[@"data"][@"approve"]];
            self.txtJumlahTahun.text = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"jumlah"]];
            self.txtApproveTahun.text = [NSString stringWithFormat:@"Approve (%@ %%)",responseObject[@"data"][@"approve"]];
            self.txtRejectTahun.text = [NSString stringWithFormat:@"Reject (%@ %%)",responseObject[@"data"][@"reject"]];
        };
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ;
    }];
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
