// import 'dart:convert';
// import 'package:post_app/models/category.dart';
// import 'package:post_app/models/post.dart';
// import 'package:http/http.dart' as http;
// import 'package:post_app/config.dart';
//
// class AuthProvider with ChangeNotifier {
//
//   String _token = '';
//   String _username = '';
//   bool _isAuthenticated = false;
//
//   String get token => _token;
//   String get username => _username;
//   bool get isAuthenticated => _isAuthenticated;
//
//   Future<void> login({required String email, required String password}) async {
//     final response = await http.post(
//       Uri.parse('https://$baseUrl/login'),
//       headers: {'Accept': 'application/json'},
//       body: {'email': email, 'password': password},
//     );
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       print('Lofin $data');
//       _token = data['access_token'];
//       _username = data['username'];
//       _isAuthenticated = true;
//
//       notifyListeners();
//     } else {
//       throw Exception('Error signing in');
//     }
//   }
//
//   Future<void> logout() async {
//     _isAuthenticated = false;
//     _token = '';//null;
//     _username = '';//null;
//     notifyListeners();
//   }
//
//   Future<bool> checkAuth() async {
//     final response = await http.get(
//       Uri.parse('https://$baseUrl/auth/check'),
//       headers: {
//         'Accept': 'application/json',
//         'Authorization': 'Bearer $_token'
//       },
//     );
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       return data['authenticated'];
//     } else {
//       return false;
//     }
//   }
// }