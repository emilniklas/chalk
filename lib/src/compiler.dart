import 'directives.dart';
import '../compiler.dart' as interface;

class Compiler implements interface.Compiler {
  final Directives directives;

  Compiler(this.directives);

  String compile(String template) {
    return 'render() async* {${template.isEmpty ? '' : 'yield "$template";'}}';
  }
}
