//
//  HistoryViewController.m
//  MPMFinance
//
//  Created by Romin Adi Santoso on 5/14/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "HistoryViewController.h"
#import <UIImageView+AFNetworking.h>
@interface HistoryViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSArray* data;
@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"history appear");
    AFHTTPSessionManager *manager = [MPMGlobal sessionManager];
    NSDictionary* param = @{@"data" : @{@"limit" : @"10",
                                        @"offset" : @"0",
                                        @"status" : @"history"},
                            @"userid" : [MPMUserInfo getUserInfo][@"userId"],
                            @"token" : [MPMUserInfo getToken]};
    [manager POST:[NSString stringWithFormat:@"%@/pengajuan/getallbyspv",kApiUrl] parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"statusCode"] isEqual:@200]) {
            self.data = responseObject[@"data"];
            [self.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ;
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    [((UIImageView*)[cell viewWithTag:1]) setImageWithURL:[NSURL URLWithString:self.data[indexPath.row][@"imageIconIos"]]];
    ((UILabel*)[cell viewWithTag:2]).text = self.data[indexPath.row][@"noRegistrasi"];
    ((UILabel*)[cell viewWithTag:3]).text = self.data[indexPath.row][@"namaPengaju"];
    ((UILabel*)[cell viewWithTag:4]).text = self.data[indexPath.row][@"status"];
    ((UILabel*)[cell viewWithTag:5]).text = self.data[indexPath.row][@"tanggal"];
    [((UILabel*)[cell viewWithTag:4]) setBackgroundColor:[MPMGlobal colorFromHexString:self.data[indexPath.row][@"color"]]];
    [MPMGlobal giveBorderTo:[cell viewWithTag:4] withBorderColor:self.data[indexPath.row][@"color"] withCornerRadius:10.0f];
    return cell;
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
