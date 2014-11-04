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

#import "VBMathParserTokenVar.h"

@interface VBMathParserTokenVar ()

@property (nonatomic, strong) NSString* string;

@end

@implementation VBMathParserTokenVar

+ (VBMathParserToken *) tokenWithString:(NSString *)string {
    if ([self isToken:string]) {
        return [[self alloc] initWithString:string];
    }else{
        return nil;
    }
}

- (instancetype) initWithString:(NSString*) string {
    self = [super init];
    if (self) {
        self.string = string;
    }
    return self;
}

+ (BOOL) isToken:(NSString*)string {
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:[self.class regexPattern]
                                                                           options:NSRegularExpressionCaseInsensitive|NSRegularExpressionAnchorsMatchLines
                                                                             error:nil];
    NSRange range = [regex rangeOfFirstMatchInString:string
                                             options:0
                                               range:NSMakeRange(0, string.length)];
    if (range.location == 0 && range.length == string.length) {
        return YES;
    }else{
        return NO;
    }
}

#pragma mark - token abstract
+ (NSString *) regexPattern {
    return @"^[A-Za-z]+[A-Za-z0-9]*$";
}

#pragma mark - token concrete
- (NSString *) stringValue {
    return [NSString stringWithFormat:@"%@", self.string];
}

@end
