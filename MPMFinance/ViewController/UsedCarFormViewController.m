//
//  UsedCarFormViewController.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 6/22/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "UsedCarFormViewController.h"
#import <XLForm.h>
#import "FormModel.h"
#import "Form.h"

@interface UsedCarFormViewController ()

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property NSMutableDictionary *valueDictionary;
@property XLFormDescriptor *formDescriptor;
@property XLFormViewController *formViewController;

@end

@implementation UsedCarFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    RLMResults *forms = [Form getFormForMenu:self.menu.title];
    Form *currentForm = forms.firstObject;
    
    [self setTitle:self.menu.title];
    
    [SVProgressHUD show];
    __block UsedCarFormViewController *weakSelf = self;
    [FormModel generate:self.formDescriptor form:currentForm completion:^(XLFormDescriptor *formDescriptor, NSError *error) {
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [FormModel saveValueFrom:self.formDescriptor to:self.valueDictionary];
    
    //calculate base on valueDictionary here
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
