import 'package:template_cache/cache.dart';
import 'tokenizer.dart';

class Parser {
  GeneratedTemplateCode parse(List<Token> tokens) {
    return new _Parser(tokens).parse();
  }
}

class _Parser {
  final List<Token> source;
  int offset = 0;

  Token get current => source.length > offset ? source[offset] : Token.eof;

  _Parser(this.source);

  void expect(TokenType type) {
    if (current.isntA(type)) {
      throw new ParseError(current, 'Expected $type, but saw ${current.type}');
    }
  }

  void movePastWhitespace() {
    movePast(TokenType.whitespace);
  }

  void movePast(TokenType type) {
    if (current.isA(type)) {
      offset++;
    }
  }

  GeneratedTemplateCode parse() {
    return new GeneratedTemplateCode(
      'import "package:chalk/src/_escape.dart";' +
      _importStatements().join(),
      _body().join()
    );
  }

  move() {
    final c = current;
    offset++;
    return c;
  }

  Iterable<String> _body() sync* {
    while (current.type != null) {
      yield 'yield "';
      yield* _markup().map((l) => l.replaceAll('\n', r'\n'));
      yield '";';
    }
  }

  Iterable<String> _importStatements() sync* {
    movePastWhitespace();
    while (current.isA(TokenType.importKeyword)) {
      yield* _importStatement();
    }
  }

  Iterable<String> _importStatement() sync* {
    expect(TokenType.importKeyword);
    yield 'import ';
    move();
    movePastWhitespace();
    expect(TokenType.simpleString);
    yield move().content;
    movePastWhitespace();
    if (current.isA(TokenType.asKeyword)) {
      move();
      yield ' as ';
      movePastWhitespace();
      expect(TokenType.identifier);
      yield move().content;
    }
    movePastWhitespace();
    movePast(TokenType.semicolon);
    yield ';';
  }

  Iterable<String> _markup() sync* {
    while (current.type != null) {
      if (current.isA(TokenType.backSlash)) {
        move();
        if (current.isA(TokenType.dollarSign)) {
          move();
          yield r'\$';
        } else if (current.isA(TokenType.atSymbol)) {
          move();
          yield '@';
        } else {
          yield r'\\';
        }
      }
      if (current.isA(TokenType.dollarSign)) {
        offset++;
        yield r'${$_esc(';
        if (current.isA(TokenType.openCurly)) {
          offset++;
          yield* _expression();
          expect(TokenType.closeCurly);
          offset++;
        } else {
          expect(TokenType.identifier);
          yield move().content;
        }
        yield ')}';
        continue;
      }
      if (current.type == null) {
        break;
      }
      yield current.content.replaceAll('\n', r'\n');
      offset++;
    }
  }

  Iterable<String> _expression() sync* {
    while (current.isntA(TokenType.closeCurly)) {
      yield move().content;
    }
  }
}

class ParseError {
  final Token token;
  final String message;

  ParseError(this.token, this.message);

  String toString() => 'ParseError: $message ${token.location}';
}
