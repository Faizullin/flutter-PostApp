import 'package:post_app/models/post.dart';
import 'package:post_app/models/tag.dart';

class SearchResult {
  final List<Post> posts;
  final List<Tag> tags;


  const SearchResult({
    required this.posts,
    required this.tags,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      posts: json['posts'].map<Post>((el) => Post.fromJson(el)).toList(),
      tags: json['tags'].map<Tag>((el) => Tag.fromJson(el)).toList(),
    );
  }
}

