//
//  VBMathParserDefaultSyntaxAnalyzerTests.m
//  VBMathParserExamples
//
//  Created by Valeriy Bezuglyy on 24/04/16.
//  Copyright © 2016 Valeriy Bezuglyy. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>

#import "VBMathParserDefaultSyntaxAnalyzer.h"

#import "VBMathParserBracketNotClosedException.h"
#import "VBMathParserBracketNotOpenedException.h"

#import "VBMathParserMissingTokenException.h"

#import "VBMathParserTokenSpecialBracketOpen.h"
#import "VBMathParserTokenSpecialBracketClose.h"

#import "VBMathParserTokenOperationAddition.h"
#import "VBMathParserTokenOperationSubstraction.h"
#import "VBMathParserTokenOperationMultiplication.h"

#import "VBMathParserTokenNumber.h"
#import "VBMathParserTokenConst.h"
#import "VBMathParserTokenVar.h"

#import "VBMathParserTokenFunction.h"

@interface VBMathParserDefaultSyntaxAnalyzerTests : XCTestCase

@property (nonatomic, strong) VBMathParserDefaultSyntaxAnalyzer* syntaxAnalyzer;

@property (nonatomic, strong) id mockTokenBracketOpen;
@property (nonatomic, strong) id mockTokenBracketClose;

@property (nonatomic, strong) id mockTokenNumber1;
@property (nonatomic, strong) id mockTokenConst;
@property (nonatomic, strong) id mockTokenVar;

@property (nonatomic, strong) id mockTokenOperation;
@property (nonatomic, strong) id mockTokenOperationAdd;
@property (nonatomic, strong) id mockTokenOperationSub;

@property (nonatomic, strong) id mockTokenFunction;

@end

@implementation VBMathParserDefaultSyntaxAnalyzerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.mockTokenBracketOpen = OCMClassMock([VBMathParserTokenSpecialBracketOpen class]);
    self.mockTokenBracketClose = OCMClassMock([VBMathParserTokenSpecialBracketClose class]);
    
    self.mockTokenNumber1 = OCMClassMock([VBMathParserTokenNumber class]);
    self.mockTokenConst = OCMClassMock([VBMathParserTokenConst class]);
    self.mockTokenVar = OCMClassMock([VBMathParserTokenVar class]);
    
    self.mockTokenOperation = OCMClassMock([VBMathParserTokenOperation class]);
    self.mockTokenOperationAdd = OCMClassMock([VBMathParserTokenOperationAddition class]);
    self.mockTokenOperationSub = OCMClassMock([VBMathParserTokenOperationSubstraction class]);
    
    self.mockTokenFunction = OCMClassMock([VBMathParserTokenFunction class]);
    
    self.syntaxAnalyzer = [VBMathParserDefaultSyntaxAnalyzer new];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    self.syntaxAnalyzer = nil;
    
    [super tearDown];
}

- (void) testThatItImplementsSyntaxAnalyzerProtocol {
    expect(self.syntaxAnalyzer).to.conformTo(@protocol(VBMathParserSyntaxAnalyzer));
}

#pragma mark - brackets
- (void) testThatItCountsBracketsCorrectly {
    NSArray* tokens = @[self.mockTokenBracketOpen,
                        self.mockTokenBracketOpen,
                        self.mockTokenNumber1,
                        self.mockTokenBracketClose,
                        self.mockTokenBracketClose];

    XCTAssertNoThrow([self.syntaxAnalyzer analyseExpression:tokens]);
}

- (void) testThatItThrowsBracketNotClosedException {
    NSArray* tokens = @[self.mockTokenBracketOpen,
                        self.mockTokenBracketOpen,
                        self.mockTokenNumber1,
                        self.mockTokenBracketClose];
    
    XCTAssertThrowsSpecific([self.syntaxAnalyzer analyseExpression:tokens],
                            VBMathParserBracketNotClosedException);
}

- (void) testThatItThrowsBracketNotOpennedException {
    NSArray* tokens = @[self.mockTokenBracketOpen,
                        self.mockTokenNumber1,
                        self.mockTokenBracketClose,
                        self.mockTokenBracketClose];
    
    XCTAssertThrowsSpecific([self.syntaxAnalyzer analyseExpression:tokens],
                            VBMathParserBracketNotOpenedException);
}

#pragma mark - missing tokens
#pragma mark 1++1
- (void) testThatItThrowsTokenMissingExceptionWhenOperationsOneByOne {
    NSArray* tokens = @[self.mockTokenNumber1,
                        self.mockTokenOperationAdd,
                        self.mockTokenOperationAdd,
                        self.mockTokenNumber1];
    
    XCTAssertThrowsSpecific([self.syntaxAnalyzer analyseExpression:tokens],
                            VBMathParserMissingTokenException);
}

- (void) testThatItDoesntThrowExceptionWhenNoOperationsOneByOne {
    NSArray* tokens = @[self.mockTokenNumber1,
                        self.mockTokenOperationAdd,
                        self.mockTokenNumber1,
                        self.mockTokenOperationAdd,
                        self.mockTokenNumber1];
    
    XCTAssertNoThrow([self.syntaxAnalyzer analyseExpression:tokens]);
}

