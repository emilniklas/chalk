import 'dart:io';
import 'dart:async';
import 'dart:convert' show BASE64;

import '_gen/templates.dart' as gen;
import 'package:current_script/current_script.dart';
import 'package:path/path.dart' as path;
import 'compiler.dart';

Future<Null> compile(File template, {Directives directives}) async {
  final genDir = path.join(currentScript().parent.path, '_gen');
  final templatesDir = new Directory(path.join(genDir, 'templates'));
  if (!templatesDir.exists()) {
    await templatesDir.create(recursive: true);
  }
  final templateFile = new File(path.join(templatesDir.path, _name(template) + '.dart'));
  final templatesFile = new File(path.join(genDir, 'templates.dart'));
  final compiler = new Compiler(directives ?? new Directives());
  await templateFile.writeAsString(compiler.compile(await template.readAsString()));
  final List<File> templateFiles = (await templatesDir.list().toList())
    .where((f) => f is File && f.path.endsWith('.dart'));

  await templatesFile.writeAsString(
    templateFiles.map((f) {
      final name = _name(f);
      return 'import "templates/$name" as $name;';
    }).join() +
    'final templates = {' +
    templateFiles.map((f) {
      final name = _name(f);
      return "#$name: $name.\$,";
    }).join() +
    '};'
  );
}

Stream<String> render(File template) {
  return gen.templates[_symbol(template)].render();
}

String _name(File file) {
  return BASE64.encode(file.absolute.path.codeUnits);
}

Symbol _symbol(File file) {
  return new Symbol(_name(file));
}
