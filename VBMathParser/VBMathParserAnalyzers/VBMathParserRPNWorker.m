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

#import "VBMathParserTokenNumber.h"
#import "VBMathParserTokenOperation.h"
#import "VBMathParserTokenSpecial.h"

#import "VBStack.h"

@implementation VBMathParserRPNWorker

- (NSArray*) formatTokens:(NSArray*)tokensInput {
    
    VBMathParserLog(@"RPNWorker: formatTokens:\n%@", tokensInput);
    NSMutableArray* tokens = [NSMutableArray new];
    VBStack* stack = [VBStack new];
    
    for (NSInteger i = 0; i < tokensInput.count; i++) {
        VBMathParserToken* token = tokensInput[i];
        
        if ([token isKindOfClass:[VBMathParserTokenNumber class]]) {
            [tokens addObject:token];
            
        }else if ([token isKindOfClass:[VBMathParserTokenOperation class]]) {
            if (stack.isEmpty) {
                [stack pushObject:token];
                
            }else {
                id lastObject = stack.lastObject;
                while ([lastObject isKindOfClass:[VBMathParserTokenOperation class]]) {
                    VBMathParserTokenOperation* lastOperation = (VBMathParserTokenOperation*)lastObject;
                    if (lastOperation.priority >= ((VBMathParserTokenOperation*)token).priority) {
                        [tokens addObject:[stack popObject]];
                        lastObject = stack.lastObject;
                    }else{
                        break;
                    }
                }
                [stack pushObject:token];
            }
        }else if ([token isKindOfClass:[VBMathParserTokenSpecial class]]) {
            
            VBMathParserTokenSpecial* tokenSpecial = (VBMathParserTokenSpecial*)token;
            if (tokenSpecial.tokenSpecial == VBTokenSpecialBracketOpen) {
                [stack pushObject:tokenSpecial];
                
            }else if (tokenSpecial.tokenSpecial == VBTokenSpecialBracketClose) {
                id lastObject = stack.lastObject;
                while ( ([lastObject isKindOfClass:[VBMathParserTokenSpecial class]] &&
                         ( ((VBMathParserTokenSpecial*)lastObject).tokenSpecial == VBTokenSpecialBracketOpen ||
                           ((VBMathParserTokenSpecial*)lastObject).tokenSpecial == VBTokenSpecialBracketClose) ) == NO) {
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

- (double) evaluate:(NSArray*)tokensInput {
    VBMathParserLog(@"RPNWorker: evaluate:\n%@", tokensInput);
    NSMutableArray* resultArray = [NSMutableArray arrayWithArray:tokensInput];

    for (NSInteger i = 0; i < resultArray.count; i++) {
        id object = resultArray[i];

        if ([object isKindOfClass:[VBMathParserTokenOperation class]]) {
            
            NSRange replacementRange = NSMakeRange(i, 1);
            double paramRight = 0;
            double paramLeft = 0;

            if (i > 0) {
                id objectRight = resultArray[i-1];
               
                if ([objectRight isKindOfClass:[VBMathParserTokenNumber class]] || [objectRight isKindOfClass:[NSNumber class]]) {
                    paramRight = [objectRight doubleValue];
                }
                
                replacementRange.location--;
                replacementRange.length++;
            }
            
            if (i > 1) {
                id objectLeft = resultArray[i-2];
                
                if ([objectLeft isKindOfClass:[VBMathParserTokenNumber class]] || [objectLeft isKindOfClass:[NSNumber class]]) {
                    paramLeft = [objectLeft doubleValue];
                }
                replacementRange.location--;
                replacementRange.length++;
            }
            
            VBMathParserTokenOperation* operation = (VBMathParserTokenOperation*)object;
            double opRes = [operation evaluateWithParamLeft:paramLeft
                                                 paramRight:paramRight];
            [resultArray removeObjectsInRange:replacementRange];
            [resultArray insertObject:@(opRes) atIndex:replacementRange.location];
            
            i = replacementRange.location - 1;
        }
    }
    
    double result = [resultArray.lastObject isKindOfClass:[NSNumber class]] || [resultArray.lastObject isKindOfClass:[VBMathParserTokenNumber class]] ? [resultArray.lastObject doubleValue] : 0;
#warning TODO exception maybe?
    VBMathParserLog(@"RPNWorker: evaluationResult:%@", @(result));
    return result;
}

@end
