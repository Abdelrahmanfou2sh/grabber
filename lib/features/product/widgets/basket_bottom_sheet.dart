import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../model/product_model.dart';

class BasketBottomSheet extends StatelessWidget {
  final List<Product> cart;

  const BasketBottomSheet({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    double totalPrice = cart.fold(0, (sum, item) => sum + item.price);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 4,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Your Basket',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ...cart.map(
            (product) => ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(product.imageUrl),
              ),
              title: Text(product.name),
              subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
              trailing: InkWell(
                onTap: () => cart.remove(product),
                child: Icon(Icons.delete_outline),
              ),
            ),
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                '\$${totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () {
                context.push('/checkout', extra: cart);
              },
              child: const Text(
                'Proceed to Checkout',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
