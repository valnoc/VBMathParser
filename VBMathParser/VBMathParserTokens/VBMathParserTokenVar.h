//
//  VBMathParserTokenVar.h
//  VBMathParserExamples
//
//  Created by Valeriy Bezuglyy on 25/06/14.
//  Copyright (c) 2014 Valeriy Bezuglyy. All rights reserved.
//

#import "VBMathParserToken.h"

@interface VBMathParserTokenVar : VBMathParserToken

@property (nonatomic, strong, readonly) NSString* var;

+ (instancetype) varWithString:(NSString*)str;

@end
