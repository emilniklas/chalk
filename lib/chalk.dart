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
  final Iterable<String> templateFiles = (await templatesDir.list().toList())
    .where((f) => f is File && f.path.endsWith('.dart'))
    .map((f) => path.split(f.path).last.replaceFirst('.dart', ''));

  await templatesFile.writeAsString(
    templateFiles.map((name) {
      return 'import "templates/$name.dart" as $name;';
    }).join() +
    'final templates = {' +
    templateFiles.map((name) {
      return "'$name': (_) => new $name.\$(_),";
    }).join() +
    '};'
  );
}

Stream<String> render(File template, {Map<String, dynamic> locals: const {}}) {
  final factory = gen.templates[_name(template)];
  if (factory is! Function) {
    throw new Exception('${template.path} is not compiled. Run `chalk.compile(${template.path})` first!');
  }
  return factory(locals).render();
}

String _name(File file) {
  return r'template_' + BASE64.encode(file.absolute.path.codeUnits);
}
