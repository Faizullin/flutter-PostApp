import 'package:post_app/models/category.dart';

class Post {
  final int id;
  final String title;
  final String body;
  final String description;
  final String? imageUrl;
  final Category? category;

  const Post({
    required this.id,
    required this.title,
    required this.body,
    required this.description,
    this.imageUrl,
    this.category,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      category: json['category']!= null ? Category.fromJson(json['category']) : null,
    );
  }
}

