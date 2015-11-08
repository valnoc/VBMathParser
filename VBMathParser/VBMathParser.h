//
//    The MIT License (MIT)
//
//    Copyright (c) 2015 Valeriy Bezuglyy.
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

//    VBMathParser
//    ============
//
//    VBMathParser is a simple framework to perform mathematical expressions parsing.
//    Math parser is conceived as a one-line string-to-double converter.
//
//    This framework uses ARC. DO NOT FORGET to turn on ARC for framework's sources (-fobjc-arc flag), if your project is developed in non-ARC environment.
//
//    ## How to use
//    1. Drag VBMathParser dir into your project.
//    2. Import header
//
//    `#import "VBMathParser.h”`
//
//    3. Use one of the variants
//
//    Single line
//
//    double result = [VBMathParser evaluateExpression:@"1"];
//
//    Using instance method
//
//    VBMathParser* parser = [VBMathParser mathParserWithExpression:@"2 + 4"];
//    result = [parser evaluate];
//
//    Expression can always be changed by setting the expression property of VBMathParser object
//
//    parser.expression = @"2(1+3)";
//    result = [parser evaluate];
//
//    To use variables declare them before assigning new expression (single line variant included)
//
//    parser.vars = @[@"x"];
//    parser.expression = @"x+1";
//    result = [parser evaluateWithVarsValues:@{@"x": @(2)}];
//
//    ## Expected syntax
//    1. If you open a bracket - do not forget to close it later.
//    2. All operations are expected to be used in mathematical expressions as binary operations.
//
//    Only "-" operation can be used both as binary and as unary one. Actually unary minus operation is always replaced by a binary one as the following:
//
//    "-4" -> "0-4"
//    "2 * (-4)" -> "2 * (0 - 4)"
//    "-abs(4)" -> "0 - abs(4)"
//
//    3. All functions are expected to be followed by an argument enclosed in brackets.
//
//    abs3 - error!
//    abs(3) - OK
//
//    4. Variable name must consist of at least one letter plus letters and numbers.
//
//    valid names: x, y, x1, x01, etc
//    invalid names: 0x, x_213, etc
//
//    ## Supported features
//    1. brackets: (, )
//    2. operations: +, - (unary/binary), *, /, ^(power)
//    3. functions: abs, sin, cos, tan
//    4. variables
//    5. constants: pi
//
//    ## Coming soon
//    1. more functions and constants
//
//    Feel free to left a feature request
//
//    ## License
//    VBMathParser is available under the MIT license. See the LICENSE file for more info.

#import <Foundation/Foundation.h>

#import "VBMathParserLexicalAnalyzer.h"
#import "VBMathParserSyntaxAnalyzer.h"
#import "VBMathParserRPNWorker.h"

@interface VBMathParser : NSObject

@property (nonnull, nonatomic, strong) NSString* expression;
@property (nullable, nonatomic, strong, readonly) NSArray<NSString*>* variables;

- (nonnull instancetype) initWithLexicalAnalyzer:(nullable id<VBMathParserLexicalAnalyzer>) lexicalAnalyzer
                                  syntaxAnalyzer:(nullable id<VBMathParserSyntaxAnalyzer>) syntaxAnalyzer
                                       rpnWorker:(nullable id<VBMathParserRPNWorker>) rpnWorker;

#pragma mark - parse
- (void) setExpression:(nonnull NSString *)expression;
- (void) setExpression:(nonnull NSString *) expression
         withVariables:(nullable NSArray<NSString*>*) variables;

- (void) parseExpression;

#pragma mark - evaluate
- (double) evaluate;
- (double) evaluateWithVariablesValues:(nullable NSDictionary<NSString*, NSNumber*>*) variablesValues;

@end
