//
//  SubmenuCollectionViewController.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 5/31/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "SubmenuCollectionViewController.h"
#import "SubmenuCollectionViewCell.h"
#import "FormViewController.h"
#import "SimpleListViewController.h"
#import "ListViewController.h"

@interface SubmenuCollectionViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *banner;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property RLMResults *submenus;

@end

@implementation SubmenuCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTitle:@"Detail"];
    self.banner.image = [UIImage imageNamed:self.menu.backgroundImageName];
    self.icon.image = [UIImage imageNamed:self.menu.circleIconImageName];
    self.submenus = [Menu getSubmenuForMenu:self.menu.title role:[MPMUserInfo getGroupLevel]];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"SubmenuCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Collection View Data Source

//- (CGSize)collectionView:(UICollectionView *)collectionView
//                  layout:(UICollectionViewLayout *)collectionViewLayout
//  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    return 
//}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.submenus.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SubmenuCollectionViewCell *cell = (SubmenuCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
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
#pragma mark - Collection View Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Menu *submenu;
    @try {
        submenu = [self.submenus objectAtIndex:indexPath.row];
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
        [self.navigationController pushViewController:simpleListViewController animated:YES];
    } else if ([submenu.menuType isEqualToString:kMenuTypeList]) {
        ListViewController *listViewController = [[ListViewController alloc] init];
        listViewController.menu = submenu;
        [self.navigationController pushViewController:listViewController animated:YES];
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
