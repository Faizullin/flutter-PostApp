import 'package:post_app/models/user.dart';

class Comment {
  final String id;
  //final int? postId;

  final String body;
  final User? user;
  List<Comment>? replies;
  final Comment? parent;

  Comment({
    required this.id,
    required this.body,
    this.user,
    this.replies,
    this.parent,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    if(json['parent'] != null){
      json['parent'].addEntries({'message':''}.entries);
    }
    if(json['author'] != null){
      json['author']['email'] = json['author']['email'] ?? '';
    }
    return Comment(
      id: '${json['id']}',
      body: json['message'],
      user: json['author'] != null ? User.fromJson(json['author']) : null,
      replies: json['replies'] != null ? json['replies']!.map<Comment>((el) => Comment.fromJson(el)).toList() : [],
      parent: json['parent'] != null ? Comment.fromJson(json['parent']) : null,
    );
  }
}

