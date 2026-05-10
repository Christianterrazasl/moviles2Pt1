class Post {
  final String title;
  final String description;
  final String imageUrl;
  final String sourceName;

  Post({
    this.title = "",
    this.description = "",
    this.imageUrl = "",
    this.sourceName = "",
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      title: json["title"] ?? "",
      description: json["description"] ?? "",
      imageUrl: json["urlToImage"] ?? "",
      sourceName: json["source"]["name"] ?? "",
    );
  }
}