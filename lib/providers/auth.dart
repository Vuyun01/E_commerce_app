// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:ec_shop_app/models/http_exception.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;

  bool isAuth() {
    return _token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime
            .now()) && //the expirydate is still in the future (after now)
        _token != null) {
      return _token;
    }
    return null;
  }

  String? get useriD {
    return _userId;
  }

  Future<void> _authenticateUser(
      String email, String password, String urlSegment) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyAE-5bvJqwd2CfcnCBF3xmu-GxXn6TOjiY');
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));

      // print(json.decode(response.body));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']); //throw exception
      }
      _token = responseData['idToken'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      //convert total expires seconds to DateTime object
      _userId = responseData['localId'];
      notifyListeners();

      final prefs = await SharedPreferences
          .getInstance(); //init shared preferences object
      final savedData = json.encode(
          {'token': _token, 'userId': _userId, 'expiryDate': _expiryDate?.toIso8601String()});
      prefs.setString('userData', savedData);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final getStoredData = prefs.getString('userData');
    if (getStoredData == null) {
      return false;
    }
    final extractedData = json.decode(getStoredData) as Map<String, dynamic>;
    final expiryDate = DateTime.parse(extractedData['expiryDate']);
    if(expiryDate.isBefore(DateTime.now())){
      return false;
    }

    _token = extractedData['token'];
    _userId = extractedData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    return true;
  }

  Future<void> signup(String email, String password) async {
    return _authenticateUser(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticateUser(email, password, 'signInWithPassword');
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    // print('logged out');
    // prefs.remove('userData') // remove a specific data in shared preference
    prefs.clear(); //remove all data in shared preferences
  }
}
