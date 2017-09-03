//
//  SuggestionComplaintTableViewController.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 9/3/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "SuggestionComplaintTableViewController.h"
#import "SuggestionTableViewCell.h"
#import "ComplainTableViewCell.h"
#import "SuggestionComplaintModel.h"

@interface SuggestionComplaintTableViewController ()

@property NSArray *datas;
@property UISegmentedControl *segmentedControl;

@end

@implementation SuggestionComplaintTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.datas = [NSArray array];
    self.title = self.menu.title;
    self.segmentedControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(10, 10, self.tableView.frame.size.width - 20, 29)];
    [self.segmentedControl insertSegmentWithTitle:@"Pengaduan" atIndex:0 animated:NO];
    [self.segmentedControl insertSegmentWithTitle:@"Saran" atIndex:0 animated:NO];
    [self.segmentedControl setSelectedSegmentIndex:0];
    [self.segmentedControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 49)];
    [view addSubview:self.segmentedControl];
    
    [self.tableView setTableHeaderView:view];
    
    [self refreshData];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.segmentedControl setFrame:CGRectMake(10, 10, self.tableView.frame.size.width - 20, 29)];
}

- (void)refreshData{
    if (self.segmentedControl.selectedSegmentIndex == 0){
        [SuggestionComplaintModel getListSuggestionCompletion:^(NSArray *responses, NSError *error) {
            self.datas = responses;
            [self.tableView reloadData];
        }];
    } else {
        [SuggestionComplaintModel getListComplainCompletion:^(NSArray *responses, NSError *error) {
            self.datas = responses;
            [self.tableView reloadData];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        return 163;
    } else {
        return 268;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        SuggestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SuggestionCell"];
        if (!cell){
            [tableView registerNib:[UINib nibWithNibName:@"SuggestionTableViewCell" bundle:nil] forCellReuseIdentifier:@"SuggestionCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"SuggestionCell"];
        }
        
        NSDictionary *dictionary;
        @try {
            dictionary = [self.datas objectAtIndex:indexPath.row];
            
            cell.noKontrak.text = [dictionary objectForKey:@"noKontrak"];
            cell.tanggal.text = [dictionary objectForKey:@"tanggalSaran"];
            cell.nama.text = [dictionary objectForKey:@"nama"];
            cell.noHP.text = [dictionary objectForKey:@"noHp"];
            cell.email.text = [dictionary objectForKey:@"email"];
            cell.alamat.text = [dictionary objectForKey:@"alamat"];
            cell.saran.text = [dictionary objectForKey:@"saran"];
        } @catch (NSException *exception) {
            NSLog(@"%@", exception);
        }
        
        if (dictionary == nil) {
            cell.noKontrak.text = @"";
            cell.tanggal.text = @"";
            cell.nama.text = @"";
            cell.noHP.text = @"";
            cell.email.text = @"";
            cell.alamat.text = @"";
            cell.saran.text = @"";
        }
        
        return cell;
        
    } else {
        ComplainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ComplainCell"];
        if (!cell){
            [tableView registerNib:[UINib nibWithNibName:@"ComplainTableViewCell" bundle:nil] forCellReuseIdentifier:@"ComplainCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"ComplainCell"];
        }
        
        NSDictionary *dictionary;
        @try {
            dictionary = [self.datas objectAtIndex:indexPath.row];
            
            cell.noKontrak.text = [dictionary objectForKey:@"noKontrak"];
            cell.tanggal.text = [dictionary objectForKey:@"tangalPengajuan"];
            cell.nama.text = [dictionary objectForKey:@"nama"];
            cell.noTelp.text = [dictionary objectForKey:@"noTlp"];
            cell.noTelpBaru.text = [dictionary objectForKey:@"noTlpBaru"];
            cell.noHP.text = [dictionary objectForKey:@"noHp"];
            cell.noHPBaru.text = [dictionary objectForKey:@"noHpBaru"];
            cell.email.text = [dictionary objectForKey:@"email"];
            cell.alamat.text = [dictionary objectForKey:@"alamat"];
            cell.kategoriMasalah.text = [dictionary objectForKey:@"subJnsMasalah"];
            cell.kronologiMasalah.text = [dictionary objectForKey:@"kronologisMasalah"];
            cell.penjelasanMasalah.text = [dictionary objectForKey:@"penjelasanMasalah"];
        } @catch (NSException *exception) {
            NSLog(@"%@", exception);
        }
        
        if (dictionary == nil) {
            cell.noKontrak.text = @"";
            cell.tanggal.text = @"";
            cell.nama.text = @"";
            cell.noTelp.text = @"";
            cell.noTelpBaru.text = @"";
            cell.noHP.text = @"";
            cell.noHPBaru.text = @"";
            cell.email.text = @"";
            cell.alamat.text = @"";
            cell.kategoriMasalah.text = @"";
            cell.kronologiMasalah.text = @"";
            cell.penjelasanMasalah.text = @"";
        }
        
        return cell;
    }
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
