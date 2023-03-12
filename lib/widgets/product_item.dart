import 'package:ec_shop_app/providers/auth.dart';
import 'package:ec_shop_app/screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/product.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({super.key});

  @override
  Widget build(BuildContext context) {
    print('ProductItem build');
    final data = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          title: Text(
            data.name,
            textAlign: TextAlign.center,
          ),
          leading: Consumer<Product>(
            builder: (__, data, _) => IconButton(
                onPressed: () =>
                    data.changeFavorite(authData.token!, authData.useriD!),
                icon: Icon(
                    data.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border_outlined,
                    color: Theme.of(context).colorScheme.secondary)),
          ),
          trailing: IconButton(
            onPressed: () {
              cart.addItem(product: data);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text('Add to cart successfully!'),
                duration: const Duration(seconds: 2),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () => cart.removeSingleItem(data.id),
                ),
              ));
            },
            icon: Icon(
              Icons.shopping_cart_checkout,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
        child: GestureDetector(
          onTap: () => Navigator.of(context)
              .pushNamed(ProductDetailScreen.routeName, arguments: data),
          child: Hero(
            tag: data.id,
            child: FadeInImage(
              image: NetworkImage(data.imageURL),
              placeholder:
                  const AssetImage('assets/images/product-placeholder.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
