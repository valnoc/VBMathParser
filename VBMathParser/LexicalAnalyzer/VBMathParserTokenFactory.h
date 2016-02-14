//
//  VBMathParserTokenFactory.h
//  VBMathParserExamples
//
//  Created by Valeriy Bezuglyy on 14/02/16.
//  Copyright © 2016 Valeriy Bezuglyy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VBMathParserToken;

@protocol VBMathParserTokenFactory <NSObject>

- (nullable VBMathParserToken*) tokenWithType:(nonnull NSString*) tokenType
                                       string:(nonnull NSString*) string;

@end
