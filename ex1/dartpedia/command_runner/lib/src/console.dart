import 'dart:io';

const String ansiEscapeLiteral = '\x1B';

/// In từng dòng một với khoảng chờ [duration] giữa các dòng.
Future<void> write(String text, {int duration = 50}) async {
  final List<String> lines = text.split('\n');
  for (final String l in lines) {
    await _delayedPrint('$l \n', duration: duration);
  }
}

Future<void> _delayedPrint(String text, {int duration = 0}) async {
  return Future<void>.delayed(
    Duration(milliseconds: duration),
    () => stdout.write(text),
  );
}

/// Enum nâng cao để quản lý màu sắc Console bằng mã RGB
enum ConsoleColor {
  lightBlue(184, 234, 254),
  red(242, 93, 80),
  yellow(249, 248, 196),
  grey(240, 240, 240),
  white(255, 255, 255);

  const ConsoleColor(this.r, this.g, this.b);

  final int r;
  final int g;
  final int b;

  String get enableForeground => '$ansiEscapeLiteral[38;2;$r;$g;${b}m';
  String get enableBackground => '$ansiEscapeLiteral[48;2;$r;$g;${b}m';
  static String get reset => '$ansiEscapeLiteral[0m';

  /// Áp dụng màu chữ cho đoạn văn bản và tự động reset sau đó
  String applyForeground(String text) {
    return '$ansiEscapeLiteral[38;2;$r;$g;${b}m$text$reset';
  }

  String applyBackground(String text) {
    return '$ansiEscapeLiteral[48;2;$r;$g;${b}m$text$reset';
  }
}

extension TextRenderUtils on String {
  // Getters để áp dụng màu nhanh
  String get errorText => ConsoleColor.red.applyForeground(this);
  String get instructionText => ConsoleColor.yellow.applyForeground(this);
  String get titleText => ConsoleColor.lightBlue.applyForeground(this);

  // Hàm hỗ trợ tự động xuống dòng khi văn bản quá dài
  List<String> splitLinesByLength(int length) {
    final List<String> words = split(' ');
    final List<String> output = <String>[];
    final StringBuffer strBuffer = StringBuffer();
    
    for (int i = 0; i < words.length; i++) {
      final String word = words[i];
      if (strBuffer.length + word.length <= length) {
        strBuffer.write(word.trim());
        if (strBuffer.length + 1 <= length) strBuffer.write(' ');
      }
      
      if (i + 1 < words.length &&
          words[i + 1].length + strBuffer.length + 1 > length) {
        output.add(strBuffer.toString().trim());
        strBuffer.clear();
      }
    }
    output.add(strBuffer.toString().trim());
    return output;
  }
}