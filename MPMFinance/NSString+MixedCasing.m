//
//  NSString+MixedCasing.m
//  MPMFinance
//
//  Created by Rudy Suharyadi on 6/1/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import "NSString+MixedCasing.h"

@implementation NSString (MixedCasing)

- (NSString *)camelCased  {
    NSMutableString *result = [NSMutableString new];
    NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890 "] invertedSet];
    NSString *resultString = [[self componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];

    NSArray *words = [resultString componentsSeparatedByString: @" "];
    for (uint i = 0; i < words.count; i++) {
        if (i==0) {
            [result appendString:((NSString *) words[i]).withLowercasedFirstChar];
        }
        else {
            [result appendString:((NSString *)words[i]).withUppercasedFirstChar];
        }
    }
    return result;
}
- (WordsType)checkWordType {
    WordsType wordType = WordsTypeNone;
    NSCharacterSet *allowedChars = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"];
    NSRange range = [self rangeOfCharacterFromSet:allowedChars];
    if (range.location != NSNotFound) {
        wordType = WordsTypeAlphabetOnly;
    }
    allowedChars = [NSCharacterSet characterSetWithCharactersInString:@"!@#$%^&*()'{][}+=-_"];
    range = [self rangeOfCharacterFromSet:allowedChars];
    if (range.location != NSNotFound) {
        if (wordType == WordsTypeAlphabetOnly) {
            wordType = WordsTypeAlphabetPunctuation;
        } else {
            wordType = WordsTypePunctuationOnly;
        }
        
    }
    
    allowedChars = [NSCharacterSet characterSetWithCharactersInString:@"1234567890"];
    range = [self rangeOfCharacterFromSet:allowedChars];
    if (range.location != NSNotFound) {
        if (wordType == WordsTypeAlphabetOnly) {
            wordType = WordsTypeAlphabetNumeric;
        } else if (wordType == WordsTypeAlphabetPunctuation) {
            wordType = WordsTypeAll;
        } else {
            wordType = WordsTypeNumericOnly;
        }
        
    }
    return wordType;
}
- (NSString *)pascalCased  {
    NSMutableString *result = [NSMutableString new];
    NSArray *words = [self componentsSeparatedByString: @" "];
    for (NSString *word in words) {
        [result appendString:word.withUppercasedFirstChar];
    }
    return result;
}

- (NSString *)withUppercasedFirstChar  {
    if (self.length <= 1) {
        return self.uppercaseString;
    } else {
        return [NSString stringWithFormat:@"%@%@",[[self substringToIndex:1] uppercaseString],[self substringFromIndex:1]];
    }
}

- (NSString *)withLowercasedFirstChar {
    if (self.length <= 1) {
        return self.lowercaseString;
    } else {
        return [NSString stringWithFormat:@"%@%@",[[self substringToIndex:1] lowercaseString],[self substringFromIndex:1]];
    }
}
@end
