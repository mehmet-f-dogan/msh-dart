import 'package:msh_dart/src/command/command.dart';
import 'package:msh_dart/src/command_registry.dart';
import 'package:msh_dart/src/util/util.dart';

class Type implements Command {
  final CommandRegistry _commandRegistry;

  Type(this._commandRegistry);

  @override
  (String?, String?) execute(List<String?> args) {
    String? output;
    String? error;
    var commandToCheck = args[0];

    if (_commandRegistry.isShellBuiltInCommand(commandToCheck)) {
      output = "$commandToCheck is a shell builtin";
    } else {
      String? executablePath =
          PathResolver.findExecutableInPath(commandToCheck);
      if (executablePath != null) {
        output = "$commandToCheck is {executablePath}";
      } else {
        error = "$commandToCheck: not found";
      }
    }
    return (output, error);
  }
}
