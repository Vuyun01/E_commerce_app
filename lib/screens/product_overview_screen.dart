import 'package:ec_shop_app/screens/cart_screen.dart';
import 'package:ec_shop_app/widgets/badge.dart';
import 'package:ec_shop_app/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:ec_shop_app/constant.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../providers/products_provider.dart';
import '../widgets/products_grid.dart';

class ProductOverviewScreen extends StatefulWidget {
  static const String routeName = '/product_overview';
  const ProductOverviewScreen({super.key});

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _isShowFavoritedProducts = false;
  late Future _productsFuture;

  @override
  void initState() {
    _productsFuture = Provider.of<Products>(context, listen: false).fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('ProductOverView build');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Overview'),
        actions: [
          PopupMenuButton(
              onSelected: (value) {
                setState(() {
                  if (value == ProductFilter.favorite) {
                    _isShowFavoritedProducts = true;
                  } else {
                    _isShowFavoritedProducts = false;
                  }
                });
              },
              itemBuilder: ((context) => [
                    const PopupMenuItem(
                      value: ProductFilter.all,
                      child: Text('Show all products'),
                    ),
                    const PopupMenuItem(
                      value: ProductFilter.favorite,
                      child: Text('Favorites'),
                    ),
                  ])),
          Consumer<Cart>(
              builder: (_, cartItem, cd) => Badge(
                  value: cartItem.countItemsOfCart.toString(), child: cd!),
              child: IconButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed(CartScreen.routeName),
                icon: const Icon(Icons.shopping_cart),
              ))
        ],
      ),
      body: FutureBuilder(
        future: _productsFuture,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Consumer(
              builder: (__, Products products, _) => RefreshIndicator(
                onRefresh: products.fetchData,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ProductsGrid(
                    isShowFavoritedProducts: _isShowFavoritedProducts,
                  ),
                ),
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        },
      ),
      drawer: const CustomDrawer(),
    );
  }
}
