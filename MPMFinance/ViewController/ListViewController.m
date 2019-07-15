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
#import "SubmenuCollectionViewController.h"
#import <SVProgressHUD.h>
#import "SimpleListViewController.h"
#import "FormViewController.h"
#import "APIModel.h"
#import "SurveyFormViewController.h"
#import <UIScrollView+SVPullToRefresh.h>
#import <UIScrollView+SVInfiniteScrolling.h>
#import "OfflineDataManager.h"
#import "WorkOrderModel.h"
#import "ViewStepMonitoringViewController.h"

@interface ListViewController ()<UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *segmentedView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *segmentedViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIStackView *horizontalStackView;

@property NSMutableArray *lists;
@property Menu *submenu;
@property NSInteger page;
@property NSInteger selectedIndex;
@property RLMResults *dataSources;
@property OfflineData *selectedOfflineData;
@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    // Do any additional setup after loading the view from its nib.
    
    if (self.navigationTitle.length == 0) {
        [self setTitle:self.menu.title];
    } else {
        [self setTitle:self.navigationTitle];
    }
    self.submenu = self.menu.submenus.firstObject;
    self.dataSources = [Menu getDataSourcesForMenu:self.submenu.primaryKey role:[MPMUserInfo getRole]];
    
    Action *rightButtonAction = self.submenu.rightButtonAction;
    if (rightButtonAction) {
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:rightButtonAction.name style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonClicked:)];
        
        [self.navigationItem setRightBarButtonItem:rightButton];
    }
    
    __block ListViewController *weakSelf = self;
  
    
    if (self.submenu.isOnePageOnly == NO) {
        [self.tableView addPullToRefreshWithActionHandler:^{
            [weakSelf loadDataForSelectedIndex:weakSelf.selectedIndex andPage:0];
        }];
        [self.tableView addInfiniteScrollingWithActionHandler:^{
            [weakSelf loadDataForSelectedIndex:weakSelf.selectedIndex andPage:weakSelf.page];
        }];
    }
    
    [self setupSegmentedControl];
}
-(void)viewWillAppear:(BOOL)animated{
  self.page = 0;
  self.selectedOfflineData = nil;
  self.selectedIndex = 0;
  if ([[OfflineData allObjects] count] > 0 && [self.menu.title isEqualToString:kSubmenuListPengajuanApplikasi]) {
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Silahkan lanjutkan pengajuan awal anda pada menu offline." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okButton = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
      self.page = 0;
      self.selectedIndex = 1;
      [self loadDataForSelectedIndex:self.selectedIndex andPage:self.page];
    }];
    [alertController addAction:okButton];
    [self presentViewController:alertController animated:YES completion:nil];
  }
  
  [self loadDataForSelectedIndex:self.selectedIndex andPage:self.page];
}

