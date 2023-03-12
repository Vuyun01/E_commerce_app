import 'package:ec_shop_app/providers/products_provider.dart';
import 'package:ec_shop_app/screens/edit_product_screen.dart';
import 'package:ec_shop_app/widgets/custom_drawer.dart';
import 'package:ec_shop_app/widgets/user_product_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ProductManagement extends StatefulWidget {
  static const String routeName = '/product-management';
  const ProductManagement({super.key});

  @override
  State<ProductManagement> createState() => _ProductManagementState();
}

class _ProductManagementState extends State<ProductManagement> {

  late Future _productFuture;

  @override
  void initState() {
    _productFuture = Provider.of<Products>(context, listen: false).fetchData(true);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products Management'),
        actions: [
          IconButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(EditProductScreen.routeName),
              icon: const Icon(Icons.add))
        ],
      ),
      drawer: const CustomDrawer(),
      body: FutureBuilder(
        future: _productFuture,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Consumer(
              builder: (_, Products products, __) => RefreshIndicator(
                onRefresh: () => products.fetchData(true),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: ListView.builder(
                      itemCount: products.getProducts.length,
                      itemBuilder: (context, index) =>
                          UserProductItem(product: products.getProducts[index])),
                ),
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        },
      ),
    );
  }
}
