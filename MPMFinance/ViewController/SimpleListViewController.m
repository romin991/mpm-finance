//
//  SimpleListViewController.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 5/15/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "SimpleListViewController.h"
#import "SimpleListTableViewCell.h"
#import "Form.h"
#import "DataMAPFormViewController.h"
#import "DataMAPModel.h"

@interface SimpleListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property RLMResults *forms;
@property NSMutableDictionary *valueDictionary;
@property NSArray *statusGrouping;

@end

@implementation SimpleListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.statusGrouping = [NSArray array];
    
    self.forms = [Form getFormForMenu:self.menu.primaryKey];
    if (self.navigationTitle.length != 0) {
        [self setTitle:self.navigationTitle];
    } else {
        [self setTitle:self.menu.title];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.list) {
        [self fetchData];
    }
}

- (void)fetchData{
    //call API here
    __block SimpleListViewController *weakSelf = self;
    [SVProgressHUD show];
    [DataMAPModel getDataMAPWithID:self.list.primaryKey completion:^(NSDictionary *response, NSError *error) {
        if (error == nil) {
            if (response) {
              NSMutableDictionary *responseMutable = [NSMutableDictionary dictionaryWithDictionary:response];
              [responseMutable setObject:response[@"rca"] forKey:@"rCA"];
                weakSelf.valueDictionary = [NSMutableDictionary dictionaryWithDictionary:responseMutable];
                
                if ([weakSelf.valueDictionary objectForKey:@"statusGrouping"] && [[weakSelf.valueDictionary objectForKey:@"statusGrouping"] isKindOfClass:NSArray.class]) {
                    weakSelf.statusGrouping = [weakSelf.valueDictionary objectForKey:@"statusGrouping"];
                    [weakSelf.tableView reloadData];
                    [weakSelf.tableView layoutIfNeeded];
                }
            }
            [SVProgressHUD dismiss];
        } else {
            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
            [SVProgressHUD dismissWithDelay:1.5 completion:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.forms.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DataMAPFormViewController *formViewController = [[DataMAPFormViewController alloc] init];
    formViewController.menu = self.menu;
    formViewController.index = indexPath.row;
    formViewController.valueDictionary = self.valueDictionary;
    formViewController.isReadOnly = self.isReadOnly;
    [self.navigationController pushViewController:formViewController animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SimpleListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell){
        [tableView registerNib:[UINib nibWithNibName:@"SimpleListTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    }
    
    Form *form;
    @try {
        form = [self.forms objectAtIndex:indexPath.row];
    } @catch (NSException * e) {
        NSLog(@"Exception : %@", e);
    }
    
    if (form){
        cell.title.text = form.title;
        if ([self.statusGrouping containsObject:@(indexPath.row+1)]) {
            cell.checkmark.hidden = false;
        } else {
            cell.checkmark.hidden = true;
        }
    } else {
        cell.title.text = @"";
        cell.checkmark.hidden = true;
    }
    
    return cell;
}

//dataMAP delegate
- (void)saveDictionary:(NSDictionary *)dictionary{
    self.valueDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
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
