//
//  WorkOrderListViewController.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 6/26/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "WorkOrderListViewController.h"
#import "List.h"
#import "WorkOrderModel.h"
#import "DataSource.h"
#import "APIModel.h"
#import "SubmenuViewController.h"
#import "WorkOrderListTableViewCell.h"

#import <UIScrollView+SVPullToRefresh.h>
#import <UIScrollView+SVInfiniteScrolling.h>
#import "UIImageView+AFNetworking.h"

@interface WorkOrderListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *segmentedView;
@property (weak, nonatomic) IBOutlet UIStackView *horizontalStackView;

@property NSMutableArray *lists;
@property NSInteger page;
@property NSInteger selectedIndex;
@property NSMutableArray *dataSources;

@end

@implementation WorkOrderListViewController

- (void)setDataSources{
    self.dataSources = [NSMutableArray array];
    
    //supervisor
    if ([[MPMUserInfo getRole] isEqualToString:kRoleSupervisor]) {
        DataSource *dataSource = [[DataSource alloc] init];
        dataSource.name = @"Clear";
        dataSource.type = kDataSourceTypeSupervisorNew;
        [self.dataSources addObject:dataSource];
    
        dataSource = [[DataSource alloc] init];
        dataSource.name = @"Negative";
        dataSource.type = kDataSourceTypeSupervisorBadUsers;
        [self.dataSources addObject:dataSource];
    }
    
    //officer
    if ([[MPMUserInfo getRole] isEqualToString:kRoleOfficer]) {
        DataSource *dataSource = [[DataSource alloc] init];
        dataSource.name = @"All";
        dataSource.type = kDataSourceTypeAll;
        [self.dataSources addObject:dataSource];
    
        dataSource = [[DataSource alloc] init];
        dataSource.name = @"Approval";
        dataSource.type = kDataSourceTypeNeedApproval;
        [self.dataSources addObject:dataSource];
    }
    
    //dedicated
    if ([[MPMUserInfo getRole] isEqualToString:kRoleDedicated]) {
        DataSource *dataSource = [[DataSource alloc] init];
        dataSource.name = @"Clear";
        dataSource.type = kDataSourceTypeAll;
        [self.dataSources addObject:dataSource];
    
        dataSource = [[DataSource alloc] init];
        dataSource.name = @"Negative";
        dataSource.type = kDataSourceTypeBadUsers;
        [self.dataSources addObject:dataSource];
        
        dataSource = [[DataSource alloc] init];
        dataSource.name = @"Approval";
        dataSource.type = kDataSourceTypeNeedApproval;
        [self.dataSources addObject:dataSource];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setDataSources];
    [self setTitle:self.menu.title];
    
    self.page = 0;
    self.selectedIndex = 0;
    __block WorkOrderListViewController *weakSelf = self;
    [self loadDataForSelectedIndex:self.selectedIndex andPage:self.page];
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf loadDataForSelectedIndex:weakSelf.selectedIndex andPage:0];
    }];
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadDataForSelectedIndex:weakSelf.selectedIndex andPage:weakSelf.page];
    }];
    
    [self setupSegmentedControl];
}

- (void)setupSegmentedControl{
    for (int i = 0; i < self.dataSources.count; i++) {
        DataSource *dataSource = [self.dataSources objectAtIndex:i];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:dataSource.name forState:UIControlStateNormal];
        [button setTag:i];
        [button addTarget:self action:@selector(segmentedButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0){
            button.titleLabel.font = [UIFont fontWithName:@"Avenir-Heavy" size:18];
        } else {
            button.titleLabel.font = [UIFont fontWithName:@"Avenir-Book" size:18];
        }
        
        [self.horizontalStackView addArrangedSubview:button];
    }
}

- (void)segmentedButtonClicked:(id)sender{
    UIButton *button = sender;
    @try {
        DataSource *dataSource = [self.dataSources objectAtIndex:button.tag];
        if (dataSource) {
            self.page = 0;
            self.selectedIndex = button.tag;
            
            for (UIButton *anotherButton in self.horizontalStackView.arrangedSubviews) {
                anotherButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Book" size:18];
            }
            
            button.titleLabel.font = [UIFont fontWithName:@"Avenir-Heavy" size:18];
            
            [self loadDataForSelectedIndex:self.selectedIndex andPage:self.page];
        }
    } @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
}

- (void)dealloc{
    NSLog(@"dealloc");
}

