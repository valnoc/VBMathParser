//
//  VBMathParserRPNWorker.h
//  VBMathParserExamples
//
//  Created by Valeriy Bezuglyy on 08/11/15.
//  Copyright © 2015 Valeriy Bezuglyy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VBMathParserToken;

@protocol VBMathParserCalculator <NSObject>

- (nonnull NSArray<VBMathParserToken*>*) prepareExpression:(nonnull NSArray<VBMathParserToken*>*) expression;

- (double) evaluateExpression:(nonnull NSArray<VBMathParserToken*>*) expression
               withVarsValues:(nullable NSDictionary<NSString*, NSNumber*>*) varsValues;

@end
