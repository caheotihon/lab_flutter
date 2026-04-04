import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../model/summary.dart';

// Hàm lấy tóm tắt của một bài viết ngẫu nhiên
Future<Summary> getRandomArticleSummary() async {
  final client = http.Client();
  try {
    final url = Uri.https('en.wikipedia.org', '/api/rest_v1/page/random/summary');
    final response = await client.get(url);
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as Map<String, Object?>;
      return Summary.fromJson(jsonData);
    } else {
      throw HttpException('Lỗi kết nối: ${response.statusCode}');
    }
  } finally {
    client.close();
  }
}

// Hàm lấy tóm tắt của bài viết theo tên
Future<Summary> getArticleSummaryByTitle(String articleTitle) async {
  final client = http.Client();
  try {
    final url = Uri.https('en.wikipedia.org', '/api/rest_v1/page/summary/$articleTitle');
    final response = await client.get(url);
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as Map<String, Object?>;
      return Summary.fromJson(jsonData);
    } else {
      throw HttpException('Lỗi kết nối: ${response.statusCode}');
    }
  } finally {
    client.close();
  }
}