- (void)loadDataForSelectedIndex:(NSInteger)index andPage:(NSInteger)page{
    [SVProgressHUD show];
    DataSource *dataSource = [self.dataSources objectAtIndex:index];
    if (dataSource) {
        __block WorkOrderListViewController *weakSelf = self;
        if ([dataSource.type isEqualToString:kDataSourceTypeAll]){
            [APIModel getAllListWorkOrderPage:page completion:^(NSArray *lists, NSError *error) {
                [weakSelf loadDataWithList:lists page:page error:error];
            }];
        } else if ([dataSource.type isEqualToString:kDataSourceTypeBadUsers]){
            [APIModel getBadUsersListWorkOrderPage:page completion:^(NSArray *lists, NSError *error) {
                [weakSelf loadDataWithList:lists page:page error:error];
            }];
        } else if ([dataSource.type isEqualToString:kDataSourceTypeNeedApproval]){
            [APIModel getNeedApprovalListWorkOrderPage:page completion:^(NSArray *lists, NSError *error) {
                [weakSelf loadDataWithList:lists page:page error:error];
            }];
        } else if ([dataSource.type isEqualToString:kDataSourceTypeSupervisorNew]){
            [APIModel getNewBySupervisorListWorkOrderPage:page completion:^(NSArray *lists, NSError *error) {
                [weakSelf loadDataWithList:lists page:page error:error];
            }];
        } else if ([dataSource.type isEqualToString:kDataSourceTypeSupervisorBadUsers]){
            [APIModel getBadUsersBySupervisorListWorkOrderPage:page completion:^(NSArray *lists, NSError *error) {
                [weakSelf loadDataWithList:lists page:page error:error];
            }];
        }
    }
}

- (void)loadDataWithList:(NSArray *)lists page:(NSInteger)page error:(NSError *)error{
    dispatch_async(dispatch_get_main_queue(), ^{
        //set the result here
        if (page == 0) {
            if (lists) {
                self.lists = [NSMutableArray arrayWithArray:lists];
                if (self.tableView) {
                    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 0, 0) animated:YES];
                    [self.tableView reloadData];
                }
            };
            self.page = 1;
            [self.tableView.pullToRefreshView stopAnimating];
        } else {
            if (lists && lists.count > 0) {
                [self.lists addObjectsFromArray:lists];
                if (self.tableView) {
                    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 0, 0) animated:YES];
                    [self.tableView reloadData];
                }
                self.page += 1;
            };
            [self.tableView.infiniteScrollingView stopAnimating];
        }
        
        if (error) {
            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
            [SVProgressHUD dismissWithDelay:1.5];
        } else {
            [SVProgressHUD dismiss];
        }
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lists.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    List *list;
    DataSource *dataSource;
    @try {
        list = [self.lists objectAtIndex:indexPath.row];
        dataSource = [self.dataSources objectAtIndex:self.selectedIndex];
    } @catch (NSException * e) {
        NSLog(@"Exception : %@", e);
    }
    
    if (list && dataSource){
        if ([dataSource.type isEqualToString:kDataSourceTypeAll]){
            [self selectedList:list];
            
        } else if ([dataSource.type isEqualToString:kDataSourceTypeBadUsers]){
            //showing popup you sure want to proceed?
            
        } else if ([dataSource.type isEqualToString:kDataSourceTypeNeedApproval]){
            //showing popup you sure want to proceed?
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Approve" message:@"Are you sure want to approve?" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                //nothing
                
            }]];
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //approve
                [SVProgressHUD show];
                [WorkOrderModel setApproveWithID:list.primaryKey completion:^(NSDictionary *dictionary, NSError *error) {
                    if (error) {
                        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                        [SVProgressHUD dismissWithDelay:1.5];
                    } else {
                        [self loadDataForSelectedIndex:self.selectedIndex andPage:0];
                        [SVProgressHUD dismiss];
                    }
                }];
                
            }]];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
        } else if ([dataSource.type isEqualToString:kDataSourceTypeSupervisorNew]){
            [self selectedList:list];
            
        } else if ([dataSource.type isEqualToString:kDataSourceTypeSupervisorBadUsers]){
            //showing popup you sure want to proceed?
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Stop Progress" message:@"Are you sure want to stop progress?" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                //nothing
                
            }]];
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //setblacklist
                [SVProgressHUD show];
                [WorkOrderModel setBlackListWithID:list.primaryKey type:@"stopProccess" completion:^(NSDictionary *dictionary, NSError *error) {
                    if (error) {
                        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                        [SVProgressHUD dismissWithDelay:1.5];
                    } else {
                        [self loadDataForSelectedIndex:self.selectedIndex andPage:self.page];
                        [SVProgressHUD dismiss];
                    }
                }];
                
            }]];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
}

- (void)selectedList:(List *)list{
    Menu *submenu = self.menu.submenus.firstObject;
    if ([submenu.menuType isEqualToString:kMenuTypeSubmenu]) {
        SubmenuViewController *submenuViewController = [[SubmenuViewController alloc] init];
        submenuViewController.menu = submenu;
        submenuViewController.list = list;
        [self.navigationController pushViewController:submenuViewController animated:YES];
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WorkOrderListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell){
        [tableView registerNib:[UINib nibWithNibName:@"WorkOrderListTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
