//
//  VBMathParserSyntaxAnalyzer.m
//  VBMathExamples
//
//  Created by Valeriy Bezuglyy on 3/1/14.
//  Copyright (c) 2014 Valeriy Bezuglyy. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "VBMathParserLexicalAnalyzer.h"
#import "VBMathParserSyntaxAnalyzer.h"

#import "VBMathParserBracketNotClosedException.h"
#import "VBMathParserBracketNotOpenedException.h"
#import "VBMathParserMissingTokenException.h"

@interface VBMathParserSyntaxAnalyzerTests : XCTestCase

@end

@implementation VBMathParserSyntaxAnalyzerTests

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

- (void)testBrackets
{
    VBMathParserLexicalAnalyzer* lexicalAnalyzer = [VBMathParserLexicalAnalyzer new];
    VBMathParserSyntaxAnalyzer* syntaxAnalyzer = [VBMathParserSyntaxAnalyzer new];
    
    NSArray* tokens = [lexicalAnalyzer analyseString:@"(1 + 1)"];
    XCTAssertNoThrow([syntaxAnalyzer analyseTokens:tokens], @"brackets");
    
    tokens = [lexicalAnalyzer analyseString:@"(1 + 1"];
    XCTAssertThrowsSpecific([syntaxAnalyzer analyseTokens:tokens], VBMathParserBracketNotClosedException, @"bracket not closed");
    
    tokens = [lexicalAnalyzer analyseString:@"1 + 1)"];
    XCTAssertThrowsSpecific([syntaxAnalyzer analyseTokens:tokens], VBMathParserBracketNotOpenedException, @"bracket not opened");
}

- (void) testMissingArgs {
    VBMathParserLexicalAnalyzer* lexicalAnalyzer = [VBMathParserLexicalAnalyzer new];
    VBMathParserSyntaxAnalyzer* syntaxAnalyzer = [VBMathParserSyntaxAnalyzer new];
    
    NSArray* tokens = [lexicalAnalyzer analyseString:@"1 + "];
    XCTAssertThrowsSpecific([syntaxAnalyzer analyseTokens:tokens], VBMathParserMissingTokenException, @"missing arg in operation");
}

- (void) testFunctions {
    VBMathParserLexicalAnalyzer* lexicalAnalyzer = [VBMathParserLexicalAnalyzer new];
    VBMathParserSyntaxAnalyzer* syntaxAnalyzer = [VBMathParserSyntaxAnalyzer new];
    
    NSArray* tokens = [lexicalAnalyzer analyseString:@"abs"];
    XCTAssertThrowsSpecific([syntaxAnalyzer analyseTokens:tokens], VBMathParserMissingTokenException, @"missing arg of function");
    
    tokens = [lexicalAnalyzer analyseString:@"abs3+5"];
    XCTAssertThrowsSpecific([syntaxAnalyzer analyseTokens:tokens], VBMathParserMissingTokenException, @"missing brackets for args");
    
    tokens = [lexicalAnalyzer analyseString:@"abs(3)"];
    XCTAssertNoThrow([syntaxAnalyzer analyseTokens:tokens], @"everything should be ok");
}

- (void)testVars
{
    VBMathParserLexicalAnalyzer* lexicalAnalyzer = [VBMathParserLexicalAnalyzer new];
    VBMathParserSyntaxAnalyzer* syntaxAnalyzer = [VBMathParserSyntaxAnalyzer new];
    
    NSArray* tokens = [lexicalAnalyzer analyseString:@"(x + x)"
                                            withVars:@[@"x"]];
    XCTAssertNoThrow([syntaxAnalyzer analyseTokens:tokens], @"brackets");
    
    tokens = [lexicalAnalyzer analyseString:@"(x + x"
                                   withVars:@[@"x"]];
    XCTAssertThrowsSpecific([syntaxAnalyzer analyseTokens:tokens], VBMathParserBracketNotClosedException, @"bracket not closed");
    
    tokens = [lexicalAnalyzer analyseString:@"x + x)"
                                   withVars:@[@"x"]];
    XCTAssertThrowsSpecific([syntaxAnalyzer analyseTokens:tokens], VBMathParserBracketNotOpenedException, @"bracket not opened");

    tokens = [lexicalAnalyzer analyseString:@"x + "
                                   withVars:@[@"x"]];
    XCTAssertThrowsSpecific([syntaxAnalyzer analyseTokens:tokens], VBMathParserMissingTokenException, @"missing arg in operation");
}

- (void)testConsts
{
    VBMathParserLexicalAnalyzer* lexicalAnalyzer = [VBMathParserLexicalAnalyzer new];
    VBMathParserSyntaxAnalyzer* syntaxAnalyzer = [VBMathParserSyntaxAnalyzer new];
    
    NSArray* tokens = [lexicalAnalyzer analyseString:@"(pi + pi)"];
    XCTAssertNoThrow([syntaxAnalyzer analyseTokens:tokens], @"brackets");
    
    tokens = [lexicalAnalyzer analyseString:@"(pi + pi"];
    XCTAssertThrowsSpecific([syntaxAnalyzer analyseTokens:tokens], VBMathParserBracketNotClosedException, @"bracket not closed");
    
    tokens = [lexicalAnalyzer analyseString:@"pi + pi)"];
    XCTAssertThrowsSpecific([syntaxAnalyzer analyseTokens:tokens], VBMathParserBracketNotOpenedException, @"bracket not opened");
    
    tokens = [lexicalAnalyzer analyseString:@"pi + "];
    XCTAssertThrowsSpecific([syntaxAnalyzer analyseTokens:tokens], VBMathParserMissingTokenException, @"missing arg in operation");
}

@end
