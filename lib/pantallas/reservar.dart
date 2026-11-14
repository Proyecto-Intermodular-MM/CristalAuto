import 'package:flutter/material.dart';

import '../modelos.dart';
import '../repositorio.dart';

/// Pantalla 3: elegir día, hora exacta y dirección; el pago queda retenido.
class Reservar extends StatefulWidget {
  const Reservar({super.key, required this.repositorio, required this.lavadero, required this.servicio});

  final Repositorio repositorio;
  final Lavadero lavadero;
  final Servicio servicio;

  @override
  State<Reservar> createState() => _ReservarState();
}

class _ReservarState extends State<Reservar> {
  final _direccion = TextEditingController();
  late final List<DateTime> _dias;
  int _dia = 0;
  int? _hora;

  @override
  void initState() {
    super.initState();
    final hoy = DateTime.now();
    _dias = List.generate(3, (i) => DateTime(hoy.year, hoy.month, hoy.day + i + 1));
  }

  @override
  void dispose() {
    _direccion.dispose();
    super.dispose();
  }

  DateTime _inicio(int hora) {
    final d = _dias[_dia];
    return DateTime(d.year, d.month, d.day, hora);
  }

  void _confirmar() {
    final hora = _hora;
    if (hora == null) {
      _aviso('Elige una hora');
      return;
    }
    try {
      widget.repositorio.reservar(widget.lavadero, widget.servicio, _inicio(hora), _direccion.text);
      Navigator.of(context).popUntil((r) => r.isFirst);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reserva confirmada. El pago queda retenido hasta completar el servicio.')),
      );
    } on ErrorReserva catch (e) {
      _aviso(e.mensaje);
    }
  }

  void _aviso(String m) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tu reserva')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Text('${widget.servicio.nombre} · ${widget.servicio.precio}',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          const Text('Día'),
          Wrap(spacing: 8, children: [
            for (var i = 0; i < _dias.length; i++)
              ChoiceChip(
                label: Text('${_dias[i].day}/${_dias[i].month}'),
                selected: _dia == i,
                onSelected: (_) => setState(() {
                  _dia = i;
                  _hora = null;
                }),
              ),
          ]),
          const SizedBox(height: 12),
          const Text('Hora exacta'),
          Wrap(spacing: 8, children: [
            for (final h in Repositorio.horasDelDia)
              ChoiceChip(
                label: Text('${h.toString().padLeft(2, '0')}:00'),
                selected: _hora == h,
                onSelected: widget.repositorio.horaLibre(widget.lavadero, _inicio(h), widget.servicio)
                    ? (_) => setState(() => _hora = h)
                    : null,
              ),
          ]),
          const SizedBox(height: 12),
          TextField(
            controller: _direccion,
            decoration: const InputDecoration(labelText: 'Dirección del servicio'),
          ),
          const SizedBox(height: 8),
          const Text('El pago queda retenido hasta que el servicio esté completado.'),
          const SizedBox(height: 16),
          FilledButton(onPressed: _confirmar, child: const Text('Confirmar y pagar')),
        ],
      ),
    );
  }
}
