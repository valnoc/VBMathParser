//
//  VBMathParserTests.m
//  VBMathParserExamples
//
//  Created by Valeriy Bezuglyy on 3/16/14.
//  Copyright (c) 2014 Valeriy Bezuglyy. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>

#import "VBMathParser.h"

#import "VBMathParserDefaultLexicalAnalyzer.h"
#import "VBMathParserDefaultSyntaxAnalyzer.h"
#import "VBMathParserDefaultRPNCalculator.h"

@interface VBMathParser (tests)

@property (nonatomic, strong) id<VBMathParserLexicalAnalyzer> lexicalAnalyzer;
@property (nonatomic, strong) id<VBMathParserSyntaxAnalyzer> syntaxAnalyzer;
@property (nonatomic, strong) id<VBMathParserCalculator> calculator;

@end

@interface VBMathParserTests : XCTestCase

@property (nonatomic, strong) VBMathParser* parser;

@property (nonatomic, strong) id mockLexicalAnalyzer;
@property (nonatomic, strong) id mockSyntaxAnalyzer;
@property (nonatomic, strong) id mockCalculator;

@end

@implementation VBMathParserTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.

    self.mockLexicalAnalyzer = OCMProtocolMock(@protocol(VBMathParserLexicalAnalyzer));
    self.mockSyntaxAnalyzer = OCMProtocolMock(@protocol(VBMathParserSyntaxAnalyzer));
    self.mockCalculator = OCMProtocolMock(@protocol(VBMathParserCalculator));
    
    self.parser = [[VBMathParser alloc] initWithLexicalAnalyzer:self.mockLexicalAnalyzer
                                                 syntaxAnalyzer:self.mockSyntaxAnalyzer
                                                     calculator:self.mockCalculator];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    
    self.mockCalculator = nil;
    self.mockLexicalAnalyzer = nil;
    self.mockSyntaxAnalyzer = nil;
    
    self.parser = nil;
    
    [super tearDown];
}

- (void) testThatItUsesInjections {
    expect(self.parser.lexicalAnalyzer).to.equal(self.mockLexicalAnalyzer);
    expect(self.parser.syntaxAnalyzer).to.equal(self.mockSyntaxAnalyzer);
    expect(self.parser.calculator).to.equal(self.mockCalculator);
}

- (void) testThatItCreatesDefaultTokenFactory {
    self.parser = [[VBMathParser alloc] initWithDefaultAnalyzers];

    expect(self.parser.lexicalAnalyzer).to.beAnInstanceOf([VBMathParserDefaultLexicalAnalyzer class]);
    expect(self.parser.syntaxAnalyzer).to.beAnInstanceOf([VBMathParserDefaultSyntaxAnalyzer class]);
    expect(self.parser.calculator).to.beAnInstanceOf([VBMathParserDefaultRPNCalculator class]);
}

- (void) testThatItPreparesExpressionCorrectly {
    NSString* expression = @"123";
    NSArray* tokens = @[];
    [OCMStub([self.mockLexicalAnalyzer analyseExpression:OCMOCK_ANY withVariables:OCMOCK_ANY]) andReturn:tokens];
    [OCMStub([self.mockSyntaxAnalyzer analyseExpression:OCMOCK_ANY]) andReturn:tokens];
    [OCMStub([self.mockCalculator prepareExpression:OCMOCK_ANY]) andReturn:tokens];

    [self.parser setExpression:expression];
    
    OCMVerify([self.mockLexicalAnalyzer analyseExpression:expression withVariables:nil]);
    OCMVerify([self.mockSyntaxAnalyzer analyseExpression:tokens]);
    OCMVerify([self.mockCalculator prepareExpression:tokens]);
}

- (void) testThatItEvaluatesCorrectly {
    NSDictionary* varValues = @{@"x": @(123)};
    
    [self.parser evaluateWithVariablesValues:varValues];
    
    OCMVerify([self.mockCalculator evaluateWithVariablesValues:varValues]);
}

