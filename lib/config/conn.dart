import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> inicializarBaseDatos() async {
  return openDatabase(
    join(await getDatabasesPath(), 'peliculasDb.db'),
    onCreate: (db, version) async {
      await db.execute(
        'CREATE TABLE pelicula(id INTEGER PRIMARY KEY, titulo TEXT, fecha TEXT, genero TEXT, sinopsis TEXT, imagen TEXT, rating FLOAT)',
      );
      await db.execute(
        'CREATE TABLE historial(id INTEGER PRIMARY KEY AUTOINCREMENT, query TEXT)',
      );
    },
    onUpgrade: (db, oldVersion, newVersion) async {
      if (oldVersion < 2) {
        await db.execute(
          'CREATE TABLE historial(id INTEGER PRIMARY KEY AUTOINCREMENT, query TEXT)',
        );
      }
    },
    version: 2,
  );
}
