//
//    The MIT License (MIT)
//
//    Copyright (c) 2015 Valeriy Bezuglyy.
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

#import "VBMathParserToken.h"

#import "VBMathParserNotImplementedException.h"

@interface VBMathParserToken ()

@end

@implementation VBMathParserToken

+ (nonnull instancetype) tokenWithString:(nonnull NSString*)string {
    return [self new];
}

+ (BOOL) isToken:(nonnull NSString*)string {
    return [[self rawString] isEqualToString:string];
}

+ (nonnull NSString*) tokenType {
    @throw [VBMathParserNotImplementedException exception];
}

#pragma mark - regexp
+ (nonnull NSString*) regexpPattern {
    @throw [VBMathParserNotImplementedException exception];
}
+ (nonnull NSRegularExpression*) regularExpression {
    NSError* error = nil;
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:[self regexpPattern]
                                                                           options:NSRegularExpressionCaseInsensitive|NSRegularExpressionAnchorsMatchLines
                                                                             error:&error];
    return regex;
}

#pragma mark - string
+ (NSString *) rawString {
    @throw [VBMathParserNotImplementedException exception];
}
- (NSString *) stringValue {
    return [self.class rawString];
}

#pragma mark - description
- (NSString *) description {
    return [NSString stringWithFormat:@"%@: %@", NSStringFromClass(self.class), self.class.rawString];
    //    return [[super description] stringByAppendingFormat:@": %@", self.string];
}

@end
