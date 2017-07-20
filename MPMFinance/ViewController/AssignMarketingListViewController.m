//
//  AssignCustomerListViewController.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 7/15/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "AssignMarketingListViewController.h"
#import "Marketing.h"
#import "MarketingModel.h"
#import "AssignMarketingTableViewCell.h"
#import "SubmenuViewController.h"
#import "MarketingWorkOrderListViewController.h"

#import <UIScrollView+SVPullToRefresh.h>
#import <UIScrollView+SVInfiniteScrolling.h>
#import "UIImageView+AFNetworking.h"

@interface AssignMarketingListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property NSMutableArray *marketings;

@end

@implementation AssignMarketingListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTitle:self.menu.title];
    [self loadData];
}

- (void)loadData{
    __block typeof(self) weakSelf = self;
    [SVProgressHUD show];
    [MarketingModel getAllMarketingBySupervisor:self.list.primaryKey completion:^(NSArray *marketings, NSError *error) {
        if (error) {
            NSString *errorMessage = error.localizedDescription;
            @try {
                NSDictionary *responseObject = [error userInfo][AFNetworkingOperationFailingURLResponseDataErrorKey];
                errorMessage = [responseObject objectForKey:@"message"];
            } @catch (NSException *exception) {
                NSLog(@"%@", exception);
            } @finally {
                [SVProgressHUD showErrorWithStatus:errorMessage];
                [SVProgressHUD dismissWithDelay:1.5];
            }
        } else {
            [SVProgressHUD dismiss];
            weakSelf.marketings = [NSMutableArray arrayWithArray:marketings];
            if (weakSelf.tableView) {
                [weakSelf.tableView scrollRectToVisible:CGRectMake(0, 0, 0, 0) animated:YES];
                [weakSelf.tableView reloadData];
            }
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return 104;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.marketings.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Marketing *marketing;
    @try {
        marketing = [self.marketings objectAtIndex:indexPath.row];
    } @catch (NSException * e) {
        NSLog(@"Exception : %@", e);
    }
    
    if (marketing){
        //showing popup you sure want to proceed?
        __block typeof(self) weakSelf = self;
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Select Action" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"View" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            MarketingWorkOrderListViewController *listViewController = [[MarketingWorkOrderListViewController alloc] init];
            listViewController.menu = self.menu;
            listViewController.userID = marketing.primaryKey;
            [self.navigationController pushViewController:listViewController animated:YES];
            
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Assign" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [SVProgressHUD show];
            [MarketingModel assignMarketing:self.list.primaryKey marketingId:marketing.primaryKey completion:^(NSDictionary *dictionary, NSError *error) {
                if (error) {
                    NSString *errorMessage = error.localizedDescription;
                    @try {
                        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:[error userInfo][AFNetworkingOperationFailingURLResponseDataErrorKey] options:NSJSONReadingAllowFragments error:nil];
                        NSString *message = [responseObject objectForKey:@"message"];
                        errorMessage = [message componentsSeparatedByString:@" | "][1];
                    } @catch (NSException *exception) {
                        NSLog(@"%@", exception);
                    } @finally {
                        [SVProgressHUD showErrorWithStatus:errorMessage];
                        [SVProgressHUD dismissWithDelay:1.5];
                    }
                } else {
                    [SVProgressHUD dismiss];
                    for (UIViewController *vc in weakSelf.navigationController.viewControllers) {
                        if ([vc isKindOfClass:[SubmenuViewController class]]) {
                            [weakSelf.navigationController popToViewController:vc animated:NO];
                        }
                    }
                }
            }];
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AssignMarketingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell){
        [tableView registerNib:[UINib nibWithNibName:@"AssignMarketingTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    Marketing *marketing;
    @try {
        marketing = [self.marketings objectAtIndex:indexPath.row];
    } @catch (NSException * e) {
        NSLog(@"Exception : %@", e);
    }
    
    if (marketing){
        if (marketing.imageURL.length > 0){
            cell.icon.image = nil;
            [cell.icon setContentMode:UIViewContentModeScaleAspectFit];
            NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:marketing.imageURL]
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

        cell.name.text = marketing.name;
        cell.accountName.text = marketing.accountName;
        cell.summaryWorkOrder.text = marketing.summaryWorkOrder;
        
    } else {
        cell.name.text = @"";
        cell.icon.image = nil;
        cell.accountName.text = @"";
        cell.summaryWorkOrder.text = @"";
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
