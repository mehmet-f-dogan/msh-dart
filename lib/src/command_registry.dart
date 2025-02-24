import 'dart:collection';
import 'dart:io';

import 'package:msh_dart/src/command/command.dart';
import 'package:msh_dart/src/util/util.dart';

class CommandRegistry {
  final Map<String, Command> _commands;

  CommandRegistry()
      : _commands = HashMap<String, Command>(equals: caseInsensitive) {
    _commands["cat"] = Cat();
    _commands["cd"] = Cd();
    _commands["echo"] = Echo();
    _commands["exit"] = Exit();
    _commands["pwd"] = Pwd();
    _commands["type"] = Type(this);
  }

  static bool Function(String, String) get caseInsensitive =>
      (a, b) => a.toLowerCase() == b.toLowerCase();

  (String? output, String? error) executeShellBuiltInCommand(
      String? commandWord, List<String?> args) {
    if (commandWord == null) return (null, null);

    Command? command = _commands[commandWord];

    if (command == null) {
      return (null, "command not found: $commandWord");
    }
    return command.execute(args);
  }

  bool isInCommandRegistry(String? commandWord) {
    return commandWord != null &&
        commandWord.trim().isNotEmpty &&
        _commands.containsKey(commandWord);
  }

  bool isShellBuiltInCommand(String? commandWord) {
    return commandWord != null &&
        commandWord.isNotEmpty &&
        commandWord != 'cat' &&
        _commands.containsKey(commandWord);
  }

  (String?, String?) executeExternalProgramCommand(
      String executable, List<String?> args) {
    String? executablePath = PathResolver.findExecutableInPath(executable);
    if (executablePath == null) {
      return (null, "$executable: command not found");
    }

    try {
      var result = Process.runSync(
        executablePath,
        args.whereType<String>().toList(),
        runInShell: false,
      );

      var output = result.stdout.toString().trim();
      var error = result.stderr.toString().trim();

      if (error.isNotEmpty) {
        return (null, error);
      }

      return (output, null);
    } catch (e) {
      return (null, e.toString());
    }
  }
}