#pragma mark ()
- (void) testThatItThrowsTokenMissingExceptionWhenBracketsWithoutNumber {
    NSArray* tokens = @[self.mockTokenBracketOpen,
                        self.mockTokenBracketClose];
    
    XCTAssertThrowsSpecific([self.syntaxAnalyzer analyseExpression:tokens],
                            VBMathParserMissingTokenException);
}

- (void) testThatItDoesntThrowsExceptionWhenNumberInsideBrackets {
    NSArray* tokens = @[self.mockTokenBracketOpen,
                        self.mockTokenNumber1,
                        self.mockTokenBracketClose];
    
    XCTAssertNoThrow([self.syntaxAnalyzer analyseExpression:tokens]);
}

#pragma mark (+1
- (void) testThatItThrowsTokenMissingExceptionWhenBeginsWithOperationAfterBracket {
    NSArray* tokens = @[self.mockTokenBracketOpen,
                        self.mockTokenOperation,
                        self.mockTokenNumber1,
                        self.mockTokenBracketClose];
    
    XCTAssertThrowsSpecific([self.syntaxAnalyzer analyseExpression:tokens],
                            VBMathParserMissingTokenException);
}

- (void) testThatItDoesntThrowExceptionWhenBeginsWithUnaryMinusAfterBracket {
    NSArray* tokens = @[self.mockTokenBracketOpen,
                        self.mockTokenOperationSub,
                        self.mockTokenNumber1,
                        self.mockTokenBracketClose];
    
    XCTAssertNoThrow([self.syntaxAnalyzer analyseExpression:tokens]);
}

#pragma mark +1
- (void) testThatItThrowsTokenMissingExceptionWhenBeginsWithOperation {
    NSArray* tokens = @[self.mockTokenOperation,
                        self.mockTokenNumber1];
    
    XCTAssertThrowsSpecific([self.syntaxAnalyzer analyseExpression:tokens],
                            VBMathParserMissingTokenException);
}

- (void) testThatItDoesntThrowExceptionWhenBeginsWithUnaryMinus {
    NSArray* tokens = @[self.mockTokenOperationSub,
                        self.mockTokenNumber1];
    
    XCTAssertNoThrow([self.syntaxAnalyzer analyseExpression:tokens]);
}

#pragma mark 1+)
- (void) testThatItThrowsTokenMissingExceptionWhenEndsWithOperationBeforeBracket {
    NSArray* tokens = @[self.mockTokenBracketOpen,
                        self.mockTokenNumber1,
                        self.mockTokenOperation,
                        self.mockTokenBracketClose];
    
    XCTAssertThrowsSpecific([self.syntaxAnalyzer analyseExpression:tokens],
                            VBMathParserMissingTokenException);
}

#pragma mark 1+
- (void) testThatItThrowsTokenMissingExceptionWhenEndsWithOperation {
    NSArray* tokens = @[self.mockTokenNumber1,
                        self.mockTokenOperation];
    
    XCTAssertThrowsSpecific([self.syntaxAnalyzer analyseExpression:tokens],
                            VBMathParserMissingTokenException);
}

#pragma mark abs1
- (void) testThatItThrowsTokenMissingExceptionWhenNoBracketAfterFunction {
    NSArray* tokens = @[self.mockTokenFunction,
                        self.mockTokenNumber1];
    
    XCTAssertThrowsSpecific([self.syntaxAnalyzer analyseExpression:tokens],
                            VBMathParserMissingTokenException);
}

- (void) testThatItDoesntThrowExceptionWhenBracketAfterFunction {
    NSArray* tokens = @[self.mockTokenFunction,
                        self.mockTokenBracketOpen,
                        self.mockTokenNumber1,
                        self.mockTokenBracketClose];
    
    XCTAssertNoThrow([self.syntaxAnalyzer analyseExpression:tokens]);
}

#pragma mark ^+$, ^abs$
- (void) testThatItThrowsTokenMissingExceptionWhenOnlyOperation {
    NSArray* tokens = @[self.mockTokenOperation];
    
    XCTAssertThrowsSpecific([self.syntaxAnalyzer analyseExpression:tokens],
                            VBMathParserMissingTokenException);
}

- (void) testThatItThrowsTokenMissingExceptionWhenOnlyFunction {
    NSArray* tokens = @[self.mockTokenFunction];
    
    XCTAssertThrowsSpecific([self.syntaxAnalyzer analyseExpression:tokens],
                            VBMathParserMissingTokenException);
}

#pragma mark - insert suppressed multiplication
#pragma mark ()() -> ()*()
- (void) testThatItAddsMissingMultiplicationBetweenBrackets {
    NSArray* tokens = @[self.mockTokenBracketOpen,
                        self.mockTokenNumber1,
                        self.mockTokenBracketClose,
                        self.mockTokenBracketOpen,
                        self.mockTokenNumber1,
                        self.mockTokenBracketClose];
    
    tokens = [self.syntaxAnalyzer analyseExpression:tokens];
    
    expect(tokens.count).to.equal(7);
    expect(tokens[3]).to.beAnInstanceOf([VBMathParserTokenOperationMultiplication class]);
}

