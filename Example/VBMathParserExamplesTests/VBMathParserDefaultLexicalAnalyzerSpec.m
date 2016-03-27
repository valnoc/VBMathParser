//
//  VBMathParserDefaultLexicalAnalyzerSpec.m
//  VBMathParserExamples
//
//  Created by Valeriy Bezuglyy on 27/03/16.
//  Copyright © 2016 Valeriy Bezuglyy. All rights reserved.
//

#import <Specta/Specta.h> // #import "Specta.h" if you're using libSpecta.a
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>

#import "VBMathParserDefaultLexicalAnalyzer.h"
#import "VBMathParserDefaultTokenFactory.h"

@interface VBMathParserDefaultLexicalAnalyzer ()

@property (nonatomic, strong) id<VBMathParserTokenFactory> tokenFactory;

@end

SpecBegin(VBMathParserDefaultLexicalAnalyzer)

describe(@"VBMathParserDefaultLexicalAnalyzer", ^{

    __block VBMathParserDefaultLexicalAnalyzer* __lexicalAnalyzer = nil;
    
    beforeEach(^{
        // This is run before each example.
        __lexicalAnalyzer = [[VBMathParserDefaultLexicalAnalyzer alloc] initWithDefaultTokenFactory];
    });
    
    it(@"should create default token factory", ^{
        // This is an example block. Place your assertions here.
        expect(__lexicalAnalyzer.tokenFactory).to.beAnInstanceOf([VBMathParserDefaultTokenFactory class]);
    });
    
    it(@"should use given factory", ^{
        // This is an example block. Place your assertions here.
        id<VBMathParserTokenFactory> factory = OCMProtocolMock(@protocol(VBMathParserTokenFactory));
        VBMathParserDefaultLexicalAnalyzer* analyzer = [[VBMathParserDefaultLexicalAnalyzer alloc] initWithTokenFactory:factory];
        expect(analyzer.tokenFactory).to.equal(factory);
    });
    
    afterEach(^{
        __lexicalAnalyzer = nil;
    });
});

SpecEnd
