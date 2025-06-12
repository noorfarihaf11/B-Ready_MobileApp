class Product {
  final int id; // pakai uuid dari Supabase
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      imageUrl: map['imageUrl'] ?? 'assets/images/placeholder.jpg',
    );
  }
}
