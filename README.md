VBMathParser
============

VBMathParser is a simple framework to perform mathematical expressions parsing.

## How to install
Drag VBMathParser dir into your project

## How to use

1. import header

    `#import "VBMathParser.h”`

2. use one of the variants

single line

    double result = [VBMathParser evaluateExpression:@"1"];

using instance method

    VBMathParser* parser = [[VBMathParser alloc] initWithExpression:@"2 + 4"];
    result = [parser evaluate];

Expression can always be changed by setting expression property of VBMathParser object

    parser.expression = @"2(1+3)";
    result = [parser evaluate];

## Supported 
1. operations: +, - (unary/binary), *, /, ^(power)
2. brackets: (, )

## Coming soon
1. functions 
2. variables

## License
VBMathParser is available under the MIT license. See the LICENSE file for more info.
