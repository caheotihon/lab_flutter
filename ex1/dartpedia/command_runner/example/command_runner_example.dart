import 'dart:async';
import 'package:command_runner/command_runner.dart';

class PrettyEcho extends Command {
  @override
  String get name => 'echo';

  @override
  String get description => 'In ra văn bản với nhiều màu sắc khác nhau.';

  @override
  FutureOr<String> run(ArgResults arg) {
    if (arg.commandArg == null) {
      throw ArgumentException('Lệnh này yêu cầu một đoạn văn bản đi kèm!', name);
    }

    List<String> prettyWords = [];
    var words = arg.commandArg!.split(' ');
    
    for (var i = 0; i < words.length; i++) {
      var word = words[i];
      // Xoay vòng màu sắc cho từng từ
      switch (i % 3) {
        case 0: prettyWords.add(word.titleText); break;
        case 1: prettyWords.add(word.instructionText); break;
        case 2: prettyWords.add(word.errorText); break;
      }
    }
    return prettyWords.join(' ');
  }
}

void main(List<String> arguments) {
  final runner = CommandRunner()..addCommand(PrettyEcho());
  runner.run(arguments);
}