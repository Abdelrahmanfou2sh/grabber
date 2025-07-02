import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:grabber/features/product/model/product_model.dart';

class SearchRepository {
  final String _baseUrl = 'https://dummyjson.com';
  SearchRepository();
  Future<List<Product>> searchProducts(String query) async {
    try {
      if (query.isEmpty) return [];

      final response = await http.get(
        Uri.parse('$_baseUrl/products/search?q=$query'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> productsJson = data['products'];

        return productsJson.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception(
          'Failed to search products: HTTP ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to search products: $e');
    }
  }
}
