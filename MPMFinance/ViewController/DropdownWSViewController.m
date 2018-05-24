//
//  DropdownWSViewController.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 23/05/18.
//  Copyright © 2018 MPMFinance. All rights reserved.
//

#import "DropdownWSViewController.h"
#import "Data.h"
#import "XLFormBaseDropdownViewController.h"
#import "DropdownModel.h"

@interface DropdownWSViewController ()

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property NSArray *datas;
@property NSString *idCabang;
@property NSString *idProduct;
@property NSString *type;

@end

@implementation DropdownWSViewController
@synthesize rowDescriptor = _rowDescriptor;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.datas = [NSArray array];
    
    XLFormDescriptor *form = self.rowDescriptor.sectionDescriptor.formDescriptor;
    XLFormBaseDropdownViewController *formViewController = (XLFormBaseDropdownViewController *)form.delegate;
    NSDictionary *valueDictionary = formViewController.valueDictionary;
    self.idCabang = [valueDictionary objectForKey:@"kodeCabang"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    __block typeof(self) weakSelf = self;
    [DropdownModel getDropdownWSType:self.type keyword:searchText idCabang:self.idCabang additionalURL:@"" completion:^(NSArray *datas, NSError *error) {
        weakSelf.datas = datas;
        [weakSelf refresh];
    }];
}

- (void)refresh{
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell){
        [tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"Cell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    }
    
    Data *data;
    @try {
        data = [self.datas objectAtIndex:indexPath.row];
    } @catch (NSException * e) {
        NSLog(@"Exception : %@", e);
    }
    
    if (data){
        cell.textLabel.text = data.name;
    } else {
        cell.textLabel.text = @"";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Data *data;
    @try {
        data = [self.datas objectAtIndex:indexPath.row];
    } @catch (NSException * e) {
        NSLog(@"Exception : %@", e);
    }
    
    if (data){
        self.rowDescriptor.value = data;
        [self.navigationController popViewControllerAnimated:YES];
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
