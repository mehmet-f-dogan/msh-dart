import 'dart:io';

import 'package:msh_dart/src/command_registry.dart';
import 'package:msh_dart/src/output_engine/output_engine.dart';
import 'package:msh_dart/src/util/util.dart';

class CommandParser {
  final CommandRegistry _commandRegistry = CommandRegistry();
  final OutputEngine _defaultOutputEngine;
  late OutputEngine _currentOutputEngine;
  late OutputEngine _currentOutputErrorEngine;

  CommandParser(this._defaultOutputEngine) {
    _currentOutputEngine = _defaultOutputEngine;
    _currentOutputErrorEngine = _defaultOutputEngine;
  }

  void run() {
    while (true) {
      resetEngines();
      printUserInputLine();
      var userInput = stdin.readLineSync();

      var (result, error) = handleUserInput(userInput);
      writeOutput(result, _currentOutputEngine);
      writeOutput(error, _currentOutputErrorEngine);
    }
  }

  void resetEngines() {
    _currentOutputEngine = _defaultOutputEngine;
    _currentOutputErrorEngine = _defaultOutputEngine;
  }

  void printUserInputLine() {
    _currentOutputEngine.write("\$ ");
  }

  (String?, String?) handleUserInput(String? userInput) {
    if (userInput == null || userInput.isEmpty) {
      return (null, "No command entered. Please try again.");
    }

    var (commandWord, args) = CommandParserUtils.extractCommandAndArgs(userInput);
    handleRedirection(args);
    return executeCommand(commandWord, args);
  }

  void handleRedirection(List<String?> args) {
    for (int i = 0; i < args.length; ++i) {
      var operatorType = args[i];
      bool isErrorStream = operatorType == "2>" || operatorType == "2>>";
      bool isAppendMode = operatorType == ">>" || operatorType == "1>>" || operatorType == "2>>";

      if (operatorType == "1>" || operatorType == ">" || operatorType == ">>" || operatorType == "1>>" || operatorType == "2>" || operatorType == "2>>") {
        if (i + 1 < args.length && args[i + 1] != null) {
          var targetFile = args[i + 1]!;
          redirectStream(targetFile, isErrorStream, isAppendMode);
          removeOperatorAndFileName(args, i);
        } else {
          writeOutput("Error: Missing target file for redirection.", _currentOutputErrorEngine);
        }
      }
    }
  }

  void redirectStream(String targetFile, bool isErrorStream, bool isAppendMode) {
    try {
      var outputEngine = FileOutputEngine(targetFile, append: isAppendMode);
      if (isErrorStream) {
        _currentOutputErrorEngine = outputEngine;
      } else {
        _currentOutputEngine = outputEngine;
      }
    } catch (e) {
      var errorMsg = "Error: Unable to redirect to file '$targetFile': $e";
      writeOutput(errorMsg, _currentOutputErrorEngine);
    }
  }

  static void removeOperatorAndFileName(List<String?> args, int i) {
    args.removeAt(i + 1);
    args.removeAt(i);
  }

  static void writeOutput(String? message, OutputEngine outputEngine) {
    if (message != null && message.isNotEmpty) {
      outputEngine.writeLine(message);
    }
  }

  (String?, String?) executeCommand(String commandWord, List<String?> args) {
    if (_commandRegistry.isInCommandRegistry(commandWord)) {
      return _commandRegistry.executeShellBuiltInCommand(commandWord, args);
    }

    return _commandRegistry.executeExternalProgramCommand(commandWord, args);
  }
}
