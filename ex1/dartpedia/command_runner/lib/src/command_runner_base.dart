import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'arguments.dart';
import 'exceptions.dart';

class CommandRunner {
  // Constructor nhận thêm một hàm callback xử lý lỗi tùy chọn
  CommandRunner({this.onOutput, this.onError});

  final Map<String, Command> _commands = <String, Command>{};
  FutureOr<void> Function(String)? onOutput;
  FutureOr<void> Function(Object)? onError;

  UnmodifiableSetView<Command> get commands =>
      UnmodifiableSetView<Command>(<Command>{..._commands.values});

  Future<void> run(List<String> input) async {
    try {
      final ArgResults results = parse(input);
      if (results.command != null) {
        Object? output = await results.command!.run(results);
        
        // SỬ DỤNG ONOUTPUT NẾU CÓ, NẾU KHÔNG THÌ PRINT BÌNH THƯỜNG
        if (onOutput != null) {
          await onOutput!(output.toString());
        } else {
          print(output.toString());
        }
      }
    } on Exception catch (exception) {
      if (onError != null) {
        onError!(exception);
      } else {
        rethrow;
      }
    }
  }

  void addCommand(Command command) {
    _commands[command.name] = command;
    command.runner = this;
  }

  ArgResults parse(List<String> input) {
    ArgResults results = ArgResults();
    if (input.isEmpty) return results;

    // Kiểm tra lệnh đầu tiên có hợp lệ không
    if (_commands.containsKey(input.first)) {
      results.command = _commands[input.first];
      input = input.sublist(1);
    } else {
      throw ArgumentException(
        'The first word of input must be a command.',
        null,
        input.first,
      );
    }

    // Xử lý Options và Flags
    Map<Option, Object?> inputOptions = {};
    int i = 0;
    while (i < input.length) {
      if (input[i].startsWith('-')) {
        var base = _removeDash(input[i]);
        
        // Tìm option tương ứng, nếu không thấy thì báo lỗi Unknown option
        var option = results.command!.options.firstWhere(
          (option) => option.name == base || option.abbr == base,
          orElse: () {
            throw ArgumentException(
              'Unknown option ${input[i]}',
              results.command!.name,
              input[i],
            );
          },
        );

        if (option.type == OptionType.flag) {
          inputOptions[option] = true;
          i++;
          continue;
        }

        if (option.type == OptionType.option) {
          // Kiểm tra xem option có giá trị đi kèm không
          if (i + 1 >= input.length || input[i + 1].startsWith('-')) {
            throw ArgumentException(
              'Option ${option.name} requires an argument',
              results.command!.name,
              option.name,
            );
          }
          inputOptions[option] = input[i + 1];
          i++;
        }
      } else {
        // Xử lý đối số vị trí (positional argument)
        if (results.commandArg != null) {
          throw ArgumentException(
            'Commands can only have up to one argument.',
            results.command!.name,
            input[i],
          );
        }
        results.commandArg = input[i];
      }
      i++;
    }
    results.options = inputOptions;
    return results;
  }

  String _removeDash(String input) {
    if (input.startsWith('--')) return input.substring(2);
    if (input.startsWith('-')) return input.substring(1);
    return input;
  }

  String get usage {
    final exeFile = Platform.script.path.split('/').last;
    return 'Usage: dart bin/$exeFile <command> [commandArg?] [...options?]';
  }
}