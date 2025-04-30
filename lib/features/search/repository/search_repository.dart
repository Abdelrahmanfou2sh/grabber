import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grabber/features/product/model/product_model.dart';

class SearchRepository {
  final FirebaseFirestore _firestore;
  SearchRepository(this._firestore);
  Future<List<Product>> searchProducts(String query) async {
    try {
      if (query.isEmpty) return [];

      final queryLower = query.toLowerCase().trim();
      final QuerySnapshot snapshot =
          await _firestore.collection('products').get();

      final List<Product> products =
          snapshot.docs
              .map((doc) => Product.fromFirestore(doc))
              .where(
                (product) =>
                    product.name.toLowerCase().trim().contains(queryLower) ||
                    product.description.toLowerCase().trim().contains(
                      queryLower,
                    ) ||
                    product.category.toLowerCase().trim().contains(queryLower),
              )
              .toList();

      // Sort results by relevance (exact matches first)
      products.sort((a, b) {
        final aNameMatch = a.name.toLowerCase().trim() == queryLower;
        final bNameMatch = b.name.toLowerCase().trim() == queryLower;
        if (aNameMatch && !bNameMatch) return -1;
        if (!aNameMatch && bNameMatch) return 1;
        return 0;
      });

      return products;
    } catch (e) {
      throw Exception('Failed to search products: $e');
    }
  }
}
