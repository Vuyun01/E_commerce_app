import 'package:ec_shop_app/providers/cart.dart'
    show Cart; //only use Cart not CartItem
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/cart/cart_item.dart';
import '../widgets/cart/cart_summary.dart';

class CartScreen extends StatelessWidget {
  static const String routeName = '/cart';
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print('Cart rebuild');
    final data = Provider.of<Cart>(context);
    final checkCart = data.items.isEmpty;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: checkCart
          ? Center(
              child: Text(
                'Shopping cart is empty now.\nPlease go back and continue shopping',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline6,
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  CartSummary(cart: data),
                  const SizedBox(
                    height: 15,
                  ),
                  Expanded(
                      child: ListView.builder(
                          itemCount: data.countItems,
                          itemBuilder: ((context, index) {
                            final cartItems = data.items.values.toList();
                            return CartItem(cartItem: cartItems[index]);
                          })))
                ],
              ),
            ),
    );
  }
}
