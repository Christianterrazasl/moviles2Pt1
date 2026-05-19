import 'package:flutter/material.dart';
import 'package:flutter_http/models/pelicula.dart';

class PeliculasGuardadas extends StatelessWidget {
  final List<Pelicula> peliculas;
  final void Function(Pelicula)? onEliminar;

  const PeliculasGuardadas({
    super.key,
    required this.peliculas,
    this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    if (peliculas.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(8),
        child: Text('No hay películas guardadas'),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: peliculas.length,
      itemBuilder: (context, index) {
        final p = peliculas[index];
        return ListTile(
          leading: Image.network(p.urlImagen, width: 50, fit: BoxFit.cover),
          title: Text(p.titulo),
          subtitle: Text('${p.fecha} · ★ ${p.rating}'),
          trailing: onEliminar == null
              ? null
              : IconButton(
                  icon: const Icon(Icons.delete_outline),
                  tooltip: 'Eliminar',
                  onPressed: () => onEliminar?.call(p),
                ),
        );
      },
    );
  }
}
