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

#import "VBMathParserSyntaxAnalyzer.h"

#import "VBMathParserDefines.h"

#import "VBMathParserTokenNumber.h"
#import "VBMathParserTokenOperation.h"
#import "VBMathParserTokenSpecial.h"

#import "VBMathParserBracketNotClosedException.h"
#import "VBMathParserBracketNotOpenedException.h"
#import "VBMathParserMissingTokenException.h"

#import "VBStack.h"

@implementation VBMathParserSyntaxAnalyzer

- (NSArray*) analyseTokens:(NSArray*)tokensInput {
    
    VBMathParserLog(@"SyntaxAnalyzer: analyzeTokens:\n%@", tokensInput);
    
    NSMutableArray* tokens = [NSMutableArray arrayWithArray:tokensInput];
    
    //****** BRACKETS ((()))
    {
        VBMathParserLog(@"SyntaxAnalyzer: brackets: checking");
        VBStack* bracketsStack = [VBStack new];
        NSString* bracketsCheckFailedLogMessage = @"SyntaxAnalyzer: brackets: failed";
        
        for (NSInteger i = 0; i < tokens.count; i++) {
            VBMathParserToken* token = tokens[i];
            if ([token isKindOfClass:[VBMathParserTokenSpecial class]]) {
                VBMathParserTokenSpecial* tokenSpec = (VBMathParserTokenSpecial*)token;
                
                if (tokenSpec.tokenSpecial == VBTokenSpecialBracketOpen) {
                    [bracketsStack pushObject:tokenSpec];
                    
                }else if (tokenSpec.tokenSpecial == VBTokenSpecialBracketClose) {
                    if (bracketsStack.isEmpty) {
                        // nothing to pop
                        VBMathParserLog(@"%@", bracketsCheckFailedLogMessage);
                        @throw [VBMathParserBracketNotOpenedException exception];
                    }
                    [bracketsStack popObject];
                }
            }
        }
        if (bracketsStack.isEmpty) {
            VBMathParserLog(@"SyntaxAnalyzer: brackets: ok");
        }else{
            VBMathParserLog(@"%@", bracketsCheckFailedLogMessage);
            @throw [VBMathParserBracketNotClosedException exception];
        }
    }
    
    //****** MISSING TOKENS
    {
        VBMathParserLog(@"SyntaxAnalyzer: missing tokens: checking");
        NSString* missingArgumentCheckFailedLogMessage = @"SyntaxAnalyzer: missing tokens: failed";
        
        for (NSInteger i = 0; i < tokens.count; i++) {
            BOOL tokenIsMissing = NO;
            VBMathParserToken* token = tokens[i];
            VBMathParserToken* tokenNext = nil;
            
            if (i < tokens.count - 1) {
                VBMathParserToken* tokenNext = tokens[i + 1];
                
                if ([token isKindOfClass:[VBMathParserTokenOperation class]] &&
                    [tokenNext isKindOfClass:[VBMathParserTokenOperation class]]) {
                    // operations one by one. e.g. 1+*2, 1+-2
                    tokenIsMissing = YES;

                } else if ([token isKindOfClass:[VBMathParserTokenSpecial class]] && (((VBMathParserTokenSpecial*)token).tokenSpecial == VBTokenSpecialBracketOpen) &&
                           [tokenNext isKindOfClass:[VBMathParserTokenSpecial class]] && (((VBMathParserTokenSpecial*)tokenNext).tokenSpecial == VBTokenSpecialBracketClose) ) {
                    // ()
                    tokenIsMissing = YES;
                    
                } else if ([token isKindOfClass:[VBMathParserTokenSpecial class]] && (((VBMathParserTokenSpecial*)token).tokenSpecial == VBTokenSpecialBracketOpen) &&
                           [tokenNext isKindOfClass:[VBMathParserTokenOperation class]] && ((VBMathParserTokenOperation*)tokenNext).tokenOperation != VBTokenOperationSubstraction) {
                    // begins with operation after bracket. e.g. (+2
                    tokenIsMissing = YES;
                    
                } else if ([tokenNext isKindOfClass:[VBMathParserTokenSpecial class]] && (((VBMathParserTokenSpecial*)tokenNext).tokenSpecial == VBTokenSpecialBracketClose) &&
                           [token isKindOfClass:[VBMathParserTokenOperation class]]) {
                    // ends with operation before bracket. e.g. 2+)
                    tokenIsMissing = YES;

                } else if ((i == 0) &&
                           [token isKindOfClass:[VBMathParserTokenOperation class]] && ((VBMathParserTokenOperation*)token).tokenOperation != VBTokenOperationSubstraction ) {
                    // begins with operation. e.g. +2
                    tokenIsMissing = YES;

                } else if ((i == tokens.count-1) &&
                           [token isKindOfClass:[VBMathParserTokenOperation class]]) {
                    // ends with operation. e.g. 2+$
                    tokenIsMissing = YES;
                }

            }else if ([token isKindOfClass:[VBMathParserTokenOperation class]]) {
                // last token
                tokenIsMissing = YES;
            }
            
            if (tokenIsMissing) {
                VBMathParserLog(@"%@", missingArgumentCheckFailedLogMessage);
                NSString* str = [NSString stringWithFormat:@"%@%@", token.string, tokenNext ? tokenNext.string : @""];
                if (i + 2 < tokens.count) {
                    str = [NSString stringWithFormat:@"%@%@", str, ((VBMathParserToken*)tokens[i + 2]).string];
                }
                if (i - 1 > -1) {
                    str = [NSString stringWithFormat:@"%@%@", ((VBMathParserToken*)tokens[i - 1]).string, str];
                }
                @throw [VBMathParserMissingTokenException exceptionWithInfo:str];
            }
        }
        
        VBMathParserLog(@"SyntaxAnalyzer: missing tokens: ok");
    }
    
    //****** ADD SUPPRESSED MULTIPLICATION
    {
        VBMathParserLog(@"SyntaxAnalyzer: suppressed multiplication: fixing");
        
        for (NSInteger i = 0; i < tokens.count-1; i++) {
            
            if ([tokens[i] isKindOfClass:[VBMathParserTokenSpecial class]] && ((VBMathParserTokenSpecial*)tokens[i]).tokenSpecial == VBTokenSpecialBracketClose &&
                [tokens[i+1] isKindOfClass:[VBMathParserTokenSpecial class]] && ((VBMathParserTokenSpecial*)tokens[i+1]).tokenSpecial == VBTokenSpecialBracketOpen) {
                // ()() -> ()*()
                [tokens insertObject:[VBMathParserTokenOperation operationWithString:@"*"] atIndex:i+1];
                
            }else if ([tokens[i] isKindOfClass:[VBMathParserTokenNumber class]] &&
                     [tokens[i+1] isKindOfClass:[VBMathParserTokenSpecial class]] && ((VBMathParserTokenSpecial*)tokens[i+1]).tokenSpecial == VBTokenSpecialBracketOpen) {
                // 2() -> 2*()
                [tokens insertObject:[VBMathParserTokenOperation operationWithString:@"*"] atIndex:i+1];
                
            }
        }
        
        VBMathParserLog(@"SyntaxAnalyzer: suppressed multiplication: ok");
    }
    
    //****** UNARY MINUS
    {
        VBMathParserLog(@"SyntaxAnalyzer: unary minus: fixing");
        
        for (NSInteger i = 0; i < tokens.count-1; i++) {
            
            if (i == 0 &&
                [tokens[i] isKindOfClass:[VBMathParserTokenOperation class]] && ((VBMathParserTokenOperation*)tokens[i]).tokenOperation == VBTokenOperationSubstraction &&
                [tokens[i+1] isKindOfClass:[VBMathParserTokenNumber class]]) {
                // -1 -> 0-1
                [tokens insertObject:[VBMathParserTokenNumber numberWithString:@"0"] atIndex:i];
                
            }else if ([tokens[i] isKindOfClass:[VBMathParserTokenSpecial class]] && ((VBMathParserTokenSpecial*)tokens[i]).tokenSpecial == VBTokenSpecialBracketOpen &&
                      [tokens[i+1] isKindOfClass:[VBMathParserTokenOperation class]] && ((VBMathParserTokenOperation*)tokens[i+1]).tokenOperation == VBTokenOperationSubstraction) {
                // -1 -> 0-1
                [tokens insertObject:[VBMathParserTokenNumber numberWithString:@"0"] atIndex:i+1];
                
            }
        }
        
        VBMathParserLog(@"SyntaxAnalyzer: unary minus: ok");
    }
    
    VBMathParserLog(@"SyntaxAnalyzer: Analysis finished");
    return tokens;
}


@end
