//
//  ReasonViewController.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 01/06/18.
//  Copyright © 2018 MPMFinance. All rights reserved.
//

#import "ReasonViewController.h"
#import "DropdownModel.h"
#import "Option.h"
#import "WorkOrderModel.h"
#import "BarcodeViewController.h"
#import "SubmenuViewController.h"
#import "MenuViewController.h"

@interface ReasonViewController ()<BarcodeDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSArray *dataSources;

@end

@implementation ReasonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"Cell"];
    self.title = @"Alasan";
    
    [SVProgressHUD show];
    __weak typeof(self) weakSelf = self;
    [DropdownModel getDropdownForType:@"getStopProses" completion:^(NSArray *options, NSError *error) {
        [SVProgressHUD dismiss];
        weakSelf.dataSources = options;
        [weakSelf.tableView reloadData];
        [weakSelf.tableView layoutIfNeeded];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSources.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    Option *option = [self.dataSources objectAtIndex:indexPath.row];
    if (option) {
        cell.textLabel.text = option.name;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Option *option = [self.dataSources objectAtIndex:indexPath.row];
    if (option) {
        [SVProgressHUD show];
        __weak typeof(self) weakSelf = self;
        [WorkOrderModel setStopProccessWithID:self.list.primaryKey reason:option.primaryKey completion:^(NSDictionary *dictionary, NSError *error) {
            if (error) {
                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                [SVProgressHUD dismissWithDelay:1.5];
            } else {
                [SVProgressHUD dismiss];
                
                BarcodeViewController *barcodeVC = [[BarcodeViewController alloc] init];
                barcodeVC.barcodeString = weakSelf.noRegistrasi;
                barcodeVC.modalPresentationStyle = UIModalPresentationFullScreen;
                barcodeVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                barcodeVC.delegate = weakSelf;
                
                [weakSelf presentViewController:barcodeVC animated:YES completion:nil];
            }
        }];
    }
}

- (void)finish{
    if ([[MPMUserInfo getRole] isEqualToString:kRoleDedicated]) {
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[MenuViewController class]]) {
                [self.navigationController popToViewController:vc animated:NO];
            }
        }
    } else {
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[SubmenuViewController class]]) {
                [self.navigationController popToViewController:vc animated:NO];
            }
        }
    }
}

@end
