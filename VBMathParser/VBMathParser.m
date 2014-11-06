//
//    The MIT License (MIT)
//
//    Copyright (c) 2014 Valeriy Bezuglyy. All rights reserved.
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

#import "VBMathParserLexicalAnalyzer.h"
#import "VBMathParserSyntaxAnalyzer.h"
#import "VBMathParserRPNWorker.h"

@interface VBMathParser ()

@property (nonatomic, strong) VBMathParserLexicalAnalyzer* lexicalAnalyzer;
@property (nonatomic, strong) VBMathParserSyntaxAnalyzer* syntaxAnalyzer;
@property (nonatomic, strong) VBMathParserRPNWorker* rpnWorker;

@property (nonatomic, strong) NSArray* tokens;

@end

@implementation VBMathParser

+ (instancetype) mathParserWithExpression:(NSString*)expression {
    return [[self alloc] initWithExpression:expression
                                       vars:nil];
}
+ (instancetype) mathParserWithExpression:(NSString*)expression
                                     vars:(NSArray*)vars{
    return [[self alloc] initWithExpression:expression
                                       vars:vars];
}

- (instancetype) initWithExpression:(NSString*)expression
                               vars:(NSArray*)vars {
    self = [super init];
    if (self) {
        self.vars = vars;
        self.expression = expression;
    }
    return self;
}

#pragma mark - public change expression
- (void) setExpression:(NSString *)expression {
    @synchronized(self){
        _expression = expression;
        [self parse:expression
           withVars:self.vars];
    }
}

- (void) parse:(NSString*)expression
      withVars:(NSArray*)vars {
    NSArray* tokens = [self.lexicalAnalyzer analyseString:expression
                                                 withVars:vars];
    tokens = [self.syntaxAnalyzer analyseTokens:tokens];
    self.tokens = [self.rpnWorker formatTokens:tokens];
}

#pragma mark - evaluate
+ (double) evaluateExpression:(NSString*)expression {
    return [self evaluateExpression:expression
                     withVarsValues:nil];
}
+ (double) evaluateExpression:(NSString*)expression
               withVarsValues:(NSDictionary*)varsValues {
    VBMathParser* parser = [self mathParserWithExpression:expression
                                                     vars:varsValues.allKeys];
    return [parser evaluateWithVarsValues:varsValues];
}

- (double) evaluate {
    return [self evaluateWithVarsValues:nil];
}

- (double) evaluateWithVarsValues:(NSDictionary*)varsValues{
    return [self.rpnWorker evaluate:self.tokens
                     withVarsValues:varsValues];
}

#pragma mark - private props
- (VBMathParserLexicalAnalyzer *) lexicalAnalyzer {
    if (_lexicalAnalyzer == nil) {
        _lexicalAnalyzer = [VBMathParserLexicalAnalyzer new];
    }
    return _lexicalAnalyzer;
}

- (VBMathParserSyntaxAnalyzer *) syntaxAnalyzer {
    if (_syntaxAnalyzer == nil) {
        _syntaxAnalyzer = [VBMathParserSyntaxAnalyzer new];
    }
    return _syntaxAnalyzer;
}

- (VBMathParserRPNWorker*) rpnWorker {
    if (_rpnWorker == nil) {
        _rpnWorker = [VBMathParserRPNWorker new];
    }
    return _rpnWorker;
}

@end
