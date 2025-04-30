import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grabber/features/categories/model/category_model.dart';

class CategoryRepository {
  final FirebaseFirestore _firestore;

  CategoryRepository(this._firestore);
  Future<List<CategoryModel>> getCategories() async {
    try {
      final snapshot = await _firestore.collection('categories').get();
      return snapshot.docs
          .map((doc) => CategoryModel.fromFirestore(doc))
          .toList();
    } on Exception catch (e) {
      throw Exception('Failed to load categories: $e');
    }
  }
}
