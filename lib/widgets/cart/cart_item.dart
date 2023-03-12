import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart.dart' as ci;

class CartItem extends StatelessWidget {
  const CartItem({Key? key, required this.cartItem}) : super(key: key);

  final ci.CartItem cartItem;

  @override
  Widget build(BuildContext context) {
    print('Cart item rebuild');
    final data = Provider.of<ci.Cart>(context, listen: false);
    return Dismissible(
      key: ValueKey(cartItem.product.id),
      onDismissed: (direction) => data.removeItem(cartItem.product.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) => showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: Text(
                  'Are you sure?',
                  style: Theme.of(context).textTheme.headline3,
                ),
                content: Text(
                  'Do you want to remove this item from Cart?',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Yes')),
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('No')),
                ],
              )),
      background: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).errorColor,
            borderRadius: BorderRadius.circular(10)),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 40),
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: const Icon(
          Icons.delete_outlined,
          size: 30,
          color: Colors.white,
        ),
      ),
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 5),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: Colors.black26)),
        child: ListTile(
          title: Text(
            cartItem.product.name,
            style: Theme.of(context).textTheme.headline6,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                child: Text(
                  'Price: \$${cartItem.product.price.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
              Text(
                'Total: \$${(cartItem.product.price * cartItem.quantity).toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          ),
          isThreeLine: true,
          leading: SizedBox(
            width: 60,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                cartItem.product.imageURL,
                fit: BoxFit.fill,
              ),
            ),
          ),
          trailing: Text(
            '${cartItem.quantity} x',
            style:
                Theme.of(context).textTheme.headline6?.copyWith(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
