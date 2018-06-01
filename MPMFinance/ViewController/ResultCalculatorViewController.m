//
//  ResultCalculatorViewController.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 30/05/18.
//  Copyright © 2018 MPMFinance. All rights reserved.
//

#import "ResultCalculatorViewController.h"
#import "ResultTableViewCell.h"
#import "ResultTableData.h"

@interface ResultCalculatorViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation ResultCalculatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.tableView registerNib:[UINib nibWithNibName:@"ResultTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    
    if (self.dataSources.count == 0) self.dataSources = [NSMutableArray array];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSources.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    ResultTableData *data = [self.dataSources objectAtIndex:indexPath.row];
    if (data) {
        [cell setupCellWithData:data];
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
