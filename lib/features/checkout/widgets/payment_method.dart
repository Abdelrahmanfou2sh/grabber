import 'package:flutter/material.dart';

class PaymentMethod extends StatelessWidget {
  const PaymentMethod({
    super.key,
    required this.text,
    required this.icon,
  });

  final String text;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.network(
          'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b0/Apple_Pay_logo.svg/1200px-Apple_Pay_logo.svg.png',
          height: 32,
        ),
        title: Text(text),
        trailing: Icon(icon),
        onTap: () {},
      ),
    );
  }
}