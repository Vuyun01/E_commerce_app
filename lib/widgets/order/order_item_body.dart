import 'package:ec_shop_app/providers/cart.dart' show CartItem;
import 'package:flutter/material.dart';

class OrderItemBody extends StatelessWidget {
  const OrderItemBody({
    super.key,
    required this.cartItem,
  });
  final CartItem cartItem;
  @override
  Widget build(BuildContext context) {
    return ListTile(
        dense: true,
        title: Text(
          cartItem.product.name,
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            'Total: \$${cartItem.product.price}',
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        trailing: Text(
          '${cartItem.quantity} x',
          style: Theme.of(context)
              .textTheme
              .bodyText2
              ?.copyWith(fontWeight: FontWeight.bold, fontSize: 14),
        ));
  }
}
