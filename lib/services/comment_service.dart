import 'dart:convert';
import 'package:post_app/core/app_export.dart';
import 'package:post_app/models/comment.dart';
import 'package:http/http.dart' as http;
import 'package:post_app/models/filters.dart';

class CommentService {
  final String postId;
  const CommentService({required this.postId});


  Future<List<Comment>> getAllPostComments() async {
    final response = await http.get(Uri.parse('${Env.baseUrl}/comments?postId=$postId'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Comment.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<Comment> store(Map<String,dynamic> body) async {
    final response = await http.post(
      Uri.parse('${Env.baseUrl}/posts'),
      headers:<String, String> {
        'Context-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      return Comment.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }



  Future<List<Comment>> applyFilters(Filters filters) async {
    String url = '${Env.baseUrl}/posts?';
    if(filters.categories.isNotEmpty){
      url += "category.slug=${filters.categories[filters.categories.length - 1].slug}&";
    }
    for(int i=0;i < filters.tags.length;i++){
      url += "tag[$i].slug=${filters.tags[i].slug}&";
    }
    final response = await http.get(
      Uri.parse(url),
      headers: {"Accept": "application/json"},
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Comment.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load album');
    }
  }
}
