import 'dart:convert';
import 'package:post_app/core/app_export.dart';
import 'package:post_app/models/comment.dart';
import 'package:http/http.dart' as http;
import 'package:post_app/models/like.dart';

class LikeService {
  final String postId;
  const LikeService({required this.postId});

  Future<Map> likePost(String postId, String token) async {
    final response = await http.post(
      Uri.parse('${Env.baseUrl}/api/like'),
      headers:<String, String> {
        'Context-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
        'type': 'post',
        'id': postId,
      }),
    );
    if (response.statusCode == 200) {
      Map<String,dynamic> resp = jsonDecode(response.body);
      return {
        'likes_count': int.parse(resp['likes_count']),
      };
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<Map> unlikePost(String postId, String token) async {
    final response = await http.post(
      Uri.parse('${Env.baseUrl}/api/unlike'),
      headers: <String, String>{
        'Context-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
        'type': 'post',
        'id': postId,
      }),
    );
    if (response.statusCode == 200) {
      Map<String,dynamic> resp = jsonDecode(response.body);
      return {
        'likes_count': int.parse(resp['likes_count']),
      };
    } else {
      throw Exception('Failed to load album');
    }
  }
}
