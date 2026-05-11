class Food {
  final String id;
  final String name;
  final String description;
  final double price;
  final String image;
  final String categoryId;

  Food({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.categoryId,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['_id'],
      name: json['name'],
      description: json['description'] ?? '',
      price: (json['price'] as num).toDouble(),
      image: json['image'],
      categoryId: json['category'],
    );
  }
}
