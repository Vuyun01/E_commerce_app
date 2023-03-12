import 'package:ec_shop_app/providers/products_provider.dart';
import 'package:ec_shop_app/widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsGrid extends StatelessWidget {
  const ProductsGrid({
    Key? key,
    this.isShowFavoritedProducts = false,
  }) : super(key: key);
  final bool isShowFavoritedProducts;
  @override
  Widget build(BuildContext context) {
    print('ProductGrid build');

    final checkData = Provider.of<Products>(context);
    final data = isShowFavoritedProducts
        ? checkData.getFavoritedProducts
        : checkData.getProducts;
    return GridView.builder(
        itemCount: data.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10),
        itemBuilder: (context, index) => ChangeNotifierProvider.value(
              value: data[index],
              child: const ProductItem(),
            ));
  }
}
