//
//  ListViewController.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 5/15/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "ListViewController.h"
#import "ListTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "SubmenuViewController.h"
#import <SVProgressHUD.h>

@interface ListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *lists;

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (self.menu) [self setTitle:self.menu.title];
    
    __block ListViewController *weakSelf = self;
    [SVProgressHUD show];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //get API call here
        dispatch_async(dispatch_get_main_queue(), ^{
            //set the result here
            NSMutableArray *dataSource = [NSMutableArray array];
            
            List *list = [[List alloc] init];
            list.title = @"PK1235";
            list.date = @"12 March 2017";
            list.assignee = @"Bejo";
            list.imageURL = @"https://image.flaticon.com/teams/new/1-freepik.jpg";
            [dataSource addObject:list];
            
            [weakSelf setDataSource:dataSource];
            [SVProgressHUD dismiss];
        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setDataSource:(NSArray<List *> *)lists{
    self.lists = [NSMutableArray arrayWithArray:lists];
    if (self.tableView) [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lists.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    List *list;
    @try {
        list = [self.lists objectAtIndex:indexPath.row];
    } @catch (NSException * e) {
        NSLog(@"Exception : %@", e);
    }
    
    if (list){
        if (self.menu && [self.menu.title isEqualToString:kMenuListWorkOrder]) {
            SubmenuViewController *submenuViewController = [[SubmenuViewController alloc] init];
            submenuViewController.menu = self.menu;
            [self.navigationController pushViewController:submenuViewController animated:YES];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell){
        [tableView registerNib:[UINib nibWithNibName:@"ListTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    List *list;
    @try {
        list = [self.lists objectAtIndex:indexPath.row];
    } @catch (NSException * e) {
        NSLog(@"Exception : %@", e);
    }
    
    if (list){
        if (list.imageURL.length > 0){
            cell.icon.image = nil;
            NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:list.imageURL]
                                                          cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                      timeoutInterval:60];
            
            __weak UIImageView *weakImageView = cell.icon;
            [cell.icon setImageWithURLRequest:imageRequest
                             placeholderImage:nil
                                      success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                          if (weakImageView) weakImageView.image = image;
                                      }
                                      failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                          if (weakImageView) weakImageView.image = nil;
                                      }];
        }
        
        cell.title.text = list.title;
        cell.date.text = list.date;
        cell.assignee.text = list.assignee;
    } else {
        cell.icon.image = nil;
        cell.title.text = @"";
        cell.date.text = @"";
        cell.assignee.text = @"";
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
