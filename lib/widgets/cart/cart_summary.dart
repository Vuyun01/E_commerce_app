import 'package:ec_shop_app/providers/order.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/cart.dart';

class CartSummary extends StatelessWidget {
  const CartSummary({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  Widget build(BuildContext context) {
    print('Cart summary rebuild');
    final order = Provider.of<Order>(context, listen: false);
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Colors.black26)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Row(
          children: <Widget>[
            Text(
              'Total: ',
              style: Theme.of(context).textTheme.headline3,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Chip(
                backgroundColor: Theme.of(context).colorScheme.primary,
                label: Text(
                  '\$${cart.totalPrice.toStringAsFixed(2)}',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      ?.copyWith(color: Colors.white),
                ),
              ),
            ),
            const Spacer(),
            OrderButton(order: order, cart: cart),
          ],
        ),
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.order,
    required this.cart,
  }) : super(key: key);

  final Order order;
  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                  color: Theme.of(context).colorScheme.primary, width: 2))),
      onPressed: (widget.cart.countItemsOfCart <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await widget.order.addOrder(
                  orderItem: OrderItem(
                      id: '#${widget.order.orders.length}',
                      cartItems: widget.cart.items.values.toList(),
                      totalPrice: widget.cart.totalPrice,
                      date: DateTime.now()));
              widget.cart.clearCart();
              setState(() {
                _isLoading = false;
              });
            },
      child: _isLoading
          ? const CircularProgressIndicator.adaptive()
          : const Text('ORDER NOW'),
    );
  }
}
