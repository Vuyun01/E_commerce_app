import 'package:ec_shop_app/widgets/custom_drawer.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order.dart' show Order;
import '../widgets/order/order_item.dart';

class OrderScreen extends StatefulWidget {
  static const String routeName = '/order';
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  late Future _orderFuture;
  @override
  void initState() {
    _orderFuture = Provider.of<Order>(context, listen: false).fetchOrderData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('Order Screen build');
    return Scaffold(
      appBar: AppBar(title: const Text('Your Order')),
      drawer: const CustomDrawer(),
      body: FutureBuilder(
        future: _orderFuture,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Consumer(
              builder: (_, Order orderData, __) => RefreshIndicator(
                onRefresh: orderData.fetchOrderData,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: orderData.orders.isEmpty
                      ? Center(
                          child: Text(
                            'You don\'t have any orders!',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        )
                      : ListView.builder(
                          itemCount: orderData.orders.length,
                          itemBuilder: (context, index) =>
                              OrderItem(orderItem: orderData.orders[index])),
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
