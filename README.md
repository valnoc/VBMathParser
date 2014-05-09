VBMathParser
============

VBMathParser is a simple framework to perform mathematical expressions parsing.

## How to install
Drag VBMathParser dir into your project.

## How to use

1. Import header

    `#import "VBMathParser.h”`

2. Use one of the variants

Single line

    double result = [VBMathParser evaluateExpression:@"1"];

Using instance method

    VBMathParser* parser = [[VBMathParser alloc] initWithExpression:@"2 + 4"];
    result = [parser evaluate];

Expression can always be changed by setting the expression property of VBMathParser object

    parser.expression = @"2(1+3)";
    result = [parser evaluate];

## Expected syntax
1. If you open a bracket - do not forget to close it later.
2. Only "-" operation can be used as an unary one. Actually unary minus operation is always replaced by a binary one as the following: 

    "-4" -> "0-4"
    "2 * (-4)" -> "2 * (0 - 4)"
    "-abs(4)" -> "0 - abs(4)"

3. All functions are expected to be followed by an argument enclosed in brackets. 

## Supported features
1. brackets: (, )
2. operations: +, - (unary/binary), *, /, ^(power)
3. functions: abs

## Coming soon
1. more functions 
2. variables

## License
VBMathParser is available under the MIT license. See the LICENSE file for more info.
