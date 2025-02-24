import 'package:msh_dart/src/command/command.dart';

class Echo implements Command {
  @override
  (String?, String?) execute(List<String?> args) {
    var output = args.join(" ");
    return (output, null);
  }
}
