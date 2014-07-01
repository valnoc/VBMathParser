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
#import "VBMathParserTokenConst.h"

#import "VBMathParserUnknownTokenException.h"

@implementation VBMathParserLexicalAnalyzer

- (NSArray*) analyseString:(NSString*)str {
    return [self analyseString:str
                      withVars:nil];
}

- (NSArray*) analyseString:(NSString*)str
                  withVars:(NSArray*)vars {
    
    VBMathParserLog(@"LexicalAnalyzer: analyseString: %@", str);
    
    NSMutableArray* tokens = [NSMutableArray new];
    
    //****** PREPARE STRING FOR PARSING
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"," withString:@"."];
    str = [str lowercaseString];
    VBMathParserLog(@"LexicalAnalyzer: Prepared string: %@", str);
    
    VBMathParserToken* token = nil;
    while (str.length > 0) {
        token = nil;
        //****** TRY TO READ NUMBER TOKEN
        token = [self parseNextTokenFromString:str
                                    tokenClass:[VBMathParserTokenNumber class]];
        if (token) {
            str = [str substringFromIndex:token.string.length];
            [tokens addObject:token];
            
        }else {
            //****** TRY TO READ SPECIAL TOKEN
            token = [self parseNextTokenFromString:str
                                        tokenClass:[VBMathParserTokenSpecial class]];
            if (token) {
                str = [str substringFromIndex:token.string.length];
                [tokens addObject:token];
                
            }else {
                //****** TRY TO READ OPERATION TOKEN
                token = [self parseNextTokenFromString:str
                                            tokenClass:[VBMathParserTokenOperation class]];
                if (token) {
                    str = [str substringFromIndex:token.string.length];
                    [tokens addObject:token];
                    
                }else {
                    //****** TRY TO READ FUNCTION TOKEN
                    token = [self parseNextTokenFromString:str
                                                tokenClass:[VBMathParserTokenFunction class]];
                    if (token) {
                        str = [str substringFromIndex:token.string.length];
                        [tokens addObject:token];
                        
                    }else {
                        //****** TRY TO READ CONST TOKEN
                        token = [self parseNextTokenFromString:str
                                                    tokenClass:[VBMathParserTokenConst class]];
                        if (token) {
                            str = [str substringFromIndex:token.string.length];
                            [tokens addObject:token];
                        }else{
                            //****** TRY TO READ VAR TOKEN
                            token = [self parseNextTokenFromString:str
                                                        tokenClass:[VBMathParserTokenVar class]];
                            BOOL knownVar = NO;
                            for (NSString* var in vars) {
                                if ([var isEqualToString:((VBMathParserTokenVar*)token).var]) {
                                    knownVar = YES;
                                    break;
                                }
                            }
                            if (token && knownVar) {
                                str = [str substringFromIndex:token.string.length];
                                [tokens addObject:token];
                                
                            }else {
                                //****** UNKNOWN TOKEN
                                @throw [VBMathParserUnknownTokenException exceptionWithInfo:str];
                            }
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

- (VBMathParserToken*) parseNextTokenFromString:(NSString*)str
                                     tokenClass:(Class)tokenClass {
    // length - length of token to be removed from source string
    NSInteger length = 1;
    // substr - substring which forms a token
    NSString* substr = [str substringToIndex:length];
    
    NSError* error = nil;
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:[tokenClass regexPattern]
                                                                           options:NSRegularExpressionCaseInsensitive|NSRegularExpressionAnchorsMatchLines
                                                                             error:&error];
    NSRange rangeOfFirstMatch = [regex rangeOfFirstMatchInString:substr
                                                         options:0
                                                           range:NSMakeRange(0, substr.length)];
    // can be token - substr can be token as to token regex
    BOOL canBeToken = NO;
    // substractOne - go one symbol back
    BOOL substractOne = NO;
    while (!NSEqualRanges(rangeOfFirstMatch, NSMakeRange(NSNotFound, 0))) {
        // if first symbol is token (by regexPattern), then add one symbol each step up to next token
        canBeToken = YES;
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
    
    VBMathParserToken* token = nil;
    if (canBeToken && [tokenClass isToken:substr]) {
        VBMathParserLog(@"LexicalAnalyzer: Token %@: %@", tokenClass, substr);
        token = [[tokenClass alloc] initWithString:substr];
    }
    return token;
}

@end
