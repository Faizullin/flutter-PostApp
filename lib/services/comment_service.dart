import 'dart:convert';
import 'package:post_app/core/app_export.dart';
import 'package:post_app/models/comment.dart';
import 'package:http/http.dart' as http;

class CommentService {
  final String postId;
  const CommentService({required this.postId});


  Future<List<Comment>> getAllPostComments() async {
    final response = await http.get(Uri.parse('${Env.baseUrl}/api/comment?post_id=$postId'));
    if (response.statusCode == 200) {
      Map<String,dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse['data'].map<Comment>((data) => Comment.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<Comment> store(Map<String,dynamic> body, String token) async {
    final response = await http.post(
      Uri.parse('${Env.baseUrl}/api/comment/add'),
      headers:<String, String> {
        'Context-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      return Comment.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }
  Future<Comment> storeReply(Map<String,dynamic> body, String token) async {
    final response = await http.post(
      Uri.parse('${Env.baseUrl}/api/comment/reply/add'),
      headers:<String, String> {
        'Context-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(body),
    );
    //return Comment(id: '', body: body['body'],);
    if (response.statusCode == 200) {

      return Comment.fromJson(jsonDecode(response.body)['comment']);
    } else {
      throw Exception('Failed to load album');
    }
  }
  Future<Comment> delete(Map<String,dynamic> body,String token) async {
    final response = await http.delete(
      Uri.parse('${Env.baseUrl}/api/comment/${body['id']}'),
      headers:<String, String> {
        'Context-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      return Comment.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }
  Future<Comment> update(Map<String,dynamic> body,String token) async {
    final response = await http.patch(
      Uri.parse('${Env.baseUrl}/api/comment/${body['id']}/edit'),
      headers:<String, String> {
        'Context-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      return Comment.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }
}
