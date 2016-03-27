//
//  VBMathParserDefaultTokenFactorySpec.m
//  VBMathParserExamples
//
//  Created by Valeriy Bezuglyy on 27/03/16.
//  Copyright © 2016 Valeriy Bezuglyy. All rights reserved.
//

#import <Specta/Specta.h> // #import "Specta.h" if you're using libSpecta.a
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

SpecBegin(VBMathParserDefaultTokenFactory)

describe(@"VBMathParserDefaultTokenFactory", ^{
    
    __block VBMathParserDefaultTokenFactory* __tokenFactory = nil;
    
    beforeEach(^{
        __tokenFactory = [[VBMathParserDefaultTokenFactory alloc] init];
    });
    
    it(@"should implement factory protocol", ^{
        expect(__tokenFactory).to.conformTo(@protocol(VBMathParserTokenFactory));
    });
    
    //--- special
    it(@"should create VBMathParserTokenSpecialBracketOpen", ^{
        VBMathParserToken *token = [__tokenFactory tokenWithType:[VBMathParserTokenSpecial tokenType]
                                                          string:@"("];
        expect(token).to.beAnInstanceOf([VBMathParserTokenSpecialBracketOpen class]);
    });
    
    it(@"should create VBMathParserTokenSpecialBracketClose", ^{
        VBMathParserToken *token = [__tokenFactory tokenWithType:[VBMathParserTokenSpecial tokenType]
                                                          string:@")"];
        expect(token).to.beAnInstanceOf([VBMathParserTokenSpecialBracketClose class]);
    });
    
    //--- operation
    it(@"should create VBMathParserTokenOperationAddition", ^{
        VBMathParserToken *token = [__tokenFactory tokenWithType:[VBMathParserTokenOperation tokenType]
                                                          string:@"+"];
        expect(token).to.beAnInstanceOf([VBMathParserTokenOperationAddition class]);
    });
    
    it(@"should create VBMathParserTokenOperationDivision", ^{
        VBMathParserToken *token = [__tokenFactory tokenWithType:[VBMathParserTokenOperation tokenType]
                                                          string:@"/"];
        expect(token).to.beAnInstanceOf([VBMathParserTokenOperationDivision class]);
    });
    
    it(@"should create VBMathParserTokenOperationMultiplication", ^{
        VBMathParserToken *token = [__tokenFactory tokenWithType:[VBMathParserTokenOperation tokenType]
                                                          string:@"*"];
        expect(token).to.beAnInstanceOf([VBMathParserTokenOperationMultiplication class]);
    });
    
    it(@"should create VBMathParserTokenOperationPower", ^{
        VBMathParserToken *token = [__tokenFactory tokenWithType:[VBMathParserTokenOperation tokenType]
                                                          string:@"^"];
        expect(token).to.beAnInstanceOf([VBMathParserTokenOperationPower class]);
    });
    
    it(@"should create VBMathParserTokenOperationSubstraction", ^{
        VBMathParserToken *token = [__tokenFactory tokenWithType:[VBMathParserTokenOperation tokenType]
                                                          string:@"-"];
        expect(token).to.beAnInstanceOf([VBMathParserTokenOperationSubstraction class]);
    });
    
    //--- FUNCTION
    it(@"should create VBMathParserTokenFunctionAbs", ^{
        VBMathParserToken *token = [__tokenFactory tokenWithType:[VBMathParserTokenFunction tokenType]
                                                          string:@"abs"];
        expect(token).to.beAnInstanceOf([VBMathParserTokenFunctionAbs class]);
    });
    
    it(@"should create VBMathParserTokenFunctionCos", ^{
        VBMathParserToken *token = [__tokenFactory tokenWithType:[VBMathParserTokenFunction tokenType]
                                                          string:@"cos"];
        expect(token).to.beAnInstanceOf([VBMathParserTokenFunctionCos class]);
    });
    
    it(@"should create VBMathParserTokenFunctionSin", ^{
        VBMathParserToken *token = [__tokenFactory tokenWithType:[VBMathParserTokenFunction tokenType]
                                                          string:@"sin"];
        expect(token).to.beAnInstanceOf([VBMathParserTokenFunctionSin class]);
    });
    
    it(@"should create VBMathParserTokenFunctionTan", ^{
        VBMathParserToken *token = [__tokenFactory tokenWithType:[VBMathParserTokenFunction tokenType]
                                                          string:@"tan"];
        expect(token).to.beAnInstanceOf([VBMathParserTokenFunctionTan class]);
    });
    
//#import "VBMathParserTokenNumber.h"
//#import "VBMathParserTokenVar.h"

    //--- CONST
    it(@"should create VBMathParserTokenConstPi", ^{
        VBMathParserToken *token = [__tokenFactory tokenWithType:[VBMathParserTokenFunction tokenType]
                                                          string:@"pi"];
        expect(token).to.beAnInstanceOf([VBMathParserTokenConstPi class]);
    });
    
    //--- NUMBER
    it(@"should create VBMathParserTokenNumber", ^{
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
            VBMathParserToken *token = [__tokenFactory tokenWithType:[VBMathParserTokenNumber tokenType]
                                                              string:obj];
            expect(token).to.beAnInstanceOf([VBMathParserTokenNumber class]);
            expect(((VBMathParserTokenNumber*)token).doubleValue).to.equal([obj doubleValue]);
        }];
    });
    
    //--- VAR
    
    
    afterEach(^{
        __tokenFactory = nil;
    });
});

SpecEnd
