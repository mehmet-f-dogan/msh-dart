import 'dart:io';

import 'package:msh_dart/src/command/command.dart';

class Pwd implements Command {
  @override
  (String?, String?) execute(List<String?> args) {
    return (Directory.current.absolute.path, null);
  }
}
