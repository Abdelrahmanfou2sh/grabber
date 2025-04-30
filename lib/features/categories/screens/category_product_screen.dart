import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../product/cubit/products_cubit.dart';
import '../../product/widgets/screens/product_details_screen.dart';

class CategoryProductsScreen extends StatelessWidget {
  final String category;

  const CategoryProductsScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(category)),
      body: BlocBuilder<ProductsCubit, ProductsState>(
        builder: (context, state) {
          if (state is ProductsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductsLoaded) {
            final filteredProducts =
                state.products
                    .where((product) => product.category == category)
                    .toList();

            if (filteredProducts.isEmpty) {
              return const Center(child: Text('لا يوجد منتجات هنا'));
            }
            return ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return ListTile(
                  leading: Image.network(
                    product.imageUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(product.name),
                  subtitle: Text('\$${product.discountPrice ?? product.price}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => ProductDetailsScreen(product: product),
                      ),
                    );
                  },
                );
              },
            );
          } else if (state is ProductsError) {
            return Center(child: Text('Error Occured: ${state.message}'));
          } else {
            return const Center(child: Text('No products available'));
          }
        },
      ),
    );
  }
}
