//
//  HistoryViewController.m
//  MPMFinance
//
//  Created by Romin Adi Santoso on 5/14/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "HistoryViewController.h"
#import <UIImageView+AFNetworking.h>
#import <UIScrollView+SVInfiniteScrolling.h>
#import <UIScrollView+SVPullToRefresh.h>
#import "WorkOrderModel.h"
#import "FormViewController.h"
#define kHistoryPerPage 10
@interface HistoryViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray* data;
@property int currentPage;
@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.data = [NSMutableArray array];
    __weak HistoryViewController *weakSelf = self;
    [self loadFirstPage];
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf loadFirstPage];
    }];
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMoreData];
    }];
    // Do any additional setup after loading the view.
}
-(void)loadFirstPage
{
    [self loadDataForPage:0];
}
-(void)loadMoreData
{
    [self loadDataForPage:_currentPage++];
    
    
}

-(void)loadDataForPage:(int)page
{
    __weak HistoryViewController *weakSelf = self;
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    int offset = page * kHistoryPerPage;
    NSString* url = [NSString stringWithFormat:@"%@/pengajuan/getallbyuser",kApiUrl];
    NSDictionary* param = @{@"data" : @{@"limit" : [NSString stringWithFormat:@"%i",kHistoryPerPage],
                                        @"offset" : [NSString stringWithFormat:@"%i",offset],
                                        @"status" : @"monitoring"},
                            @"userid" : [MPMUserInfo getUserInfo][@"userId"],
                            @"token" : [MPMUserInfo getToken]};
    
    [manager POST:url parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (page == 0) {
            weakSelf.data = [NSMutableArray arrayWithArray:responseObject[@"data"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                _currentPage = 1;
                [weakSelf.tableView reloadData];
                [weakSelf.tableView.pullToRefreshView stopAnimating];
            });
        }
        else
        {
            
            [weakSelf.data addObjectsFromArray:responseObject[@"data"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                _currentPage = page;
                [weakSelf.tableView reloadData];
                [weakSelf.tableView.infiniteScrollingView stopAnimating];
            });
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf.tableView.pullToRefreshView stopAnimating];
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"history appear");

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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [WorkOrderModel getListWorkOrderDetailWithID:[self.data[indexPath.row][@"id"] integerValue] completion:^(NSDictionary *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            FormViewController *vc = [[FormViewController alloc] init];
            vc.menu = [Menu objectForPrimaryKey:kSubmenuFormPengajuanApplikasi];
            //vc.list =
        });
    }];
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
