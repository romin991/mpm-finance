//
//  AssetViewController.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 7/10/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "AssetViewController.h"
#import "Asset.h"
#import "DropdownModel.h"
#import "FormViewController.h"

@interface AssetViewController ()

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property NSArray *assets;
@property NSString *idCabang;
@property NSString *idProduct;

@end

@implementation AssetViewController
@synthesize rowDescriptor = _rowDescriptor;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.assets = [NSArray array];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    XLFormDescriptor *form = self.rowDescriptor.sectionDescriptor.formDescriptor;
    FormViewController *formViewController = (FormViewController *)form.delegate;
    NSDictionary *valueDictionary = formViewController.valueDictionary;
    self.idCabang = [valueDictionary objectForKey:@"kodeCabang"];
    
    for (XLFormSectionDescriptor *section in form.formSections) {
        for (XLFormRowDescriptor *row in section.formRows) {
            if ([row.tag isEqualToString:@"tipeProduk"]){
                if (row.value) {
                    self.idProduct = ((XLFormOptionsObject *) row.value).formValue;
                }
            }
        }
    }
    
    if (self.idProduct == nil || self.idCabang == nil) {
        [SVProgressHUD showErrorWithStatus:@"ID product not found"];
        [SVProgressHUD dismissWithDelay:1.5];
        [self.navigationController popViewControllerAnimated:true];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    __block typeof(self) weakSelf = self;
    [DropdownModel getDropdownWSForAssetWithKeyword:searchText idProduct:self.idProduct idCabang:self.idCabang completion:^(NSArray *options, NSError *error) {
        weakSelf.assets = options;
        [weakSelf refresh];
    }];
}

- (void)refresh{
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.assets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell){
        [tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"Cell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    }
    
    Asset *asset;
    @try {
        asset = [self.assets objectAtIndex:indexPath.row];
    } @catch (NSException * e) {
        NSLog(@"Exception : %@", e);
    }
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    if (asset){
        cell.textLabel.text = asset.name;
    } else {
        cell.textLabel.text = @"";
    }
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Asset *asset;
    @try {
        asset = [self.assets objectAtIndex:indexPath.row];
    } @catch (NSException * e) {
        NSLog(@"Exception : %@", e);
    }
    
    if (asset){
        self.rowDescriptor.value = asset;
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