#pragma mark - black box
- (void) testParserBlackBoxNumbersOnly {
    self.parser = [[VBMathParser alloc] initWithDefaultAnalyzers];
    
    NSArray* expressions = @[@{@"expr": @"1",   @"res": @(1)},
                             @{@"expr": @"1 + 2",   @"res": @(3)},
                             @{@"expr": @"1 - 2",   @"res": @(-1)},
                             @{@"expr": @"1 * 2",   @"res": @(2)},
                             @{@"expr": @"1 / 2",   @"res": @(0.5)},
                             @{@"expr": @"-1",      @"res": @(-1)},
                             //
                             @{@"expr": @"-2 * 2",  @"res": @(-4)},
                             @{@"expr": @"-2 / 2",  @"res": @(-1)},
                             @{@"expr": @"-2 + 2",  @"res": @(0)},
                             //
                             @{@"expr": @"(2 + 2)", @"res": @(4)},
                             @{@"expr": @"(-2 + 2) * 2",    @"res": @(0)},
                             @{@"expr": @"-(-2 + 1) * 2",   @"res": @(2)},
                             @{@"expr": @"3 + (-2 + 2) * 2",    @"res": @(3)},
                             @{@"expr": @"(1 + 2) (3 - 4)", @"res": @(-3)},
                             @{@"expr": @"(1 + 2) - (3 + 4) * 2",   @"res": @(-11)},
                             @{@"expr": @"(1 + 2) - (3 + 4) * (-2)",    @"res": @(17)},
                             //
                             @{@"expr": @"0.5123124",   @"res": @(0.5123124)},
                             @{@"expr": @"0.123 + 0.321",   @"res": @(0.444)},
                             @{@"expr": @"1/2 + 0.5",   @"res": @(1)},
                             @{@"expr": @"0.99 + 0.01", @"res": @(1)},
                             //
                             @{@"expr": @"0.9 + 1", @"res": @(1.9)},
                             @{@"expr": @"1/2 - 0.25", @"res": @(0.25)},
                             
                             @{@"expr": @"2^2", @"res": @(4)},
                             @{@"expr": @"3^2", @"res": @(9)},
                             @{@"expr": @"3*5^3+2^2", @"res": @(379)},
                             @{@"expr": @"(3*5)^3+2^2", @"res": @(3379)},
                             @{@"expr": @"-(3*5)^3+2^2", @"res": @(-3371)},
                             @{@"expr": @"4^0.5-(3*5)^3+2^2", @"res": @(-3369)},
                             
                             @{@"expr": @"abs(-4)", @"res": @(4)},
                             @{@"expr": @"-1+abs(-4)", @"res": @(3)},
                             @{@"expr": @"2*abs(-4)", @"res": @(8)},
                             @{@"expr": @"2/abs(-4)", @"res": @(0.5)},
                             @{@"expr": @"-abs(-4)-abs(0.5)", @"res": @(-4.5)},
                             @{@"expr": @"abs(-8)/abs(-4)", @"res": @(2)},
                             @{@"expr": @"(-abs(-4)+14)*20+abs(-100)*abs(2)", @"res": @(400)},
                             
                             @{@"expr": @"cos(0)", @"res": @(1)},
                             @{@"expr": @"sin(0)", @"res": @(0)},
                             @{@"expr": @"cos(3)", @"res": @(cos(3))},
                             @{@"expr": @"tan(3)", @"res": @(tan(3))}
                             ];

    [expressions enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.parser setExpression:obj[@"expr"]];
        double result = [self.parser evaluate];
        expect(result).to.equal(obj[@"res"]);
    }];
}

