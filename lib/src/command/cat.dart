import 'dart:io';

import 'package:msh_dart/src/command/command.dart';

class Cat implements Command {
  @override
  (String?, String?) execute(List<String?> args) {
    var outputBuilder = StringBuffer();
    String? error;
    for (var path in args) {
      if (path == null) {
        continue;
      }
      if (File(path).existsSync()) {
        outputBuilder.write(File(path).readAsStringSync().trimRight());
      } else {
        error = "cat: $path: No such file or directory";
      }
    }
    return (outputBuilder.toString().trimRight(), error);
  }
}
