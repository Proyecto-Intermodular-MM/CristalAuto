import 'package:flutter/material.dart';

import '../modelos.dart';
import '../repositorio.dart';
import 'detalle.dart';
import 'mis_reservas.dart';

/// Pantalla 1: comparar lavaderos por valoración y precio.
class Inicio extends StatefulWidget {
  const Inicio({super.key, required this.repositorio});

  final Repositorio repositorio;

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  bool _porValoracion = true;

  @override
  Widget build(BuildContext context) {
    final lista = [...widget.repositorio.lavaderos];
    if (_porValoracion) {
      lista.sort((a, b) => b.media.compareTo(a.media));
    } else {
      lista.sort((a, b) => a.precioDesdeCent.compareTo(b.precioDesdeCent));
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('CristalAuto'),
        actions: [
          IconButton(
            tooltip: 'Mis reservas',
            icon: const Icon(Icons.event_note),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(
              builder: (_) => MisReservas(repositorio: widget.repositorio),
            )),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Wrap(spacing: 8, children: [
              ChoiceChip(
                label: const Text('Mejor valorados'),
                selected: _porValoracion,
                onSelected: (_) => setState(() => _porValoracion = true),
              ),
              ChoiceChip(
                label: const Text('Más baratos'),
                selected: !_porValoracion,
                onSelected: (_) => setState(() => _porValoracion = false),
              ),
            ]),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: lista.length,
              itemBuilder: (context, i) {
                final l = lista[i];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(l.nombre),
                    subtitle: Text(
                      '${l.resenas.isEmpty ? 'Sin reseñas' : '★ ${l.media.toStringAsFixed(1)} · ${l.resenas.length} reseñas'}'
                      '\nDesde ${formatoEuros(l.precioDesdeCent)} · ${l.zona}',
                    ),
                    isThreeLine: true,
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(
                      builder: (_) => Detalle(repositorio: widget.repositorio, lavadero: l),
                    )),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
