import 'dart:convert';

import 'package:ec_shop_app/providers/product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  String? authToken;
  String? useriD;
  // Products(this.authToken);

  void update(String token, List<Product> listProducts, String uId) {
    authToken = token;
    _products = listProducts;
    useriD = uId;
  }

  List<Product> _products = [];

  List<Product> get getProducts {
    return _products;
  }

  List<Product> get getFavoritedProducts {
    return _products.where((item) => item.isFavorite).toList();
  }

  Future<void> fetchData([bool isSortedByUser = false]) async {
    final sortQuery = isSortedByUser ? 'orderBy="creatorId"&equalTo="$useriD"' : '';
    var url = Uri.parse(
        'https://ec-shop-app-default-rtdb.firebaseio.com/products.json?auth=$authToken&$sortQuery');
    try {
      final response = await http.get(url);
      if (response.body == 'null') {
        _products = [];
        notifyListeners();
        //due to response.body return a String,in this case server return no results, 'null' is cast to String
        print(response.body);
        return;
      }
      final getFetchedData = json.decode(response.body) as Map<String, dynamic>;
      List<Product> listProducts = [];
      url = Uri.parse(
          'https://ec-shop-app-default-rtdb.firebaseio.com/userFavorites/$useriD.json?auth=$authToken');
      final favoriteResponse = await http.get(url);
      final getFetchedFavoritesData =
          json.decode(favoriteResponse.body) as Map<String, dynamic>?; //might be null
      getFetchedData.forEach(
        (proID, proData) => listProducts.add(Product(
            id: proID,
            name: proData['title'],
            isFavorite: getFetchedFavoritesData == null
                ? false
                : getFetchedFavoritesData[proID] ?? false,
            description: proData['description'],
            price: proData['price'],
            imageURL: proData['imageURL'])),
      );
      _products = listProducts;
      notifyListeners();
    } catch (exception) {
      rethrow;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        'https://ec-shop-app-default-rtdb.firebaseio.com/products.json?auth=$authToken');
    final response = await http.post(url,
        body: json.encode({
          'title': product.name,
          'price': product.price,
          'description': product.description,
          'imageURL': product.imageURL,
          'creatorId': useriD
        }));
    _products.add(Product(
        id: json.decode(response.body)['name'],
        name: product.name,
        description: product.description,
        price: product.price,
        imageURL: product.imageURL));
    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    final index = _products.indexWhere((item) => item.id == product.id);
    if (index >= 0) {
      final url = Uri.parse(
          'https://ec-shop-app-default-rtdb.firebaseio.com/products/${product.id}.json?auth=$authToken');
      await http.patch(url,
          body: json.encode({
            'title': product.name,
            'price': product.price,
            'description': product.description,
            'imageURL': product.imageURL,
          }));
      _products[index] = product;
    }
    notifyListeners();
  }

  Future<void> removeProduct(Product product) async {
    final url = Uri.parse(
        'https://ec-shop-app-default-rtdb.firebaseio.com/products/${product.id}.json?auth=$authToken');
    final existingProductIndex =
        _products.indexWhere((item) => item.id == product.id);
    Product? existingProduct = _products[existingProductIndex];
    _products.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _products.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw Exception('Could not delete product');
    }
    existingProduct = null; //remove from the memory
  }
}
