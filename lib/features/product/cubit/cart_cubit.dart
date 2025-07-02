import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../model/product_model.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  static const String baseUrl = 'https://dummyjson.com';
  CartCubit() : super(const CartState(cart: [], totalPrice: 0));

  Future<void> fetchUserCart(int userId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/carts/user/$userId'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> products = data['carts'][0]['products'];
        final List<Product> cartProducts = await Future.wait(
          products.map((product) => _fetchProductDetails(product['id'] as int)),
        );
        _emitCart(cartProducts);
      } else {
        throw Exception('Failed to load cart: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load cart: $e');
    }
  }

  Future<Product> _fetchProductDetails(int productId) async {
    final response = await http.get(Uri.parse('$baseUrl/products/$productId'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return Product.fromJson(data);
    } else {
      throw Exception('Failed to load product details: ${response.statusCode}');
    }
  }

  List<Product> get cart => state.cart;

  void toggleCart(Product product) {
    final currentCart = List<Product>.from(state.cart);
    if (currentCart.contains(product)) {
      currentCart.remove(product);
    } else {
      currentCart.add(product);
    }
    _emitCart(currentCart);
  }

  void addToCart(Product product) {
    final currentCart = List<Product>.from(state.cart);
    if (!currentCart.contains(product)) {
      currentCart.add(product);
      _emitCart(currentCart);
    }
  }

  void removeFromCart(Product product) {
    final currentCart = List<Product>.from(state.cart);
    if (currentCart.contains(product)) {
      currentCart.remove(product);
      _emitCart(currentCart);
    }
  }

  void clearCart() {
    _emitCart([]);
  }

  bool isInCart(Product product) => state.cart.contains(product);

  void _emitCart(List<Product> updatedCart) {
    emit(
      CartState(cart: updatedCart, totalPrice: _calculateTotal(updatedCart)),
    );
  }

  double _calculateTotal(List<Product> cart) {
    return cart.fold(
      0.0,
      (total, product) => total + (product.price * (1 - product.discountPercentage / 100)),
    );
  }
}
