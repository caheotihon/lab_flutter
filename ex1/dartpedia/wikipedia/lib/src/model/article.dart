class Article {
  Article({required this.title, required this.extract});
  final String title;
  final String extract;

  static List<Article> listFromJson(Map<String, Object?> json) {
    final List<Article> articles = [];
    if (json case {'query': {'pages': final Map<String, Object?> pages}}) {
      for (var entry in pages.entries) {
        if (entry.value case {'title': final String title, 'extract': final String extract}) {
          articles.add(Article(title: title, extract: extract));
        }
      }
      return articles;
    }
    throw FormatException('Could not deserialize Article');
  }
}