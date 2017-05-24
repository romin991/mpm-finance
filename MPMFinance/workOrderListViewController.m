//
//  workOrderListViewController.m
//  MPMFinance
//
//  Created by Romin Adi Santoso on 5/24/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "workOrderListViewController.h"

@interface workOrderListViewController ()

@end

@implementation workOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AFHTTPSessionManager* manager = [MPMGlobal sessionManager];
    NSDictionary* param = @{@"userid" : @"officer_spv",
                            @"token" : @"eyJraWQiOiIxIiwiYWxnIjoiUlMyNTYifQ.eyJpc3MiOiJnYXJ1ZGFhcGkiLCJleHAiOjE0OTU2MzQ0NTMsImp0aSI6IlItdThVSnB6TnhCaDBNUzhibUFkZ0EiLCJpYXQiOjE0OTU2MzQxNTMsIm5iZiI6MTQ5NTYzNDA5Mywic3ViIjoidGVtcGxhdGUiLCJyb2xlcyI6WyJST0xFX1VTRVIiXX0.jaDmmdHIP5kLMYeY4DK6uuWASygmccWeECtbVQjktAL-KAWsKjUxjhxDkviF75PaDSNOnUhhLnec5WqR3h3pbSTYpxU6YlmihZxkvLm30ZRh_i47XChGI1Aef-sr6IqfpXzdl3iMWOnTY3x_jmoALofCeYI-XzXU5WtFrUgGpLmlnaqz5qngx4P18zOD9l2GDJTefl4RRK0vX2FfCTMHnsGQalJXeFM_tkx3c2BfbHAewINV-RbWkN3Hl1dNMJMSByXctjCRCony4xFvDhpRyVtTZHc7fi2ohDqhjeMqx-pzP30kFzDI28tqGeZbZr7XzA_xFu6l-Vfx-BS3mXOvvQ"};
    [manager POST:[NSString stringWithFormat:@"%@/datamap/getworkorder",kApiUrl] parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"statusCode"] isEqual:@200]) {
            NSMutableArray *lists = [NSMutableArray array];
            for (NSDictionary* listDict in responseObject[@"data"]) {
                List *list = [[List alloc] init];
                list.title = listDict[@"noRegistrasi"];
                list.date = listDict[@"tanggal"];
                list.assignee = listDict[@"namaPengaju"];
                list.imageURL = @"https://image.flaticon.com/teams/new/1-freepik.jpg";
                [lists addObject:list];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setDataSource:lists];
            });
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ;
    }];
    // Do any additional setup after loading the view.
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
