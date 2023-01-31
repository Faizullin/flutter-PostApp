class Tag {
  final int id;
  final String title;
  final String slug;


  const Tag({
    required this.id,
    required this.title,
    required this.slug,
  });

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json['id'],
      title: json['title'],
      slug: json['slug'],
    );
  }
}

