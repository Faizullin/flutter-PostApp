import 'dart:convert';
import 'package:post_app/models/category.dart';
import 'package:post_app/models/post.dart';
import 'package:http/http.dart' as http;
import 'package:post_app/config.dart';

Future<Post> fetchPost(String id) async {
  final response = await http.get(Uri.parse('${Env.baseUrl}/posts/$id'));

  if (response.statusCode == 200) {
    return Post.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}
Future<Post> fetchStorePost(Map<String,dynamic> body) async {
  print('Body $body => ${jsonEncode(body)}');
  final response = await http.post(
    Uri.parse('${Env.baseUrl}/posts'),
    headers:<String, String> {
      'Context-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(body),
  );
  print('${response.statusCode}, ${response.body}');
  if (response.statusCode == 200) {
    return Post.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}

Future<List<Post>> fetchPosts() async {
  final response = await http.get(Uri.parse('${Env.baseUrl}/posts'));

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => Post.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load album');
  }
}

Future<List<Category>> fetchFilters() async {
  final response = await http.get(Uri.parse('${Env.baseUrl}/posts'));

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => Category.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load album');
  }
}

Future fetchGetFilters() async {
  print("STart egt");
  final response = await http.get(Uri.parse('${Env.baseUrl}/filters'));

  if (response.statusCode == 200) {
    Map<String,dynamic> jsonResponse = json.decode(response.body);
    // Map<String,dynamic> filters = {
    //   'categories': jsonResponse['categories'].map((data) => Category.fromJson(data)).toList(),
    //   'tags': jsonResponse['categories'].map((data) => Category.fromJson(data)).toList(),
    // };
    return jsonResponse;
  } else {
    throw Exception('Failed to load album');
  }
}