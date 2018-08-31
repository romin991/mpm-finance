//  FloatLabeledTextFieldCell.m
//  XLForm ( https://github.com/xmartlabs/XLForm )
//
//  Copyright (c) 2015 Xmartlabs ( http://xmartlabs.com )
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "FloatLabeledTextFieldCell.h"
#import "UIView+XLFormAdditions.h"
#import "JVFloatLabeledTextField.h"
#import "NSObject+XLFormAdditions.h"

#import <JVFloatLabeledTextField/JVFloatLabeledTextField.h>

NSString * const XLFormRowDescriptorTypeFloatLabeledTextField = @"XLFormRowDescriptorTypeFloatLabeledTextField";

const static CGFloat kVMargin = 8.0f;
const static CGFloat kFloatingLabelFontSize = 11.0f;

@interface FloatLabeledTextFieldCell () <UITextFieldDelegate>
@property (nonatomic) JVFloatLabeledTextField * floatLabeledTextField;
@end

@implementation FloatLabeledTextFieldCell

@synthesize floatLabeledTextField =_floatLabeledTextField;

+(void)load
{
    
    [XLFormViewController.cellClassesForRowDescriptorTypes setObject:[FloatLabeledTextFieldCell class] forKey:XLFormRowDescriptorTypeFloatLabeledTextField];
}

-(JVFloatLabeledTextField *)floatLabeledTextField
{
    if (_floatLabeledTextField) return _floatLabeledTextField;
    
    _floatLabeledTextField = [JVFloatLabeledTextField autolayoutView];
    _floatLabeledTextField.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    _floatLabeledTextField.floatingLabel.font = [UIFont boldSystemFontOfSize:kFloatingLabelFontSize];

    _floatLabeledTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    return _floatLabeledTextField;
}

#pragma mark - XLFormDescriptorCell

- (void)setKeyboardType:(UIKeyboardType)keyboardType{
    self.floatLabeledTextField.keyboardType = keyboardType;
}
- (void)setKeyboardType:(UIKeyboardType)keyboardType andMaximumLength:(NSInteger) maxLength{
    self.floatLabeledTextField.keyboardType = keyboardType;
    self.maximumLength = maxLength;
    
}

-(void)configure
{
    [super configure];
    self.mustAlphabetOnly = NO;
    self.floatLabeledTextField.keyboardType = UIKeyboardTypeASCIICapable;
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self.contentView addSubview:self.floatLabeledTextField];
    [self.floatLabeledTextField setDelegate:self];
    [self.contentView addConstraints:[self layoutConstraints]];
    [self.floatLabeledTextField addTarget:self
                action:@selector(textFieldDidChange:)
      forControlEvents:UIControlEventEditingChanged];
}

-(void)update
{
    [super update];
    
    self.floatLabeledTextField.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:self.rowDescriptor.title
                                    attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    
    self.floatLabeledTextField.text = self.rowDescriptor.value ? [self.rowDescriptor.value displayText] : self.rowDescriptor.noValueDisplayText;
    [self.floatLabeledTextField setEnabled:!self.rowDescriptor.isDisabled];
    
    self.floatLabeledTextField.floatingLabelTextColor = [UIColor lightGrayColor];
    
    [self.floatLabeledTextField setAlpha:((self.rowDescriptor.isDisabled) ? .6 : 1)];
}

-(BOOL)formDescriptorCellCanBecomeFirstResponder
{
    return !self.rowDescriptor.isDisabled;
}

-(BOOL)formDescriptorCellBecomeFirstResponder
{
    return [self.floatLabeledTextField becomeFirstResponder];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return [self.formViewController textFieldShouldClear:textField];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [self.formViewController textFieldShouldReturn:textField];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return [self.formViewController textFieldShouldBeginEditing:textField];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return [self.formViewController textFieldShouldEndEditing:textField];
}

