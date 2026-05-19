import 'package:dio/dio.dart';
import 'package:flutter_http/models/pelicula.dart';

final String apiKey =
    "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiNWE4YjVlZDhkYmE2YmRmYTlkNzQ5MDMwNGZhNWY1MyIsIm5iZiI6MTc3ODk3ODg1Ny41MTcsInN1YiI6IjZhMDkxMDI5MzY2ZDE3MTYzMzljZWFlYSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.6ezKS7oUc2fwSKsMcxhO1uitpaIlqANnV-5sCovxQjU";

class PeliculaApiServices {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: "https://api.themoviedb.org/3",
      headers: {"Authorization": "Bearer $apiKey"},
    ),
  );

  Future<List<Pelicula>> getPeliculas(String query) async {
    final response = await dio.get(
      "/search/movie",
      queryParameters: {
        "query": query,
        "include_adult": true,
        "language": "en-US",
        "page": 1,
      },
    );

    final List peliculasResponse = response.data["results"];

    return peliculasResponse
        .map((pelicula) => Pelicula.fromJson(pelicula))
        .toList();
  }

  Future<Pelicula> getPeliculaById(int id) async {
    final response = await dio.get(
      "/movie/$id",
      queryParameters: {"append_to_response": "credits", "language": "en-US"},
    );

    return Pelicula.fromJson(response.data);
  }
}
