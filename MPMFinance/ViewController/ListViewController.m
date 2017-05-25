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
#import "SimpleListViewController.h"
#import "FormViewController.h"
#import "APIModel.h"

@interface ListViewController ()<UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *lists;
@property Menu *submenu;

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (self.navigationTitle.length == 0) {
        [self setTitle:self.menu.title];
    } else {
        [self setTitle:self.navigationTitle];
    }
    self.submenu = self.menu.submenus.firstObject;
    
    __block ListViewController *weakSelf = self;
    __block NSString *methodName = self.submenu.fetchDataFromAPI ? self.submenu.fetchDataFromAPI.methodName : @"";
    [SVProgressHUD show];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([APIModel respondsToSelector:NSSelectorFromString(methodName)]) {
            [APIModel performSelector:NSSelectorFromString(methodName) withObject:^(NSArray *lists, NSError *error) {
                //set the result here
                if (error == nil) {
                    if (lists) [weakSelf setDataSource:lists];
                    [SVProgressHUD dismiss];
                } else {
                    [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
                    [SVProgressHUD dismissWithDelay:1.5];
                }
            }];
        } else {
            [SVProgressHUD showErrorWithStatus:@"No method found"];
            [SVProgressHUD dismissWithDelay:1.5];
            
            //set dummy here
            NSMutableArray *dataSource = [NSMutableArray array];
            
            List *list = [[List alloc] init];
            list.title = @"PK1235";
            list.date = @"12 March 2017";
            list.assignee = @"Bejo";
            list.imageURL = @"https://image.flaticon.com/teams/new/1-freepik.jpg";
            [dataSource addObject:list];
            
            [weakSelf setDataSource:dataSource];
        }
    });
    
    Action *rightButtonAction = self.submenu.rightButtonAction;
    if (rightButtonAction) {
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:rightButtonAction.name style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonClicked:)];
        
        [self.navigationItem setRightBarButtonItem:rightButton];
    }
}

- (void)rightButtonClicked:(id)sender{
    [self selectedList:nil withSubmenu:self.submenu];
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
        if (self.submenu.actions.count > 0) {
            NSString *alertMessage = [NSString stringWithFormat:@"Select action for %@ %@:", list.title, list.assignee];
            UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Select Action"
                                                                                 message:alertMessage
                                                                          preferredStyle:UIAlertControllerStyleActionSheet];
            
            [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                // Cancel button tappped.
                [actionSheet dismissViewControllerAnimated:YES completion:^{
                    NSLog(@"close");
                }];
            }]];
            
            for (Action *action in self.submenu.actions) {
                [actionSheet addAction:[UIAlertAction actionWithTitle:action.name style:UIAlertActionStyleDefault handler:^(UIAlertAction *alertAction) {
                    if ([action.actionType isEqualToString:kActionTypeAPICall]){
                        //call API send list
                        
                        __block NSString *methodName = action.methodName;
                        [SVProgressHUD show];
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            if ([APIModel respondsToSelector:NSSelectorFromString(methodName)]) {
                                [APIModel performSelector:NSSelectorFromString(methodName) withObject:list];
                            } else {
                                [SVProgressHUD showErrorWithStatus:@"No method found"];
                                [SVProgressHUD dismissWithDelay:1.5];
                            }
                        });
                    }
                    
                    if ([action.actionType isEqualToString:kActionTypeForward]){
                        [self selectedList:list withSubmenu:self.submenu];
                    }
                }]];
            }
            
            // Present action sheet.
            [self presentViewController:actionSheet animated:YES completion:nil];
        } else {
            [self selectedList:list withSubmenu:self.submenu];
        }
    }
}

- (void)selectedList:(List *)list withSubmenu:(Menu *)submenu{
    if (submenu.submenus.count == 1){
        submenu = submenu.submenus.firstObject;
    }
    
    if ([submenu.menuType isEqualToString:kMenuTypeSubmenu]) {
        SubmenuViewController *submenuViewController = [[SubmenuViewController alloc] init];
        submenuViewController.menu = submenu;
        [self.navigationController pushViewController:submenuViewController animated:YES];
        
    } else if ([submenu.menuType isEqualToString:kMenuTypeFormVertical]){
        SimpleListViewController *simpleListViewController = [[SimpleListViewController alloc] init];
        simpleListViewController.menu = submenu;
        simpleListViewController.title = self.menu.title;
        [self.navigationController pushViewController:simpleListViewController animated:YES];
        
    } else if ([submenu.menuType isEqualToString:kMenuTypeMap]){
        //create map view controller
        
    } else if ([submenu.menuType isEqualToString:kMenuTypeFormHorizontal]){
        FormViewController *formViewController = [[FormViewController alloc] init];
        formViewController.menu = submenu;
        [self.navigationController pushViewController:formViewController animated:YES];
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
