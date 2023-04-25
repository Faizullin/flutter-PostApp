import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:post_app/core/app_export.dart';
import 'package:post_app/models/user.dart';
import 'package:post_app/models/user_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String _token = '';
  bool _isAuthenticated = false;
  User? user;

  String get token => _token;
  bool get isAuthenticated => _isAuthenticated;


  Future<UserData> getUser() async {
    final response = await http.get(
      Uri.parse('${Env.baseUrl}/api/user'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      UserData user = UserData.fromJson(data);
      return user;
    } else {
      throw Exception('Error getting user');
    }
  }

  Future<Map<String,dynamic>> login({required String email, required String password}) async {
    final response = await http.post(
      Uri.parse('${Env.baseUrl}/api/login'),
      headers: {'Accept': 'application/json'},
      body: {'email': email, 'password': password},
    );

    if(response.statusCode == 200) {
      final data = json.decode(response.body);
      _token = data['token'];
      _isAuthenticated = true;

      final userData = await getUser();
      user = User(id: userData.id, name: userData.name, email: userData.email);

      var prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setString('id', user!.id);
      await prefs.setString('name', user!.name);
      await prefs.setString('email', user!.email);
      notifyListeners();
      return {
        'success': true,
      };
    } else if(response.statusCode == 401) {
      final data = json.decode(response.body);
      return {
        'success': false,
        'errors': data['error'],
      };
    } else if(response.statusCode == 422) {
      final data = json.decode(response.body);
      String errorsMessage = '';
      if(data['errors'].values.first is List){
        errorsMessage = '${data['errors'].values.first.first}';
      } else if (data['errors'].values.first is String) {
        errorsMessage = data['errors'].values.first;
      }
      return {
        'success': false,
        'errors': errorsMessage,
      };
    }
    throw Exception("Error in singning in");
  }

  Future<void> logout() async {
    var prefs = await SharedPreferences.getInstance();
    _isAuthenticated = false;
    _token = ''; //null;
    user = null; //null;
    var token = prefs.getString('token');
    if(token != null){
      prefs.remove('token');
    }
    notifyListeners();
  }

  Future<bool> checkAuth() async {
    var prefs = await SharedPreferences.getInstance();
    var userToken = prefs.getString('token');
    var userEmail = prefs.getString('email');
    var userName = prefs.getString('name');
    var userId = prefs.getString('id');


    //print('AuthProvide.check: ${userId} ${userName} ${userEmail} token=>${userToken}');

    if (userToken != null && userEmail != null && userId!=null) {
      _token = userToken;
      _isAuthenticated = true;
      user = User(id: userId, name: userName ?? "", email: userEmail);
      notifyListeners();
      return true;
    } else {
      await logout();
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
