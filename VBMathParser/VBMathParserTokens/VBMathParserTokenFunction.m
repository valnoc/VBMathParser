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

#import "VBMathParserTokenFunction.h"

#import "VBMathParserUnknownTokenException.h"

@implementation VBMathParserTokenFunction

+ (instancetype) functionWithString:(NSString*)str{
	return [[self alloc] initWithString:str];
}

- (instancetype) initWithString:(NSString*)str{
	self = [super initWithString:str];
	if (self) {
		_tokenFunction = [self.class tokenFunctionWithString:str];
		if (self.tokenFunction == VBTokenFunctionUnknown) {
            @throw [VBMathParserUnknownTokenException exceptionWithInfo:str];
		}
	}
	return self;
}

+ (NSString *)regexPattern {
    return @"^[A-Za-z]*$";
}

#pragma mark - tokens
+ (VBTokenFunction) tokenFunctionWithString:(NSString*)str {
	VBTokenFunction function = VBTokenFunctionUnknown;
	
	if ([str isEqualToString:@"abs"]) {
        function = VBTokenFunctionABS;
        
	}else if ([str isEqualToString:@"sin"]) {
        function = VBTokenFunctionSin;
        
	}else if ([str isEqualToString:@"cos"]) {
        function = VBTokenFunctionCos;

    }else if ([str isEqualToString:@"tan"]) {
        function = VBTokenFunctionTan;
    }
	
	return function;
}

+ (BOOL) isToken:(NSString *)str {
    return [self tokenFunctionWithString:str] != VBTokenFunctionUnknown;
}

- (NSInteger) priority {
    return 2;
}

#pragma mark - evaluation
- (double) evaluateWithParam:(double)param {
    double result = 0;
	switch (self.tokenFunction) {
            
		case VBTokenFunctionABS:
			result = ABS(param);
			break;
            
        case VBTokenFunctionSin:
            result = sin(param);
            break;
            
        case VBTokenFunctionCos:
            result = cos(param);
            break;
            
        case VBTokenFunctionTan:
            result = tan(param);
            break;
            
		default:
#warning TODO throw exception
			break;
	}
    return result;
}

@end
