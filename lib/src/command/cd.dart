import 'dart:io';

import 'package:msh_dart/src/command/command.dart';

class Cd implements Command {
  @override
  (String?, String?) execute(List<String?> args) {
    if (args.isEmpty) {
      return (null, "cd: missing arguments");
    }

    var directoryPath = args[0];
    try {
      var targetDirectory = resolveTargetDirectory(directoryPath);
      if (targetDirectory != null) {
        Directory.current = targetDirectory;
      }
      return (null, null);
    } catch (e) {
      if (e is FileSystemException) {
        return (null, "cd: $directoryPath: No such file or directory");
      }
      rethrow;
    }
  }

  String? resolveTargetDirectory(String? directoryPath) {
    if (directoryPath == null || directoryPath.isEmpty) {
      throw ArgumentError("cd: missing arguments");
    }

    if (directoryPath.startsWith('~')) {
      return Platform.environment['HOME'];
    }

    return isAbsolutePath(directoryPath)
        ? directoryPath
        : Directory.current.uri.resolve(directoryPath).toString();
  }

  bool isAbsolutePath(String? path) {
    return path != null && path.startsWith('/');
  }
}
