// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:ec_shop_app/providers/cart.dart' show CartItem;
import 'package:ec_shop_app/providers/product.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final List<CartItem> cartItems;
  final double totalPrice;
  final DateTime date;
  OrderItem({
    required this.id,
    required this.cartItems,
    required this.totalPrice,
    required this.date,
  });
}

class Order with ChangeNotifier {

  String? authToken;
  String? useriD;
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return _orders;
  }

  void update(String token, List<OrderItem> orderItems, String uid){
    _orders = orderItems;
    authToken = token;
    useriD = uid;
  }

  Future<void> fetchOrderData() async {
    try {
      final url = Uri.parse(
          'https://ec-shop-app-default-rtdb.firebaseio.com/orders/$useriD.json?auth=$authToken');
      final response = await http.get(url);
      // print(response.body);
      if (response.body == 'null') {
        _orders = [];
        notifyListeners();
        //due to response.body return a String,in this case server return no results, 'null' is cast to String
        print(response.body);
        return;
      }
      final fetchedOrdersData =
          json.decode(response.body) as Map<String, dynamic>;
      List<OrderItem> listOrders = [];
      fetchedOrdersData
          .forEach((orderId, orderData) => listOrders.add(OrderItem(
              id: orderId,
              cartItems: (orderData['products'] as List<dynamic>)
                  .map((e) => CartItem(
                        id: e['id'],
                        product: Product.fromJson(e['product']),
                        quantity: e['quantity'],
                      ))
                  .toList(),
              totalPrice: orderData['totalPrice'],
              date: DateTime.parse(orderData['date']))));
      _orders = listOrders.reversed.toList();
      notifyListeners();
    } catch (exception) {
      print(exception);
      throw Exception(exception);
    }
  }

  Future<void> addOrder({required OrderItem orderItem}) async {
    final url = Uri.parse(
        'https://ec-shop-app-default-rtdb.firebaseio.com/orders/$useriD.json?auth=$authToken');
    final response = await http.post(url,
        body: json.encode({
          'totalPrice': orderItem.totalPrice,
          'date': orderItem.date.toIso8601String(),
          'products': orderItem.cartItems
              .map((e) => {
                    'id': e.id,
                    'quantity': e.quantity,
                    'product': {
                      'id': e.product.id,
                      'name': e.product.name,
                      'price': e.product.price,
                      'imageURL': e.product.imageURL,
                      'description': e.product.description
                    }
                  })
              .toList()
        }));
    _orders.insert(
        0,
        OrderItem(
            id: json.decode(response.body)['name'],
            cartItems: orderItem.cartItems,
            totalPrice: orderItem.totalPrice,
            date: orderItem.date));
    notifyListeners();
  }
}
