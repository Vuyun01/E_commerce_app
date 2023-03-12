import 'package:ec_shop_app/providers/products_provider.dart';
import 'package:ec_shop_app/screens/edit_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';

class UserProductItem extends StatelessWidget {
  const UserProductItem({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<Products>(context, listen: false);
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 5),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Colors.black26)),
      child: ListTile(
          title: Text(
            product.name,
            style: Theme.of(context).textTheme.headline6,
          ),
          // contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          leading: SizedBox(
            width: 60,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.network(
                product.imageURL,
                fit: BoxFit.cover,
              ),
            ),
          ),
          subtitle: Text(
            'Price: ${product.price}',
            style: Theme.of(context).textTheme.bodyText2,
          ),
          trailing: SizedBox(
            width: 100,
            child: Row(
              children: [
                IconButton(
                    onPressed: () => Navigator.of(context).pushNamed(
                        EditProductScreen.routeName,
                        arguments: product),
                    icon: Icon(
                      Icons.edit,
                      color: Theme.of(context).colorScheme.primary,
                    )),
                IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (ctx) {
                            final snackbar = ScaffoldMessenger.of(ctx);
                            final navigator = Navigator.of(ctx);
                            return AlertDialog(
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
                                    onPressed: () {
                                      data
                                          .removeProduct(product)
                                          .then((_) => navigator.pop())
                                          .catchError((_) {
                                        navigator.pop();
                                        snackbar.showSnackBar(const SnackBar(
                                            content: Text(
                                                'Unable to delete this product')));
                                      });
                                    },
                                    child: const Text('Yes')),
                                TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text('No')),
                              ],
                            );
                          });
                    },
                    icon: Icon(Icons.delete_outline,
                        color: Theme.of(context).errorColor)),
              ],
            ),
          )),
    );
  }
}
