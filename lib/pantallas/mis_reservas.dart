import 'package:flutter/material.dart';

import '../modelos.dart';
import '../repositorio.dart';

String _estado(EstadoReserva e) => switch (e) {
      EstadoReserva.pendiente => 'Pendiente',
      EstadoReserva.aceptada => 'Aceptada',
      EstadoReserva.enCamino => 'En camino',
      EstadoReserva.enCurso => 'En curso',
      EstadoReserva.completada => 'Completada',
      EstadoReserva.cancelada => 'Cancelada',
    };

String _pago(EstadoPago p) => switch (p) {
      EstadoPago.retenido => 'Pago retenido',
      EstadoPago.capturado => 'Pago liberado al lavadero',
      EstadoPago.reembolsado => 'Pago reembolsado',
    };

/// Pantalla 4: seguimiento de la cita y reseña tras completarla.
/// El botón «Avanzar estado» simula la acción del lavadero (en la versión real es otra app/rol).
class MisReservas extends StatefulWidget {
  const MisReservas({super.key, required this.repositorio});

  final Repositorio repositorio;

  @override
  State<MisReservas> createState() => _MisReservasState();
}

class _MisReservasState extends State<MisReservas> {
  void _resenar(Reserva r) async {
    var puntos = 5;
    final texto = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setD) => AlertDialog(
          title: const Text('¿Qué tal fue?'),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              for (var i = 1; i <= 5; i++)
                IconButton(
                  key: Key('estrella$i'),
                  icon: Icon(i <= puntos ? Icons.star : Icons.star_border),
                  onPressed: () => setD(() => puntos = i),
                ),
            ]),
            TextField(controller: texto, decoration: const InputDecoration(labelText: 'Comentario')),
          ]),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Más tarde')),
            FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Publicar reseña')),
          ],
        ),
      ),
    );
    if (ok == true) {
      widget.repositorio.resenar(r, puntos, texto.text);
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final lista = widget.repositorio.reservas;
    return Scaffold(
      appBar: AppBar(title: const Text('Mis reservas')),
      body: lista.isEmpty
          ? const Center(child: Text('Aún no tienes reservas'))
          : ListView(
              children: [
                for (final r in lista)
                  Card(
                    margin: const EdgeInsets.all(12),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('${r.lavadero.nombre} · ${r.servicio.nombre}',
                            style: Theme.of(context).textTheme.titleMedium),
                        Text('${r.inicio.day}/${r.inicio.month} a las ${r.inicio.hour.toString().padLeft(2, '0')}:00 · ${r.direccion}'),
                        Text('Estado: ${_estado(r.estado)}'),
                        Text('${_pago(r.estadoPago)} (${r.servicio.precio}, comisión ${formatoEuros(r.comisionCent)})'),
                        if (r.resena != null) Text('Tu reseña: ${'★' * r.resena!.puntuacion}'),
                        Wrap(spacing: 8, children: [
                          if (r.estado != EstadoReserva.completada && r.estado != EstadoReserva.cancelada)
                            TextButton(
                              onPressed: () => setState(() => widget.repositorio.avanzar(r)),
                              child: const Text('Avanzar estado'),
                            ),
                          if (r.estado == EstadoReserva.pendiente ||
                              r.estado == EstadoReserva.aceptada ||
                              r.estado == EstadoReserva.enCamino)
                            TextButton(
                              onPressed: () => setState(() => widget.repositorio.cancelar(r)),
                              child: const Text('Cancelar'),
                            ),
                          if (r.estado == EstadoReserva.completada && r.resena == null)
                            FilledButton(onPressed: () => _resenar(r), child: const Text('Dejar reseña')),
                        ]),
                      ]),
                    ),
                  ),
              ],
            ),
    );
  }
}
