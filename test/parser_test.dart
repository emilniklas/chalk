import 'package:quark/quark.dart';
export 'package:quark/init.dart';

import 'package:chalk/src/parser.dart';
import 'package:chalk/src/tokenizer.dart';

const prefix = r'import "package:chalk/src/proxy_object.dart";class $ extends ProxyObject {$(_) : super(_);render() async* {';
const suffix = '}}';

class ParserTest extends UnitTest {
  expectParses(List<Token> tokens, String output) {
    expectParsesWithImports(tokens, '$prefix$output$suffix');
  }

  expectParsesWithImports(List<Token> tokens, String output) {
    expect(new Parser(tokens).parse().join(), output);
  }

  @test
  itWorks() {
    expectParses([], '');
    expectParses([
      const Token(TokenType.identifier, 'x')
    ], 'yield "x";');
  }

  @test
  importStatement() {
    expectParsesWithImports([
      const Token(TokenType.importKeyword, 'import'),
      const Token(TokenType.simpleString, '"x"'),
      const Token(TokenType.openAngle, '<'),
      const Token(TokenType.identifier, 'div'),
      const Token(TokenType.closeAngle, '>'),
      const Token(TokenType.openAngle, '<'),
      const Token(TokenType.forwardSlash, '/'),
      const Token(TokenType.identifier, 'div'),
      const Token(TokenType.closeAngle, '>'),
    ],
      'import "x";'
      '$prefix'
      'yield "<div></div>";'
      '$suffix'
    );
  }
}
