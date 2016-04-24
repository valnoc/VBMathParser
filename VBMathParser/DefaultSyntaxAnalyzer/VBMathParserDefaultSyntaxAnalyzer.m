//
//  VBMathParserDefaultSyntaxAnalyzer.m
//  VBMathParserExamples
//
//  Created by Valeriy Bezuglyy on 13/03/16.
//  Copyright © 2016 Valeriy Bezuglyy. All rights reserved.
//

#import "VBMathParserDefaultSyntaxAnalyzer.h"

#import "VBMathParserTokenSpecialBracketOpen.h"
#import "VBMathParserTokenSpecialBracketClose.h"

#import "VBMathParserTokenOperationSubstraction.h"

#import "VBMathParserTokenNumber.h"

#import "VBMathParserTokenFunction.h"
#import "VBMathParserTokenVar.h"
#import "VBMathParserTokenConst.h"

#import "VBMathParserBracketNotClosedException.h"
#import "VBMathParserBracketNotOpenedException.h"
#import "VBMathParserMissingTokenException.h"

@implementation VBMathParserDefaultSyntaxAnalyzer

- (NSArray<VBMathParserToken *> *) analyseExpression:(NSArray<VBMathParserToken *> *)expression {
    NSMutableArray* tokens = [NSMutableArray arrayWithArray:expression];
    
    [self checkBrackets:tokens];
    [self checkMissingTokens:tokens];
    
    [self fixMissingMultiplication:tokens];
    [self fixUnaryMinus:tokens];

    return tokens;
}

#pragma mark - check
- (void) checkBrackets:(NSArray*)tokens {
    //  ((()))
    NSMutableArray* bracketsStack = [NSMutableArray new];
    
    for (NSInteger i = 0; i < tokens.count; i++) {
        VBMathParserToken* token = tokens[i];
        
        if ([token isKindOfClass:[VBMathParserTokenSpecial class]]) {
            if ([token isKindOfClass:[VBMathParserTokenSpecialBracketOpen class]]) {
                [bracketsStack addObject:token];
                
            }else if ([token isKindOfClass:[VBMathParserTokenSpecialBracketClose class]]) {
                if (bracketsStack.count == 0) {
                    // nothing to pop
                    @throw [VBMathParserBracketNotOpenedException exception];
                }
                [bracketsStack removeLastObject];
            }
        }
    }
    if (bracketsStack.count != 0) {
        @throw [VBMathParserBracketNotClosedException exception];
    }
}

- (void) checkMissingTokens:(NSArray*)tokens {
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
                
            } else if ([token isKindOfClass:[VBMathParserTokenSpecialBracketOpen class]] &&
                       [tokenNext isKindOfClass:[VBMathParserTokenSpecialBracketClose class]]) {
                // ()
                tokenIsMissing = YES;
                
            } else if ([token isKindOfClass:[VBMathParserTokenSpecialBracketOpen class]] &&
                       [tokenNext isKindOfClass:[VBMathParserTokenOperation class]] &&
                       [tokenNext isKindOfClass:[VBMathParserTokenOperationSubstraction class]] == NO) {
                // begins with operation after bracket. e.g. (+2
                tokenIsMissing = YES;
                
            } else if ([token isKindOfClass:[VBMathParserTokenOperation class]] &&
                       [tokenNext isKindOfClass:[VBMathParserTokenSpecialBracketClose class]]) {
                // ends with operation before bracket. e.g. 2+)
                tokenIsMissing = YES;
                
            } else if ((i == 0) &&
                       [token isKindOfClass:[VBMathParserTokenOperation class]] &&
                       [token isKindOfClass:[VBMathParserTokenOperationSubstraction class]] == NO ) {
                // begins with operation. e.g. +2
                tokenIsMissing = YES;
                
            } else if ((i == tokens.count-1) &&
                       [token isKindOfClass:[VBMathParserTokenOperation class]]) {
                // ends with operation. e.g. 2+$
                tokenIsMissing = YES;
                
            } else if ([token isKindOfClass:[VBMathParserTokenFunction class]] &&
                       [tokenNext isKindOfClass:[VBMathParserTokenSpecialBracketOpen class]] == NO) {
                // any function should be followed by its arguments in brackets
                tokenIsMissing = YES;
            }
            
        }else if ([token isKindOfClass:[VBMathParserTokenOperation class]] ||
                  [token isKindOfClass:[VBMathParserTokenFunction class]]) {
            // last token
            tokenIsMissing = YES;
        }
        
        if (tokenIsMissing) {
            NSString* str = [NSString stringWithFormat:@"%@%@", token.stringValue, tokenNext ? tokenNext.stringValue : @""];
            if (i + 2 < tokens.count) {
                str = [NSString stringWithFormat:@"%@%@", str, ((VBMathParserToken*)tokens[i + 2]).stringValue];
            }
            if (i - 1 > -1) {
                str = [NSString stringWithFormat:@"%@%@", ((VBMathParserToken*)tokens[i - 1]).stringValue, str];
            }
            @throw [VBMathParserMissingTokenException exceptionWithExpression:str];
        }
    }
}

#pragma mark - fix
- (void) fixMissingMultiplication:(NSMutableArray*)tokens {
    for (NSInteger i = 0; i < tokens.count-1; i++) {
        
        if ([tokens[i] isKindOfClass:[VBMathParserTokenSpecialBracketClose class]] &&
            [tokens[i + 1] isKindOfClass:[VBMathParserTokenSpecialBracketOpen class]]) {
            // ()() -> ()*()
            [tokens insertObject:[VBMathParserTokenOperation tokenWithString:@"*"]
                         atIndex:i + 1];
            
        }else if (([tokens[i] isKindOfClass:[VBMathParserTokenNumber class]] ||
                   [tokens[i] isKindOfClass:[VBMathParserTokenVar class]] ||
                   [tokens[i] isKindOfClass:[VBMathParserTokenConst class]]) &&
                  [tokens[i+1] isKindOfClass:[VBMathParserTokenSpecialBracketOpen class]]) {
            // 2() -> 2*()
            [tokens insertObject:[VBMathParserTokenOperation tokenWithString:@"*"]
                         atIndex:i + 1];
        }
    }
}

- (void) fixUnaryMinus:(NSMutableArray*)tokens {
    for (NSInteger i = 0; i < tokens.count-1; i++) {
        
        if (i == 0 &&
            [tokens[i] isKindOfClass:[VBMathParserTokenOperationSubstraction class]] &&
            ([tokens[i + 1] isKindOfClass:[VBMathParserTokenNumber class]] ||
             [tokens[i + 1] isKindOfClass:[VBMathParserTokenVar class]] ||
             [tokens[i + 1] isKindOfClass:[VBMathParserTokenConst class]])) {
                // -1 -> 0-1
                [tokens insertObject:[VBMathParserTokenNumber tokenWithString:@"0"]
                             atIndex:i];
                
            }else if ([tokens[i] isKindOfClass:[VBMathParserTokenSpecialBracketOpen class]] &&
                      [tokens[i + 1] isKindOfClass:[VBMathParserTokenOperationSubstraction class]]) {
                // (-1 -> (0-1
                [tokens insertObject:[VBMathParserTokenNumber tokenWithString:@"0"]
                             atIndex:i + 1];
                
            }
    }
}

@end
