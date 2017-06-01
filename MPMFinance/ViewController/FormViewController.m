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
#import <TPKeyboardAvoidingTableView.h>
#import "SimpleListViewController.h"
#import "APIModel.h"

@interface FormViewController ()

@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *horizontalViewHeightConstraint;

@property RLMResults *forms;
@property RLMArray *formRows;
@property XLFormDescriptor *formDescriptor;

@end

@implementation FormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.forms = [Form getFormForMenu:self.menu.title];
    Form *currentForm = [self.forms objectAtIndex:self.index];
    if (self.forms.count > self.index) self.formRows = currentForm.rows;
    if (currentForm.title.length < 1) {
        //hide containerView
        [self hideHorizontalView];
    }
    
    UIViewController *viewController = [self.navigationController.viewControllers objectAtIndex: self.navigationController.viewControllers.count - 2];
    if ([viewController isKindOfClass:[SimpleListViewController class]]) {
        [self setTitle:currentForm.title];
        
    } else {
        [self setTitle:self.menu.title];
    
    }
    
    [self generateFormDescriptor];
    [self setHorizontalLabel];
    [self setRightBarButton];
}

- (void)hideHorizontalView{
    self.horizontalViewHeightConstraint.constant = 0;
}

- (void)showHorizontalView{
    self.horizontalViewHeightConstraint.constant = 48;
}

- (void)setRightBarButton{
    UIViewController *viewController = [self.navigationController.viewControllers objectAtIndex: self.navigationController.viewControllers.count - 2];
    if ([viewController isKindOfClass:[SimpleListViewController class]]) {
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
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)nextButtonClicked:(id)sender{
    for (XLFormSectionDescriptor *section in self.formDescriptor.formSections) {
        for (XLFormRowDescriptor *row in section.formRows) {
            if (self.valueDictionary == nil) self.valueDictionary = [NSMutableDictionary dictionary];
            [self.valueDictionary setObject:((row.value != nil) ? row.value : [NSNull null]) forKey:row.tag];
        }
    }
    
    if (self.forms.count == self.index + 1){
        //call API here
        void (^handler)(UIAlertAction *action) = ^void(UIAlertAction *action){
            //callback api here
        };
        
        __block NSString *methodName = self.menu.rightButtonAction ? self.menu.rightButtonAction.methodName : @"";
        NSMutableDictionary *valueDictionary = self.valueDictionary;
        if ([APIModel respondsToSelector:NSSelectorFromString(methodName)]) {
            NSMethodSignature * mySignature = [APIModel methodSignatureForSelector:NSSelectorFromString(methodName)];
            NSInvocation * myInvocation = [NSInvocation invocationWithMethodSignature:mySignature];
            [myInvocation setTarget:[APIModel class]];
            [myInvocation setSelector:NSSelectorFromString(methodName)];
            [myInvocation setArgument:&valueDictionary atIndex:2];
            [myInvocation setArgument:&handler atIndex:3];
            [myInvocation retainArguments];
            [myInvocation performSelector:@selector(invoke) withObject:nil afterDelay:0.1];
        }
        
    } else {
        FormViewController *nextFormViewController = [[FormViewController alloc] init];
        nextFormViewController.menu = self.menu;
        nextFormViewController.index = self.index + 1;
        nextFormViewController.valueDictionary = self.valueDictionary;
        [self.navigationController pushViewController:nextFormViewController animated:YES];
    }
}

- (void)setHorizontalLabel{
    UIViewController *viewController = [self.navigationController.viewControllers objectAtIndex: self.navigationController.viewControllers.count - 2];
    if ([viewController isKindOfClass:[SimpleListViewController class]]) {
        [self hideHorizontalView];
        
    } else {
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
}

- (void)generateFormDescriptor{
    // Form
    self.formDescriptor = [XLFormDescriptor formDescriptorWithTitle:@"Text Fields"];
    XLFormSectionDescriptor *section;
    XLFormRowDescriptor *row;
    
    // Section
    section = [XLFormSectionDescriptor formSection];
    [self.formDescriptor addFormSection:section];
    
    // Row
    for (FormRow *formRow in self.formRows) {
        row = [XLFormRowDescriptor formRowDescriptorWithTag:formRow.key rowType:formRow.type title:formRow.title];
        if (formRow.options.count > 0) {
            NSMutableArray *options = [NSMutableArray array];
            for (Option *option in formRow.options) {
                [options addObject:[XLFormOptionsObject formOptionsObjectWithValue:option.name displayText:option.name]];
            }
            row.selectorTitle = formRow.title;
            row.selectorOptions = options;
        }
        row.required = formRow.required;
        row.disabled = @(formRow.disabled);
        [section addFormRow:row];
    }
}

- (void)viewDidLayoutSubviews{
    XLFormViewController *formViewController = [[XLFormViewController alloc] init];
    formViewController.form = self.formDescriptor;
    
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
