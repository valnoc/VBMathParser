//
//    The MIT License (MIT)
//
//    Copyright (c) 2014 Valeriy Bezuglyy. All rights reserved.
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

#import "VBMathParserLexicalAnalyzer.h"

#import "VBMathParserDefines.h"

#import "VBMathParserTokenNumber.h"
#import "VBMathParserTokenOperation.h"
#import "VBMathParserTokenFunction.h"
#import "VBMathParserTokenSpecial.h"
#import "VBMathParserTokenVar.h"

#import "VBMathParserUnknownTokenException.h"

@implementation VBMathParserLexicalAnalyzer

- (NSArray*) analyseString:(NSString*)str
                  withVars:(NSArray*)vars {
    
    VBMathParserLog(@"LexicalAnalyzer: analyseString: %@", str);
    
    NSMutableArray* tokens = [NSMutableArray new];
    
    //****** PREPARE STRING FOR PARSING
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"," withString:@"."];
    str = [str lowercaseString];
    VBMathParserLog(@"LexicalAnalyzer: Prepared string: %@", str);
    
    while (str.length > 0) {
        //****** TRY TO READ NUMBER TOKEN
        // length - length of token to be removed from source string
        NSInteger length = 1;
        // substr - substring which forms a token
        NSString* substr = [str substringToIndex:length];
        
        NSError* error = nil;
        NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:[VBMathParserTokenNumber regexPattern]
                                                                               options:NSRegularExpressionCaseInsensitive|NSRegularExpressionAnchorsMatchLines
                                                                                 error:&error];
        NSRange rangeOfFirstMatch = [regex rangeOfFirstMatchInString:substr
                                                             options:0
                                                               range:NSMakeRange(0, substr.length)];
        // isNumber - substr is a number token
        BOOL isNumber = NO;
        // substractOne - go one symbol back
        BOOL substractOne = NO;
        while (!NSEqualRanges(rangeOfFirstMatch, NSMakeRange(NSNotFound, 0))) {
            // if first symbol is TokenNumber (by regexPattern), then add one symbol each step up to next token
            isNumber = YES;
            if (str.length > length) {
                substractOne = YES;
                substr = [str substringToIndex:++length];
                rangeOfFirstMatch = [regex rangeOfFirstMatchInString:substr
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
        
        if (isNumber) {
            VBMathParserLog(@"LexicalAnalyzer: Token number: %@", substr);
            str = [str substringFromIndex:substr.length];
            [tokens addObject:[VBMathParserTokenNumber numberWithString:substr]];
            
        }else {
            //****** TRY TO READ SPECIAL TOKEN
            length = 1;
            substr = [str substringToIndex:length];
            
            regex = [NSRegularExpression regularExpressionWithPattern:[VBMathParserTokenSpecial regexPattern]
                                                              options:NSRegularExpressionCaseInsensitive|NSRegularExpressionAnchorsMatchLines
                                                                error:&error];
            rangeOfFirstMatch = [regex rangeOfFirstMatchInString:substr
                                                         options:0
                                                           range:NSMakeRange(0, substr.length)];
            BOOL isSpecial = NO;
            substractOne = NO;
            while (!NSEqualRanges(rangeOfFirstMatch, NSMakeRange(NSNotFound, 0))) {
                isSpecial = YES;
                if (str.length > length) {
                    substractOne = YES;
                    substr = [str substringToIndex:++length];
                    rangeOfFirstMatch = [regex rangeOfFirstMatchInString:substr
                                                                 options:0
                                                                   range:NSMakeRange(0, substr.length)];
                }else{
                    substractOne = NO;
                    break;
                }
            }
            if (substractOne) {
                substr = [substr substringToIndex:substr.length - 1];
            }
            
            if (isSpecial && [VBMathParserTokenSpecial isSpecial:substr]) {
                
                VBMathParserLog(@"LexicalAnalyzer: Token symbol: %@", substr);
                str = [str substringFromIndex:substr.length];
                [tokens addObject:[VBMathParserTokenSpecial specialWithString:substr]];
                
            }else {
                //****** TRY TO READ OPERATION TOKEN
                length = 1;
                substr = [str substringToIndex:length];
                
                regex = [NSRegularExpression regularExpressionWithPattern:[VBMathParserTokenOperation regexPattern]
                                                                  options:NSRegularExpressionCaseInsensitive|NSRegularExpressionAnchorsMatchLines
                                                                    error:&error];
                rangeOfFirstMatch = [regex rangeOfFirstMatchInString:substr
                                                             options:0
                                                               range:NSMakeRange(0, substr.length)];
                BOOL isOperation = NO;
                substractOne = NO;
                while (!NSEqualRanges(rangeOfFirstMatch, NSMakeRange(NSNotFound, 0))) {
                    isOperation = YES;
                    if (str.length > length) {
                        substractOne = YES;
                        substr = [str substringToIndex:++length];
                        rangeOfFirstMatch = [regex rangeOfFirstMatchInString:substr
                                                                     options:0
                                                                       range:NSMakeRange(0, substr.length)];
                    }else{
                        substractOne = NO;
                        break;
                    }
                }
                if (substractOne) {
                    substr = [substr substringToIndex:substr.length - 1];
                }
                
                if (isOperation && [VBMathParserTokenOperation isOperation:substr]) {
                    
                    VBMathParserLog(@"LexicalAnalyzer: Token operation: %@", substr);
                    str = [str substringFromIndex:substr.length];
                    [tokens addObject:[VBMathParserTokenOperation operationWithString:substr]];
                    
                }else {
                    //****** TRY TO READ FUNCTION TOKEN
                    length = 1;
                    substr = [str substringToIndex:length];
                    
                    regex = [NSRegularExpression regularExpressionWithPattern:[VBMathParserTokenFunction regexPattern]
                                                                      options:NSRegularExpressionCaseInsensitive|NSRegularExpressionAnchorsMatchLines
                                                                        error:&error];
                    rangeOfFirstMatch = [regex rangeOfFirstMatchInString:substr
                                                                 options:0
                                                                   range:NSMakeRange(0, substr.length)];
                    BOOL isFunction = NO;
                    substractOne = NO;
                    while (!NSEqualRanges(rangeOfFirstMatch, NSMakeRange(NSNotFound, 0))) {
                        isFunction = YES;
                        if (str.length > length) {
                            substractOne = YES;
                            substr = [str substringToIndex:++length];
                            rangeOfFirstMatch = [regex rangeOfFirstMatchInString:substr
                                                                         options:0
                                                                           range:NSMakeRange(0, substr.length)];
                        }else{
                            substractOne = NO;
                            break;
                        }
                    }
                    if (substractOne) {
                        substr = [substr substringToIndex:substr.length - 1];
                    }
                    
                    if (isFunction && [VBMathParserTokenFunction isFunction:substr]) {
                        
                        VBMathParserLog(@"LexicalAnalyzer: Token function: %@", substr);
                        str = [str substringFromIndex:substr.length];
                        [tokens addObject:[VBMathParserTokenFunction functionWithString:substr]];
                        
                    }else {
                        //****** TRY TO READ VAR TOKEN
                        length = 1;
                        substr = [str substringToIndex:length];
                        
                        regex = [NSRegularExpression regularExpressionWithPattern:[VBMathParserTokenVar regexPattern]
                                                                          options:NSRegularExpressionCaseInsensitive|NSRegularExpressionAnchorsMatchLines
                                                                            error:&error];
                        rangeOfFirstMatch = [regex rangeOfFirstMatchInString:substr
                                                                     options:0
                                                                       range:NSMakeRange(0, substr.length)];
                        BOOL canBeVar = NO;
                        substractOne = NO;
                        while (!NSEqualRanges(rangeOfFirstMatch, NSMakeRange(NSNotFound, 0))) {
                            canBeVar = YES;
                            if (str.length > length) {
                                substractOne = YES;
                                substr = [str substringToIndex:++length];
                                rangeOfFirstMatch = [regex rangeOfFirstMatchInString:substr
                                                                             options:0
                                                                               range:NSMakeRange(0, substr.length)];
                            }else{
                                substractOne = NO;
                                break;
                            }
                        }
                        if (substractOne) {
                            substr = [substr substringToIndex:substr.length - 1];
                        }
                        
                        BOOL isVar = NO;
                        for (NSString* var in vars) {
                            if ([var isEqualToString:substr]) {
                                isVar = YES;
                                break;
                            }
                        }
                        
                        if (canBeVar && isVar) {

                            VBMathParserLog(@"LexicalAnalyzer: Token var: %@", substr);
                            str = [str substringFromIndex:substr.length];
                            [tokens addObject:[VBMathParserTokenVar varWithString:substr]];
                            
                        }else {
                            //****** UNKNOWN TOKEN
                            @throw [VBMathParserUnknownTokenException exceptionWithInfo:str];
                        }
                    }
                }
                
            }
            
        }
    }
    
    VBMathParserLog(@"LexicalAnalyzer: Analysis finished");
//    VBMathParserLog(@"LexicalAnalyzer: Analysis finished\n%@", tokens);
    return tokens;
}



@end
