VBMathParser
============

VBMathParser is a simple framework to perform mathematical expressions parsing. 
Math parser is conceived as a one-line string-to-double converter.  

This framework uses ARC. DO NOT FORGET to turn on ARC for framework's sources (-fobjc-arc flag), if your project is developed in non-ARC environment.

## How to use
1. Drag VBMathParser dir into your project.
2. Import header

    `#import "VBMathParser.h”`

3. Use one of the variants

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
2. All operations are expected to be used in mathematical expressions as binary operations. 

    Only "-" operation can be used both as binary and as unary one. Actually unary minus operation is always replaced by a binary one as the following: 

        "-4" -> "0-4"
        "2 * (-4)" -> "2 * (0 - 4)"
        "-abs(4)" -> "0 - abs(4)"

3. All functions are expected to be followed by an argument enclosed in brackets.  

        abs3 - error!
        abs(3) - OK

## Supported features
1. brackets: (, )
2. operations: +, - (unary/binary), *, /, ^(power)
3. functions: abs, sin, cos, tan

## Coming soon
1. more functions 
2. variables

## License
VBMathParser is available under the MIT license. See the LICENSE file for more info.
