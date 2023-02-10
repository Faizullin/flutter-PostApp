import 'package:post_app/models/user.dart';

class Comment {
  final int id;
  final int postId;

  final String body;
  final User? user;

  const Comment({
    required this.id,
    required this.postId,
    required this.body,
    required this.user,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      postId: json['postId'],
      body: json['body'],
      user: json['user']!= null ? User.fromJson(json['user']) : null,
    );
  }
}

