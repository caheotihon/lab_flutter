import 'package:cli/cli.dart';
import 'package:command_runner/command_runner.dart';

void main(List<String> arguments) async {
  // Khởi tạo file log có tên 'errors'
  final errorLogger = initFileLogger('errors');
  
  final app = CommandRunner(
    onOutput: (String output) async {
      await write(output, duration: 10);
    },
    onError: (Object error) {
      if (error is Error) {
        // Ghi lỗi nghiêm trọng vào file
        errorLogger.severe('[Error] ${error.toString()}\n${error.stackTrace}');
        throw error;
      }
      if (error is Exception) {
        // Ghi cảnh báo vào file
        errorLogger.warning(error);
      }
    },
  )
    ..addCommand(HelpCommand())
    // Truyền logger vào các lệnh sắp tạo
    ..addCommand(SearchCommand(logger: errorLogger))
    ..addCommand(GetArticleCommand(logger: errorLogger));

  app.run(arguments);
}