//
//  FormGeneratorViewController.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 5/14/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "FormGeneratorViewController.h"

@interface FormGeneratorViewController ()

@end

@implementation FormGeneratorViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
        [self initializeForm];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self){
        [self initializeForm];
    }
    return self;
}

- (void)initializeForm {
    // Implementation details covered in the next section.
    XLFormDescriptor * formDescriptor = [XLFormDescriptor formDescriptorWithTitle:@"Text Fields"];
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    // Name Section
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Validation Required"];
    [formDescriptor addFormSection:section];
    
    // Name
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"Name" rowType:XLFormRowDescriptorTypeText title:@"Name"];
    [row.cellConfigAtConfigure setObject:@"Required..." forKey:@"textField.placeholder"];
    row.required = YES;
    row.value = @"Martin";
    [section addFormRow:row];
    
//    // Email Section
//    section = [XLFormSectionDescriptor formSectionWithTitle:@"Validation Email"];
//    [formDescriptor addFormSection:section];
//    
//    // Email
//    row = [XLFormRowDescriptor formRowDescriptorWithTag:kValidationEmail rowType:XLFormRowDescriptorTypeText title:@"Email"];
//    [row.cellConfigAtConfigure setObject:@(NSTextAlignmentRight) forKey:@"textField.textAlignment"];
//    row.required = NO;
//    row.value = @"not valid email";
//    [row addValidator:[XLFormValidator emailValidator]];
//    [section addFormRow:row];
//    
//    // password Section
//    section = [XLFormSectionDescriptor formSectionWithTitle:@"Validation Password"];
//    section.footerTitle = @"between 6 and 32 charachers, 1 alphanumeric and 1 numeric";
//    [formDescriptor addFormSection:section];
//    
//    // Password
//    row = [XLFormRowDescriptor formRowDescriptorWithTag:kValidationPassword rowType:XLFormRowDescriptorTypePassword title:@"Password"];
//    [row.cellConfigAtConfigure setObject:@"Required..." forKey:@"textField.placeholder"];
//    [row.cellConfigAtConfigure setObject:@(NSTextAlignmentRight) forKey:@"textField.textAlignment"];
//    row.required = YES;
//    [row addValidator:[XLFormRegexValidator formRegexValidatorWithMsg:@"At least 6, max 32 characters" regex:@"^(?=.*\\d)(?=.*[A-Za-z]).{6,32}$"]];
//    [section addFormRow:row];
//    
//    // number Section
//    section = [XLFormSectionDescriptor formSectionWithTitle:@"Validation Numbers"];
//    section.footerTitle = @"greater than 50 and less than 100";
//    [formDescriptor addFormSection:section];
//    
//    // Integer
//    row = [XLFormRowDescriptor formRowDescriptorWithTag:kValidationInteger rowType:XLFormRowDescriptorTypeInteger title:@"Integer"];
//    [row.cellConfigAtConfigure setObject:@"Required..." forKey:@"textField.placeholder"];
//    [row.cellConfigAtConfigure setObject:@(NSTextAlignmentRight) forKey:@"textField.textAlignment"];
//    row.required = YES;
//    [row addValidator:[XLFormRegexValidator formRegexValidatorWithMsg:@"greater than 50 and less than 100" regex:@"^([5-9][0-9]|100)$"]];
//    [section addFormRow:row];
    
    self.form = formDescriptor;
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
