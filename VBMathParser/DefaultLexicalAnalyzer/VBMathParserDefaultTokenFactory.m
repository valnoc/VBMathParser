//
//    The MIT License (MIT)
//
//    Copyright (c) 2016 Valeriy Bezuglyy.
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

#import "VBMathParserDefaultTokenFactory.h"

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

@implementation VBMathParserDefaultTokenFactory

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