- (void)setupSegmentedControl{
    if (self.dataSources.count <= 1) {
        self.segmentedViewHeightConstraint.constant = 0;
        
    } else {
        for (int i = 0; i < self.dataSources.count; i++) {
            Action *action = [self.dataSources objectAtIndex:i];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:action.name forState:UIControlStateNormal];
            [button setTag:i];
            [button addTarget:self action:@selector(segmentedButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            if (i == 0){
                button.titleLabel.font = [UIFont fontWithName:@"Avenir-Heavy" size:18];
            } else {
                button.titleLabel.font = [UIFont fontWithName:@"Avenir-Book" size:18];
            }
            
            [self.horizontalStackView addArrangedSubview:button];
        }
    }
}

- (void)segmentedButtonClicked:(id)sender{
    UIButton *button = sender;
    @try {
        Action *dataSource = [self.dataSources objectAtIndex:button.tag];
        if (dataSource) {
            self.page = 0;
            self.selectedIndex = button.tag;
            
            for (UIButton *anotherButton in self.horizontalStackView.arrangedSubviews) {
                anotherButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Book" size:18];
            }
            
            button.titleLabel.font = [UIFont fontWithName:@"Avenir-Heavy" size:18];
            
            [self loadDataForSelectedIndex:self.selectedIndex andPage:self.page];
        }
    } @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
}

- (void)dealloc{
    NSLog(@"dealloc");
}

- (void)loadDataForSelectedIndex:(NSInteger)index andPage:(NSInteger)page{
    __block NSString *methodName;
    Action *dataSource;
    if (self.dataSources.count > index) {
        dataSource = [self.dataSources objectAtIndex:index];
        if (dataSource.methodName) methodName = dataSource.methodName;
    }
    if ([dataSource.actionType isEqualToString:kActionQueryDB]) {
        NSArray *offlineData = [OfflineDataManager loadAllOfflineSubmission];
        self.lists = [NSMutableArray arrayWithArray:offlineData];
        [self.tableView reloadData];
    }
    else if ([APIModel respondsToSelector:NSSelectorFromString(methodName)]) {
        __block ListViewController *weakSelf = self;
        __block NSInteger weakPage = page;
        __block void (^handler)(NSArray *lists, NSError *error) = ^void(NSArray *lists, NSError *error){
            dispatch_async(dispatch_get_main_queue(), ^{
                //set the result here
                if (page == 0) {
                    if (lists) {
                        weakSelf.lists = [NSMutableArray arrayWithArray:lists];
                        if (weakSelf.tableView) {
                            [weakSelf.tableView scrollRectToVisible:CGRectMake(0, 0, 0, 0) animated:YES];
                            [weakSelf.tableView reloadData];
                        }
                    };
                    weakSelf.page = 1;
                    [weakSelf.tableView.pullToRefreshView stopAnimating];
                } else {
                    if (lists && lists.count > 0) {
                        [weakSelf.lists addObjectsFromArray:lists];
                        if (weakSelf.tableView) {
                            [weakSelf.tableView scrollRectToVisible:CGRectMake(0, 0, 0, 0) animated:YES];
                            [weakSelf.tableView reloadData];
                        }
                        weakSelf.page += 1;
                    };
                    [weakSelf.tableView.infiniteScrollingView stopAnimating];
                }
                
                if (error) {
                  
                } else {
                    [SVProgressHUD dismiss];
                }
            });
        };
        
        NSMethodSignature * mySignature = [APIModel methodSignatureForSelector:NSSelectorFromString(methodName)];
        NSInvocation * myInvocation = [NSInvocation invocationWithMethodSignature:mySignature];
        [myInvocation setTarget:[APIModel class]];
        [myInvocation setSelector:NSSelectorFromString(methodName)];
        [myInvocation setArgument:&weakPage atIndex:2];
        [myInvocation setArgument:&handler atIndex:3];
        [myInvocation retainArguments];
        
       // [SVProgressHUD show];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [myInvocation invoke];
        });
        
    } else {
        [SVProgressHUD showErrorWithStatus:@"No method found"];
        [SVProgressHUD dismissWithDelay:1.5];
    }
}

