import 'dart:io';

import 'package:msh_dart/src/output_engine/output_engine.dart';

class FileOutputEngine implements OutputEngine {
  final File _file;
  late IOSink _fileWriter;

  FileOutputEngine(String filePath, {bool append = false})
      : _file = File(filePath) {
    _fileWriter = _file.openWrite(mode: append ? FileMode.append : FileMode.write);
  }

  @override
  void write(String message) {
    _fileWriter.write(message);
  }

  @override
  void writeLine(String message) {
    _fileWriter.writeln(message);
  }

  void close() {
    _fileWriter.close();
  }
}