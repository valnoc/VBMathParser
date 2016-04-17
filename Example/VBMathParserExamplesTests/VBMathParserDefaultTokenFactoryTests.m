//
//  VBMathParserDefaultTokenFactoryTests.m
//  VBMathParserExamples
//
//  Created by Valeriy Bezuglyy on 17/04/16.
//  Copyright © 2016 Valeriy Bezuglyy. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>

#import "VBMathParserDefaultTokenFactory.h"

#import "VBMathParserTokenSpecialBracketOpen.h"
#import "VBMathParserTokenSpecialBracketClose.h"

#import "VBMathParserTokenNumber.h"
#import "VBMathParserTokenVar.h"

#import "VBMathParserTokenConstPi.h"

#import "VBMathParserTokenOperationAddition.h"
#import "VBMathParserTokenOperationDivision.h"
#import "VBMathParserTokenOperationMultiplication.h"
#import "VBMathParserTokenOperationPower.h"
#import "VBMathParserTokenOperationSubstraction.h"

#import "VBMathParserTokenFunctionAbs.h"
#import "VBMathParserTokenFunctionCos.h"
#import "VBMathParserTokenFunctionSin.h"
#import "VBMathParserTokenFunctionTan.h"

@interface VBMathParserDefaultTokenFactoryTests : XCTestCase

@property (nonatomic, strong) VBMathParserDefaultTokenFactory* tokenFactory;

@end

@implementation VBMathParserDefaultTokenFactoryTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.tokenFactory = [[VBMathParserDefaultTokenFactory alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    self.tokenFactory = nil;
    
    [super tearDown];
}

- (void) testThatItImplementsFactoryProtocol {
    // This is an example of a functional test case.
    expect(self.tokenFactory).to.conformTo(@protocol(VBMathParserTokenFactory));
}

#pragma mark - special
- (void) testThatItCreatesTokenSpecialBracketOpen {
    VBMathParserToken *token = [self.tokenFactory tokenWithType:[VBMathParserTokenSpecial tokenType]
                                                         string:@"("];
    expect(token).to.beAnInstanceOf([VBMathParserTokenSpecialBracketOpen class]);
}

- (void) testThatItCreatesTokenSpecialBracketClose {
    VBMathParserToken *token = [self.tokenFactory tokenWithType:[VBMathParserTokenSpecial tokenType]
                                                      string:@")"];
    expect(token).to.beAnInstanceOf([VBMathParserTokenSpecialBracketClose class]);
}

#pragma mark - operation
- (void) testThatItCreatesTokenOperationAddition {
    VBMathParserToken *token = [self.tokenFactory tokenWithType:[VBMathParserTokenOperation tokenType]
                                                         string:@"+"];
    expect(token).to.beAnInstanceOf([VBMathParserTokenOperationAddition class]);
}

- (void) testThatItCreatesTokenOperationDivision {
    VBMathParserToken *token = [self.tokenFactory tokenWithType:[VBMathParserTokenOperation tokenType]
                                                         string:@"/"];
    expect(token).to.beAnInstanceOf([VBMathParserTokenOperationDivision class]);
}

- (void) testThatItCreatesTokenOperationMultiplication {
    VBMathParserToken *token = [self.tokenFactory tokenWithType:[VBMathParserTokenOperation tokenType]
                                                         string:@"*"];
    expect(token).to.beAnInstanceOf([VBMathParserTokenOperationMultiplication class]);
}

- (void) testThatItCreatesTokenOperationPower {
    VBMathParserToken *token = [self.tokenFactory tokenWithType:[VBMathParserTokenOperation tokenType]
                                                         string:@"^"];
    expect(token).to.beAnInstanceOf([VBMathParserTokenOperationPower class]);
}

- (void) testThatItCreatesTokenOperationSubstraction {
    VBMathParserToken *token = [self.tokenFactory tokenWithType:[VBMathParserTokenOperation tokenType]
                                                         string:@"-"];
    expect(token).to.beAnInstanceOf([VBMathParserTokenOperationSubstraction class]);
}

#pragma mark - function
- (void) testThatItCreatesTokenFunctionAbs {
    VBMathParserToken *token = [self.tokenFactory tokenWithType:[VBMathParserTokenFunction tokenType]
                                                         string:@"abs"];
    expect(token).to.beAnInstanceOf([VBMathParserTokenFunctionAbs class]);
}

- (void) testThatItCreatesTokenFunctionCos {
    VBMathParserToken *token = [self.tokenFactory tokenWithType:[VBMathParserTokenFunction tokenType]
                                                         string:@"cos"];
    expect(token).to.beAnInstanceOf([VBMathParserTokenFunctionCos class]);
}

- (void) testThatItCreatesTokenFunctionSin {
    VBMathParserToken *token = [self.tokenFactory tokenWithType:[VBMathParserTokenFunction tokenType]
                                                         string:@"sin"];
    expect(token).to.beAnInstanceOf([VBMathParserTokenFunctionSin class]);
}

- (void) testThatItCreatesTokenFunctionTan {
    VBMathParserToken *token = [self.tokenFactory tokenWithType:[VBMathParserTokenFunction tokenType]
                                                         string:@"tan"];
    expect(token).to.beAnInstanceOf([VBMathParserTokenFunctionTan class]);
}

#pragma mark - const
- (void) testThatItCreatesTokenConstPi {
    VBMathParserToken *token = [self.tokenFactory tokenWithType:[VBMathParserTokenFunction tokenType]
                                                         string:@"pi"];
    expect(token).to.beAnInstanceOf([VBMathParserTokenConstPi class]);
}

#pragma mark - number
- (void) testThatItCreatesTokenNumber {
    NSMutableArray* strToParse = [NSMutableArray new];
    for (NSInteger i = 0; i < 10; i++) {
        [strToParse addObject:@(i).stringValue];
    }
    [strToParse addObject:@"100500"];
    [strToParse addObject:@"8001212"];
    [strToParse addObject:@"0.0123"];
    [strToParse addObject:@" 1.97         "];
    [strToParse addObject:@" 2.         "];
    [strToParse addObject:@"0."];
    
    [strToParse enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        VBMathParserToken *token = [self.tokenFactory tokenWithType:[VBMathParserTokenNumber tokenType]
                                                             string:obj];
        expect(token).to.beAnInstanceOf([VBMathParserTokenNumber class]);
        expect(((VBMathParserTokenNumber*)token).doubleValue).to.equal([obj doubleValue]);
    }];
}

@end
