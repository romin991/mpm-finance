//
//  SubmenuViewController.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 5/15/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "SubmenuViewController.h"
#import "SubmenuTableViewCell.h"
#import "FormViewController.h"
#import "SimpleListViewController.h"
#import "ListViewController.h"
#import "CreditSimulationViewController.h"
@interface SubmenuViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *banner;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property RLMResults *submenus;

@end

@implementation SubmenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"Detail"];
    self.banner.image = [UIImage imageNamed:self.menu.backgroundImageName];
    self.icon.image = [UIImage imageNamed:self.menu.circleIconImageName];
    self.submenus = [Menu getSubmenuForMenu:self.menu.title role:[MPMUserInfo getGroupLevel]];
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

- (void)buttonClicked:(id)sender{
    UIButton *button = (UIButton *)sender;
    
    Menu *submenu;
    @try {
        submenu = [self.submenus objectAtIndex:button.tag];
    } @catch (NSException * e) {
        NSLog(@"Exception : %@", e);
    }
    
    if ([submenu.menuType isEqualToString:kMenuTypeFormHorizontal]) {
        FormViewController *formViewController = [[FormViewController alloc] init];
        formViewController.menu = submenu;
        [self.navigationController pushViewController:formViewController animated:YES];
    } else if ([submenu.menuType isEqualToString:kMenuTypeFormVertical]) {
        SimpleListViewController *simpleListViewController = [[SimpleListViewController alloc] init];
        simpleListViewController.menu = submenu;
        simpleListViewController.list = self.list;
        [self.navigationController pushViewController:simpleListViewController animated:YES];
    } else if ([submenu.menuType isEqualToString:kMenuTypeList]) {
        ListViewController *listViewController = [[ListViewController alloc] init];
        listViewController.menu = submenu;
        [self.navigationController pushViewController:listViewController animated:YES];
    }
    else if ([submenu.menuType isEqualToString:kMenuTypeCreditSimulation]){
        CreditSimulationViewController *creditSimulation = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CreditSimulationViewController"];
        creditSimulation.menuType = submenu.title;
        [self.navigationController pushViewController:creditSimulation animated:YES];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SubmenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell){
        [tableView registerNib:[UINib nibWithNibName:@"SubmenuTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    }
    
    cell.button.layer.borderWidth = 1;
    cell.button.layer.borderColor = [[UIColor grayColor] CGColor];
    cell.button.tag = indexPath.row;
    [cell.button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    Menu *submenu;
    @try {
        submenu = [self.submenus objectAtIndex:indexPath.row];
    } @catch (NSException * e) {
        NSLog(@"Exception : %@", e);
    }
    
    if (submenu){
        cell.icon.image = [UIImage imageNamed:submenu.imageName];
        cell.title.text = submenu.title;
        
        if (submenu.borderColor) {
            unsigned int hex;
            [[NSScanner scannerWithString:submenu.borderColor] scanHexInt:&hex];
            cell.button.layer.borderColor = [UIColorFromRGB(hex) CGColor];
        }
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
