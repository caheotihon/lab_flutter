class SearchResult {
  SearchResult({required this.title, required this.url});
  final String title;
  final String url;
}

class SearchResults {
  SearchResults(this.results, {this.searchTerm});
  final List<SearchResult> results;
  final String? searchTerm;

  static SearchResults fromJson(List<Object?> json) {
    final List<SearchResult> results = [];
    if (json case [String searchTerm, Iterable titles, Iterable _, Iterable urls]) {
      final tList = titles.toList();
      final uList = urls.toList();
      for (int i = 0; i < titles.length; i++) {
        results.add(SearchResult(title: tList[i], url: uList[i]));
      }
      return SearchResults(results, searchTerm: searchTerm);
    }
    throw FormatException('Could not deserialize SearchResults');
  }

  @override
  String toString() => '\nKết quả tìm kiếm cho "$searchTerm": \n${results.map((r) => r.url).join('\n')}';
}