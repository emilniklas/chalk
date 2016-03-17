import 'dart:io';

import '_gen/templates.dart';
import 'package:current_script/current_script.dart';
import 'package:path/path.dart' as path;

compile() {
  final file = new File(path.join(currentScript().parent.path, '_gen', 'templates.dart'));
  file.writeAsStringSync('thing() => "${new DateTime.now()}";');
}

render() {
  return thing();
}
