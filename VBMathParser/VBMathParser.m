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

#import "VBMathParser.h"

#import "VBMathParserDefaultLexicalAnalyzer.h"
#import "VBMathParserDefaultSyntaxAnalyzer.h"
#import "VBMathParserDefaultRPNCalculator.h"

@interface VBMathParser ()

@property (nonatomic, strong) id<VBMathParserLexicalAnalyzer> lexicalAnalyzer;
@property (nonatomic, strong) id<VBMathParserSyntaxAnalyzer> syntaxAnalyzer;
@property (nonatomic, strong) id<VBMathParserCalculator> calculator;

@property (nonatomic, strong) NSArray* tokens;

@end

@implementation VBMathParser

- (instancetype)init {
    return [self initWithDefaultAnalyzers];
}

- (instancetype) initWithDefaultAnalyzers {
    return [self initWithLexicalAnalyzer:[VBMathParserDefaultLexicalAnalyzer new]
                          syntaxAnalyzer:[VBMathParserDefaultSyntaxAnalyzer new]
                              calculator:[VBMathParserDefaultRPNCalculator new]];
}

- (instancetype) initWithLexicalAnalyzer:(id<VBMathParserLexicalAnalyzer>) lexicalAnalyzer
                          syntaxAnalyzer:(id<VBMathParserSyntaxAnalyzer>) syntaxAnalyzer
                              calculator:(id<VBMathParserCalculator>) calculator {
    self = [super init];
    if (self) {
        self.lexicalAnalyzer = lexicalAnalyzer;
        self.syntaxAnalyzer = syntaxAnalyzer;
        self.calculator = calculator;
    }
    return self;
}

#pragma mark - parse
- (void) setExpression:(nonnull NSString *)expression {
    [self setExpression:expression
          withVariables:nil];
}

- (void) setExpression:(nonnull NSString *) expression
         withVariables:(nullable NSArray<NSString*>*) variables {
    _expression = expression;
    _variables = variables;
    [self parseExpression];
}

- (void) parseExpression {
    NSArray* tokens = [self.lexicalAnalyzer analyseExpression:self.expression
                                                withVariables:self.variables];
    tokens = [self.syntaxAnalyzer analyseExpression:tokens];
    self.tokens = [self.calculator prepareExpression:tokens];
}

#pragma mark - evaluate
- (double) evaluate {
    return [self evaluateWithVariablesValues:nil];
}

- (double) evaluateWithVariablesValues:(NSDictionary<NSString*, NSNumber*>*) variablesValues {
    return [self.calculator evaluateExpression:self.tokens
                                withVarsValues:variablesValues];
}

@end
