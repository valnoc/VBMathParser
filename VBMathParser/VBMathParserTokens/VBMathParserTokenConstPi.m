//
//  VBMathParserTokenConstPi.m
//  VBMathParserExamples
//
//  Created by Valeriy Bezuglyy on 03/11/14.
//  Copyright (c) 2014 Valeriy Bezuglyy. All rights reserved.
//

#import "VBMathParserTokenConstPi.h"

@implementation VBMathParserTokenConstPi

#pragma mark - token concrete
+ (NSString *) rawString {
    return @"pi";
}

- (double) doubleValue {
    return M_PI;
}

@end
