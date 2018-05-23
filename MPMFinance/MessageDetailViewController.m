//
//  MessageDetailViewController.m
//  MPMFinance
//
//  Created by Romin Adi Santoso on 5/23/18.
//  Copyright © 2018 MPMFinance. All rights reserved.
//

#import "MessageDetailViewController.h"
#import "MPMCustomUI.h"
@interface MessageDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblContent;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation MessageDetailViewController


- (void)setup {
    self.lblDate.text = self.data[@"date"];
    self.lblTitle.text = self.data[@"title"];
    self.lblContent.text = self.data[@"isiPesan"];
    [MPMCustomUI giveBorderTo:self.titleView];
    [MPMCustomUI giveBorderTo:self.contentView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
