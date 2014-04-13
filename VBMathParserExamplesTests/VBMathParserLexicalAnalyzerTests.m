//
//  VBMathParserLexicalAnalyzerTests.m
//  VBMathExamples
//
//  Created by Valeriy Bezuglyy on 2/22/14.
//  Copyright (c) 2014 Valeriy Bezuglyy. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "VBMathParserLexicalAnalyzer.h"

#import "VBMathParserTokenNumber.h"
#import "VBMathParserTokenOperation.h"
#import "VBMathParserTokenSpecial.h"

@interface VBMathParserLexicalAnalyzerTests : XCTestCase

@end

@implementation VBMathParserLexicalAnalyzerTests

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

- (void)testNumbers
{
    VBMathParserLexicalAnalyzer* lexicalAnalyzer = [VBMathParserLexicalAnalyzer new];
#warning check long long
    NSMutableArray* strToParse = [NSMutableArray new];
    for (NSInteger i = 0; i < 10; i++) {
        [strToParse addObject:[NSString stringWithFormat:@"%ld", i]];
    }
    [strToParse addObject:@"100500"];
    [strToParse addObject:@"8001212"];
    [strToParse addObject:@"0.0123"];
    [strToParse addObject:@" 1.97         "];
    [strToParse addObject:@" 2.         "];
    [strToParse addObject:@"0."];
    
    for (NSString* str in strToParse) {
        NSArray* tokens;
        
        XCTAssertNoThrow(tokens = [lexicalAnalyzer analyseString:str],
                         @"failed to parse number, %@", str);

        XCTAssert(tokens.count == 1,
                  @"parsed more token than it should, %@", str);
        
        XCTAssert([tokens.lastObject class] == [VBMathParserTokenNumber class],
                  @"parsed wrong class, %@", str);
        
        XCTAssert(((VBMathParserTokenNumber*)tokens.lastObject).doubleValue == str.doubleValue,
                  @"parsed wrong value, str = %@, parsed = %@", str, @(((VBMathParserTokenNumber*)tokens.lastObject).doubleValue));
    }
}

- (void) testOperations
{
    VBMathParserLexicalAnalyzer* lexicalAnalyzer = [VBMathParserLexicalAnalyzer new];

    NSMutableArray* strToParse = [NSMutableArray new];
    [strToParse addObject:@[@"+",
                            @(VBTokenOperationAddition)]];
    [strToParse addObject:@[@"-",
                            @(VBTokenOperationSubstraction)]];
    [strToParse addObject:@[@"*",
                            @(VBTokenOperationMultiplication)]];
    [strToParse addObject:@[@"/",
                            @(VBTokenOperationDivision)]];
    
    for (NSArray* arr in strToParse) {
        NSString* str = arr[0];
        NSArray* tokens;
        
        XCTAssertNoThrow(tokens = [lexicalAnalyzer analyseString:str],
                         @"failed to parse operation, %@", str);
        
        XCTAssert(tokens.count == 1,
                  @"parsed more token than it should, %@", str);
        
        XCTAssert([tokens.lastObject class] == [VBMathParserTokenOperation class],
                  @"parsed wrong class, %@", str);
        
        XCTAssert(((VBMathParserTokenOperation*)tokens.lastObject).tokenOperation == [arr[1] integerValue],
                  @"parsed wrong operation, str = %@, parsed = %@", str, @(((VBMathParserTokenOperation*)tokens.lastObject).tokenOperation));
    }
}

- (void) testSpecials
{
    VBMathParserLexicalAnalyzer* lexicalAnalyzer = [VBMathParserLexicalAnalyzer new];
    
    NSMutableArray* strToParse = [NSMutableArray new];
    [strToParse addObject:@[@"(",
                            @(VBTokenSpecialBracketOpen)]];
    [strToParse addObject:@[@")",
                            @(VBTokenSpecialBracketClose)]];
    
    for (NSArray* arr in strToParse) {
        NSString* str = arr[0];
        NSArray* tokens;
        
        XCTAssertNoThrow(tokens = [lexicalAnalyzer analyseString:str],
                         @"failed to parse special, %@", str);
        
        XCTAssert(tokens.count == 1,
                  @"parsed more token than it should, %@", str);
        
        XCTAssert([tokens.lastObject class] == [VBMathParserTokenSpecial class],
                  @"parsed wrong class, %@", str);
        
        XCTAssert(((VBMathParserTokenSpecial*)tokens.lastObject).tokenSpecial == [arr[1] integerValue],
                  @"parsed wrong special, str = %@, parsed = %@", str, @(((VBMathParserTokenSpecial*)tokens.lastObject).tokenSpecial));
    }
}

@end
