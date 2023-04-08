import 'package:post_app/core/app_export.dart';
import 'package:post_app/models/category.dart';
import 'package:post_app/models/tag.dart';
import 'package:post_app/models/user.dart';

class Post {
  final int id;
  final String title;
  final String body;
  final String description;
  final String? imageUrl;
  final Category? category;
  final List<Tag> tags;
  final User? author;
  final int commentsCount;
  final int likesCount;
  final bool? isLikedByCurrentUser;

  const Post({
    required this.id,
    required this.title,
    required this.body,
    required this.description,
    required this.tags,
    required this.commentsCount,
    required this.likesCount,
    this.imageUrl,
    this.category,
    this.author,
    this.isLikedByCurrentUser,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    bool? isLikedByCurrentUserFromApi;
    if(json['author'] != null){
      json['author']['email'] = json['author']['email'] ?? "";
    }
    if(json.containsKey('isLikedByCurrentUser')){
      isLikedByCurrentUserFromApi = json['isLikedByCurrentUser'];
    }
    return Post(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      description: json['description'],
      imageUrl: '${Env.baseUrl}${json['imageUrl']}',
      category: json['category']!= null ? Category.fromJson(json['category']) : null,
      author: json['author']!= null ? User.fromJson(json['author']) : null,
      tags: json['tags'] != null ? json['tags'].map<Tag>((el) => Tag.fromJson(el)).toList() : [],
      commentsCount: json['comments_count'] != null ? json['comments_count'] as int : 0,
      likesCount: json['likes_count'] != null ? json['likes_count'] as int : 0,
      isLikedByCurrentUser: isLikedByCurrentUserFromApi,
    );
  }
}