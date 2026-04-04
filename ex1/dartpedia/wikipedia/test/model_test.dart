import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';
import 'package:wikipedia/src/model/article.dart';
import 'package:wikipedia/src/model/search_results.dart';
import 'package:wikipedia/src/model/summary.dart';

// Khai báo đường dẫn file dữ liệu mẫu
const String dartLangSummaryJson = './test/test_data/dart_lang_summary.json';
const String catExtractJson = './test/test_data/cat_extract.json';
const String openSearchResponse = './test/test_data/open_search_response.json';

void main() {
  group('Kiểm tra giải mã JSON từ Wikipedia API', () {
    
    // Test 1: Kiểm tra Summary model
    test('Giải mã Summary của trang Dart (Programming Language)', () async {
      final input = await File(dartLangSummaryJson).readAsString();
      final map = jsonDecode(input) as Map<String, Object?>;
      final summary = Summary.fromJson(map);
      
      expect(summary.titles.canonical, 'Dart_(programming_language)');
    });

    // Test 2: Kiểm tra Article model
    test('Giải mã danh sách Article từ dữ liệu mẫu Cat', () async {
      final input = await File(catExtractJson).readAsString();
      final map = jsonDecode(input) as Map<String, Object?>;
      final articles = Article.listFromJson(map);
      
      expect(articles.first.title.toLowerCase(), 'cat');
    });

    // Test 3: Kiểm tra SearchResults model
    test('Giải mã SearchResults từ Open Search API', () async {
      final input = await File(openSearchResponse).readAsString();
      final list = jsonDecode(input) as List<Object?>;
      final results = SearchResults.fromJson(list);
      
      expect(results.results.length, greaterThan(1));
      expect(results.searchTerm, 'dart');
    });
  });
}