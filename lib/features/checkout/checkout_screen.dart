import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../product/cubit/cart_cubit.dart';
import 'widgets/order_summary.dart';
import 'widgets/payment_method.dart';
import '../payment/payment_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedDeliveryOption = 'priority';

  @override
  Widget build(BuildContext context) {
    final cartCubit = context.read<CartCubit>();
    final cart = cartCubit.state.cart;
    final totalPrice = cartCubit.state.totalPrice;

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Delivery Options',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              child: Column(
                children: [
                  RadioListTile<String>(
                    title: const Row(
                      children: [
                        Icon(Icons.flash_on),
                        SizedBox(width: 8),
                        Text('Priority (10 - 20 mins)'),
                      ],
                    ),
                    value: 'priority',
                    groupValue: _selectedDeliveryOption,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedDeliveryOption = value;
                        });
                      }
                    },
                  ),
                  RadioListTile<String>(
                    title: const Row(
                      children: [
                        Icon(Icons.access_time),
                        SizedBox(width: 8),
                        Text('Standard (30 - 45 mins)'),
                      ],
                    ),
                    value: 'standard',
                    groupValue: _selectedDeliveryOption,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedDeliveryOption = value;
                        });
                      }
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.schedule),
                    title: const Text('Schedule'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            OrderSummary(cart: cart),
            const SizedBox(height: 16),
            const Divider(),

            // Cost Breakdown
            _buildCostRow('Subtotal', totalPrice),
            _buildCostRow('Bag fee', 0.25),
            _buildCostRow('Service fee', 5.25),
            _buildCostRow('Delivery', 0.00),
            const Divider(),
            _buildCostRow('Total', totalPrice + 0.25 + 5.25, isBold: true),
            const SizedBox(height: 16),

            // Invoice Toggle
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Request an invoice'),
                  Switch(value: false, onChanged: (value) {}),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Payment Method
            const Text(
              'Payment method',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            PaymentMethod(
              text: 'Apple Pay',
              icon: Icons.arrow_forward_ios_outlined,
            ),
            const SizedBox(height: 24),

            // Place Order Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () async {
                  // منطق حفظ الطلب هنا (مثال توضيحي)
                  try {
                    // يمكنك استبدال هذا الجزء بمنطق الحفظ الفعلي للطلب
                    // await OrderRepository(...).placeOrder(...);
                    // بعد نجاح الحفظ، التوجيه إلى شاشة الدفع
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PaymentScreen(),
                      ),
                    );
                  } catch (e) {
                    // يمكنك عرض رسالة خطأ للمستخدم هنا
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('حدث خطأ أثناء حفظ الطلب: $e')),
                    );
                  }
                },
                child: const Text(
                  'Place Order',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCostRow(String label, double amount, {bool isBold = false}) {
    final style = TextStyle(
      fontSize: isBold ? 18 : 16,
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text('\$${amount.toStringAsFixed(2)}', style: style),
        ],
      ),
    );
  }
}
