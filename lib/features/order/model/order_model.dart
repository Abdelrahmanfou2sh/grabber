class OrderModel {
  final String id;
  final List<Map<String, dynamic>> products;
  final double totalPrice;
  final String paymentMethod;
  final String deliveryOption;
  final DateTime createdAt;
  OrderModel({
    required this.id,
    required this.products,
    required this.totalPrice,
    required this.paymentMethod,
    required this.deliveryOption,
    required this.createdAt,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'products': products,
      'totalPrice': totalPrice,
      'paymentMethod': paymentMethod,
      'deliveryOption': deliveryOption,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