- (NSString *)formatToRupiah:(NSString *)charge{
  
  NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc]init];
  numberFormatter.locale = [NSLocale currentLocale];// this ensures the right separator behavior
  numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
  numberFormatter.usesGroupingSeparator = YES;
  NSInteger chargeDouble = [charge integerValue];
  NSNumber *chargeNumber = [NSNumber numberWithInteger:chargeDouble];
  NSString *theString = [numberFormatter stringFromNumber:chargeNumber];
  return theString;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    int newLength = textField.text.length + string.length - range.length;
    NSString * proposedNewString = [[textField text] stringByReplacingCharactersInRange:range withString:string];
  if ([string isEqualToString:@" "] && self.disableSpace) {
    return NO;
  }
    if (self.maximumLength > 0 && newLength > self.maximumLength) {
      if (self.shouldGiveThousandSeparator) {
        NSString *filtered = [proposedNewString stringByReplacingOccurrencesOfString:@"." withString:@""];
        if (filtered.length > self.maximumLength) {
          return NO;
        }
      } else 
        return NO;
    }
    WordsType wordType = [proposedNewString checkWordType];
    if (wordType == WordsTypeNone) {
        
    } else {
        if (wordType == notAllowedPunctuation) {
            return NO;
        }
        if (self.mustAlphabetOnly && wordType != WordsTypeAlphabetOnly) {
            return NO;
        } else if (self.mustAlphabetNumericOnly && (wordType != WordsTypeNumericOnly && wordType != WordsTypeAlphabetNumeric && wordType != WordsTypeAlphabetOnly)) {
            return NO;
        } else if (self.mustAlphabetPunctuationOnly && (wordType != WordsTypePunctuationOnly && wordType != WordsTypeAlphabetPunctuation && wordType != WordsTypeAlphabetOnly) ) {
            return NO;
        } else if (self.mustNumericOnly && wordType != WordsTypeNumericOnly){
            return NO;
        }
    }
  
  if (self.shouldGiveThousandSeparator) {
    // First check whether the replacement string's numeric...
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    bool isNumeric = [string isEqualToString:filtered];
    
    // Then if the replacement string's numeric, or if it's
    // a backspace, or if it's a decimal point and the text
    // field doesn't already contain a decimal point,
    // reformat the new complete number using
    // NSNumberFormatterDecimalStyle
    if (isNumeric ||
        [string isEqualToString:@""] ||
        ([string isEqualToString:@"."] &&
         [textField.text rangeOfString:@"."].location == NSNotFound)) {
          
          // Create the decimal style formatter
          NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
          [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
          [formatter setGroupingSeparator:@"."];
          [formatter setMaximumFractionDigits:10];
          
          // Combine the new text with the old; then remove any
          // commas from the textField before formatting
          NSString *combinedText = [textField.text stringByReplacingCharactersInRange:range withString:string];
          NSString *numberWithoutCommas = [combinedText stringByReplacingOccurrencesOfString:@"." withString:@""];
          NSNumber *number = [formatter numberFromString:numberWithoutCommas];
          
          NSString *formattedString = [formatter stringFromNumber:number];
          
          // If the last entry was a decimal or a zero after a decimal,
          // re-add it here because the formatter will naturally remove
          // it.
          if ([string isEqualToString:@"."] &&
              range.location == textField.text.length) {
            formattedString = [formattedString stringByAppendingString:@"."];
          }
          
          textField.text = formattedString;
          return NO;
        }

    
  }
  
  if (self.isPercentage) {
    if ([proposedNewString integerValue] > 100) {
      return NO;
    }
  }
  
    return [self.formViewController textField:textField shouldChangeCharactersInRange:range replacementString:string];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
  
    [self.formViewController textFieldDidBeginEditing:textField];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self textFieldDidChange:textField];
    [self.formViewController textFieldDidEndEditing:textField];
}

-(void)setReturnKeyType:(UIReturnKeyType)returnKeyType
{
    self.floatLabeledTextField.returnKeyType = returnKeyType;
}

-(UIReturnKeyType)returnKeyType
{
    return self.floatLabeledTextField.returnKeyType;
}

+(CGFloat)formDescriptorCellHeightForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor {
    return 55;
}



-(NSArray *)layoutConstraints
{
    NSMutableArray * result = [[NSMutableArray alloc] init];

    NSDictionary * views = @{@"floatLabeledTextField": self.floatLabeledTextField};
    NSDictionary *metrics = @{@"vMargin":@(kVMargin)};
    
    [result addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[floatLabeledTextField]-|"
                                                                                               options:0
                                                                                               metrics:metrics
                                                                                                 views:views]];
    [result addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(vMargin)-[floatLabeledTextField]-(vMargin)-|"
                                                                                               options:0
                                                                                               metrics:metrics
                                                                                                 views:views]];
    return result;
}

#pragma mark - Helpers

- (void)textFieldDidChange:(UITextField *)textField
{
    if (self.floatLabeledTextField == textField) {
        if ([self.floatLabeledTextField.text length] > 0) {
            self.rowDescriptor.value = self.floatLabeledTextField.text;
        } else {
            self.rowDescriptor.value = nil;
        }
    }
}



@end
