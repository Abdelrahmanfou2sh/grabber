import 'package:flutter/material.dart';
import '../model/product_model.dart';
import 'basket_bottom_sheet.dart';

class AddToCartBar extends StatelessWidget {
  const AddToCartBar({super.key, required this.cart});

  final List<Product> cart;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Container(
        width: double.infinity,
        height: 80,
        decoration: BoxDecoration(
          color: Color(0xCC0CA201),
          borderRadius: BorderRadius.circular(7),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 200,
              child: ListView.builder(
                itemCount: cart.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: ValueKey(cart[index].id),
                    onDismissed: (direction) {
                      cart.removeAt(index);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${cart[index].name} removed from cart',
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.network(cart[index].imageUrl),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(width: 2, height: 40, color: Colors.white),
            SizedBox(width: 10),
            InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder:
                      (context) => DraggableScrollableSheet(
                        initialChildSize: 0.6,
                        minChildSize: 0.4,
                        maxChildSize: 0.95,
                        builder:
                            (context, controller) => SingleChildScrollView(
                              controller: controller,
                              child: BasketBottomSheet(cart: cart),
                            ),
                      ),
                );
              },
              child: Text(
                "View Basket",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 5),
            Badge(
              label: Text(cart.length.toString()),
              child: Icon(Icons.add_shopping_cart, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
