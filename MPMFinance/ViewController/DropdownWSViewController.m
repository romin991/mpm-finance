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

@property NSMutableArray *allDatas;
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
    self.allDatas = [NSMutableArray array];
    
    XLFormDescriptor *form = self.rowDescriptor.sectionDescriptor.formDescriptor;
    XLFormBaseDropdownViewController *formViewController = (XLFormBaseDropdownViewController *)form.delegate;
    NSDictionary *valueDictionary = formViewController.valueDictionary;
    self.idCabang = [valueDictionary objectForKey:@"kodeCabang"];
    
    for (XLFormOptionsObject *optionObject in self.rowDescriptor.selectorOptions) {
        Data *data = [[Data alloc] init];
        data.name = optionObject.displayText;
        data.value = optionObject.valueData;
        [self.allDatas addObject:data];
    }
    self.datas = [NSArray arrayWithArray:self.allDatas];
    
//    if ([self.rowDescriptor.tag isEqualToString:@"pekerjaan"]) {
//        self.type = @"Pekerjaan";
//    } else if ([self.rowDescriptor.tag isEqualToString:@"bidangUsaha"]){
//        self.type = @"BidangUsaha";
//    } else {
//        [SVProgressHUD showErrorWithStatus:@"Data not found"];
//        [SVProgressHUD dismissWithDelay:1.5];
//        [self.navigationController popViewControllerAnimated:true];
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.name CONTAINS[cd] %@", searchText];
    self.datas = [self.allDatas filteredArrayUsingPredicate:predicate];
    [self refresh];
    
//    __block typeof(self) weakSelf = self;
//    [DropdownModel getDropdownWSType:self.type keyword:searchText idCabang:self.idCabang additionalURL:@"" completion:^(NSArray *datas, NSError *error) {
//        weakSelf.datas = datas;
//        [weakSelf refresh];
//    }];
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
