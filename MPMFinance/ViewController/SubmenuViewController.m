//
//  SubmenuViewController.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 5/15/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "SubmenuViewController.h"
#import "SubmenuTableViewCell.h"

@interface SubmenuViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *banner;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) RLMResults *submenus;

@end

@implementation SubmenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"Detail"];
    self.banner.image = [UIImage imageNamed:self.menu.backgroundImageName];
    self.icon.image = [UIImage imageNamed:self.menu.circleIconImageName];
    self.submenus = [Menu getSubmenuForMenu:self.menu.title role:kRoleDedicated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.submenus.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SubmenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell){
        [tableView registerNib:[UINib nibWithNibName:@"SubmenuTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    }
    
    cell.button.layer.borderWidth = 1;
    cell.button.layer.borderColor = [[UIColor greenColor] CGColor];
    
    Menu *submenu;
    @try {
        submenu = [self.submenus objectAtIndex:indexPath.row];
    } @catch (NSException * e) {
        NSLog(@"Exception : %@", e);
    }
    
    if (submenu){
        cell.icon.image = [UIImage imageNamed:submenu.imageName];
        cell.title.text = submenu.title;
    } else {
        cell.icon.image = nil;
        cell.title.text = @"";
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
