import 'tokenizer.dart';

class Parser {
  final List<Token> source;
  int offset = 0;

  Token get current => source.length > offset ? source[offset] : null;

  Parser(this.source);

  void expect(TokenType type) {
    if (current.isntA(type)) {
      throw new ParseError(current, 'Expected $type, but saw ${current.type}');
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
    while (current != null) {
      yield* _markup();
    }
    yield* suffix();
  }

  Iterable<String> _importStatement() sync* {
    expect(TokenType.importKeyword);
    yield 'import ';
    offset++;
    expect(TokenType.simpleString);
    yield current.content;
    yield ';';
    offset++;
  }

  Iterable<String> _markup() sync* {
    yield 'yield "';
    while (current != null) {
      yield current.content.replaceAll('\n', r'\n');
      offset++;
    }
    yield '";';
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
