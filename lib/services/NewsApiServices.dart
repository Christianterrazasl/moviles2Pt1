import 'package:dio/dio.dart';
import 'package:flutter_http/models/post.dart';

final String apiKey = "9536527df3be4401967568da2bd5a0ef";

class NewsApiServices {
  final Dio dio = Dio(
    BaseOptions(baseUrl: "https://newsapi.org/v2"),
  );

  Future<List<Post>> getPosts(String category) async {
    final response = await dio.get(
      "/top-headlines?country=us&page=1&pageSize=5&category=$category&apiKey=$apiKey",
    );

    final List articles = response.data["articles"];

    List<Post> posts =
        articles.map((post) => Post.fromJson(post)).toList();

    return posts;
  }
}