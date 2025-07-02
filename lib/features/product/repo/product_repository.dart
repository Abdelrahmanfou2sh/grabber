import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/product_model.dart';

class ProductRepository {
  static const String baseUrl = 'https://dummyjson.com';

  Future<List<Product>> getProducts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/products'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> products = data['products'];
        return products.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  Future<List<Product>> getProductsByCategory(String category) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/products/category/$category'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> products = data['products'];
        return products.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products by category: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load products by category: $e');
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/products/search?q=$query'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> products = data['products'];
        return products.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to search products: $e');
    }
  }
}