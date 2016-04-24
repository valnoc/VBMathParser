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

#import "VBMathParserTokenNumber.h"

#define kBracketOpen [VBMathParserTokenSpecialBracketOpen new]
#define kBracketClose [VBMathParserTokenSpecialBracketClose new]

#define kNumber1 [VBMathParserTokenNumber tokenWithString:@"1"]

#define kOperation [VBMathParserTokenOperation new]
#define kOperationAdd [VBMathParserTokenOperationAddition new]
#define kOperationSub [VBMathParserTokenOperationSubstraction new]

@interface VBMathParserDefaultSyntaxAnalyzerTests : XCTestCase

@property (nonatomic, strong) VBMathParserDefaultSyntaxAnalyzer* syntaxAnalyzer;


@end

@implementation VBMathParserDefaultSyntaxAnalyzerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
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
    NSArray* tokens = @[kBracketOpen,
                        kBracketOpen,
                        kNumber1,
                        kBracketClose,
                        kBracketClose];

    XCTAssertNoThrow([self.syntaxAnalyzer analyseExpression:tokens]);
}

- (void) testThatItThrowsBracketNotClosedException {
    NSArray* tokens = @[kBracketOpen,
                        kBracketOpen,
                        kNumber1,
                        kBracketClose];
    
    XCTAssertThrowsSpecific([self.syntaxAnalyzer analyseExpression:tokens],
                            VBMathParserBracketNotClosedException);
}

- (void) testThatItThrowsBracketNotOpennedException {
    NSArray* tokens = @[kBracketOpen,
                        kNumber1,
                        kBracketClose,
                        kBracketClose];
    
    XCTAssertThrowsSpecific([self.syntaxAnalyzer analyseExpression:tokens],
                            VBMathParserBracketNotOpenedException);
}

#pragma mark - missing tokens
- (void) testThatItThrowsTokenMissingExceptionWhenOperationsOneByOne {
    NSArray* tokens = @[kNumber1,
                        kOperationAdd,
                        kOperationAdd,
                        kNumber1];
    
    XCTAssertThrowsSpecific([self.syntaxAnalyzer analyseExpression:tokens],
                            VBMathParserMissingTokenException);
}

- (void) testThatItThrowsTokenMissingExceptionWhenBracketsWithoutNumber {
    NSArray* tokens = @[kBracketOpen,
                        kBracketClose];
    
    XCTAssertThrowsSpecific([self.syntaxAnalyzer analyseExpression:tokens],
                            VBMathParserMissingTokenException);
}

- (void) testThatItThrowsTokenMissingExceptionWhenBeginsWithOperationAfterBracket {
    NSArray* tokens = @[kBracketOpen,
                        kOperation,
                        kNumber1,
                        kBracketClose];
    
    XCTAssertThrowsSpecific([self.syntaxAnalyzer analyseExpression:tokens],
                            VBMathParserMissingTokenException);
}

- (void) testThatItDoesntThrowExceptionWhenBeginsWithUnaryMinusAfterBracket {
    NSArray* tokens = @[kBracketOpen,
                        kOperationSub,
                        kNumber1,
                        kBracketClose];
    
    XCTAssertNoThrow([self.syntaxAnalyzer analyseExpression:tokens]);
}

- (void) testThatItThrowsTokenMissingExceptionWhenBeginsWithOperation {
    NSArray* tokens = @[kOperation,
                        kNumber1];
    
    XCTAssertThrowsSpecific([self.syntaxAnalyzer analyseExpression:tokens],
                            VBMathParserMissingTokenException);
}

- (void) testThatItDoesntThrowExceptionWhenBeginsWithUnaryMinus {
    NSArray* tokens = @[kOperationSub,
                        kNumber1];
    
    XCTAssertNoThrow([self.syntaxAnalyzer analyseExpression:tokens]);
}

- (void) testThatItThrowsTokenMissingExceptionWhenEndsWithOperationBeforeBracket {
    NSArray* tokens = @[kBracketOpen,
                        kNumber1,
                        kOperation,
                        kBracketClose];
    
    XCTAssertThrowsSpecific([self.syntaxAnalyzer analyseExpression:tokens],
                            VBMathParserMissingTokenException);
}

- (void) testThatItThrowsTokenMissingExceptionWhenEndsWithOperation {
    NSArray* tokens = @[kNumber1,
                        kOperation];
    
    XCTAssertThrowsSpecific([self.syntaxAnalyzer analyseExpression:tokens],
                            VBMathParserMissingTokenException);
}

@end
