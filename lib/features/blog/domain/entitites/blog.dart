class Blog {
  final String id;
  final String title;
  final String userId;
  final String content;
  final String imageURL;
  final List<String> topics;
  final DateTime updatedAt;

  Blog({
    required this.id,
    required this.title,
    required this.userId,
    required this.content,
    required this.imageURL,
    required this.topics,
    required this.updatedAt,
  });
}
