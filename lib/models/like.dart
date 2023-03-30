class Like{
  final String id;
  final String modelType;
  final String modelId;

  const Like({
    required this.id,
    required this.modelType,
    required this.modelId,
  });

  factory Like.fromJson(Map<String, dynamic> json) {
    return Like(
      id: json['id'],
      modelType: json['modelType'],
      modelId: json['modelId'],
    );
  }
}