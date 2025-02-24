class CommandParserUtils {
  static const String whitespace = ' ';
  static const String singleQuote = "'";
  static const String doubleQuote = '"';
  static const String backslash = '\\';

  static String _currentWord = '';
  static bool _inSingleQuote = false;
  static bool _inDoubleQuote = false;
  static bool _hasBackslash = false;

  static (String commandWord, List<String?> args) extractCommandAndArgs(String? userInput) {
    if (userInput == null) {
      throw ArgumentError("userInput cannot be null");
    }

    List<String?> args = parseArguments(userInput);
    String commandWord = extractCommandWordFromArgs(args)!;

    return (commandWord, args);
  }

  static List<String?> parseArguments(String userInput) {
    List<String?> args = [];

    for (int i = 0; i < userInput.length; i++) {
      String c = userInput[i];

      switch (c) {
        case whitespace:
          handleWhitespace(args);
          break;
        case singleQuote:
          handleSingleQuote();
          break;
        case doubleQuote:
          handleDoubleQuote();
          break;
        case backslash:
          handleBackslash();
          break;
        default:
          handleDefaultChar(c);
          break;
      }
    }

    addRemainingWord(args);
    return args;
  }

  static void handleWhitespace(List<String?> args) {
    if (_hasBackslash && _inDoubleQuote) {
      _currentWord += backslash;
    }

    if (_hasBackslash || _inSingleQuote || _inDoubleQuote) {
      _currentWord += whitespace;
    } else {
      addRemainingWord(args);
    }

    _hasBackslash = false;
  }

  static void handleSingleQuote() {
    if (_hasBackslash && _inDoubleQuote) {
      _currentWord += backslash;
    }

    if (_hasBackslash || _inDoubleQuote) {
      _currentWord += singleQuote;
    } else {
      _inSingleQuote = !_inSingleQuote;
    }

    _hasBackslash = false;
  }

  static void handleDoubleQuote() {
    if (_inSingleQuote || _hasBackslash) {
      _currentWord += doubleQuote;
    } else {
      _inDoubleQuote = !_inDoubleQuote;
    }

    _hasBackslash = false;
  }

  static void handleBackslash() {
    if (_hasBackslash || _inSingleQuote) {
      _currentWord += backslash;
      _hasBackslash = false;
    } else {
      _hasBackslash = true;
    }
  }

  static void handleDefaultChar(String c) {
    if (_hasBackslash && _inDoubleQuote) {
      _currentWord += backslash;
    }

    _currentWord += c;
    _hasBackslash = false;
  }

  static void addRemainingWord(List<String?> args) {
    if (_currentWord.isEmpty) return;
    args.add(_currentWord);
    _currentWord = '';
  }

  static String? extractCommandWordFromArgs(List<String?> args) {
    if (args.isEmpty) return null;
    String? commandWord = args[0];
    args.removeAt(0);
    return commandWord;
  }
}
