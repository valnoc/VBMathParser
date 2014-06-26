//
//  VBMathParserTokenVar.m
//  VBMathParserExamples
//
//  Created by Valeriy Bezuglyy on 25/06/14.
//  Copyright (c) 2014 Valeriy Bezuglyy. All rights reserved.
//

#import "VBMathParserTokenVar.h"

@implementation VBMathParserTokenVar

+ (instancetype) varWithString:(NSString*)str {
    return [[self alloc] initWithString:str];
}

- (instancetype) initWithString:(NSString *)str {
    self = [super initWithString:str];
    if (self) {
        _var = str;
    }
    return self;
}

+ (NSString *)regexPattern {
    return @"^[A-Za-z]*$";
}

@end