#pragma mark 2() -> 2*()
- (void) testThatItAddsMissingMultiplicationAfterNumber {
    NSArray* tokens = @[self.mockTokenNumber1,
                        self.mockTokenBracketOpen,
                        self.mockTokenNumber1,
                        self.mockTokenBracketClose];
    
    tokens = [self.syntaxAnalyzer analyseExpression:tokens];
    
    expect(tokens.count).to.equal(5);
    expect(tokens[1]).to.beAnInstanceOf([VBMathParserTokenOperationMultiplication class]);
}

- (void) testThatItAddsMissingMultiplicationAfterConst {
    NSArray* tokens = @[self.mockTokenConst,
                        self.mockTokenBracketOpen,
                        self.mockTokenNumber1,
                        self.mockTokenBracketClose];
    
    tokens = [self.syntaxAnalyzer analyseExpression:tokens];
    
    expect(tokens.count).to.equal(5);
    expect(tokens[1]).to.beAnInstanceOf([VBMathParserTokenOperationMultiplication class]);
}

- (void) testThatItAddsMissingMultiplicationAfterVar {
    NSArray* tokens = @[self.mockTokenVar,
                        self.mockTokenBracketOpen,
                        self.mockTokenNumber1,
                        self.mockTokenBracketClose];
    
    tokens = [self.syntaxAnalyzer analyseExpression:tokens];
    
    expect(tokens.count).to.equal(5);
    expect(tokens[1]).to.beAnInstanceOf([VBMathParserTokenOperationMultiplication class]);
}

#pragma mark - unary minus
#pragma mark -1 -> 0-1
- (void) testThatItAddsZeroForUnaryMinusBeforeNumber {
    NSArray* tokens = @[self.mockTokenOperationSub,
                        self.mockTokenNumber1];
    
    tokens = [self.syntaxAnalyzer analyseExpression:tokens];
    
    expect(tokens.count).to.equal(3);
    expect(tokens[0]).to.beAnInstanceOf([VBMathParserTokenNumber class]);
    expect([tokens[0] doubleValue]).to.equal(0);
}

- (void) testThatItAddsZeroForUnaryMinusBeforeConst {
    NSArray* tokens = @[self.mockTokenOperationSub,
                        self.mockTokenConst];
    
    tokens = [self.syntaxAnalyzer analyseExpression:tokens];
    
    expect(tokens.count).to.equal(3);
    expect(tokens[0]).to.beAnInstanceOf([VBMathParserTokenNumber class]);
    expect([tokens[0] doubleValue]).to.equal(0);
}

- (void) testThatItAddsZeroForUnaryMinusBeforeVar {
    NSArray* tokens = @[self.mockTokenOperationSub,
                        self.mockTokenVar];
    
    tokens = [self.syntaxAnalyzer analyseExpression:tokens];
    
    expect(tokens.count).to.equal(3);
    expect(tokens[0]).to.beAnInstanceOf([VBMathParserTokenNumber class]);
    expect([tokens[0] doubleValue]).to.equal(0);
}

#pragma mark (-1 -> (0-1
- (void) testThatItAddsZeroForUnaryMinusAfterBracketBeforeNumber {
    NSArray* tokens = @[self.mockTokenBracketOpen,
                        self.mockTokenOperationSub,
                        self.mockTokenNumber1,
                        self.mockTokenBracketClose];
    
    tokens = [self.syntaxAnalyzer analyseExpression:tokens];
    
    expect(tokens.count).to.equal(5);
    expect(tokens[1]).to.beAnInstanceOf([VBMathParserTokenNumber class]);
    expect([tokens[1] doubleValue]).to.equal(0);
}

- (void) testThatItAddsZeroForUnaryMinusAfterBracketBeforeConst {
    NSArray* tokens = @[self.mockTokenBracketOpen,
                        self.mockTokenOperationSub,
                        self.mockTokenConst,
                        self.mockTokenBracketClose];
    
    tokens = [self.syntaxAnalyzer analyseExpression:tokens];
    
    expect(tokens.count).to.equal(5);
    expect(tokens[1]).to.beAnInstanceOf([VBMathParserTokenNumber class]);
    expect([tokens[1] doubleValue]).to.equal(0);
}

- (void) testThatItAddsZeroForUnaryMinusAfterBracketBeforeVar {
    NSArray* tokens = @[self.mockTokenBracketOpen,
                        self.mockTokenOperationSub,
                        self.mockTokenVar,
                        self.mockTokenBracketClose];
    
    tokens = [self.syntaxAnalyzer analyseExpression:tokens];
    
    expect(tokens.count).to.equal(5);
    expect(tokens[1]).to.beAnInstanceOf([VBMathParserTokenNumber class]);
    expect([tokens[1] doubleValue]).to.equal(0);
}

@end
