import 'package:msh_dart/src/command_parser.dart';
import 'package:msh_dart/src/output_engine/output_engine.dart';

void run() {
  OutputEngine outputEngine = new ConsoleOutputEngine();
  var parser = new CommandParser(outputEngine);
  parser.run();
}
