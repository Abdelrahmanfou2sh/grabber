import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/cart_cubit.dart';
import '../../model/product_model.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Image.network(product.thumbnail, height: 200)),
            const SizedBox(height: 20),
            Text(
              product.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            if (product.discountPercentage != null)
              Row(
                children: [
                  Text(
                    '\$${product.discountPercentage}',
                    style: const TextStyle(fontSize: 20, color: Colors.green),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '\$${product.price}',
                    style: const TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey,
                    ),
                  ),
                ],
              )
            else
              Text(
                '\$${product.price}',
                style: const TextStyle(fontSize: 20, color: Colors.black),
              ),
            const SizedBox(height: 10),
            Text(product.description),
            const SizedBox(height: 20),
            Text(
              product.stock > 0 ? "In stock" : "Out of stock",
              style: TextStyle(
                color: product.stock > 0 ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    product.stock > 0
                        ? () {
                          final cartCubit = context.read<CartCubit>();
                          cartCubit.toggleCart(product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${product.title} added to cart'),
                            ),
                          );
                        }
                        : null,
                child: Text("Add to Cart"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
