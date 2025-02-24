import 'dart:io';

import 'package:msh_dart/src/command/command.dart';

class Exit implements Command {
  @override
  (String?, String?) execute(List<String?> args) {
    String? exitCodeStr = args.first;
    if (exitCodeStr == null) {
      exit(0);
    }

    int? exitCode = int.tryParse(exitCodeStr);

    if (exitCode == null) {
      exit(0);
    }
    exit(exitCode);
  }
}
