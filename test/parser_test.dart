import 'package:quark/quark.dart';
export 'package:quark/init.dart';

import 'package:chalk/src/parser.dart';
import 'package:chalk/src/tokenizer.dart';

import 'package:template_cache/cache.dart';

const prefix = r'import "package:chalk/src/proxy_object.dart";class $ extends ProxyObject {$(_) : super(_);render() async* {';
const suffix = '}}';

class ParserTest extends UnitTest {
  final Parser parser = new Parser();

  expectParses(List<Token> tokens, GeneratedTemplateCode output) {
    final code = parser.parse(tokens);
    expect(code.directives, 'import "package:chalk/src/_escape.dart";${output.directives}');
    expect(code.renderBody, output.renderBody);
  }

  @test
  itWorks() {
    expectParses([], new GeneratedTemplateCode('', ''));
    expectParses([
      const Token(TokenType.identifier, 'x')
    ], new GeneratedTemplateCode('', 'yield "x";'));
  }

  @test
  importStatement() {
    expectParses([
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
    ],
      new GeneratedTemplateCode(
        'import "x";',
        'yield "<div></div>";'
      )
    );

    expectParses([
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
      new GeneratedTemplateCode(
        'import "x" as thing;'
        'import "y" as thing2;',
        ''
      )
    );
  }

  @test
  whitespaceHandling() {
    expectParses([
      const Token(TokenType.openAngle, '<'),
      const Token(TokenType.identifier, 'div'),
      const Token(TokenType.closeAngle, '>'),
      const Token(TokenType.identifier, 'a'),
      const Token(TokenType.whitespace, ' '),
      const Token(TokenType.identifier, 'b'),
      const Token(TokenType.identifier, ' '),
      const Token(TokenType.identifier, 'c'),
      const Token(TokenType.openAngle, '<'),
      const Token(TokenType.forwardSlash, '/'),
      const Token(TokenType.identifier, 'div'),
      const Token(TokenType.closeAngle, '>'),
    ], new GeneratedTemplateCode('', 'yield "<div>a b c</div>";'));
  }

  @test
  variables() {
    expectParses([
      const Token(TokenType.dollarSign, r'$'),
      const Token(TokenType.identifier, 'a'),
    ], new GeneratedTemplateCode('', r'yield "${$_esc(a)}";'));

    expectParses([
      const Token(TokenType.dollarSign, r'$'),
      const Token(TokenType.openCurly, r'{'),
      const Token(TokenType.identifier, 'a'),
      const Token(TokenType.closeCurly, r'}'),
    ], new GeneratedTemplateCode('', r'yield "${$_esc(a)}";'));
  }

  @test
  escapingSpecialSymbols() {
    expectParses([
      const Token(TokenType.backSlash, r'\'),
      const Token(TokenType.dollarSign, r'$'),
      const Token(TokenType.openCurly, r'{'),
      const Token(TokenType.identifier, 'a'),
      const Token(TokenType.closeCurly, r'}'),
      const Token(TokenType.backSlash, r'\'),
      const Token(TokenType.identifier, r'a'),
      const Token(TokenType.backSlash, r'\'),
      const Token(TokenType.atSymbol, r'@'),
    ], new GeneratedTemplateCode('', r'yield "\${a}\\a@";'));
  }
}
