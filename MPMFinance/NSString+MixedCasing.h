//
//  NSString+MixedCasing.h
//  MPMFinance
//
//  Created by Rudy Suharyadi on 6/1/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, WordsType) {
    WordsTypeAlphabetOnly,
    WordsTypeNumericOnly,
    WordsTypePunctuationOnly,
    WordsTypeAlphabetPunctuation,
    WordsTypeAlphabetNumeric,
    notAllowedPunctuation,
    WordsTypeAll,
    WordsTypeNone
};

@interface NSString (MixedCasing)
@property (nonatomic,assign)WordsType wordType;
- (NSString *)camelCased;
- (NSString *)pascalCased;
- (WordsType)checkWordType;
@end
