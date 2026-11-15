import 'package:flutter/material.dart';

import '../modelos.dart';
import '../repositorio.dart';
import 'reservar.dart';

/// Pantalla 2: detalle del lavadero con servicios y reseñas verificadas.
class Detalle extends StatelessWidget {
  const Detalle({super.key, required this.repositorio, required this.lavadero});

  final Repositorio repositorio;
  final Lavadero lavadero;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(lavadero.nombre)),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Text('Servicios', style: Theme.of(context).textTheme.titleMedium),
          for (final s in lavadero.servicios)
            Card(
              child: ListTile(
                title: Text(s.nombre),
                subtitle: Text('${s.duracionMin} min'),
                trailing: FilledButton(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(
                    builder: (_) => Reservar(repositorio: repositorio, lavadero: lavadero, servicio: s),
                  )),
                  child: Text('Reservar ${s.precio}'),
                ),
              ),
            ),
          const SizedBox(height: 12),
          Text('Reseñas verificadas', style: Theme.of(context).textTheme.titleMedium),
          if (lavadero.resenas.isEmpty) const Padding(padding: EdgeInsets.all(8), child: Text('Aún no hay reseñas')),
          for (final r in lavadero.resenas)
            Card(
              child: ListTile(
                title: Text('★' * r.puntuacion),
                subtitle: Text(r.comentario),
                trailing: const Icon(Icons.verified, size: 18),
              ),
            ),
        ],
      ),
    );
  }
}
