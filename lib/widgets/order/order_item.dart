import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../providers/order.dart' as ori;
import 'order_item_body.dart';
import 'order_item_card.dart';
import 'order_item_header.dart';

class OrderItem extends StatefulWidget {
  const OrderItem({super.key, required this.orderItem});

  final ori.OrderItem orderItem;

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _isExpanded = false;
  void _showMoreOrderInfo() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showMoreOrderInfo,
      child: OrderItemCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            OrderItemHeader(
              onChange: _showMoreOrderInfo,
              orderItem: widget.orderItem,
              isExpanded: _isExpanded,
            ),
            if (_isExpanded)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 10),
                    child: Text(
                      'Date: ${DateFormat.yMMMEd().add_jm().format(widget.orderItem.date)}',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          ?.copyWith(fontSize: 14),
                    ),
                  ),
                  ...widget.orderItem.cartItems
                      .map((e) => OrderItemBody(cartItem: e))
                ],
              )
          ],
        ),
      ),
    );
  }
}
