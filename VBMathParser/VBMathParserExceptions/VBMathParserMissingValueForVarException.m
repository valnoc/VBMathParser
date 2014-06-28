//
//  VBMathParserMissingValueForVarException.m
//  VBMathParserExamples
//
//  Created by Valeriy Bezuglyy on 28/06/14.
//  Copyright (c) 2014 Valeriy Bezuglyy. All rights reserved.
//

#import "VBMathParserMissingValueForVarException.h"

@implementation VBMathParserMissingValueForVarException

+ (instancetype) exception {
    return [[self alloc] initWithName:@"MissingValueForVar"
                               reason:@"Token is unknown"
                             userInfo:nil];
}

+ (instancetype) exceptionWithInfo:(NSString*)info {
    return [[self alloc] initWithName:@"MissingValueForVar"
                               reason:[NSString stringWithFormat:@"Variable %@ value is missing", info]
                             userInfo:@{@"info": info}];
}

@end
