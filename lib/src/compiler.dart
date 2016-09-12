import 'package:template_cache/cache.dart';
import 'parser.dart';
import 'tokenizer.dart';
import 'dart:async';

class ChalkCompiler extends Compiler {
  final ContentType contentType = ContentType.HTML;
  final Iterable<String> extensions = ['.chalk.html', '.chalk'];
  final Tokenizer tokenzer = new Tokenizer();
  final Parser parser = new Parser();

  Future<GeneratedTemplateCode> compile(Uri file, Stream<String> source) async {
    final code = await source.join('\n');
    return parser.parse(tokenzer.tokenize(code));
  }
}
