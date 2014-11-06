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

#import "VBMathParserRPNWorker.h"

#import "VBMathParserDefines.h"

#import "VBMathParserTokenSpecialBracketOpen.h"
#import "VBMathParserTokenSpecialBracketClose.h"

#import "VBMathParserTokenNumber.h"
#import "VBMathParserTokenOperation.h"
#import "VBMathParserTokenFunction.h"
#import "VBMathParserTokenVar.h"
#import "vbmathParserTokenConst.h"

#import "VBMathParserMissingValueForVarException.h"

#import "VBStack.h"

@implementation VBMathParserRPNWorker

- (NSArray*) formatTokens:(NSArray*)tokensInput {
    
    VBMathParserLog(@"RPNWorker: formatTokens:\n%@", tokensInput);
    NSMutableArray* tokens = [NSMutableArray new];
    VBStack* stack = [VBStack new];
    
    for (NSInteger i = 0; i < tokensInput.count; i++) {
        VBMathParserToken* token = tokensInput[i];
        
        if ([token isKindOfClass:[VBMathParserTokenNumber class]] ||
            [token isKindOfClass:[VBMathParserTokenVar class]] ||
            [token isKindOfClass:[VBMathParserTokenConst class]]) {
            
            [tokens addObject:token];
            
        }else if ([token isKindOfClass:[VBMathParserTokenAction class]]) {
            if (stack.isEmpty) {
                [stack pushObject:token];
                
            }else {
                id lastObject = stack.lastObject;
                while ([lastObject isKindOfClass:[VBMathParserTokenAction class]]) {
                    
                    if ([(VBMathParserTokenAction*)lastObject priority] >= [(VBMathParserTokenAction*)token priority]) {
                        [tokens addObject:[stack popObject]];
                        lastObject = stack.lastObject;
                    }else{
                        break;
                    }
                }
                [stack pushObject:token];
            }
            
        }else if ([token isKindOfClass:[VBMathParserTokenSpecial class]]) {

            if ([token isKindOfClass:[VBMathParserTokenSpecialBracketOpen class]]) {
                [stack pushObject:token];
                
            }else if ([token isKindOfClass:[VBMathParserTokenSpecialBracketClose class]]) {
                id lastObject = stack.lastObject;
                while ( ([lastObject isKindOfClass:[VBMathParserTokenSpecialBracketOpen class]] ||
                         [lastObject isKindOfClass:[VBMathParserTokenSpecialBracketClose class]]) == NO) {
                    [tokens addObject:[stack popObject]];
                    lastObject = stack.lastObject;
                }
                [stack popObject];
            }
        }
    }
    
    while (stack.isEmpty == NO) {
        [tokens addObject:[stack popObject]];
    }
    
    VBMathParserLog(@"RPNWorker: finished formatting tokens:\n%@", tokens);
    return tokens;
}

- (double) evaluate:(NSArray*)tokensInput
     withVarsValues:(NSDictionary*)varsValues {

    VBMathParserLog(@"RPNWorker: evaluate:\n%@", tokensInput);
    NSMutableArray* resultArray = [NSMutableArray arrayWithArray:tokensInput];
    
    [self replaceVarTokens:resultArray
                withValues:varsValues];
    [self replaceConstTokens:resultArray];
    
    //  evaluate
    for (NSInteger i = 0; i < resultArray.count; i++) {
        VBMathParserToken* token = resultArray[i];

        if ([token isKindOfClass:[VBMathParserTokenAction class]]) {
            
            NSRange replacementRange = NSMakeRange(i, 1);
            double paramRight = 0;
            double paramLeft = 0;

            if (i > 0) {
                VBMathParserToken* tokenRight = resultArray[i - 1];
               
                if ([tokenRight isKindOfClass:[VBMathParserTokenNumber class]] || [tokenRight isKindOfClass:[NSNumber class]]) {
                    paramRight = [(VBMathParserTokenNumber*)tokenRight doubleValue];
                }
                
                replacementRange.location--;
                replacementRange.length++;
            }
            
            if ([token isKindOfClass:[VBMathParserTokenOperation class]] && i > 1) {
                VBMathParserToken* tokenLeft = resultArray[i - 2];
                
                if ([tokenLeft isKindOfClass:[VBMathParserTokenNumber class]] || [tokenLeft isKindOfClass:[NSNumber class]]) {
                    paramLeft = [(VBMathParserTokenNumber*)tokenLeft doubleValue];
                }
                replacementRange.location--;
                replacementRange.length++;
            }
            
            double actRes = 0;
            if ([token isKindOfClass:[VBMathParserTokenOperation class]]) {
                actRes = [(VBMathParserTokenOperation*)token evaluateWithParamLeft:paramLeft
                                                                        paramRight:paramRight];
            }else if ([token isKindOfClass:[VBMathParserTokenFunction class]]) {
                actRes = [(VBMathParserTokenFunction*)token evaluateWithParam:paramRight];
            }
            
            [resultArray removeObjectsInRange:replacementRange];
            [resultArray insertObject:@(actRes)
                              atIndex:replacementRange.location];
            
            i = replacementRange.location - 1;

        }
    }
    
    double result = [resultArray.lastObject doubleValue];
#warning TODO exception maybe?
    VBMathParserLog(@"RPNWorker: evaluationResult:%@", @(result));
    return result;
}

- (void) replaceVarTokens:(NSMutableArray*)tokens
               withValues:(NSDictionary*)varsValues {
    for (NSInteger i = 0; i < tokens.count; i++) {
        VBMathParserToken* token = tokens[i];
        if ([token isKindOfClass:[VBMathParserTokenVar class]]) {
            
            NSNumber* value = varsValues[token.stringValue];
            if (value && [value isKindOfClass:[NSNumber class]]) {
                [tokens replaceObjectAtIndex:i
                                  withObject:[VBMathParserTokenNumber tokenWithString:[NSString stringWithFormat:@"%@", value]]];
            }else{
                @throw [VBMathParserMissingValueForVarException exceptionWithVar:token.stringValue];
            }
        }
    }
}

- (void) replaceConstTokens:(NSMutableArray*)tokens {
    for (NSInteger i = 0; i < tokens.count; i++) {
        VBMathParserToken* token = tokens[i];
        if ([token isKindOfClass:[VBMathParserTokenConst class]]) {
            [tokens replaceObjectAtIndex:i
                              withObject:[VBMathParserTokenNumber tokenWithString:[NSString stringWithFormat:@"%@", @(((VBMathParserTokenConst*)token).doubleValue)]]];
        }
    }
}

@end
