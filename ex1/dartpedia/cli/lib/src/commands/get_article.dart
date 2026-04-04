import 'dart:async';
import 'dart:io';
import 'package:command_runner/command_runner.dart';
import 'package:logging/logging.dart';
import 'package:wikipedia/wikipedia.dart';

class GetArticleCommand extends Command {
  GetArticleCommand({required this.logger});

  final Logger logger;

  @override
  String get description => 'Đọc một bài viết từ Wikipedia';

  @override
  String get name => 'article';

  @override
  String get defaultValue => 'cat';

  @override
  String get valueHelp => 'TÊN_BÀI_VIẾT';

  @override
  FutureOr<String> run(ArgResults args) async {
    try {
      var title = args.commandArg ?? defaultValue;
      final articles = await getArticleByTitle(title);
      final article = articles.first;
      
      final buffer = StringBuffer('\n=== ${article.title.titleText} ===\n\n');
      // Lấy 500 từ đầu tiên của bài viết
      buffer.write(article.extract.split(' ').take(500).join(' '));
      buffer.write('...\n');
      
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