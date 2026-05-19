import 'package:flutter/material.dart';
import 'package:flutter_http/models/pelicula.dart';
import 'package:flutter_http/repository/peliculaRepository.dart';
import 'package:flutter_http/services/peliculasApiServices.dart';

class ResultadosBusqueda extends StatefulWidget {
  final String query;

  const ResultadosBusqueda({super.key, required this.query});

  @override
  State<ResultadosBusqueda> createState() => _ResultadosBusquedaState();
}

class _ResultadosBusquedaState extends State<ResultadosBusqueda> {
  final PeliculaApiServices _api = PeliculaApiServices();
  final PeliculaRepository _repo = PeliculaRepository();

  List<Pelicula> peliculas = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    _buscar();
  }

  Future<void> _buscar() async {
    try {
      final resultado = await _api.getPeliculas(widget.query);
      setState(() {
        peliculas = resultado;
        cargando = false;
      });
    } catch (e) {
      setState(() => cargando = false);
    }
  }

  Future<void> _guardar(Pelicula pelicula) async {
    await _repo.insertarPelicula(pelicula);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Resultados: ${widget.query}')),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : peliculas.isEmpty
              ? const Center(child: Text('No se encontraron películas'))
              : ListView.builder(
                  itemCount: peliculas.length,
                  itemBuilder: (context, index) {
                    final p = peliculas[index];
                    return ListTile(
                      leading: p.urlImagen.isNotEmpty
                          ? Image.network(p.urlImagen, width: 50, fit: BoxFit.cover)
                          : const Icon(Icons.movie),
                      title: Text(p.titulo),
                      subtitle: Text(
                        p.sinopsis,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () => _guardar(p),
                    );
                  },
                ),
    );
  }
}
