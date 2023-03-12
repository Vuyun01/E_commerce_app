import 'package:flutter/material.dart';

import '../../providers/order.dart';

class OrderItemHeader extends StatelessWidget {
  const OrderItemHeader(
      {super.key,
      this.isExpanded = false,
      required this.orderItem,
      required this.onChange});
  final bool isExpanded;
  final VoidCallback onChange;
  final OrderItem orderItem;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
        title: Text(
          'Order: #${orderItem.id}',
          style: Theme.of(context).textTheme.headline3,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            'Total: \$${orderItem.totalPrice.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        trailing: IconButton(
            onPressed: onChange,
            icon: isExpanded
                ? const Icon(Icons.expand_more)
                : const Icon(Icons.expand_less)));
  }
}
