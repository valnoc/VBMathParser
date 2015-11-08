//
//  VBMathParserLexicalAnalyzerP.h
//  VBMathParserExamples
//
//  Created by Valeriy Bezuglyy on 08/11/15.
//  Copyright © 2015 Valeriy Bezuglyy. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VBMathParserLexicalAnalyzer <NSObject>

- (nonnull NSArray*) analyseExpression:(nonnull NSString*) expression
                         withVariables:(nonnull NSArray<NSString*>*) variables;

@end
