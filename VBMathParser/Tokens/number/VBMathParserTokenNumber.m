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

#import "VBMathParserTokenNumber.h"

@implementation VBMathParserTokenNumber

#pragma mark - regexp
+ (NSString *) regexpPattern {
    return @"^[0-9]+\\.?[0-9]*$";
}

+ (NSString *) tokenType {
    return @"VBMathParserTokenNumber";
}

+ (BOOL) isToken:(NSString*)string {
    @try {
        if ([super isToken:string]) {
            double res = [string doubleValue];
            res += 1;
            return YES;
        }else{
            return NO;
        }
    }
    @catch (NSException *exception) {
        return NO;
    }
}

#pragma mark - number
- (double) doubleValue { 
    return [[self stringValue] doubleValue];
}

@end
