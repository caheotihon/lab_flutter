import 'dart:async';
import 'dart:io';
import 'package:command_runner/command_runner.dart';
import 'package:logging/logging.dart';
import 'package:wikipedia/wikipedia.dart';

class SearchCommand extends Command {
  SearchCommand({required this.logger}) {
    addFlag(
      'im-feeling-lucky',
      help: 'Nếu bật, sẽ in luôn phần tóm tắt của bài viết đầu tiên tìm được.',
    );
  }

  final Logger logger;

  @override
  String get description => 'Tìm kiếm các bài viết trên Wikipedia.';

  @override
  bool get requiresArgument => true;

  @override
  String get name => 'search';

  @override
  String get valueHelp => 'TỪ_KHÓA';

  @override
  FutureOr<String> run(ArgResults args) async {
    if (requiresArgument && (args.commandArg == null || args.commandArg!.isEmpty)) {
      return 'Vui lòng nhập từ khóa tìm kiếm';
    }

    final buffer = StringBuffer('Kết quả tìm kiếm:\n');
    try {
      final results = await search(args.commandArg!);

      // Tính năng I'm feeling lucky
      if (args.flag('im-feeling-lucky') && results.results.isNotEmpty) {
        final title = results.results.first.title;
        final article = await getArticleSummaryByTitle(title);
        buffer.writeln('\n--- Chúc mừng, bạn đã may mắn! ---');
        buffer.writeln(article.titles.normalized.titleText);
        if (article.description != null) buffer.writeln(article.description);
        buffer.writeln('\n${article.extract}\n');
        buffer.writeln('--- Các kết quả khác ---');
      }

      for (var result in results.results) {
        buffer.writeln('${result.title} - ${result.url}');
      }
      return buffer.toString();
    } on HttpException catch (e) {
      logger..warning(e.message)..warning(e.uri)..info(usage);
      return 'Lỗi mạng: ${e.message}';
    } on FormatException catch (e) {
      logger..warning(e.message)..warning(e.source)..info(usage);
      return 'Lỗi định dạng dữ liệu: ${e.message}';
    }
  }
}