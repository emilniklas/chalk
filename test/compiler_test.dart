import 'package:quark/quark.dart';
export 'package:quark/init.dart';

import 'package:chalk/compiler.dart';

class CompilerTest extends UnitTest {
  final compiler = new Compiler(new Directives());

  @test
  itWorks() {
    expect(compiler.compile(''), 'render() async* {}');
    expect(compiler.compile('x'), 'render() async* {yield "x";}');
  }
}
