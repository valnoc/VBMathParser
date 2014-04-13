//
//  VBMathParserTests.m
//  VBMathParserExamples
//
//  Created by Valeriy Bezuglyy on 3/16/14.
//  Copyright (c) 2014 Valeriy Bezuglyy. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "VBMathParser.h"

@interface VBMathParserTests : XCTestCase

@end

@implementation VBMathParserTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testEvaluation
{
    VBMathParser* parser = [VBMathParser new];

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
                             @{@"expr": @"1/2 - 0.25", @"res": @(0.25)}
                             ];

    for (NSDictionary* entry in expressions) {
        parser.expression = entry[@"expr"];
        double result = [parser evaluate];
        XCTAssert(result == [entry[@"res"] doubleValue], @"Incorrect evaluation result \nexpression: %@\nexpected: %@\nevaluated: %@", parser.expression, entry[@"res"], @(result));
    }
}

@end
