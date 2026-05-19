class Pelicula {
  final int id;
  final String titulo;
  final String fecha;
  final String sinopsis;
  final String imagen;
  final double rating;
  final String genero;

  Pelicula({
    this.id = 0,
    this.titulo = "",
    this.fecha = "",
    this.sinopsis = "",
    this.imagen = "",
    this.rating = 0,
    this.genero = "",
  });

  factory Pelicula.fromJson(Map<String, dynamic> json) {
    return Pelicula(
      id: json["id"] ?? 0,
      titulo: json["title"] ?? "",
      fecha: json["release_date"] ?? "",
      sinopsis: json["overview"] ?? "",
      imagen: json["poster_path"] ?? "",
      rating: (json["vote_average"] ?? 0).toDouble(),
      genero: "",
    );
  }

  String get urlImagen {
    if (imagen.isEmpty) return "";
    if (imagen.startsWith("http")) return imagen;
    return "https://image.tmdb.org/t/p/w200$imagen";
  }
}


/*
• Título
• Año
• Tiempo de duración
• Género
• Director
• Sinopsis
• Imagen de la película
• Rating en el sitio (Puntuación del usuario).
 */