VBMathParser
============

VBMathParser is a library for mathematical expressions parsing.

It uses ARC. DO NOT FORGET to turn on ARC for framework's sources (-fobjc-arc flag), if your project is developed in non-ARC environment.

## How to import
Drag VBMathParser dir into your project.

OR

use Cocoapods <i>(is coming in several days)</i>

## How to use
#### Creation
This library if DI-ready.

Create an instance of VBMathParser using method
```
- (nullable instancetype) initWithLexicalAnalyzer:(nonnull id<VBMathParserLexicalAnalyzer>) lexicalAnalyzer
                                   syntaxAnalyzer:(nonnull id<VBMathParserSyntaxAnalyzer>) syntaxAnalyzer
                                       calculator:(nonnull id<VBMathParserCalculator>) calculator NS_DESIGNATED_INITIALIZER;
```
It needs three objects
1. lexical analyzer (conforms VBMathParserLexicalAnalyzer protocol)
It breaks string expression into several tokens.

2. syntax analyzer (conforms VBMathParserSyntaxAnalyzer protocol)
It checks the syntax of given expression (not openned or not closed brackets, etc.)

3. calculator (conforms VBMathParserCalculator protocol)
Prepares given array of tokens for fast calculation and calculates the result.

Inject your own objects that conform to these protocols or use the default ones
1. VBMathParserDefaultLexicalAnalyzer
2. VBMathParserDefaultSyntaxAnalyzer
3. VBMathParserDefaultRPNCalculator

To simplify the creation of a default math parser call
```
- (nullable instancetype) initWithDefaultAnalyzers;
```
It will use default analyzers.
```
    self.parser = [[VBMathParser alloc] initWithDefaultAnalyzers];
```

#### Setting the expression
```
    [self.parser setExpression:@"......"];
```
OR
```
    [self.parser setExpression:@"......"
                 withVariables:@[@"x", @"y", @"z", @"t"]];
```
#### Evaluating
```
    double result = [self.parser evaluate];
```
OR
```
    double result = [self.parser evaluateWithVariablesValues:@{@"x":  @(1),
                                                               @"y":  @(2),
                                                               @"z":  @(3),
                                                               @"t":  @(4)}];
```

## Expected syntax
You will get an exception if expression syntax has errors. To handle such cases you should you try/catch pattern.
1. If you open a bracket - do not forget to close it later. 
2. All operations are expected to be used in mathematical expressions as binary operations. 

    Only "-" operation can be used both as binary and as unary one. Actually unary minus operation is always replaced by a binary one as the following: 
```
        "-4" -> "0-4"
        "2 * (-4)" -> "2 * (0 - 4)"
        "-abs(4)" -> "0 - abs(4)"
```
3. All functions are expected to be followed by an argument enclosed in brackets.  
```
        abs3 - error!
        abs(3) - OK
```
4. Variable name must consist of at least one letter plus letters and numbers.
```
        valid names: x, y, x1, x01, etc
        invalid names: 0x, x_213, etc
```
## Supported features
1. brackets: (, )
2. operations: +, - (unary/binary), *, /, ^(power)
3. functions: abs, sin, cos, tan
4. variables
5. constants: pi

## Coming soon
Feel free to left a feature request

## License
VBMathParser is available under the MIT license. See the LICENSE file for more info.
