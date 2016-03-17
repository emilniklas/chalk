import 'directives.dart';
import '../compiler.dart' as interface;
import 'tokenizer.dart';

class Compiler implements interface.Compiler {
  final Directives directives;
  final Tokenizer tokenizer = new Tokenizer();

  Compiler(this.directives);

  String compile(String template) {
    final tokens = tokenizer.tokenize(template);
    return new Parser(tokens).parse().join();
  }
}

class Parser {
  final List<Token> source;
  int offset = 0;

  Token get current => source.length > offset ? source[offset] : null;

  Parser(this.source);

  Iterable<String> parse() sync* {
    while (current.isntA(TokenType.importKeyword)) {
      
    }
  }
}
