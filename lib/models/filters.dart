import 'package:post_app/models/category.dart';
import 'package:post_app/models/tag.dart';

class Filters {
  final List<Category> categories;
  final List<Tag> tags;

  const Filters({
    required this.categories,
    required this.tags,
  });

  factory Filters.fromJson(Map<String, dynamic> json) {
    return Filters(
      categories: json['categories'].map<Category>((el) => Category.fromJson(el)).toList(),
      tags: json['tags'].map<Tag>((el) => Tag.fromJson(el)).toList(),
    );
  }
}

