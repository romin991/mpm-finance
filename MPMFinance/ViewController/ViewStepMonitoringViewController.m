//
//  ViewStepMonitoringViewController.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 06/06/18.
//  Copyright © 2018 MPMFinance. All rights reserved.
//

#import "ViewStepMonitoringViewController.h"
#import "WorkOrderModel.h"
#import "ViewStepMonitoring.h"
#import "ViewStepMonitoringTableViewCell.h"

@interface ViewStepMonitoringViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSArray *dataSources;

@end

@implementation ViewStepMonitoringViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.tableView registerNib:[UINib nibWithNibName:@"ViewStepMonitoringTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    self.title = @"View Step Monitoring";
    [self setupDataSource];
}

- (void)setupDataSource{
    [SVProgressHUD show];
    [WorkOrderModel getViewStepMonitoringWithID:self.list.primaryKey completion:^(NSArray *datas, NSError *error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            [SVProgressHUD dismissWithDelay:1.5 completion:^{
                [self.navigationController popViewControllerAnimated:true];
            }];
        } else {
            [SVProgressHUD dismiss];
            self.dataSources = datas;
            [self.tableView reloadData];
            [self.tableView layoutIfNeeded];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSources.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ViewStepMonitoringTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    ViewStepMonitoring *object = [self.dataSources objectAtIndex:indexPath.row];
    if (object) {
        cell.titleLabel.text = object.label;
        cell.subtitleLabel.text = object.date;
        if ([object.status isEqualToString:@"1"]) {
            cell.checkImageView.image = [UIImage imageNamed:@"ViewStepMonitoringCheck"];
        } else if ([object.status isEqualToString:@"2"]) {
            cell.checkImageView.image = [UIImage imageNamed:@"ViewStepMonitoringStop"];
        } else {
            cell.checkImageView.image = [UIImage imageNamed:@"unselected"];
//            cell.checkImageView.image = [UIImage imageNamed:@"ViewStepMonitoringDefault"];
        }
        
        if ([object isEqual:self.dataSources.lastObject]) {
            cell.lineView.hidden = true;
        } else {
            cell.lineView.hidden = false;
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20)];
    [view setBackgroundColor:[UIColor clearColor]];
    return view;
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
