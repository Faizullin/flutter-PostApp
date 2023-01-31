import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthenticationService {
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  static Future<http.Response> register(String name, String email, String password) async {
    Map data = {
      "name": name,
      "email": email,
      "password": password,
    };
    const baseURL = "";
    var body = jsonEncode(data);
    var url = Uri.parse('$baseURL/auth/register');
    http.Response response = await http.post(
      url,
      //headers: headers,
      body: body,
    );
    return response;
  }

  Future<void> login({required String email,required String password}) async {
    // Perform login logic (e.g. API call)
    await Future.delayed(const Duration(seconds: 1));
    _isAuthenticated = true;
    notifyListeners();
  }

  Future<void> logout() async {
    // Perform logout logic (e.g. API call)
    await Future.delayed(const Duration(seconds: 1));
    _isAuthenticated = false;
    notifyListeners();
  }


  notifyListeners() {
    //print("AUTH Notification: $isAuthenticated (get) <= $_isAuthenticated ");
  }
}