VBMathParser
============

VBMathParser is a simple framework to perform mathematical expressions parsing.

## How to use

1. import header

    `#import "VBMathParser.h”`

2. use one of the variants

2.1. one line

    double result = [VBMathParser evaluateExpression:@"1"];

2.2. using instance method

    VBMathParser* parser = [[VBMathParser alloc] initWithExpression:@"2 + 4"];
    result = [parser evaluate];

Expression can always be changed by setting expression property of VBMathParser object

    parser.expression = @"2(1+3)";
    result = [parser evaluate];
