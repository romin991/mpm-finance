//
//  SurveyFormViewController.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 6/7/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "SurveyFormViewController.h"
#import <XLForm.h>
#import "Form.h"
#import "SurveyModel.h"
#import "DropdownModel.h"
#import "FormModel.h"

@interface SurveyFormViewController ()

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property RLMResults *forms;
@property RLMArray *formRows;
@property XLFormDescriptor *formDescriptor;
@property XLFormViewController *formViewController;

@end

@implementation SurveyFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.forms = [Form getFormForMenu:self.menu.title];
    Form *currentForm = [self.forms objectAtIndex:self.index];
    if (self.forms.count > self.index) self.formRows = currentForm.rows;
    
    [self setTitle:self.menu.title];
    [self setRightBarButton];
    
    [SVProgressHUD show];
    [FormModel generate:self.formDescriptor dataSource:self.formRows completion:^(NSError *error) {
        if (error){
            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
            [SVProgressHUD dismissWithDelay:1.5 completion:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
        } else if (self.valueDictionary.count > 0){
            [FormModel loadValueFrom:self.valueDictionary to:self.formDescriptor on:self.formViewController];
            [SVProgressHUD dismiss];
            
        } else if (self.list) {
            __block SurveyFormViewController *weakSelf = self;
            [SurveyModel getSurveyWithID:self.list.primaryKey completion:^(NSDictionary *dictionary, NSError *error) {
                if (error == nil) {
                    if (dictionary) {
                        weakSelf.valueDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
                        [FormModel loadValueFrom:weakSelf.valueDictionary to:weakSelf.formDescriptor on:weakSelf.formViewController];
                    }
                    [SVProgressHUD dismiss];
                    
                } else {
                    [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
                    [SVProgressHUD dismissWithDelay:1.5 completion:^{
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                }
            }];
            
        } else {
            //something wrong i think
            [SVProgressHUD dismiss];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveButtonClicked:(id)sender{
    [FormModel saveValueFrom:self.formDescriptor to:self.valueDictionary];
    [SVProgressHUD show];
    [SurveyModel postSurveyWithList:self.list dictionary:self.valueDictionary completion:^(NSDictionary *dictionary, NSError *error) {
        if (error == nil) {
            [SVProgressHUD dismiss];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
            [SVProgressHUD dismissWithDelay:1.5];
        }
    }];
}

- (void)setRightBarButton{
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(saveButtonClicked:)];
    [self.navigationItem setRightBarButtonItem:barButtonItem];
}

- (void)viewDidLayoutSubviews{
    XLFormViewController *formViewController = [[XLFormViewController alloc] init];
    formViewController.form = self.formDescriptor;
    self.formViewController = formViewController;
    
    [self addChildViewController:formViewController];
    formViewController.view.frame = self.containerView.frame;
    [self.view addSubview:formViewController.view];
    [formViewController didMoveToParentViewController:self];
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
