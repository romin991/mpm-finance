//
//  SetAlternateTableViewController.m
//  MPMFinance
//
//  Created by Romin Adi Santoso on 5/23/18.
//  Copyright © 2018 MPMFinance. All rights reserved.
//

#import "SetAlternateViewController.h"
#import "SetAlternateTableViewCell.h"
#import "APIModel.h"
#import <UIScrollView+SVInfiniteScrolling.h>
#import <UIScrollView+SVPullToRefresh.h>
#import "SetAlternateDetailViewController.h"
#define kHistoryPerPage 10
@interface SetAlternateViewController ()<UITableViewDelegate,UITableViewDataSource>
@property NSMutableArray *data;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property int currentPage;
@end

@implementation SetAlternateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak SetAlternateViewController *weakSelf = self;
    
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf loadFirstPage];
    }];
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMoreData];
    }];
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithTitle:@"Tambah" style:UIBarButtonItemStylePlain target:self action:@selector(tambah:)];
    self.navigationItem.rightBarButtonItem = rightBar;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView registerNib:[UINib nibWithNibName:@"SetAlternateTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    self.title = @"Set Alternate";
}
-(void)viewWillAppear:(BOOL)animated{
    [self loadFirstPage];
}
-(void)tambah:(id)sender {
    SetAlternateDetailViewController *detailViewController = [[SetAlternateDetailViewController alloc] initWithNibName:@"SetAlternateDetailViewController" bundle:nil];
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
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
    __weak SetAlternateViewController *weakSelf = self;
    int offset = page * kHistoryPerPage;
    NSString* url = [NSString stringWithFormat:@"%@/pengajuan2/historyalternate",kApiUrl];
    NSDictionary* param = @{@"data" : @{@"limit" : @10,
                                        @"offset" : @(offset)
                                        },
                            @"userid" : [MPMUserInfo getUserInfo][@"userId"],
                            @"token" : [MPMUserInfo getToken]};
    
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
    SetAlternateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [cell setupWithData:self.data[indexPath.row]];
    // Configure the cell...
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    SetAlternateDetailViewController *detailViewController = [[SetAlternateDetailViewController alloc] initWithNibName:@"SetAlternateDetailViewController" bundle:nil];
    detailViewController.data = self.data[indexPath.row];
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
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
