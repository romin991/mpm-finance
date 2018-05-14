//
//  KontrakKerjaViewController.m
//  MPMFinance
//
//  Created by Romin Adi Santoso on 4/23/18.
//  Copyright © 2018 MPMFinance. All rights reserved.
//

#import "KontrakKerjaViewController.h"
#import "KontrakKerjaDetailViewController.h"
@interface KontrakKerjaViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSArray *data;
@property UIRefreshControl *refreshControl;
@end

@implementation KontrakKerjaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Initialize the refresh control.
    self.view.backgroundColor = [UIColor whiteColor];
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor lightGrayColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(loadListContract)
                  forControlEvents:UIControlEventValueChanged];
    self.tableView.refreshControl = self.refreshControl;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)loadListContract {
    /*
     {
     "data": {
     "limit": 10,
     "offset": 0
     },
     "userid": "customer.mpm@gmail.com",
     "token": "eyJraWQiOiIxIiwiYWxnIjoiUlMyNTYifQ.eyJpc3MiOiJnYXJ1ZGFhcGkiLCJleHAiOjE1MjQ0ODg5ODIsImp0aSI6IkR6UzZYb19XMzdvTlB4a3BFZGlwcVEiLCJpYXQiOjE1MjQ0ODUzODIsIm5iZiI6MTUyNDQ4NTMyMiwic3ViIjoidGVtcGxhdGUiLCJyb2xlcyI6WyJST0xFX1VTRVIiXX0.H07ONCdgpBtNOE44k9YEWWRe9rFM6RyX5mJIADvlFTJVps8FLcyiRvuOXsZ_uIlf-QUOFkydmbanB3oZsXhW3Py00lQE2BIGdrolZMsPJbcyVhVcPnPBKY1XOU4WZLCnlBvO78m2OwjXjDNSsEDATiJKdlfQtSCwdjkCCu70anggUNRqMgA_kNHJjHcq8OBBgbQr__hR7SX88ur4L5U0b0U_m-cMoeU2kQgscvlzb1UKXcpEmldF8npS9UluN8ErKO-wFs_zRBB3Fr8GzFTywKIKGxk-2inhUWNrwTvOIQaxw-yVNRvHtFimR7-M_Uk6Mdekmn4WDWa6929jordxdw"
     }
     */
    NSDictionary * parameter = @{ @"data" : @{@"limit" : @10,
                                              @"offset" : @0
                                              },
                                  @"userid" : [MPMUserInfo getUserInfo][@"userId"],
                                  @"token" : [MPMUserInfo getToken]};
    AFHTTPSessionManager *manager = [MPMGlobal sessionManager];
    [manager POST:[NSString stringWithFormat:@"%@/pengajuan/listkontrak",kApiUrl] parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.data = responseObject[@"data"];
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.refreshControl endRefreshing];
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.data.count > 0) {
        return self.data.count;
    } else return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (self.data.count > 0) {
        self.tableView.backgroundView = nil;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        return 1;
        
    } else {
        
        // Display a message when the table is empty
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        messageLabel.text = @"No data is currently available. Please pull down to refresh.";
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
        [messageLabel sizeToFit];
        
        self.tableView.backgroundView = messageLabel;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    UILabel *noReg = [cell viewWithTag:1];
    noReg.text = self.data[indexPath.row][@"noRegistrasi"];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [SVProgressHUD show];
    NSDictionary * parameter = @{ @"data" : @{@"agreementNo" : self.data[indexPath.row][@"noRegistrasi"]
                                              },
                                  @"userid" : [MPMUserInfo getUserInfo][@"userId"],
                                  @"token" : [MPMUserInfo getToken]};
    AFHTTPSessionManager *manager = [MPMGlobal sessionManager];
    [manager POST:[NSString stringWithFormat:@"%@/pengajuan2/detailkontrak",kApiUrl] parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
            KontrakKerjaDetailViewController *vc = [[KontrakKerjaDetailViewController alloc] init];
            vc.data = responseObject[@"data"];
            [self.navigationController.navigationController.navigationController pushViewController:vc animated:YES];
            [SVProgressHUD dismiss];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
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
