import 'dart:io';

import 'package:msh_dart/src/output_engine/output_engine.dart';

class ConsoleOutputEngine implements OutputEngine{
  final IOSink _currentWriter = stdout;

  @override
  void write(String message) {
    _currentWriter.write(message);
  }

  @override
  void writeLine(String message) {
    _currentWriter.writeln(message);
  }
}