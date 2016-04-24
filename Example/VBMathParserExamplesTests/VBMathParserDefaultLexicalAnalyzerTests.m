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
#import "VBMathParserTokenOperationAddition.h"
#import "VBMathParserTokenOperationSubstraction.h"

@interface VBMathParserDefaultLexicalAnalyzer (tests)

@property (nonatomic, strong) id<VBMathParserTokenFactory> tokenFactory;

@end

@interface VBMathParserDefaultLexicalAnalyzerTests : XCTestCase

@property (nonatomic, strong) VBMathParserDefaultLexicalAnalyzer* lexicalAnalyzer;
//@property (nonatomic, strong) id<VBMathParserTokenFactory> mockTokenFactory;

@end

@implementation VBMathParserDefaultLexicalAnalyzerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
//    self.mockTokenFactory = OCMProtocolMock(@protocol(VBMathParserTokenFactory));

    self.lexicalAnalyzer = [[VBMathParserDefaultLexicalAnalyzer alloc] initWithDefaultTokenFactory];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
//    self.mockTokenFactory = nil;
    
    self.lexicalAnalyzer = nil;
}

- (void) testThatItImplementsLexicalAnalyzerProtocol {
    // This is an example of a functional test case.
    expect(self.lexicalAnalyzer).to.conformTo(@protocol(VBMathParserLexicalAnalyzer));
}

- (void) testThatItUsesGivenFactory {
    // This is an example of a functional test case.
    id<VBMathParserTokenFactory> tokenFactory = OCMProtocolMock(@protocol(VBMathParserTokenFactory));
    self.lexicalAnalyzer = [[VBMathParserDefaultLexicalAnalyzer alloc] initWithTokenFactory:tokenFactory];
    expect(self.lexicalAnalyzer.tokenFactory).to.equal(tokenFactory);
}

- (void) testThatItCreatesDefaultTokenFactory {
    // This is an example of a functional test case.
    expect(self.lexicalAnalyzer.tokenFactory).to.beAnInstanceOf([VBMathParserDefaultTokenFactory class]);
}

#pragma mark - 
- (void) testThatItWorksCorrectlyWithSpaces {
    NSString* expression = @"   0.4   +   9-0.3   ";

    NSArray<VBMathParserToken*>* tokens = [self.lexicalAnalyzer analyseExpression:expression
                                                                    withVariables:nil];
    
    expect(tokens.count).to.equal(5);

    expect(tokens[0]).to.beAnInstanceOf([VBMathParserTokenNumber class]);
    expect(((VBMathParserTokenNumber*)tokens[0]).doubleValue).to.equal(0.4f);
    
    expect(tokens[1]).to.beAnInstanceOf([VBMathParserTokenOperationAddition class]);

    expect(tokens[2]).to.beAnInstanceOf([VBMathParserTokenNumber class]);
    expect(((VBMathParserTokenNumber*)tokens[2]).doubleValue).to.equal(9.0f);
    
    expect(tokens[3]).to.beAnInstanceOf([VBMathParserTokenOperationSubstraction class]);

    expect(tokens[4]).to.beAnInstanceOf([VBMathParserTokenNumber class]);
    expect(((VBMathParserTokenNumber*)tokens[4]).doubleValue).to.equal(0.3f);
}

- (void) testThatItWorksCorrectlyWithCommas {
    NSString* expression = @"0,4+9-0,3";
    
    NSArray<VBMathParserToken*>* tokens = [self.lexicalAnalyzer analyseExpression:expression
                                                                    withVariables:nil];
    
    expect(tokens.count).to.equal(5);
    
    expect(tokens[0]).to.beAnInstanceOf([VBMathParserTokenNumber class]);
    expect(((VBMathParserTokenNumber*)tokens[0]).doubleValue).to.equal(0.4f);
    
    expect(tokens[1]).to.beAnInstanceOf([VBMathParserTokenOperationAddition class]);
    
    expect(tokens[2]).to.beAnInstanceOf([VBMathParserTokenNumber class]);
    expect(((VBMathParserTokenNumber*)tokens[2]).doubleValue).to.equal(9.0f);
    
    expect(tokens[3]).to.beAnInstanceOf([VBMathParserTokenOperationSubstraction class]);
    
    expect(tokens[4]).to.beAnInstanceOf([VBMathParserTokenNumber class]);
    expect(((VBMathParserTokenNumber*)tokens[4]).doubleValue).to.equal(0.3f);
}

@end
