import 'package:quark/quark.dart';
export 'package:quark/init.dart';

import 'package:chalk/compiler.dart';

const prefix = r'import "package:chalk/src/proxy_object.dart";class $ extends ProxyObject {$(_) : super(_);render() async* {';
const suffix = '}}';

class CompilerTest extends UnitTest {
  final compiler = new Compiler(new Directives());

  @test
  itWorks() {
    expect(compiler.compile(''), '$prefix$suffix');
    expect(compiler.compile('x'), '${prefix}yield "x";$suffix');
  }
}
