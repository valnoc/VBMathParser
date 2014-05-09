//
//    The MIT License (MIT)
//
//    Copyright (c) 2014 Valeriy Bezuglyy. All rights reserved.
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//    SOFTWARE.
//

#import "VBMathParserTokenOperation.h"

#import "VBMathParserUnknownTokenException.h"

@implementation VBMathParserTokenOperation

+ (instancetype) operationWithString:(NSString*)str{
	return [[self alloc] initWithString:str];
}

- (instancetype) initWithString:(NSString*)str{
	self = [super initWithString:str];
	if (self) {
		_tokenOperation = [self.class tokenOperationWithString:str];
		if (self.tokenOperation == VBTokenOperationUnknown) {
            @throw [VBMathParserUnknownTokenException exceptionWithInfo:str];
		}
	}
	return self;
}

+ (NSString *)regexPattern {
    return @"^[\\+\\-\\*/^]$";
}

#pragma mark - tokens
+ (VBTokenOperation) tokenOperationWithString:(NSString*)str {
	VBTokenOperation operation = VBTokenOperationUnknown;
	
	if ([str isEqualToString:@"+"]) {
        operation = VBTokenOperationAddition;
        
	}else if ([str isEqualToString:@"-"]) {
        operation = VBTokenOperationSubstraction;
        
	}else if ([str isEqualToString:@"*"]) {
        operation = VBTokenOperationMultiplication;
        
	}else if ([str isEqualToString:@"/"]) {
        operation = VBTokenOperationDivision;
        
	}else if ([str isEqualToString:@"^"]) {
        operation = VBTokenOperationPower;
        
    }
	
	return operation;
}

+ (BOOL) isOperation:(NSString*)str {
    return [self tokenOperationWithString:str] != VBTokenOperationUnknown;
}

- (NSInteger) priority {
    switch (self.tokenOperation) {
        case VBTokenOperationPower:
            return 2;
            break;
            
        case VBTokenOperationMultiplication:
        case VBTokenOperationDivision:
            return 1;
            break;
            
        case VBTokenOperationAddition:
        case VBTokenOperationSubstraction:
        default:
            return 0;
            break;
    }
}

#pragma mark - evaluation
- (double) evaluateWithParamLeft:(double)paramLeft
                      paramRight:(double)paramRight {
    double result = 0;
	switch (self.tokenOperation) {
            
		case VBTokenOperationAddition:
			result = paramLeft + paramRight;
			break;
            
		case VBTokenOperationSubstraction:
			result = paramLeft - paramRight;
			break;
            
        case VBTokenOperationMultiplication:
            result = paramLeft * paramRight;
            break;
            
        case VBTokenOperationDivision:
            result = paramLeft / paramRight;
            break;
            
        case VBTokenOperationPower:
            result = pow(paramLeft, paramRight);
            break;
            
		default:
#warning TODO throw exception
			break;
	}
    return result;
}

@end
