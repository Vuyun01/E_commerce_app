import 'package:flutter/material.dart';

import '../providers/product.dart';

class ProductDetailScreen extends StatelessWidget {
  static const String routeName = '/product_detail';
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print('ProductDetail build');
    final product = ModalRoute.of(context)?.settings.arguments as Product;
    return Scaffold(
      body: LayoutBuilder(
          builder: (context, constraints) => CustomScrollView(
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    expandedHeight: constraints.maxHeight * 0.4,
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      title: Text(product.name),
                      background: Hero(
                        tag: product.id,
                        child: Image.network(
                          product.imageURL,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      SizedBox(
                        height: constraints.maxWidth * 0.1,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Row(
                          children: [
                            Text(
                              product.name,
                              style: Theme.of(context).textTheme.headline3,
                            ),
                            Spacer(),
                            Text(
                              '\$${product.price}',
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: constraints.maxWidth * 0.1,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                          product.description,
                          style: Theme.of(context).textTheme.bodyText1,
                          softWrap: true,
                        ),
                      ),
                      SizedBox(
                        height: constraints.maxHeight,
                      ),
                    ]),
                  ),
                ],
              )),
    );
  }
}
