import 'dart:io';

import '_gen/templates.dart' as gen;
import 'package:current_script/current_script.dart';
import 'package:path/path.dart' as path;

compile(content) {
  final file = new File(path.join(currentScript().parent.path, '_gen', 'templates.dart'));
  file.writeAsStringSync(content);
}

render() {
  return gen.templates[#some_id]();
}
