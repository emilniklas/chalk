class Tokenizer {
  List<Token> tokenize(String source) {
    return new _Tokenizer(source).tokenize();
  }
}

class _Tokenizer {
  final String source;
  int offset = 0;

  _Tokenizer(this.source);

  String get head => source.substring(offset);

  ScriptLocation get location {
    final lines = source.substring(0, offset).split('\n');
    return new ScriptLocation(
      line: lines.length,
      char: lines.isEmpty ? 0 : lines.last.length
    );
  }

  List<Token> tokenize() {
    return new List<Token>.unmodifiable(_tokenize());
  }

  Iterable<Token> _tokenize() sync* {
    while (head.isNotEmpty) {
      yield _nextToken();
    }
  }

  Token _nextToken() {
    for (final pattern in patterns.keys) {
      final regex = new RegExp(pattern);
      if (regex.hasMatch(head)) {
        final token = new Token(patterns[pattern], regex.firstMatch(head)[0], location);
        offset += token.content.length;
        return token;
      }
    }
    throw new Exception('Unexpected character [${head.substring(0, 1)}]');
  }

  static const patterns = const {
    r'^\{': TokenType.openCurly,
    r'^\}': TokenType.closeCurly,
    r'^\[': TokenType.openBracket,
    r'^\]': TokenType.closeBracket,
    r'^\(': TokenType.openParen,
    r'^\)': TokenType.closeParen,
    r'^\<': TokenType.openAngle,
    r'^\>': TokenType.closeAngle,
    r'^\\': TokenType.backSlash,
    r'^\/': TokenType.forwardSlash,
    r'^[a-zA-Z_$][a-zA-Z0-9_$]*': TokenType.identifier,
    r'^.': TokenType.unknown
  };
}

class Token {
  final TokenType type;
  final String content;
  final ScriptLocation location;

  const Token(this.type, this.content, [this.location]);

  bool operator ==(other) {
    return other is Token
        && other.type == type
        && other.content == content
        && (other.location != null && location != null)
        ? other.location == location
        : true;
  }
}

enum TokenType {
  unknown,
  identifier,
  openCurly,
  closeCurly,
  openBracket,
  closeBracket,
  openAngle,
  closeAngle,
  openParen,
  closeParen,
  backSlash,
  forwardSlash,
}

class ScriptLocation {
  final int line;
  final int char;

  const ScriptLocation({this.line, this.char});

  bool operator ==(other) {
    return other is ScriptLocation
        && other.line == line
        && other.char == char;
  }
}
