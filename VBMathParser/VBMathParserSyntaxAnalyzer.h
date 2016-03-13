//
//  VBMathParserSyntaxAnalyzerP.h
//  VBMathParserExamples
//
//  Created by Valeriy Bezuglyy on 08/11/15.
//  Copyright © 2015 Valeriy Bezuglyy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VBMathParserToken;

@protocol VBMathParserSyntaxAnalyzer <NSObject>

- (nonnull NSArray<VBMathParserToken *>*) analyseExpression:(nonnull NSArray<VBMathParserToken *>*) expression;

@end
