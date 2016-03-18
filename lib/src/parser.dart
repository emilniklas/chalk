import 'tokenizer.dart';

class Parser {
  final List<Token> source;
  int offset = 0;

  Token get current => source.length > offset ? source[offset] : Token.eof;

  Parser(this.source);

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

  Iterable<String> parse() sync* {
    if (source.isEmpty) {
      yield* prefix();
      yield* suffix();
      return;
    }

    while (current.isA(TokenType.importKeyword)) {
      yield* _importStatement();
    }
    yield* prefix();
    while (current.type != null) {
      yield 'yield "';
      yield* _markup();
      yield '";';
    }
    yield* suffix();
  }

  move() {
    final c = current;
    offset++;
    return c;
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

  Iterable<String> prefix() sync* {
    yield 'import "package:chalk/src/proxy_object.dart";';

    yield r'class $ extends ProxyObject {';
    yield r'$(_) : super(_);';

    yield 'render() async* {';
  }

  Iterable<String> suffix() sync* {
    yield '}';
    yield '}';
  }
}

class ParseError {
  final Token token;
  final String message;

  ParseError(this.token, this.message);

  String toString() => 'ParseError: $message ${token.location}';
}
