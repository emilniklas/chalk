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
      const Token(TokenType.whitespace, ' '),
      const Token(TokenType.simpleString, '"x"'),
      const Token(TokenType.whitespace, '\n\n'),
      const Token(TokenType.openAngle, '<'),
      const Token(TokenType.identifier, 'div'),
      const Token(TokenType.closeAngle, '>'),
      const Token(TokenType.openAngle, '<'),
      const Token(TokenType.forwardSlash, '/'),
      const Token(TokenType.identifier, 'div'),
      const Token(TokenType.closeAngle, '>'),
      const Token(TokenType.whitespace, '\n'),
    ],
      'import "x";'
      '$prefix'
      'yield "<div></div>";'
      '$suffix'
    );

    expectParsesWithImports([
      const Token(TokenType.importKeyword, 'import'),
      const Token(TokenType.whitespace, ' '),
      const Token(TokenType.simpleString, '"x"'),
      const Token(TokenType.whitespace, ' '),
      const Token(TokenType.asKeyword, 'as'),
      const Token(TokenType.whitespace, ' '),
      const Token(TokenType.identifier, 'thing'),
      const Token(TokenType.whitespace, '\n'),
      const Token(TokenType.importKeyword, 'import'),
      const Token(TokenType.whitespace, ' '),
      const Token(TokenType.simpleString, '"y"'),
      const Token(TokenType.whitespace, ' '),
      const Token(TokenType.asKeyword, 'as'),
      const Token(TokenType.whitespace, ' '),
      const Token(TokenType.identifier, 'thing2'),
      const Token(TokenType.whitespace, '\n'),
    ],
      'import "x" as thing;'
      'import "y" as thing2;'
      '$prefix'
      '$suffix'
    );
  }

  @test
  whitespaceHandling() {
    expectParses([
      const Token(TokenType.openAngle, '<'),
      const Token(TokenType.identifier, 'div'),
      const Token(TokenType.closeAngle, '>'),
      const Token(TokenType.identifier, 'a'),
      const Token(TokenType.identifier, ' '),
      const Token(TokenType.identifier, 'b'),
      const Token(TokenType.identifier, ' '),
      const Token(TokenType.identifier, 'c'),
      const Token(TokenType.openAngle, '<'),
      const Token(TokenType.forwardSlash, '/'),
      const Token(TokenType.identifier, 'div'),
      const Token(TokenType.closeAngle, '>'),
    ], 'yield "<div>a b c</div>";');
  }

  @test
  variables() {
    expectParses([
      const Token(TokenType.dollarSign, r'$'),
      const Token(TokenType.identifier, 'a'),
    ], r'yield "${$_esc(a)}";');
  }
}