- (void)testParserBlackBoxVars {
    self.parser = [[VBMathParser alloc] initWithDefaultAnalyzers];
    
    NSArray* expressions = @[@{@"expr": @"x",   @"res": @(1)},
                             @{@"expr": @"x + y",   @"res": @(3)},
                             @{@"expr": @"x - y",   @"res": @(-1)},
                             @{@"expr": @"x * y",   @"res": @(2)},
                             @{@"expr": @"x / y",   @"res": @(0.5)},
                             @{@"expr": @"-x",      @"res": @(-1)},
                             //
                             @{@"expr": @"-y * y",  @"res": @(-4)},
                             @{@"expr": @"-y / y",  @"res": @(-1)},
                             @{@"expr": @"-y + y",  @"res": @(0)},
                             //
                             @{@"expr": @"(y + y)", @"res": @(4)},
                             @{@"expr": @"(-y + y) * y",    @"res": @(0)},
                             @{@"expr": @"-(-y + x) * y",   @"res": @(2)},
                             @{@"expr": @"z + (-y + y) * y",    @"res": @(3)},
                             @{@"expr": @"(x + y) (z - t)", @"res": @(-3)},
                             @{@"expr": @"(x + y) - (z + t) * y",   @"res": @(-11)},
                             @{@"expr": @"(x + y) - (z + t) * (-y)",    @"res": @(17)},
                             //
                             @{@"expr": @"0.5123124",   @"res": @(0.5123124)},
                             @{@"expr": @"0.123 + 0.321",   @"res": @(0.444)},
                             @{@"expr": @"x/y + 0.5",   @"res": @(1)},
                             @{@"expr": @"0.99 + 0.01", @"res": @(1)},
                             //
                             @{@"expr": @"0.9 + x", @"res": @(1.9)},
                             @{@"expr": @"x/y - 0.25", @"res": @(0.25)},
                             
                             @{@"expr": @"y^y", @"res": @(4)},
                             @{@"expr": @"z^y", @"res": @(9)},
                             @{@"expr": @"z*5^z+y^y", @"res": @(379)},
                             @{@"expr": @"(z*5)^z+y^y", @"res": @(3379)},
                             @{@"expr": @"-(z*5)^z+y^y", @"res": @(-3371)},
                             @{@"expr": @"t^0.5-(z*5)^z+y^y", @"res": @(-3369)},
                             
                             @{@"expr": @"abs(-t)", @"res": @(4)},
                             @{@"expr": @"-x+abs(-t)", @"res": @(3)},
                             @{@"expr": @"y*abs(-t)", @"res": @(8)},
                             @{@"expr": @"y/abs(-t)", @"res": @(0.5)},
                             @{@"expr": @"-abs(-t)-abs(0.5)", @"res": @(-4.5)},
                             @{@"expr": @"abs(-8)/abs(-t)", @"res": @(2)},
                             @{@"expr": @"(-abs(-t)+14)*20+abs(-100)*abs(y)", @"res": @(400)},
                             
                             @{@"expr": @"cos(0)", @"res": @(1)},
                             @{@"expr": @"sin(0)", @"res": @(0)},
                             @{@"expr": @"cos(z)", @"res": @(cos(3))},
                             @{@"expr": @"tan(z)", @"res": @(tan(3))}
                             ];
    NSArray* vars = @[@"x", @"y", @"z", @"t"];
    [expressions enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.parser setExpression:obj[@"expr"]
                     withVariables:vars];
        double result = [self.parser evaluateWithVariablesValues:@{@"x":  @(1),
                                                                   @"y":  @(2),
                                                                   @"z":  @(3),
                                                                   @"t":  @(4)}];
        expect(result).to.equal(obj[@"res"]);
    }];
}

- (void) testParserBlackBoxConst {
    self.parser = [[VBMathParser alloc] initWithDefaultAnalyzers];
    
    NSArray* expressions = @[@{@"expr": @"pi",   @"res": @(M_PI)},
                             @{@"expr": @"pi + 1",   @"res": @(M_PI + 1)},
                             //
                             @{@"expr": @"cos(pi)", @"res": @(-1)},
                             @{@"expr": @"sin(pi / 2)", @"res": @(1)}
                             ];
    [expressions enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.parser setExpression:obj[@"expr"]];
        double result = [self.parser evaluate];
        expect(result).to.equal(obj[@"res"]);
    }];
}

@end
