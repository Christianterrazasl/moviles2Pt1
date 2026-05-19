import 'package:flutter/material.dart';
import 'package:flutter_http/models/pelicula.dart';
import 'package:flutter_http/repository/historialRepository.dart';
import 'package:flutter_http/repository/peliculaRepository.dart';
import 'package:flutter_http/screen/peliculas_guardadas.dart';
import 'package:flutter_http/screen/resultados_busqueda.dart';

class ListaViewHolder extends StatefulWidget {
  const ListaViewHolder({super.key});

  @override
  State<ListaViewHolder> createState() => _ListaViewHolderState();
}

class _ListaViewHolderState extends State<ListaViewHolder> {
  final TextEditingController _busquedaController = TextEditingController();
  final PeliculaRepository _repoPeliculas = PeliculaRepository();
  final HistorialRepository _repoHistorial = HistorialRepository();

  List<Pelicula> peliculasGuardadas = [];
  List<String> historial = [];

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    final guardadas = await _repoPeliculas.obtenerPeliculas();
    final hist = await _repoHistorial.obtenerHistorial();
    setState(() {
      peliculasGuardadas = guardadas;
      historial = hist;
    });
  }

  Future<void> _buscar(String query) async {
    if (query.trim().isEmpty) return;

    await _repoHistorial.guardarBusqueda(query);
    await _cargarDatos();

    if (!mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultadosBusqueda(query: query.trim()),
      ),
    );

    await _cargarDatos();
  }

  @override
  void dispose() {
    _busquedaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Películas')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          TextField(
            controller: _busquedaController,
            decoration: const InputDecoration(
              labelText: 'Buscar película',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.search),
            ),
            onSubmitted: _buscar,
          ),
          if (historial.isNotEmpty) ...[
            const SizedBox(height: 8),
            const Text('Búsquedas anteriores'),
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: historial.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ActionChip(
                      label: Text(historial[index]),
                      onPressed: () {
                        _busquedaController.text = historial[index];
                        _buscar(historial[index]);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
          const SizedBox(height: 16),
          const Text(
            'Guardadas',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          PeliculasGuardadas(
            peliculas: peliculasGuardadas,
            onEliminar: (pelicula) async {
              await _repoPeliculas.eliminarPelicula(pelicula.id);
              await _cargarDatos();
            },
          ),
        ],
      ),
    );
  }
}
