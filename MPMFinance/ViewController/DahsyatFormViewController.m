//
//  DahsyatFormViewController.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 6/22/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "DahsyatFormViewController.h"
#import <XLForm.h>
#import "FormModel.h"
#import "Form.h"

@interface DahsyatFormViewController ()

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property RLMResults *forms;
@property RLMArray *formRows;
@property XLFormDescriptor *formDescriptor;
@property XLFormViewController *formViewController;

@end

@implementation DahsyatFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.forms = [Form getFormForMenu:self.menu.title];
    Form *currentForm = self.forms.firstObject;
    if (currentForm) self.formRows = currentForm.rows;
    
    [self setTitle:self.menu.title];
//    [self setRightBarButton];
    
    [SVProgressHUD show];
    __block DahsyatFormViewController *weakSelf = self;
    [FormModel generate:self.formDescriptor dataSource:self.formRows completion:^(XLFormDescriptor *formDescriptor, NSError *error) {
        if (error){
            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
            [SVProgressHUD dismissWithDelay:1.5 completion:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
        } else {
            formDescriptor = [weakSelf setAdditionalFormDescriptor:formDescriptor];
            
            weakSelf.formDescriptor = formDescriptor;
            [SVProgressHUD dismiss];
            [weakSelf viewDidLayoutSubviews];
        }
    }];
}

- (XLFormDescriptor *)setAdditionalFormDescriptor:(XLFormDescriptor *)formDescriptor{
    XLFormSectionDescriptor *section = formDescriptor.formSections.firstObject;
    if (section){
        XLFormRowDescriptor *row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeButton title:@"Calculate"];
        row.action.formSelector = @selector(calculateNow:);
        [section addFormRow:row];
    }
    
    return formDescriptor;
}

- (void)calculateNow:(XLFormRowDescriptor *)row{
    NSLog(@"calculateNow called");
    [self.formViewController deselectFormRow:row];
}

//- (void)setRightBarButton{
//    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save"
//                                                                      style:UIBarButtonItemStylePlain
//                                                                     target:self
//                                                                     action:@selector(saveButtonClicked:)];
//    [self.navigationItem setRightBarButtonItem:barButtonItem];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
