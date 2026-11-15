/// Modelos del MVP de CristalAuto (reflejan el esquema de supabase/migrations).
enum EstadoReserva { pendiente, aceptada, enCamino, enCurso, completada, cancelada }

enum EstadoPago { retenido, capturado, reembolsado }

class Servicio {
  const Servicio({
    required this.id,
    required this.nombre,
    required this.precioCent,
    required this.duracionMin,
  });

  final String id;
  final String nombre;
  final int precioCent;
  final int duracionMin;

  String get precio => formatoEuros(precioCent);
}

class Resena {
  const Resena({required this.puntuacion, required this.comentario, this.verificada = true});

  final int puntuacion;
  final String comentario;
  final bool verificada;
}

class Lavadero {
  Lavadero({
    required this.id,
    required this.nombre,
    required this.zona,
    required this.servicios,
    List<Resena>? resenas,
  }) : resenas = resenas ?? [];

  final String id;
  final String nombre;
  final String zona;
  final List<Servicio> servicios;
  final List<Resena> resenas;

  double get media =>
      resenas.isEmpty ? 0 : resenas.map((r) => r.puntuacion).reduce((a, b) => a + b) / resenas.length;

  int get precioDesdeCent => servicios.map((s) => s.precioCent).reduce((a, b) => a < b ? a : b);
}

class Reserva {
  Reserva({
    required this.id,
    required this.lavadero,
    required this.servicio,
    required this.inicio,
    required this.direccion,
    required this.comisionPct,
    this.estado = EstadoReserva.pendiente,
    this.estadoPago = EstadoPago.retenido,
    this.resena,
  });

  final String id;
  final Lavadero lavadero;
  final Servicio servicio;
  final DateTime inicio;
  final String direccion;
  final double comisionPct;
  EstadoReserva estado;
  EstadoPago estadoPago;
  Resena? resena;

  DateTime get fin => inicio.add(Duration(minutes: servicio.duracionMin));

  /// Comisión de CristalAuto en céntimos (solo se cobra al completar).
  int get comisionCent => (servicio.precioCent * comisionPct / 100).round();

  /// Lo que recibe el lavadero al liberarse el pago.
  int get netoLavaderoCent => servicio.precioCent - comisionCent;
}

String formatoEuros(int cent) {
  final euros = cent ~/ 100;
  final resto = cent % 100;
  return resto == 0 ? '$euros €' : '$euros,${resto.toString().padLeft(2, '0')} €';
}
