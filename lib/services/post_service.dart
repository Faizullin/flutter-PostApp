import 'dart:convert';
import 'package:post_app/core/app_export.dart';
import 'package:post_app/models/filters.dart';
import 'package:post_app/models/post.dart';
import 'package:http/http.dart' as http;
import 'package:post_app/services/auth_provider.dart';

class PostService {
  final AuthProvider? authProvider;

  PostService({this.authProvider});

  String sortColumn = '';
  String sortOrder = '';

  Future<Post> getPostById(String id, String token) async {
    final response = await http.get(
      Uri.parse('${Env.baseUrl}/api/post/$id'),
      headers: <String, String>{
        'Context-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
    );
    if (response.statusCode == 200) {
      return Post.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<List<Post>> getAllPosts([int page = 1]) async {
    final response = await http.get(Uri.parse('${Env.baseUrl}/api/post?page=$page'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map<Post>((data) => Post.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load album');
    }
  }



  Future<Map<String,dynamic>> store(Map<String, dynamic> body,String token) async {
    var request = http.MultipartRequest('POST',
      Uri.parse('${Env.baseUrl}/api/post/create'),
    );
    String path = body['image'].path;
    request.files.add(await http.MultipartFile.fromPath('image', path, filename: "image.jpg"));

    body.forEach((key, value) {
      if(key != 'image') {
        request.fields[key] = value.toString();
      }
    });
    request.headers.addAll({
      'Context-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });
    final response = await request.send();
    final responsed = await http.Response.fromStream(response);
    Map<String,dynamic> responseData = jsonDecode(responsed.body);

    if (response.statusCode == 200) {
      return {
        'success': true,
        // 'post': Post.fromJson(responseData),
      };
    } else if(response.statusCode == 401) {
      return {
        'success': false,
        'errorMessage': responseData['error'],
      };
    } else if(response.statusCode == 422) {
      return {
        'success': false,
        'errors': responseData['errors'],
      };
    }
    throw Exception("Error in singning in");
  }

  Future<Filters> getAllFilters() async {
    final response = await http.get(Uri.parse('${Env.baseUrl}/api/post/filters'));
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      return Filters.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<List<Post>> applyFilters(SelectFilters filters, [int page = 1, String? token,]) async {
    String url = '${Env.baseUrl}/api/post?page=$page&';
    if (filters.categories.isNotEmpty) {
      url += "category=${filters.categories[filters.categories.length - 1].slug}&";
    }
    for (int i = 0; i < filters.tags.length; i++) {
      url += "tag[$i]=${filters.tags[i].slug}&";
    }
    if(filters.searchQuery is String){
      url += "search=${filters.searchQuery}&";
    }
    if(filters.sortColumn.isNotEmpty) {
      url += "sort_field=${filters.sortColumn}&";
    }
    var headers = {"Accept": "application/json"};
    if(token != null) {
      headers = {
        'Context-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };
    }
    final response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Post.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load album');
    }
  }
}
