import 'package:quark/quark.dart';
export 'package:quark/init.dart';

import 'package:chalk/src/tokenizer.dart';

class TokenizerTest extends UnitTest {
  final Tokenizer tokenizer = new Tokenizer();

  @test
  itWorks() {
    expect(tokenizer.tokenize('x'), [
      const Token(TokenType.identifier, 'x', const ScriptLocation(line: 1, char: 0))
    ]);
    expect(tokenizer.tokenize('xx{'), [
      const Token(TokenType.identifier, 'xx', const ScriptLocation(line: 1, char: 0)),
      const Token(TokenType.openCurly, '{', const ScriptLocation(line: 1, char: 2)),
    ]);
  }

  expectTokens(String source, List<TokenType> types) {
    expect(tokenizer.tokenize(source).map((t) => t.type).toList(), types);
  }

  expectToken(String source, TokenType type) {
    expectTokens(source, [type]);
  }

  @test
  allTokens() {
    expectToken('x', TokenType.identifier);
    expectToken('å', TokenType.unknown);
    expectTokens('{}', [TokenType.openCurly, TokenType.closeCurly]);
    expectTokens('[]', [TokenType.openBracket, TokenType.closeBracket]);
    expectTokens('<>', [TokenType.openAngle, TokenType.closeAngle]);
    expectTokens('()', [TokenType.openParen, TokenType.closeParen]);
    expectTokens(r'\/', [TokenType.backSlash, TokenType.forwardSlash]);
  }

  @test
  keywords() {
    expectToken('import', TokenType.importKeyword);
  }
}
