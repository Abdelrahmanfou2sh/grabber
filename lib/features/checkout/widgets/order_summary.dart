import 'package:flutter/material.dart';

import '../../product/model/product_model.dart';

class OrderSummary extends StatelessWidget {
  const OrderSummary({
    super.key,
    required this.cart,
  });

  final List<Product> cart;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Order Summary (${cart.length} items)',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Icon(Icons.arrow_forward_ios),
      ],
    );
  }
}
