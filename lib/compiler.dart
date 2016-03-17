import 'src/compiler.dart' as compiler_impl;
import 'src/directives.dart' as directives_impl;

abstract class Compiler {
  factory Compiler(Directives directives) => new compiler_impl.Compiler(directives);

  String compile(String template);
}

class Directives extends directives_impl.Directives {

}
