//
//  ProductDetailViewController.m
//  MPMFinance
//
//  Created by Romin Adi Santoso on 4/24/18.
//  Copyright © 2018 MPMFinance. All rights reserved.
//

#import "ProductDetailViewController.h"

@interface ProductDetailViewController ()


@end

@implementation ProductDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated
{
    NSAttributedString *attributedString = [[NSAttributedString alloc]
                                            initWithData: [self.contentString dataUsingEncoding:NSUnicodeStringEncoding]
                                            options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                            documentAttributes: nil
                                            error: nil
                                            ];
    self.content.attributedText = attributedString;
    
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
