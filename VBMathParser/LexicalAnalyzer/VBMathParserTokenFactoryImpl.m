//
//  VBMathParserTokenFactoryImpl.m
//  VBMathParserExamples
//
//  Created by Valeriy Bezuglyy on 14/02/16.
//  Copyright © 2016 Valeriy Bezuglyy. All rights reserved.
//

#import "VBMathParserTokenFactoryImpl.h"

#import "VBMathParserTokenSpecialBracketOpen.h"
#import "VBMathParserTokenSpecialBracketClose.h"

#import "VBMathParserTokenNumber.h"
#import "VBMathParserTokenVar.h"

#import "VBMathParserTokenConstPi.h"

#import "VBMathParserTokenOperationAddition.h"
#import "VBMathParserTokenOperationDivision.h"
#import "VBMathParserTokenOperationMultiplication.h"
#import "VBMathParserTokenOperationPower.h"
#import "VBMathParserTokenOperationSubstraction.h"

#import "VBMathParserTokenFunctionAbs.h"
#import "VBMathParserTokenFunctionCos.h"
#import "VBMathParserTokenFunctionSin.h"
#import "VBMathParserTokenFunctionTan.h"

@implementation VBMathParserTokenFactoryImpl

- (VBMathParserToken*) tokenWithType:(NSString*) tokenType
                              string:(NSString*) string {
    
    NSArray* allClasses = @[[VBMathParserTokenSpecialBracketOpen class],
                            [VBMathParserTokenSpecialBracketClose class],
                           
                            [VBMathParserTokenNumber class],
                            [VBMathParserTokenVar class],
                           
                            [VBMathParserTokenConstPi class],
                           
                            [VBMathParserTokenOperationAddition class],
                            [VBMathParserTokenOperationDivision class],
                            [VBMathParserTokenOperationMultiplication class],
                            [VBMathParserTokenOperationPower class],
                            [VBMathParserTokenOperationSubstraction class],
                           
                            [VBMathParserTokenFunctionAbs class],
                            [VBMathParserTokenFunctionCos class],
                            [VBMathParserTokenFunctionSin class],
                            [VBMathParserTokenFunctionTan class]
                            ];
    allClasses = [allClasses filteredArrayUsingPredicate:
                  [NSPredicate predicateWithFormat:@"tokenType like %@", tokenType]];
    
    VBMathParserToken* token = nil;
    for (Class tokenClass in allClasses) {
        if ([tokenClass isToken:string]) {
            token = [tokenClass tokenWithString:string];
            break;
        }
    }
    
    return token;
}

@end
