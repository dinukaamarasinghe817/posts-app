class Post {
  final int id;
  final int userId;
  final String title;
  final String description;

  Post({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      description: json['body'],
    );
  }
}
