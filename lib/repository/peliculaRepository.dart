import 'package:flutter_http/config/conn.dart';
import 'package:flutter_http/models/pelicula.dart';
import 'package:sqflite/sqlite_api.dart';

class PeliculaRepository {
  Future<List<Pelicula>> obtenerPeliculas() async {
    final db = await inicializarBaseDatos();
    if (db.isOpen) {
      final List<Map<String, Object?>> peliculaMap = await db.query('pelicula', orderBy: 'titulo');

      return peliculaMap.map((pelicula) {
        return Pelicula(
          id: pelicula['id'] as int,
          titulo: pelicula['titulo'] as String,
          fecha: pelicula['fecha'] as String,
          genero: pelicula['genero'] as String,
          sinopsis: pelicula['sinopsis'] as String,
          imagen: pelicula['imagen'] as String,
          rating: pelicula['rating'] as double,
        );
      }).toList();
    }

    return List.empty();
  }

  Future<void> insertarPelicula(Pelicula pelicula) async {
    final db = await inicializarBaseDatos();
    if (db.isOpen) {
      await db.insert('pelicula', {
        'id': pelicula.id,
        'titulo': pelicula.titulo,
        'fecha': pelicula.fecha,
        'genero': pelicula.genero,
        'sinopsis': pelicula.sinopsis,
        'imagen': pelicula.imagen,
        'rating': pelicula.rating,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  Future<void> eliminarPelicula(int id) async {
    final db = await inicializarBaseDatos();
    if (db.isOpen) {
      await db.delete('pelicula', where: 'id = ?', whereArgs: [id]);
    }
  }
}
