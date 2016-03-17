import 'directives.dart';
import '../compiler.dart' as interface;
import 'tokenizer.dart';
import 'parser.dart';

class Compiler implements interface.Compiler {
  final Directives directives;
  final Tokenizer tokenizer = new Tokenizer();

  Compiler(this.directives);

  String compile(String template) {
    final tokens = tokenizer.tokenize(template);
    return new Parser(tokens).parse().join();
  }
}
