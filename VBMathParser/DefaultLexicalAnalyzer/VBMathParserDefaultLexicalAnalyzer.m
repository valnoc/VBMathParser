//
//    The MIT License (MIT)
//
//    Copyright (c) 2015 Valeriy Bezuglyy.
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//    SOFTWARE.
//

#import "VBMathParserDefaultLexicalAnalyzer.h"

//#import "VBMathParserDefines.h"
//
#import "VBMathParserTokenNumber.h"
#import "VBMathParserTokenOperation.h"
#import "VBMathParserTokenFunction.h"
#import "VBMathParserTokenSpecial.h"
#import "VBMathParserTokenVar.h"
#import "VBMathParserTokenConst.h"
//
#import "VBMathParserUnknownTokenException.h"

#import "VBMathParserDefaultTokenFactory.h"
#import "VBMathParserVarIsNotStringException.h"
#import "VBMathParserVarIsNotValidException.h"

@interface VBMathParserDefaultLexicalAnalyzer ()

@property (nonatomic, strong) id<VBMathParserTokenFactory> tokenFactory;

@end

@implementation VBMathParserDefaultLexicalAnalyzer

- (instancetype) init {
    return [self initWithDefaultTokenFactory];
}

- (instancetype) initWithDefaultTokenFactory {
    return [self initWithTokenFactory:[VBMathParserDefaultTokenFactory new]];
}

- (instancetype) initWithTokenFactory:(id<VBMathParserTokenFactory>) tokenFactory {
    self = [super init];
    if (self) {
        self.tokenFactory = tokenFactory;
    }
    return self;
}

#pragma mark -
- (NSArray<VBMathParserToken *>*) analyseExpression:(NSString*) expression
                                      withVariables:(NSArray<NSString*>*) variables {
    [self validateVariableNames:variables];
    //
    NSString* expr = [self prepareStringForParsing:expression];

    NSMutableArray* tokens = [NSMutableArray new];
    while (expr.length > 0) {
        VBMathParserToken* token = nil;
        for (Class tokenClass in @[[VBMathParserTokenNumber class],
                                   [VBMathParserTokenSpecial class],
                                   [VBMathParserTokenOperation class],
                                   [VBMathParserTokenFunction class],
                                   [VBMathParserTokenConst class],
                                   [VBMathParserTokenVar class]]) {
            token = [self nextTokenFromExpression:expr
                                   withTokenClass:tokenClass];
            // check whether we know this var or not
            if (tokenClass == [VBMathParserTokenVar class]) {
                BOOL knownVar = [variables indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                    return [obj isEqualToString:[(VBMathParserTokenVar*)token stringValue]];
                }] != NSNotFound;
                if (knownVar == NO) {
                    token = nil;
                }
            }
            if (token) {
                expr = [expr substringFromIndex:token.stringValue.length];
                [tokens addObject:token];
                break;
            }
        }
        if (token == nil) {
            @throw [VBMathParserUnknownTokenException exceptionWithToken:expr];
        }
    }
    return tokens;
}

- (VBMathParserToken*) nextTokenFromExpression:(NSString*) expression
                                withTokenClass:(Class) tokenClass {
    // length - length of token to be removed from source string
    NSInteger length = 1;
    // substr - substring which forms a token
    NSString* substr = [expression substringToIndex:length];
    
    NSRegularExpression* regexp = [tokenClass regularExpression];
    NSRange rangeOfFirstMatch = [regexp rangeOfFirstMatchInString:substr
                                                          options:0
                                                            range:NSMakeRange(0, substr.length)];
    // can be token - substr can be token as to token regex
    BOOL canBeToken = NO;
    // substractOne - go one symbol back
    BOOL substractOne = NO;
    while (!NSEqualRanges(rangeOfFirstMatch, NSMakeRange(NSNotFound, 0))) {
        // if first symbol is token (by regexPattern), then add one symbol each step up to next token
        canBeToken = YES;
        if (expression.length > length) {
            substractOne = YES;
            substr = [expression substringToIndex:++length];
            rangeOfFirstMatch = [regexp rangeOfFirstMatchInString:substr
                                                         options:0
                                                           range:NSMakeRange(0, substr.length)];
        }else{
            // do not go one symbol back if this token is the last one
            substractOne = NO;
            break;
        }
    }
    if (substractOne) {
        substr = [substr substringToIndex:substr.length - 1];
    }
    
    VBMathParserToken* token = nil;
    if (canBeToken) {
        token = [self.tokenFactory tokenWithType:[tokenClass tokenType]
                                          string:substr];
    }
    return token;
}

- (void) validateVariableNames:(NSArray<NSString *>*) vars {
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:[VBMathParserTokenVar regexpPattern]
                                                                           options:NSRegularExpressionCaseInsensitive|NSRegularExpressionAnchorsMatchLines
                                                                             error:nil];
    [vars enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSString class]] == NO) {
            @throw [VBMathParserVarIsNotStringException exception];
        }
        NSRange rangeOfFirstMatch = [regex rangeOfFirstMatchInString:obj
                                                             options:0
                                                               range:NSMakeRange(0, ((NSString*)obj).length)];
        if (rangeOfFirstMatch.location == NSNotFound || rangeOfFirstMatch.length != ((NSString*)obj).length) {
            @throw [VBMathParserVarIsNotValidException exceptionWithVar:obj];
        }
    }];
}

- (NSString*) prepareStringForParsing:(NSString*) string {
    NSString* strPrep = [NSString stringWithFormat:@"%@", string];
    strPrep = [strPrep stringByReplacingOccurrencesOfString:@" " withString:@""];
    strPrep = [strPrep stringByReplacingOccurrencesOfString:@"," withString:@"."];
    strPrep = [strPrep lowercaseString];
    return strPrep;
}

@end
