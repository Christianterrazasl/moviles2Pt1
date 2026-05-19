import 'package:flutter_http/config/conn.dart';

class HistorialRepository {
  Future<List<String>> obtenerHistorial() async {
    final db = await inicializarBaseDatos();
    final lista = await db.query('historial', orderBy: 'id DESC', limit: 8);
    return lista.map((fila) => fila['query'] as String).toList();
  }

  Future<void> guardarBusqueda(String query) async {
    if (query.trim().isEmpty) return;
    final db = await inicializarBaseDatos();
    await db.insert('historial', {'query': query.trim()});
  }
}