- (void)rightButtonClicked:(id)sender{
    [self selectedList:nil withSubmenu:self.submenu];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        if ([self.lists[indexPath.row] isKindOfClass:[OfflineData class]]) {
            list = ((OfflineData *)[self.lists objectAtIndex:indexPath.row]).convertToList;
        } else {
            list = [self.lists objectAtIndex:indexPath.row];
          if ([OfflineData getById:list.primaryKey]) {
            UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Silahkan lanjutkan pengajuan awal anda pada menu offline." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* okButton = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
              self.page = 0;
              self.selectedIndex = 1;
              [self loadDataForSelectedIndex:self.selectedIndex andPage:self.page];
            }];
            [alertController addAction:okButton];
            [self presentViewController:alertController animated:YES completion:nil];
            return;
            
          }
        }
    } @catch (NSException * e) {
        NSLog(@"Exception : %@", e);
    }
    
    if (list){
        self.selectedList = list;
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
                        if ([APIModel respondsToSelector:NSSelectorFromString(methodName)]) {
                            [SVProgressHUD show];
                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                [APIModel performSelector:NSSelectorFromString(methodName) withObject:list];
                            });
                        } else {
                            [SVProgressHUD showErrorWithStatus:@"No method found"];
                            [SVProgressHUD dismissWithDelay:1.5];
                        }
                    }
                    
                    if ([action.actionType isEqualToString:kActionTypeForward]){
                        [self selectedList:list withSubmenu:self.submenu];
                    }
                   
                    if ([action.actionType isEqualToString:kActionTypeSelfCustomMethod]){
                        __block NSString *methodName = action.methodName;
                        if ([ListViewController respondsToSelector:NSSelectorFromString(methodName)]) {
                            [ListViewController performSelector:NSSelectorFromString(methodName) withObject:self];
                        } else {
                            [SVProgressHUD showErrorWithStatus:@"No method found"];
                            [SVProgressHUD dismissWithDelay:1.5];
                        }
                    }
                }]];
            }
            
            // Present action sheet.
            [self presentViewController:actionSheet animated:YES completion:nil];
        } else {
            
            if ([self.lists[indexPath.row] isKindOfClass:[OfflineData class]]) {
                self.selectedOfflineData = self.lists[indexPath.row];
            }
            
            
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
        submenuViewController.list = list;
        [self.navigationController pushViewController:submenuViewController animated:YES];
        
    } else if ([submenu.menuType isEqualToString:kMenuTypeSubmenu2]) {
        SubmenuCollectionViewController *submenuCollectionViewController = [[SubmenuCollectionViewController alloc] init];
        submenuCollectionViewController.menu = submenu;
        [self.navigationController pushViewController:submenuCollectionViewController animated:YES];
        
    } else if ([submenu.menuType isEqualToString:kMenuTypeFormDataMAP]){
        SimpleListViewController *simpleListViewController = [[SimpleListViewController alloc] init];
        simpleListViewController.menu = submenu;
        simpleListViewController.title = self.menu.title;
        simpleListViewController.list = list;
        [self.navigationController pushViewController:simpleListViewController animated:YES];
        
    } else if ([submenu.menuType isEqualToString:kMenuTypeFormWorkOrder]){
        FormViewController *formViewController = [[FormViewController alloc] init];
        formViewController.parentMenu = self.menu;
        formViewController.menu = submenu;
      if ([self.menu.primaryKey isEqualToString:@"Monitoring "]) {
        formViewController.isFromMonitoring = YES;
        formViewController.isFromMonitoringPengajuanOnline = YES;
      }
        if (!self.selectedOfflineData) {
            formViewController.list = list;
        }
        else {
          formViewController.list = [self.selectedOfflineData convertToList];
            formViewController.valueDictionary = [NSMutableDictionary dictionaryWithDictionary:[self.selectedOfflineData getDataDictionary]];
        }
        [self.navigationController pushViewController:formViewController animated:YES];
        
    } else if ([submenu.menuType isEqualToString:kMenuTypeFormSurvey]) {
        SurveyFormViewController *surveyViewController = [[SurveyFormViewController alloc] init];
        surveyViewController.menu = submenu;
        surveyViewController.list = list;
        [self.navigationController pushViewController:surveyViewController animated:YES];
        
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
        if ([self.lists[indexPath.row] isKindOfClass:[OfflineData class]]) {
            list = ((OfflineData *)[self.lists objectAtIndex:indexPath.row]).convertToList;
        } else {
            list = [self.lists objectAtIndex:indexPath.row];
        }
    } @catch (NSException * e) {
        NSLog(@"Exception : %@", e);
    }
    
    if (list){
        if (list.imageURL.length > 0){
            cell.icon.image = [UIImage imageNamed:@"AppIcon"];
            [cell.icon setContentMode:UIViewContentModeScaleAspectFit];
            NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:list.imageURL]
                                                          cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                      timeoutInterval:60];
            
            __weak UIImageView *weakImageView = cell.icon;
            [cell.icon setImageWithURLRequest:imageRequest
                             placeholderImage:[UIImage imageNamed:@"AppIcon"]
                                      success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                          if (weakImageView) weakImageView.image = image;
                                      }
                                      failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                          if (weakImageView) weakImageView.image = nil;
                                      }];
        } else {
          cell.icon.image = [UIImage imageNamed:@"AppIcon"];
        }
        
        if (list.status.length > 0) {
            [MPMGlobal giveBorderTo:cell.status withBorderColor:list.statusColor withCornerRadius:8.0f];
            cell.status.text = list.status;
            cell.status.textColor = [MPMGlobal colorFromHexString:list.statusColor];
            cell.status.hidden = NO;
        } else {
            cell.status.hidden = YES;
        }
        cell.title.text = list.title;
        cell.date.text = list.date;
        cell.assignee.text = list.assignee;
    } else {
        cell.status.text = @"";
        cell.icon.image = nil;
        cell.title.text = @"";
        cell.date.text = @"";
        cell.assignee.text = @"";
    }
    
    return cell;
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  if ([self.menu.primaryKey isEqualToString:@"Monitoring "]) {
    return NO;
  } else 
    return YES;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if ([self.lists[indexPath.row] isKindOfClass:[OfflineData class]]) {
            [OfflineData deleteOfflineData:self.lists[indexPath.row]];
        } else{
            List *list = self.lists[indexPath.row];
            [SVProgressHUD show];
            [WorkOrderModel deleteCustomerDraft:@(list.primaryKey)];
        }
        
        [self.lists removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    }
}

#pragma mark - Self Custom Method for Action
+ (void)goToStepMonitoring:(ListViewController *)sender{
    ViewStepMonitoringViewController *vc = [[ViewStepMonitoringViewController alloc] init];
    vc.list = sender.selectedList;
    [sender.navigationController pushViewController:vc animated:true];
}

@end
