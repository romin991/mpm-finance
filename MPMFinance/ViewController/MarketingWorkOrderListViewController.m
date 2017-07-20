//
//  MarketingWorkOrderListViewController.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 7/20/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "MarketingWorkOrderListViewController.h"
#import "List.h"
#import "WorkOrderModel.h"
#import "WorkOrderListTableViewCell.h"

#import <UIScrollView+SVPullToRefresh.h>
#import <UIScrollView+SVInfiniteScrolling.h>
#import "UIImageView+AFNetworking.h"

@interface MarketingWorkOrderListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *lists;
@property NSInteger page;

@end

@implementation MarketingWorkOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.translucent = NO;
    [self setTitle:self.menu.title];
    
    self.page = 0;
    __block typeof(self) weakSelf = self;
    [self loadDataForPage:self.page];
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf loadDataForPage:0];
    }];
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadDataForPage:weakSelf.page];
    }];
    
}

- (void)loadDataForPage:(NSInteger)page{
    [SVProgressHUD show];
    __block typeof(self) weakSelf = self;
    [WorkOrderModel getListWorkOrderWithUserID:self.userID page:page completion:^(NSArray *lists, NSError *error) {
        if (page == 0) {
            if (lists) {
                weakSelf.lists = [NSMutableArray arrayWithArray:lists];
                if (weakSelf.tableView) {
                    [weakSelf.tableView scrollRectToVisible:CGRectMake(0, 0, 0, 0) animated:YES];
                    [weakSelf.tableView reloadData];
                }
            };
            weakSelf.page = 1;
            [weakSelf.tableView.pullToRefreshView stopAnimating];
            
        } else {
            if (lists && lists.count > 0) {
                [weakSelf.lists addObjectsFromArray:lists];
                if (weakSelf.tableView) {
                    [weakSelf.tableView scrollRectToVisible:CGRectMake(0, 0, 0, 0) animated:YES];
                    [weakSelf.tableView reloadData];
                }
                weakSelf.page += 1;
            };
            [weakSelf.tableView.infiniteScrollingView stopAnimating];
        }
        
        if (error) {
            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
            [SVProgressHUD dismissWithDelay:1.5];
        } else {
            [SVProgressHUD dismiss];
        }
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lists.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //sofar do nothing
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WorkOrderListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell){
        [tableView registerNib:[UINib nibWithNibName:@"ListTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    List *list;
    @try {
        list = [self.lists objectAtIndex:indexPath.row];
    } @catch (NSException * e) {
        NSLog(@"Exception : %@", e);
    }
    
    if (list){
        if (list.imageURL.length > 0){
            cell.icon.image = nil;
            [cell.icon setContentMode:UIViewContentModeScaleAspectFit];
            NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:list.imageURL]
                                                          cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                      timeoutInterval:60];
            
            __weak UIImageView *weakImageView = cell.icon;
            [cell.icon setImageWithURLRequest:imageRequest
                             placeholderImage:nil
                                      success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                          if (weakImageView) weakImageView.image = image;
                                      }
                                      failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                          if (weakImageView) weakImageView.image = nil;
                                      }];
        }
        
        if (list.status.length > 0) {
            [MPMGlobal giveBorderTo:cell.status withBorderColor:list.statusColor withCornerRadius:8.0f];
            cell.status.text = list.status;
            cell.status.textColor = [MPMGlobal colorFromHexString:list.statusColor];
            cell.status.hidden = NO;
        } else {
            cell.status.hidden = YES;
        }
        cell.title.text = list.title;
        cell.date.text = list.date;
        cell.assignee.text = list.assignee;
        
    } else {
        cell.status.text = @"";
        cell.icon.image = nil;
        cell.title.text = @"";
        cell.date.text = @"";
        cell.assignee.text = @"";
    }
    
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
