//
//  registerViewController.m
//  MPMFinance
//
//  Created by Romin Adi Santoso on 5/22/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "registerViewController.h"

@interface registerViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation registerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 500);
    
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
