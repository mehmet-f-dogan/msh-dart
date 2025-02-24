library;

abstract class Command {
  (String? output, String? error) execute(List<String?> args);
}
