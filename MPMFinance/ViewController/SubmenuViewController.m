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
#import "SurveyFormViewController.h"
#import "DahsyatFormViewController.h"
#import "UsedCarFormViewController.h"
#import "NewCarFormViewController.h"
#import "TopUpFormViewController.h"
#import "LegalizationBPKBFormViewController.h"
#import "InsuranceClaimFormViewController.h"
#import "IntakeBPKBFormViewController.h"
#import "SuggestionComplainFormViewController.h"
#import "AssignMarketingListViewController.h"
#import "CustomerGetCustomerFormViewController.h"

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
    self.submenus = [Menu getSubmenuForMenu:self.menu.primaryKey role:[MPMUserInfo getRole]];
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
    
    if ([submenu.menuType isEqualToString:kMenuTypeFormWorkOrder]) {
        FormViewController *formViewController = [[FormViewController alloc] init];
        formViewController.menu = submenu;
        formViewController.list = self.list;
        [self.navigationController pushViewController:formViewController animated:YES];
        
    } else if ([submenu.menuType isEqualToString:kMenuTypeFormDataMAP]) {
        SimpleListViewController *simpleListViewController = [[SimpleListViewController alloc] init];
        simpleListViewController.menu = submenu;
        simpleListViewController.list = self.list;
        [self.navigationController pushViewController:simpleListViewController animated:YES];
        
    } else if ([submenu.menuType isEqualToString:kMenuTypeFormSurvey]) {
        SurveyFormViewController *surveyViewController = [[SurveyFormViewController alloc] init];
        surveyViewController.menu = submenu;
        surveyViewController.list = self.list;
        [self.navigationController pushViewController:surveyViewController animated:YES];
        
    } else if ([submenu.menuType isEqualToString:kMenuTypeFormDahsyat]) {
        DahsyatFormViewController *dahsyatViewController = [[DahsyatFormViewController alloc] init];
        dahsyatViewController.menu = submenu;
        [self.navigationController pushViewController:dahsyatViewController animated:YES];
        
    } else if ([submenu.menuType isEqualToString:kMenuTypeFormUsedCar]) {
        UsedCarFormViewController *usedCarViewController = [[UsedCarFormViewController alloc] init];
        usedCarViewController.menu = submenu;
        [self.navigationController pushViewController:usedCarViewController animated:YES];
        
    } else if ([submenu.menuType isEqualToString:kMenuTypeFormNewCar]) {
        NewCarFormViewController *newCarViewController = [[NewCarFormViewController alloc] init];
        newCarViewController.menu = submenu;
        [self.navigationController pushViewController:newCarViewController animated:YES];
        
    } else if ([submenu.menuType isEqualToString:kMenuTypeList]) {
        ListViewController *listViewController = [[ListViewController alloc] init];
        listViewController.menu = submenu;
        [self.navigationController pushViewController:listViewController animated:YES];
        
    } else if ([submenu.menuType isEqualToString:kMenuTypeCreditSimulation]){
        CreditSimulationViewController *creditSimulation = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CreditSimulationViewController"];
        creditSimulation.menuType = submenu.title;
        [self.navigationController pushViewController:creditSimulation animated:YES];
        
    } else if ([submenu.menuType isEqualToString:kMenuTypeFormTopUp]){
        TopUpFormViewController *topupFormViewController = [[TopUpFormViewController alloc] init];
        topupFormViewController.menu = submenu;
        [self.navigationController pushViewController:topupFormViewController animated:YES];

    } else if ([submenu.menuType isEqualToString:kMenuTypeFormLegalizationBPKB]){
        LegalizationBPKBFormViewController *legalizationBPKBViewController = [[LegalizationBPKBFormViewController alloc] init];
        legalizationBPKBViewController.menu = submenu;
        [self.navigationController pushViewController:legalizationBPKBViewController animated:YES];
        
    } else if ([submenu.menuType isEqualToString:kMenuTypeFormInsuranceClaim]){
        InsuranceClaimFormViewController *insuranceClaimFormViewController = [[InsuranceClaimFormViewController alloc] init];
        insuranceClaimFormViewController.menu = submenu;
        [self.navigationController pushViewController:insuranceClaimFormViewController animated:YES];
        
    } else if ([submenu.menuType isEqualToString:kMenuTypeFormPengambilanBPKB]){
        IntakeBPKBFormViewController *intakeBPKBFormViewController = [[IntakeBPKBFormViewController alloc] init];
        intakeBPKBFormViewController.menu = submenu;
        [self.navigationController pushViewController:intakeBPKBFormViewController animated:YES];
        
    } else if ([submenu.menuType isEqualToString:kMenuTypeFormSaranPengaduan]){
        SuggestionComplainFormViewController *suggestionComplainFormViewController = [[SuggestionComplainFormViewController alloc] init];
        suggestionComplainFormViewController.menu = submenu;
        [self.navigationController pushViewController:suggestionComplainFormViewController animated:YES];
        
    } else if ([submenu.menuType isEqualToString:kMenuTypeListAssignMarketing]){
        AssignMarketingListViewController *assignMarketingViewController = [[AssignMarketingListViewController alloc] init];
        assignMarketingViewController.menu = submenu;
        assignMarketingViewController.list = self.list;
        [self.navigationController pushViewController:assignMarketingViewController animated:YES];
        
    } else if ([submenu.menuType isEqualToString:kMenuTypeFormCustomerGetCustomer]){
        CustomerGetCustomerFormViewController *customerGetCustomerFormViewController = [[CustomerGetCustomerFormViewController alloc] init];
        customerGetCustomerFormViewController.menu = submenu;
        [self.navigationController pushViewController:customerGetCustomerFormViewController animated:YES];
        
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
