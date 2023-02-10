import 'dart:convert';
import 'package:post_app/core/app_export.dart';
import 'package:post_app/models/filters.dart';
import 'package:post_app/models/post.dart';
import 'package:http/http.dart' as http;

class PostService {
  Future<Post> getPostById(String id) async {
    final response = await http.get(Uri.parse('${Env.baseUrl}/posts/$id'));

    if (response.statusCode == 200) {
      return Post.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<List<Post>> getAllPosts() async {
    final response = await http.get(Uri.parse('${Env.baseUrl}/posts'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Post.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<Post> store(Map<String, dynamic> body, String token) async {
    final response = await http.post(
      Uri.parse('${Env.baseUrl}/posts'),
      headers: <String, String>{
        'Context-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      return Post.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<Filters> getAllFilters() async {
    final response = await http.get(Uri.parse('${Env.baseUrl}/filters'));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      return Filters.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<List<Post>> applyFilters(Filters filters) async {
    String url = '${Env.baseUrl}/posts?';
    if (filters.categories.isNotEmpty) {
      url +=
          "category.slug=${filters.categories[filters.categories.length - 1].slug}&";
    }
    for (int i = 0; i < filters.tags.length; i++) {
      url += "tag[$i].slug=${filters.tags[i].slug}&";
    }
    final response = await http.get(
      Uri.parse(url),
      headers: {"Accept": "application/json"},
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Post.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load album');
    }
  }
}
