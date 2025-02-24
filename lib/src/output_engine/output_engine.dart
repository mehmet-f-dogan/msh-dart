library;

export 'file_output_engine.dart';
export 'console_output_engine.dart';

abstract class OutputEngine {
  void write(String message);
  void writeLine(String message);
}
