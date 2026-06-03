class ResourceModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String content;
  final String? imageUrl;
  final String? videoUrl;

  ResourceModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.content,
    this.imageUrl,
    this.videoUrl,
  });
}
