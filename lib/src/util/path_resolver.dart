import 'dart:io';

class PathResolver {
  static String? findExecutableInPath(String? executableName) {
    if (executableName == null) return null;

    String? pathEnv = Platform.environment['PATH'];
    if (pathEnv == null || pathEnv.isEmpty) {
      print("PATH environment variable is not set");
      return null;
    }

    List<String> pathDirectories = pathEnv.split(Platform.isWindows ? ';' : ':');
    for (var directory in pathDirectories) {
      var fullPath = Uri.file(directory).resolve(executableName).toFilePath();
      if (File(fullPath).existsSync()) {
        return fullPath;
      }
    }
    return null;
  }
}
