//
//  CustomerGetCustomerTableViewController.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 9/3/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "CustomerGetCustomerTableViewController.h"
#import "CustomerGetCustomerTableViewCell.h"
#import "CustomerGetCustomerModel.h"

@interface CustomerGetCustomerTableViewController ()

@property NSArray *datas;

@end

@implementation CustomerGetCustomerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.datas = [NSArray array];
    self.title = @"History Customer Get CUstomer";
    [CustomerGetCustomerModel getListCustomerGetCustomerCompletion:^(NSArray *responses, NSError *error) {
        self.datas = responses;
        [self.tableView reloadData];
    }];
  UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
  self.navigationItem.leftBarButtonItem = backButton;
}
- (void)back:(id)sender {
  [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomerGetCustomerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell){
        [tableView registerNib:[UINib nibWithNibName:@"CustomerGetCustomerTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    }
    
    NSDictionary *dictionary;
    @try {
        dictionary = [self.datas objectAtIndex:indexPath.row];
        
        cell.nama.text = [dictionary objectForKey:@"nama"];
        cell.noHP.text = [dictionary objectForKey:@"noHp"];
        cell.email.text = [dictionary objectForKey:@"email"];
        cell.alamat.text = [dictionary objectForKey:@"alamat"];
        cell.merk.text = [dictionary objectForKey:@"merk"];
        cell.tahunKendaraan.text = [dictionary objectForKey:@"tahunKendaraan"];
        
    } @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
    
    if (dictionary == nil) {
        cell.nama.text = @"";
        cell.noHP.text = @"";
        cell.email.text = @"";
        cell.alamat.text = @"";
        cell.merk.text = @"";
        cell.tahunKendaraan.text = @"";
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
