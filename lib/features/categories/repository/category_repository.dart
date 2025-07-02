import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:grabber/features/categories/model/category_model.dart';

class CategoryRepository {
  final String _baseUrl = 'https://dummyjson.com';

  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/products/categories'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> categoriesJson = json.decode(response.body);
        return categoriesJson
            .map(
              (category) => CategoryModel(
                slug: category,
                name: category
                    .toString()
                    .split('-')
                    .map((word) => word[0].toUpperCase() + word.substring(1))
                    .join(' '),
                url: '$_baseUrl/products/category/$category',
              ),
            )
            .toList();
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load categories: $e');
    }
  }
}
