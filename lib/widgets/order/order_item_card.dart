import 'package:flutter/material.dart';

class OrderItemCard extends StatelessWidget {
  const OrderItemCard({super.key, required this.child});

  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 5),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Colors.black26)),
      child: child,
    );
  }
}
