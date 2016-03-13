//
//  VBMathParserDefaultRPNCalculator.m
//  VBMathParserExamples
//
//  Created by Valeriy Bezuglyy on 13/03/16.
//  Copyright © 2016 Valeriy Bezuglyy. All rights reserved.
//

#import "VBMathParserDefaultRPNCalculator.h"

#import "VBMathParserTokenSpecialBracketOpen.h"
#import "VBMathParserTokenSpecialBracketClose.h"

#import "VBMathParserTokenNumber.h"
#import "VBMathParserTokenOperation.h"
#import "VBMathParserTokenFunction.h"
#import "VBMathParserTokenVar.h"
#import "vbmathParserTokenConst.h"

#import "VBMathParserMissingValueForVarException.h"

@implementation VBMathParserDefaultRPNCalculator

- (NSArray<VBMathParserToken *> *) prepareExpression:(NSArray<VBMathParserToken *> *)expression {
    NSMutableArray* tokens = [NSMutableArray new];
    NSMutableArray* stack = [NSMutableArray new];
    
    for (NSInteger i = 0; i < expression.count; i++) {
        VBMathParserToken* token = expression[i];
        
        if ([token isKindOfClass:[VBMathParserTokenNumber class]] ||
            [token isKindOfClass:[VBMathParserTokenVar class]] ||
            [token isKindOfClass:[VBMathParserTokenConst class]]) {
            
            [tokens addObject:token];
            
        }else if ([token isKindOfClass:[VBMathParserTokenAction class]]) {
            if (stack.count == 0) {
                [stack addObject:token];
                
            }else {
                VBMathParserToken* lastObject = stack.lastObject;
                while ([lastObject isKindOfClass:[VBMathParserTokenAction class]]) {
                    
                    if ([(VBMathParserTokenAction*)lastObject priority] >= [(VBMathParserTokenAction*)token priority]) {
                        [tokens addObject:stack.lastObject];
                        [stack removeLastObject];
                        lastObject = stack.lastObject;
                    }else{
                        break;
                    }
                }
                [stack addObject:token];
            }
            
        }else if ([token isKindOfClass:[VBMathParserTokenSpecial class]]) {
            
            if ([token isKindOfClass:[VBMathParserTokenSpecialBracketOpen class]]) {
                [stack addObject:token];
                
            }else if ([token isKindOfClass:[VBMathParserTokenSpecialBracketClose class]]) {
                VBMathParserToken* lastObject = stack.lastObject;
                while ( ([lastObject isKindOfClass:[VBMathParserTokenSpecialBracketOpen class]] ||
                         [lastObject isKindOfClass:[VBMathParserTokenSpecialBracketClose class]]) == NO) {
                    [tokens addObject:stack.lastObject];
                    [stack removeLastObject];
                    lastObject = stack.lastObject;
                }
                [stack removeLastObject];
            }
        }
    }
    
    while (stack.count != 0) {
        [tokens addObject:stack.lastObject];
        [stack removeLastObject];
    }

    return tokens;
}



@end
