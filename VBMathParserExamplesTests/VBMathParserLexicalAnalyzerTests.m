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
#import "VBMathParserTokenVar.h"

#import "VBMathParserTokenOperationAddition.h"
#import "VBMathParserTokenOperationSubstraction.h"
#import "VBMathParserTokenOperationMultiplication.h"
#import "VBMathParserTokenOperationDivision.h"
#import "VBMathParserTokenOperationPower.h"

#import "VBMathParserTokenFunctionAbs.h"
#import "VBMathParserTokenFunctionSin.h"
#import "VBMathParserTokenFunctionCos.h"
#import "VBMathParserTokenFunctionTan.h"

#import "VBMathParserTokenSpecialBracketOpen.h"
#import "VBMathParserTokenSpecialBracketClose.h"

#import "VBMathParserTokenConstPi.h"

#import "VBMathParserVarIsNotStringException.h"
#import "VBMathParserVarIsNotValidException.h"

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
        [strToParse addObject:[NSString stringWithFormat:@"%d", i]];
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
        
        XCTAssert([tokens.lastObject isKindOfClass:[VBMathParserTokenNumber class]],
                  @"parsed wrong class, %@", str);
        
        XCTAssert(((VBMathParserTokenNumber*)tokens.lastObject).doubleValue == str.doubleValue,
                  @"parsed wrong value, str = %@, parsed = %@", str, @(((VBMathParserTokenNumber*)tokens.lastObject).doubleValue));
    }
}

- (void) testOperations
{
    VBMathParserLexicalAnalyzer* lexicalAnalyzer = [VBMathParserLexicalAnalyzer new];

    NSDictionary* parseDict = @{@"+":  [VBMathParserTokenOperationAddition class],
                                @"-":  [VBMathParserTokenOperationSubstraction class],
                                @"/":  [VBMathParserTokenOperationDivision class],
                                @"^":  [VBMathParserTokenOperationPower class]};
    
    for (NSString* key in parseDict.allKeys) {
        NSArray* tokens;
        
        XCTAssertNoThrow(tokens = [lexicalAnalyzer analyseString:key],
                         @"failed to parse operation, %@", key);
        
        XCTAssert(tokens.count == 1,
                  @"parsed more tokens than it should, %@", key);
        
        XCTAssert([tokens.lastObject isKindOfClass:[VBMathParserTokenOperation class]],
                  @"parsed wrong class, %@", key);
        
        XCTAssert([tokens.lastObject class] == parseDict[key],
                  @"parsed wrong operation, str = %@, parsed = %@", key, NSStringFromClass([tokens.lastObject class]));
    }
}

- (void) testSpecials
{
    VBMathParserLexicalAnalyzer* lexicalAnalyzer = [VBMathParserLexicalAnalyzer new];
    
    NSDictionary* parseDict = @{@"(":  [VBMathParserTokenSpecialBracketOpen class],
                                @")":  [VBMathParserTokenSpecialBracketClose class]};
    
    for (NSString* key in parseDict.allKeys) {
        NSArray* tokens;
        
        XCTAssertNoThrow(tokens = [lexicalAnalyzer analyseString:key],
                         @"failed to parse special, %@", key);
        
        XCTAssert(tokens.count == 1,
                  @"parsed more token than it should, %@", key);
        
        XCTAssert([tokens.lastObject isKindOfClass:[VBMathParserTokenSpecial class]],
                  @"parsed wrong class, %@", key);
        
        XCTAssert([tokens.lastObject class] == parseDict[key],
                  @"parsed wrong special, str = %@, parsed = %@", key, NSStringFromClass([tokens.lastObject class]));
    }
}

- (void) testFunctions
{
    VBMathParserLexicalAnalyzer* lexicalAnalyzer = [VBMathParserLexicalAnalyzer new];
    
    NSDictionary* parseDict = @{@"abs":  [VBMathParserTokenFunctionAbs class],
                                @"sin":  [VBMathParserTokenFunctionSin class],
                                @"cos":  [VBMathParserTokenFunctionCos class],
                                @"tan":  [VBMathParserTokenFunctionTan class]};
    
    for (NSString* key in parseDict.allKeys) {
        NSArray* tokens;
        
        XCTAssertNoThrow(tokens = [lexicalAnalyzer analyseString:key],
                         @"failed to parse function, %@", key);
        
        XCTAssert(tokens.count == 1,
                  @"parsed more token than it should, %@", key);
        
        XCTAssert([tokens.lastObject isKindOfClass:[VBMathParserTokenFunction class]],
                  @"parsed wrong class, %@", key);
        
        XCTAssert([tokens.lastObject class] == parseDict[key],
                  @"parsed wrong function, str = %@, parsed = %@", key, NSStringFromClass([tokens.lastObject class]));
    }
}

- (void) testConsts
{
    VBMathParserLexicalAnalyzer* lexicalAnalyzer = [VBMathParserLexicalAnalyzer new];
    
    NSDictionary* parseDict = @{@"pi":  [VBMathParserTokenConstPi class]};
    
    for (NSString* key in parseDict.allKeys) {
        NSArray* tokens;
        
        XCTAssertNoThrow(tokens = [lexicalAnalyzer analyseString:key],
                         @"failed to parse const, %@", key);
        
        XCTAssert(tokens.count == 1,
                  @"parsed more token than it should, %@", key);
        
        XCTAssert([tokens.lastObject isKindOfClass:[VBMathParserTokenConst class]],
                  @"parsed wrong class, %@", key);
        
        XCTAssert([tokens.lastObject class] == parseDict[key],
                  @"parsed wrong const, str = %@, parsed = %@", key, NSStringFromClass([tokens.lastObject class]));
    }
}

- (void) testVars
{
    VBMathParserLexicalAnalyzer* lexicalAnalyzer = [VBMathParserLexicalAnalyzer new];
    
    NSArray* exp = @[@"x", @"x2"];
    
    for (NSString* str in exp) {
        NSArray* tokens;
        
        XCTAssertNoThrow(tokens = [lexicalAnalyzer analyseString:str
                                                        withVars:@[str]],
                            @"failed to parse var, %@", str);
        
        XCTAssert(tokens.count == 1,
                  @"parsed more token than it should, %@", str);
        
        XCTAssert([tokens.lastObject isKindOfClass:[VBMathParserTokenVar class]],
                  @"parsed wrong class, %@", str);
        
        XCTAssert([[tokens.lastObject stringValue] isEqualToString:str],
                  @"parsed wrong special, str = %@, parsed = %@", str, [tokens.lastObject stringValue]);
    }
    
    XCTAssertThrowsSpecific([lexicalAnalyzer analyseString:@"1"
                                                  withVars:@[@(1)]],
                            VBMathParserVarIsNotStringException,
                            @"did not throw VBMathParserVarIsNotStringException");
    
    XCTAssertThrowsSpecific([lexicalAnalyzer analyseString:@"1"
                                                  withVars:@[@"0x"]],
                            VBMathParserVarIsNotValidException,
                            @"did not throw VBMathParserVarIsNotValidException");
}

@end
