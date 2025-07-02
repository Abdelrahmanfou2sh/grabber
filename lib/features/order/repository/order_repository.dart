import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/order_model.dart';

class OrderRepository {
  final SharedPreferences _prefs;

  OrderRepository(this._prefs);
  Future<void> placeOrder({
    required List<Map<String, dynamic>> products,
    required double totalPrice,
    required String paymentMethod,
    required String deliveryOption,
  }) async {
    try {
      final orderId = DateTime.now().millisecondsSinceEpoch.toString();
      final order = OrderModel(
        id: orderId,
        products: products,
        totalPrice: totalPrice,
        paymentMethod: paymentMethod,
        deliveryOption: deliveryOption,
        createdAt: DateTime.now(),
      );
      
      final List<String> existingOrders = _prefs.getStringList('orders') ?? [];
      existingOrders.add(jsonEncode(order.toMap()));
      await _prefs.setStringList('orders', existingOrders);
    } catch (e) {
      throw Exception('No Orders : $e');
    }
  }
}
