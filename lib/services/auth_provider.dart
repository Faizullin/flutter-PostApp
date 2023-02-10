import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:post_app/core/app_export.dart';
import 'package:post_app/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String _token = '';
  bool _isAuthenticated = false;
  User? user;

  String get token => _token;
  bool get isAuthenticated => _isAuthenticated;

  Future<void> login({required String email, required String password}) async {
    final response = await http.post(
      Uri.parse('https://${Env.baseUrl}/login'),
      headers: {'Accept': 'application/json'},
      body: {'email': email, 'password': password},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      user = User.fromJson(data['user']);
      _isAuthenticated = true;

      var prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      notifyListeners();
    } else {
      throw Exception('Error signing in');
    }
  }

  Future<void> logout() async {
    _isAuthenticated = false;
    _token = ''; //null;
    user = null; //null;
    notifyListeners();
  }

  Future<bool> checkAuth() async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    if (token != null && user != null) {
      _token = token;
      _isAuthenticated = true;
      notifyListeners();
      return true;
    } else {
      _token = '';
      user = null;
      _isAuthenticated = false;
      notifyListeners();
      return false;
    }
  }

// final response = await http.get(
  //   Uri.parse('https://${Env.baseUrl}auth/check'),
  //   headers: {
  //     'Accept': 'application/json',
  //     'Authorization': 'Bearer $_token'
  //   },
  // );
  // if (response.statusCode == 200) {
  //   final data = jsonDecode(response.body);
  //   return data['authenticated'];
  // } else {
  //   return false;
  // }
}
