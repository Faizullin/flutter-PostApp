class Category {
  final int id;
  final String title;
  final String slug;


  const Category({
    required this.id,
    required this.title,
    required this.slug,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      title: json['title'],
      slug: json['slug'],
    );
  }
}

