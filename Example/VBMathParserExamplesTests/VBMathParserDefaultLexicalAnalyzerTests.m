//
//  VBMathParserDefaultLexicalAnalyzerTests.m
//  VBMathParserExamples
//
//  Created by Valeriy Bezuglyy on 17/04/16.
//  Copyright © 2016 Valeriy Bezuglyy. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>

#import "VBMathParserDefaultLexicalAnalyzer.h"
#import "VBMathParserDefaultTokenFactory.h"

#import "VBMathParserTokenNumber.h"

#import "VBMathParserUnknownTokenException.h"
#import "VBMathParserVarIsNotStringException.h"
#import "VBMathParserVarIsNotValidException.h"

@interface VBMathParserDefaultLexicalAnalyzer (tests)

@property (nonatomic, strong) id<VBMathParserTokenFactory> tokenFactory;

@end

@interface VBMathParserDefaultLexicalAnalyzerTests : XCTestCase

@property (nonatomic, strong) VBMathParserDefaultLexicalAnalyzer* lexicalAnalyzer;
@property (nonatomic, strong) id<VBMathParserTokenFactory> mockTokenFactory;

@end

@implementation VBMathParserDefaultLexicalAnalyzerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.mockTokenFactory = OCMProtocolMock(@protocol(VBMathParserTokenFactory));

    self.lexicalAnalyzer = [[VBMathParserDefaultLexicalAnalyzer alloc] initWithTokenFactory:self.mockTokenFactory];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    self.mockTokenFactory = nil;
    
    self.lexicalAnalyzer = nil;
    
    [super tearDown];
}

- (void) testThatItImplementsLexicalAnalyzerProtocol {
    // This is an example of a functional test case.
    expect(self.lexicalAnalyzer).to.conformTo(@protocol(VBMathParserLexicalAnalyzer));
}

- (void) testThatItUsesGivenFactory {
    // This is an example of a functional test case.
    expect(self.lexicalAnalyzer.tokenFactory).to.equal(self.mockTokenFactory);
}

- (void) testThatItCreatesDefaultTokenFactory {
    // This is an example of a functional test case.
    self.lexicalAnalyzer = [[VBMathParserDefaultLexicalAnalyzer alloc] initWithDefaultTokenFactory];
    expect(self.lexicalAnalyzer.tokenFactory).to.beAnInstanceOf([VBMathParserDefaultTokenFactory class]);
}

#pragma mark - 
- (void) testThatItWorksCorrectlyWithSpaces {
    NSString* expression = @"   0.4   ";

    VBMathParserTokenNumber* token = [VBMathParserTokenNumber tokenWithString:@"0.4"];
    [OCMStub([self.mockTokenFactory tokenWithType:OCMOCK_ANY string:OCMOCK_ANY]) andReturn:token];
    
    [self.lexicalAnalyzer analyseExpression:expression
                              withVariables:nil];

    OCMVerify([self.mockTokenFactory tokenWithType:[VBMathParserTokenNumber tokenType]
                                            string:@"0.4"]);
}

- (void) testThatItWorksCorrectlyWithCommas {
    NSString* expression = @"0,4";
    
    VBMathParserTokenNumber* token = [VBMathParserTokenNumber tokenWithString:@"0.4"];
    [OCMStub([self.mockTokenFactory tokenWithType:OCMOCK_ANY string:OCMOCK_ANY]) andReturn:token];
    
    [self.lexicalAnalyzer analyseExpression:expression
                              withVariables:nil];
    
    OCMVerify([self.mockTokenFactory tokenWithType:[VBMathParserTokenNumber tokenType]
                                            string:@"0.4"]);
}

- (void) testThatItThrowsUnknowknTokenException {
    NSString* expression = @"0.4";
    
    [OCMStub([self.mockTokenFactory tokenWithType:OCMOCK_ANY string:OCMOCK_ANY]) andReturn:nil];

    XCTAssertThrowsSpecific([self.lexicalAnalyzer analyseExpression:expression
                                                      withVariables:nil],
                            VBMathParserUnknownTokenException);
}

- (void) testThatItAcceptsCorrectVars {
    NSString* expression = @"0.4";
    NSArray* vars = @[@"x"];
    
    VBMathParserTokenNumber* token = [VBMathParserTokenNumber tokenWithString:@"0.4"];
    [OCMStub([self.mockTokenFactory tokenWithType:OCMOCK_ANY string:OCMOCK_ANY]) andReturn:token];
    
    XCTAssertNoThrow([self.lexicalAnalyzer analyseExpression:expression
                                                      withVariables:vars]);
}

- (void) testThatItThrowsVarIsNotStringException {
    NSString* expression = @"0.4";
    NSArray* vars = @[@"x", @(1)];
    
    XCTAssertThrowsSpecific([self.lexicalAnalyzer analyseExpression:expression
                                                      withVariables:vars],
                            VBMathParserVarIsNotStringException);
}

- (void) testThatItThrowsVarIsNotValidException {
    NSString* expression = @"0.4";
    NSArray* vars = @[@"x", @"1x"];
    
    XCTAssertThrowsSpecific([self.lexicalAnalyzer analyseExpression:expression
                                                      withVariables:vars],
                            VBMathParserVarIsNotValidException);
}

@end
