// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

import 'product.dart';

class CartItem {
  final String id;
  final Product product;
  final int quantity;
  CartItem({
    required this.id,
    required this.product,
    required this.quantity,
  });
}

class Cart with ChangeNotifier {
  final Map<String, CartItem> _items = {};
  Map<String, CartItem> get items {
    return _items;
  }

  int get countItems {
    return _items.length;
  }

  int get countItemsOfCart {
    return _items.values.fold(0, (sum, item) => sum + item.quantity);
  }

  double get totalPrice {
    // double totalPrice = 0;
    // _items.forEach((key, item) => totalPrice += (item.quantity * item.price));
    // return totalPrice;
    return _items.values
        .fold(0, (sum, item) => sum + (item.quantity * item.product.price));
  }

  void addItem({required Product product, int? quantity}) {
    if (_items.containsKey(product.id)) {
      _items.update(
          product.id,
          (oldCartItem) => CartItem(
              id: oldCartItem.id,
              product: oldCartItem.product,
              quantity: oldCartItem.quantity + 1));
    } else {
      _items.putIfAbsent(
          product.id,
          () => CartItem(
              id: countItems.toString(),
              product: product,
              quantity: quantity ?? 1));
    }

    notifyListeners();
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void removeSingleItem(String id) {
    if (!_items.containsKey(id)) {
      return;
    } else {
      final cartItem = _items[id];
      if (cartItem!.quantity > 1) {
        _items.update(
            id,
            (oldCartItem) => CartItem(
                id: oldCartItem.id,
                product: oldCartItem.product,
                quantity: oldCartItem.quantity - 1));
      }else{
        _items.remove(id);
      }
    }
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
