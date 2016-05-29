#
# Be sure to run `pod lib lint MyLib.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "VBMathParser"
  s.version          = "1.0.0"
  s.summary          = "VBMathParser is a library for mathematical expressions parsing."
  s.description      = <<-DESC
VBMathParser is a library for mathematical expressions parsing.
Supported features
1. brackets: (, )
2. operations: +, - (unary/binary), *, /, ^(power)
3. functions: abs, sin, cos, tan
4. variables
5. constants: pi
                       DESC
  s.homepage         = "https://github.com/valnoc/VBMathParser"
  s.license          = 'MIT'
  s.author           = { "Valeriy Bezuglyy" => "valnocorner@gmail.com" }
  s.source           = { :git => "https://github.com/valnoc/VBMathParser.git", :tag => "v#{s.version}" }

  s.platform     = :ios, '8.1'
  s.requires_arc = true

  s.source_files = 'VBMathParser/**/*'

  s.dependency 'VBException', '~> 1.0'
end
