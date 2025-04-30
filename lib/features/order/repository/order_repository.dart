import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/order_model.dart';

class OrderRepository {
  final FirebaseFirestore _firestore;

  OrderRepository(this._firestore);
  Future<void> placeOrder({required List<Map<String, dynamic>> products,
    required double totalPrice,
    required String paymentMethod,
    required String deliveryOption,}) async {
    try {
      final order = OrderModel(
        id: _firestore.collection('orders').doc().id,
        products: products,
        totalPrice: totalPrice,
        paymentMethod: paymentMethod,
        deliveryOption: deliveryOption,
        createdAt: DateTime.now(),
      );
      await _firestore.collection('orders').doc(order.id).set(order.toMap());
    } catch (e) {
      throw Exception('No Orders : $e');
    }
  }}