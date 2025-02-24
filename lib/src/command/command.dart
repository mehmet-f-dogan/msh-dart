library;

export 'cat.dart';
export 'cd.dart';
export 'echo.dart';
export 'exit.dart';
export 'pwd.dart';
export 'type.dart';

abstract class Command {
  (String? output, String? error) execute(List<String?> args);
}
