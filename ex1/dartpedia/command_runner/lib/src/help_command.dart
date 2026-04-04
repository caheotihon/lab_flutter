import 'dart:async';
import 'arguments.dart';
import 'console.dart';
import 'exceptions.dart';

class HelpCommand extends Command {
  HelpCommand() {
    addFlag(
      'verbose',
      abbr: 'v',
      help: 'Khi bật, sẽ in chi tiết tất cả các lệnh và tùy chọn của chúng.',
    );
    addOption(
      'command',
      abbr: 'c',
      help: 'In hướng dẫn chi tiết cho một lệnh cụ thể.',
    );
  }

  @override
  String get name => 'help';

  @override
  String get description => 'In thông tin hướng dẫn sử dụng ra màn hình.';

  @override
  FutureOr<String> run(ArgResults args) async {
    final buffer = StringBuffer();
    // In dòng hướng dẫn chung với màu tiêu đề (Light Blue)
    buffer.writeln(runner.usage.titleText);

    // Trường hợp 1: Người dùng gõ --verbose hoặc -v
    if (args.flag('verbose')) {
      for (var cmd in runner.commands) {
        buffer.write(_renderCommandVerbose(cmd));
      }
      return buffer.toString();
    }

    // Trường hợp 2: Người dùng muốn xem chi tiết một lệnh cụ thể (--command=...)
    if (args.hasOption('command')) {
      var (:option, :input) = args.getOption('command');

      var cmd = runner.commands.firstWhere(
        (command) => command.name == input,
        orElse: () {
          throw ArgumentException(
            'Lệnh "$input" không tồn tại trong hệ thống.',
          );
        },
      );
      return _renderCommandVerbose(cmd);
    }

    // Trường hợp 3: In danh sách lệnh cơ bản
    for (var command in runner.commands) {
      buffer.writeln(command.usage);
    }

    return buffer.toString();
  }

  // Hàm hỗ trợ in chi tiết một lệnh
  String _renderCommandVerbose(Command cmd) {
    final indent = ' ' * 4;
    final buffer = StringBuffer();
    buffer.writeln('\n${cmd.usage.instructionText}'); // Tên lệnh màu vàng
    buffer.writeln('$indent Mô tả: ${cmd.help ?? cmd.description}');
    
    if (cmd.valueHelp != null) {
      buffer.writeln(
        '$indent [Đối số] Bắt buộc: ${cmd.requiresArgument}, Kiểu: ${cmd.valueHelp}, Mặc định: ${cmd.defaultValue ?? 'không có'}',
      );
    }

    if (cmd.options.isNotEmpty) {
      buffer.writeln('$indent Tùy chọn (Options):');
      for (var option in cmd.options) {
        buffer.writeln('$indent   ${option.usage}');
      }
    }
    return buffer.toString();
  }
}