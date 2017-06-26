//
//  FormViewController.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 5/14/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "FormViewController.h"
#import <XLForm.h>
#import "Form.h"
#import <JVFloatLabeledTextField/JVFloatLabeledTextView.h>
#import "FloatLabeledTextFieldCell.h"
#import "SimpleListViewController.h"
#import "WorkOrderModel.h"
#import "DropdownModel.h"
#import "FormModel.h"

@interface FormViewController ()

@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property RLMResults *forms;
@property RLMArray *formRows;
@property XLFormDescriptor *formDescriptor;
@property XLFormViewController *formViewController;

@end

@implementation FormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.forms = [Form getFormForMenu:self.menu.primaryKey];
    Form *currentForm = [self.forms objectAtIndex:self.index];
    if (self.forms.count > self.index) self.formRows = currentForm.rows;

    [self setTitle:self.menu.title];
    [self setHorizontalLabel];
    [self setRightBarButton];
    
    [SVProgressHUD show];
    __block FormViewController *weakSelf = self;
    [FormModel generate:self.formDescriptor dataSource:self.formRows completion:^(XLFormDescriptor *formDescriptor, NSError *error) {
        if (error){
            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
            [SVProgressHUD dismissWithDelay:1.5 completion:^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
            
        } else if (weakSelf.valueDictionary.count > 0){
            weakSelf.formDescriptor = formDescriptor;
            [FormModel loadValueFrom:weakSelf.valueDictionary to:weakSelf.formDescriptor on:weakSelf.formViewController];
            [SVProgressHUD dismiss];
            [weakSelf viewDidLayoutSubviews];
            
        } else if (weakSelf.list) {
            weakSelf.formDescriptor = formDescriptor;
            [WorkOrderModel getListWorkOrderDetailWithID:weakSelf.list.primaryKey completion:^(NSDictionary *response, NSError *error) {
                if (error == nil) {
                    if (response) {
                        weakSelf.valueDictionary = [NSMutableDictionary dictionaryWithDictionary:response];
                        [FormModel loadValueFrom:weakSelf.valueDictionary to:weakSelf.formDescriptor on:weakSelf.formViewController];
                    }
                    [SVProgressHUD dismiss];
                    [weakSelf viewDidLayoutSubviews];
                    
                } else {
                    [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
                    [SVProgressHUD dismissWithDelay:1.5 completion:^{
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    }];
                }
            }];
            
        } else {
            //something wrong i think
            weakSelf.formDescriptor = formDescriptor;
            [SVProgressHUD dismiss];
            [weakSelf viewDidLayoutSubviews];
        }
    }];
}

- (void)setRightBarButton{
    if (self.forms.count == self.index + 1){
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save"
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(saveButtonClicked:)];
        [self.navigationItem setRightBarButtonItem:barButtonItem];

        
    } else {
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Next"
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(nextButtonClicked:)];
        [self.navigationItem setRightBarButtonItem:barButtonItem];
    }
}

- (void)saveButtonClicked:(id)sender{
    //save to object, call delegate, then pop navigation
    [FormModel saveValueFrom:self.formDescriptor to:self.valueDictionary];
    [SVProgressHUD show];
    [WorkOrderModel postListWorkOrder:self.list dictionary:self.valueDictionary completion:^(NSDictionary *dictionary, NSError *error) {
        if (error == nil) {
            if (dictionary) {
                
            }
            [SVProgressHUD dismiss];
        } else {
            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
            [SVProgressHUD dismissWithDelay:1.5];
        }
    }];
}

- (void)nextButtonClicked:(id)sender{
    [FormModel saveValueFrom:self.formDescriptor to:self.valueDictionary];
    
    FormViewController *nextFormViewController = [[FormViewController alloc] init];
    nextFormViewController.menu = self.menu;
    nextFormViewController.index = self.index + 1;
    nextFormViewController.valueDictionary = self.valueDictionary;
    nextFormViewController.list = self.list;
    [self.navigationController pushViewController:nextFormViewController animated:YES];
}

- (void)setHorizontalLabel{
    Form *firstForm;
    Form *secondForm;
    Form *thirdForm;
    
    if (self.forms.count > self.index) firstForm = [self.forms objectAtIndex:self.index];
    if (self.forms.count > self.index + 1) secondForm = [self.forms objectAtIndex:self.index + 1];
    if (self.forms.count > self.index + 2) thirdForm = [self.forms objectAtIndex:self.index + 2];
    
    self.firstLabel.text = firstForm ? firstForm.title : @"";
    self.secondLabel.text = secondForm ? secondForm.title : @"";
    self.thirdLabel.text = thirdForm ? thirdForm.title : @"";
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
