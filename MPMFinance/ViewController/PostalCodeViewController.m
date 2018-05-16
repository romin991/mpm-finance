//
//  PostalCodeViewController.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 7/9/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "PostalCodeViewController.h"
#import "PostalCode.h"
#import "PostalCodeTableViewCell.h"
#import "DropdownModel.h"

@interface PostalCodeViewController ()

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property NSArray *postalCodes;
@property NSString *idCabang;

@end

@implementation PostalCodeViewController
@synthesize rowDescriptor = _rowDescriptor;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.postalCodes = [NSArray array];
    
    XLFormDescriptor *form = self.rowDescriptor.sectionDescriptor.formDescriptor;
    for (XLFormSectionDescriptor *section in form.formSections) {
        for (XLFormRowDescriptor *row in section.formRows) {
            if ([row.tag isEqualToString:@"kodeCabang"]){
                if (row.value) {
                    self.idCabang = ((XLFormOptionsObject *) row.value).formValue;
                } else {
                    [SVProgressHUD showWithStatus:@"Pilih cabang terlebih dahulu"];
                    [SVProgressHUD dismissWithDelay:1.5];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    __block typeof(self) weakSelf = self;
    [DropdownModel getDropdownWSForPostalCodeWithKeyword:searchText idCabang:self.idCabang completion:^(NSArray *options, NSError *error) {
        weakSelf.postalCodes = options;
        [weakSelf refresh];
    }];
}

- (void)refresh{
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.postalCodes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PostalCodeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell){
        [tableView registerNib:[UINib nibWithNibName:@"PostalCodeTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    }
    
    PostalCode *postalCode;
    @try {
        postalCode = [self.postalCodes objectAtIndex:indexPath.row];
    } @catch (NSException * e) {
        NSLog(@"Exception : %@", e);
    }
    
    if (postalCode){
        cell.postalCode.text = postalCode.postalCode;
        cell.subDistrict.text = postalCode.subDistrict;
        cell.district.text = postalCode.disctrict;
        cell.city.text = postalCode.city;
    } else {
        cell.postalCode.text = @"";
        cell.subDistrict.text = @"";
        cell.district.text = @"";
        cell.city.text = @"";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PostalCode *postalCode;
    @try {
        postalCode = [self.postalCodes objectAtIndex:indexPath.row];
    } @catch (NSException * e) {
        NSLog(@"Exception : %@", e);
    }
    
    if (postalCode){
        self.rowDescriptor.value = postalCode;
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
