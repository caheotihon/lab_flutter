import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../model/article.dart';

Future<List<Article>> getArticleByTitle(String title) async {
  final client = http.Client();
  try {
    final url = Uri.https(
      'en.wikipedia.org',
      '/w/api.php',
      {
        'action': 'query',
        'format': 'json',
        'titles': title.trim(),
        'prop': 'extracts',
        'explaintext': '', // Cần để trống để nhận văn bản thuần thay vì HTML
      },
    );
    final response = await client.get(url);
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as Map<String, Object?>;
      return Article.listFromJson(jsonData);
    } else {
      throw HttpException('Lỗi lấy bài viết: ${response.statusCode}');
    }
  } finally {
    client.close();
  }
}