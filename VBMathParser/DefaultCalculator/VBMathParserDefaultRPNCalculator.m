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

- (double) evaluateExpression:(NSArray<VBMathParserToken *> *)expression
               withVarsValues:(NSDictionary<NSString *,NSNumber *> *)varsValues {
    NSMutableArray* resultArray = [NSMutableArray arrayWithArray:expression];
    
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
                actRes = [(VBMathParserTokenOperation*)token evaluateWithArgLeft:paramLeft
                                                                        argRight:paramRight];
            }
            else if ([token isKindOfClass:[VBMathParserTokenFunction class]]) {
                actRes = [(VBMathParserTokenFunction*)token evaluateWithArg:paramRight];
            }
            
            [resultArray removeObjectsInRange:replacementRange];
            [resultArray insertObject:@(actRes)
                              atIndex:replacementRange.location];
            
            i = replacementRange.location - 1;
            
        }
    }
    
    double result = [resultArray.lastObject doubleValue];
    return result;
}

- (void) replaceVarTokens:(NSMutableArray*)tokens
               withValues:(NSDictionary*)varsValues {
    [tokens enumerateObjectsUsingBlock:^(VBMathParserToken*  _Nonnull token, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([token isKindOfClass:[VBMathParserTokenVar class]]) {
            NSNumber* value = varsValues[token.stringValue];
            if (value && [value isKindOfClass:[NSNumber class]]) {
                [tokens replaceObjectAtIndex:idx
                                  withObject:[VBMathParserTokenNumber tokenWithString:value.stringValue]];
            }
            else{
                @throw [VBMathParserMissingValueForVarException exceptionWithVar:token.stringValue];
            }
        }
    }];
}

- (void) replaceConstTokens:(NSMutableArray*)tokens {
    [tokens enumerateObjectsUsingBlock:^(VBMathParserToken*  _Nonnull token, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([token isKindOfClass:[VBMathParserTokenConst class]]) {
            [tokens replaceObjectAtIndex:idx
                              withObject:[VBMathParserTokenNumber tokenWithString:
                                          @(((VBMathParserTokenConst*)token).doubleValue).stringValue]];
        }
    }];
}

@end
