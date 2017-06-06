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

@end

@implementation SimpleListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.forms = [Form getFormForMenu:self.menu.title];
    if (self.navigationTitle.length != 0) {
        [self setTitle:self.navigationTitle];
    } else {
        [self setTitle:self.menu.title];
    }
    [self setRightBarButton];
    
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
                weakSelf.valueDictionary = [NSMutableDictionary dictionaryWithDictionary:response];
            }
            [SVProgressHUD dismiss];
        } else {
            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
            [SVProgressHUD dismissWithDelay:1.5];
        }
    }];
}

- (void)setRightBarButton{
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Submit"
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(submitButtonClicked:)];
    [self.navigationItem setRightBarButtonItem:barButtonItem];
}

- (void)submitButtonClicked:(id)sender{
    //call API, then ... 
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
    } else {
        cell.title.text = @"";
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
