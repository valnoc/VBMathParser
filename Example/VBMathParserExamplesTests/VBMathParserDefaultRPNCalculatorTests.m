//
//  VBMathParserDefaultRPNCalculatorTests.m
//  VBMathParserExamples
//
//  Created by Valeriy Bezuglyy on 24/04/16.
//  Copyright © 2016 Valeriy Bezuglyy. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>

#import "VBMathParserDefaultRPNCalculator.h"

@interface VBMathParserDefaultRPNCalculatorTests : XCTestCase

@property (nonatomic, strong) VBMathParserDefaultRPNCalculator* calculator;

@end

@implementation VBMathParserDefaultRPNCalculatorTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.calculator = [[VBMathParserDefaultRPNCalculator alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    
    self.calculator = nil;
    
    [super tearDown];
}

- (void) testThatItImplementsCalculatorProtocol {
    expect(self.calculator).to.conformTo(@protocol(VBMathParserCalculator));
}

#pragma mark - 

#warning TODO add tests

@end
