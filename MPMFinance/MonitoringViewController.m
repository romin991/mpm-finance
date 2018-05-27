//
//  MonitoringViewController.m
//  MPMFinance
//
//  Created by Romin Adi Santoso on 5/25/18.
//  Copyright © 2018 MPMFinance. All rights reserved.
//

#import "MonitoringViewController.h"
#import "APIModel.h"
#import <UIScrollView+SVInfiniteScrolling.h>
#import <UIScrollView+SVPullToRefresh.h>
#import "MonitoringTableViewCell.h"
#import "WorkOderTableViewCell.h"
#import "SubmenuViewController.h"
#define kHistoryPerPage 10
@interface MonitoringViewController ()<UITableViewDelegate,UITableViewDataSource>
@property NSMutableArray *data;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property int currentPage;
@end

@implementation MonitoringViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak MonitoringViewController *weakSelf = self;
    
    [self loadFirstPage];
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf loadFirstPage];
    }];
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMoreData];
    }];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MonitoringTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WorkOderTableViewCell" bundle:nil] forCellReuseIdentifier:@"WOCell"];
    self.title = @"Monitoring";
    // Do any additional setup after loading the view from its nib.
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
    __weak MonitoringViewController *weakSelf = self;
    int offset = page * kHistoryPerPage;
    NSString* url;
    NSDictionary* param = @{@"data" : @{@"limit" : @10,
                                        @"offset" : @(offset)
                                        },
                            @"userid" : [MPMUserInfo getUserInfo][@"userId"],
                            @"token" : [MPMUserInfo getToken]};
    
    if ([[MPMUserInfo getRole] isEqualToString:kRoleSupervisor]) {
        
        if(self.userId) {
            url = [NSString stringWithFormat:@"%@/pengajuan/getworkorderbymarketingandproduct",kApiUrl];
            param = @{@"data" : @{@"limit" : @10,
                                  @"offset" : @(offset),
                                  @"tipeProduk" : @"1",
                                  @"status" : @"all"
                                  },
                      @"userid" : self.userId,
                      @"token" : [MPMUserInfo getToken]};
        } else {
            url = [NSString stringWithFormat:@"%@/pengajuan2/getlistmarketingbyspv",kApiUrl];
        }
    } else {
        if (!self.idProduk) {
            url = [NSString stringWithFormat:@"%@/pengajuan/getprodukbybranchmanager",kApiUrl];
        } else if(self.tipeProduk) {
            url = [NSString stringWithFormat:@"%@/pengajuan/getallmarketingbybm",kApiUrl];
            param = @{@"data" : @{@"limit" : @10,
                                  @"offset" : @(offset),
                                  @"tipeProduk" : self.tipeProduk,
                                  @"spv" : self.spv
                                  },
                      @"userid" : [MPMUserInfo getUserInfo][@"userId"],
                      @"token" : [MPMUserInfo getToken]};
        } else if(self.userId) {
            url = [NSString stringWithFormat:@"%@/pengajuan/getworkorderbymarketingandproduct",kApiUrl];
            param = @{@"data" : @{@"limit" : @10,
                                  @"offset" : @(offset),
                                  @"tipeProduk" : @"1",
                                  @"status" : @"all"
                                  },
                      @"userid" : self.userId,
                      @"token" : [MPMUserInfo getToken]};
        } else {
            url = [NSString stringWithFormat:@"%@/pengajuan/getspvbybranchmanager",kApiUrl];
            param = @{@"data" : @{@"limit" : @10,
                                  @"offset" : @(offset),
                                  @"idProduk" : self.idProduk
                                  },
                      @"userid" : [MPMUserInfo getUserInfo][@"userId"],
                      @"token" : [MPMUserInfo getToken]};
        }
        
    }
    
    
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    
    
    
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.userId) {
        WorkOderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WOCell" forIndexPath:indexPath];
        [cell setupWithData:self.data[indexPath.row]];
        // Configure the cell...
        
        return cell;
    } else {
        MonitoringTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        [cell setupWithData:self.data[indexPath.row]];
        // Configure the cell...
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[MPMUserInfo getRole] isEqualToString:kRoleSupervisor]) {
        if (!self.userId) {
            MonitoringViewController *vc = [[MonitoringViewController alloc] init];
            vc.idProduk = self.idProduk;
            vc.userId = self.data[indexPath.row][@"userid"];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else {
            Menu *submenu = [Menu getMenuForPrimaryKey:kSubmenuListWorkOrder];
            List *list = [[List alloc] init];
            list.primaryKey = [self.data[indexPath.row][@"id"] integerValue];
            list.imageURL = self.data[indexPath.row][@"imageIconIos"];
            list.title = self.data[indexPath.row][@"noRegistrasi"];
            list.date = self.data[indexPath.row][@"tanggal"];
            list.assignee = self.data[indexPath.row][@"namaPengaju"];
            list.status = self.data[indexPath.row][@"status"];
            list.statusColor = self.data[indexPath.row][@"color"];
            list.type = self.data[indexPath.row][@"idStatus"];
            SubmenuViewController *submenuViewController = [[SubmenuViewController alloc] init];
            submenuViewController.menu = submenu;
            submenuViewController.list = list;
            [self.navigationController pushViewController:submenuViewController animated:YES];

        }
    }
    else {
        if (!self.idProduk) {
            MonitoringViewController *vc = [[MonitoringViewController alloc] init];
            vc.idProduk = [self.data[indexPath.row][@"id"] stringValue];
            [self.navigationController pushViewController:vc animated:YES];
        } else if(self.idProduk && !self.tipeProduk && !self.userId) {
            MonitoringViewController *vc = [[MonitoringViewController alloc] init];
            vc.idProduk = self.idProduk;
            vc.spv = self.data[indexPath.row][@"userid"];
            vc.tipeProduk = @"1";
            [self.navigationController pushViewController:vc animated:YES];
        } else if(self.tipeProduk) {
            MonitoringViewController *vc = [[MonitoringViewController alloc] init];
            vc.idProduk = self.idProduk;
            vc.userId = self.data[indexPath.row][@"userid"];
            [self.navigationController pushViewController:vc animated:YES];
        } else if(self.userId) {
            Menu *submenu = [Menu getMenuForPrimaryKey:kSubmenuListWorkOrder];
            List *list = [[List alloc] init];
            list.primaryKey = [self.data[indexPath.row][@"id"] integerValue];
            list.imageURL = self.data[indexPath.row][@"imageIconIos"];
            list.title = self.data[indexPath.row][@"noRegistrasi"];
            list.date = self.data[indexPath.row][@"tanggal"];
            list.assignee = self.data[indexPath.row][@"namaPengaju"];
            list.status = self.data[indexPath.row][@"status"];
            list.statusColor = self.data[indexPath.row][@"color"];
            list.type = self.data[indexPath.row][@"idStatus"];
            SubmenuViewController *submenuViewController = [[SubmenuViewController alloc] init];
            submenuViewController.menu = submenu;
            submenuViewController.list = list;
            [self.navigationController pushViewController:submenuViewController animated:YES];
        }
    }
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
