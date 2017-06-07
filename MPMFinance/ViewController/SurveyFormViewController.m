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
    [self generateFormDescriptor];
    [self setRightBarButton];
    
    if (self.valueDictionary.count > 0){
        [self setFormValueWithDictionary:self.valueDictionary];
    } else if (self.list) {
        [self fetchData];
    }
}

- (void)fetchData{
    __block SurveyFormViewController *weakSelf = self;
    [SVProgressHUD show];
    [SurveyModel getSurveyWithID:self.list.primaryKey completion:^(NSDictionary *dictionary, NSError *error) {
        if (error == nil) {
            if (dictionary) {
                [weakSelf setFormValueWithDictionary:dictionary];
            }
            [SVProgressHUD dismiss];
        } else {
            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
            [SVProgressHUD dismissWithDelay:1.5];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setFormValueWithDictionary:(NSDictionary *)dictionary{
    self.valueDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    for (XLFormSectionDescriptor *section in self.formDescriptor.formSections) {
        for (XLFormRowDescriptor *row in section.formRows) {
            NSString *value;
            if ([dictionary objectForKey:row.tag]){
                value = [dictionary objectForKey:row.tag];
            }
            if (value){
                row.value = value;
            }
            
            [self.formViewController reloadFormRow:row];
        }
    }
}

- (void)saveValueToDictionary{
    for (XLFormSectionDescriptor *section in self.formDescriptor.formSections) {
        for (XLFormRowDescriptor *row in section.formRows) {
            if (self.valueDictionary == nil) self.valueDictionary = [NSMutableDictionary dictionary];
            NSString *valueString;
            id value = row.value;
            if ([value isKindOfClass:[XLFormOptionsObject class]]){
                value = ((XLFormOptionsObject *) value).valueData;
            }
            if ([value isKindOfClass:[NSDate class]]){
                valueString = [MPMGlobal stringFromDate:value];
            }
            if ([value isKindOfClass:[NSString class]]){
                valueString = value;
            }
            [self.valueDictionary setObject:((valueString != nil) ? valueString : [NSNull null]) forKey:row.tag];
        }
    }
}

- (void)saveButtonClicked:(id)sender{
    [self saveValueToDictionary];
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
