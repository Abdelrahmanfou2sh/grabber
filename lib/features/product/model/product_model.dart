import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? discountPrice;
  final String imageUrl;
  final String category;
  final bool inStock;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.discountPrice,
    required this.imageUrl,
    required this.category,
    required this.inStock,
  });

  factory Product.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      discountPrice:
          data['discountPrice'] != null
              ? data['discountPrice'].toDouble()
              : null,
      imageUrl: data['imageUrl'] ?? '',
      category: data['category'] ?? '',
      inStock: data['inStock'] ?? true,
    );
  }
}
