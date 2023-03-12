// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageURL;
  bool isFavorite;
  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageURL,
    this.isFavorite = false,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      imageURL: json["imageURL"],
      price: json["price"],
    );
  }

  void _setFavoriteState(bool favorited) {
    isFavorite = favorited;
    notifyListeners();
  }

  Future<void> changeFavorite(String authToken, String useriD) async {
    var oldFavoriteState = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      final url = Uri.parse(
          'https://ec-shop-app-default-rtdb.firebaseio.com/userFavorites/$useriD/$id.json?auth=$authToken');
      final response = await http.put(url, body: json.encode(isFavorite));
      if (response.statusCode >= 400) {
        _setFavoriteState(oldFavoriteState);
      }
    } catch (exception) {
      _setFavoriteState(oldFavoriteState);
    }
  }
}
