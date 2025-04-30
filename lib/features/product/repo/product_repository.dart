import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/product_model.dart';
class ProductRepository {
  final FirebaseFirestore _firestore;

  ProductRepository(this._firestore);

  Future<List<Product>> getProducts() async {
    try {
      final QuerySnapshot snapshot = await _firestore.collection('products').get();
      return snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }
}