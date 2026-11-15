import 'modelos.dart';

class ErrorReserva implements Exception {
  ErrorReserva(this.mensaje);
  final String mensaje;
  @override
  String toString() => mensaje;
}

/// Repositorio en memoria con las reglas del negocio. Se puede sustituir por
/// una implementación con Supabase manteniendo esta misma interfaz.
class Repositorio {
  Repositorio({this.comisionPct = 10}) : lavaderos = _datosDeEjemplo();

  final double comisionPct;
  final List<Lavadero> lavaderos;
  final List<Reserva> reservas = [];
  int _contador = 0;

  /// Horas ofrecidas cada día (hora exacta).
  static const horasDelDia = [9, 10, 12, 16, 17, 19];

  bool horaLibre(Lavadero lav, DateTime inicio, Servicio servicio) {
    final fin = inicio.add(Duration(minutes: servicio.duracionMin));
    return !reservas.any((r) =>
        r.lavadero.id == lav.id &&
        r.estado != EstadoReserva.cancelada &&
        inicio.isBefore(r.fin) &&
        fin.isAfter(r.inicio));
  }

  /// Crea la reserva; el pago queda retenido hasta completar el servicio.
  Reserva reservar(Lavadero lav, Servicio servicio, DateTime inicio, String direccion) {
    if (direccion.trim().isEmpty) throw ErrorReserva('Indica la dirección del servicio');
    if (!horaLibre(lav, inicio, servicio)) throw ErrorReserva('Esa hora ya no está disponible');
    final r = Reserva(
      id: 'r${++_contador}',
      lavadero: lav,
      servicio: servicio,
      inicio: inicio,
      direccion: direccion.trim(),
      comisionPct: comisionPct,
    );
    reservas.add(r);
    return r;
  }

  /// Avanza el estado de la cita (lo hace el lavadero). Al completar se libera el pago.
  void avanzar(Reserva r) {
    const orden = [
      EstadoReserva.pendiente,
      EstadoReserva.aceptada,
      EstadoReserva.enCamino,
      EstadoReserva.enCurso,
      EstadoReserva.completada,
    ];
    final i = orden.indexOf(r.estado);
    if (i < 0 || i == orden.length - 1) return;
    r.estado = orden[i + 1];
    if (r.estado == EstadoReserva.completada) r.estadoPago = EstadoPago.capturado;
  }

  /// Cancelar antes de empezar el servicio reembolsa el pago retenido.
  void cancelar(Reserva r) {
    if (r.estado == EstadoReserva.enCurso || r.estado == EstadoReserva.completada) {
      throw ErrorReserva('Ya no se puede cancelar esta cita');
    }
    r.estado = EstadoReserva.cancelada;
    r.estadoPago = EstadoPago.reembolsado;
  }

  /// Reseña verificada: solo citas completadas y una por cita.
  void resenar(Reserva r, int puntuacion, String comentario) {
    if (r.estado != EstadoReserva.completada) {
      throw ErrorReserva('Solo puedes reseñar una cita completada');
    }
    if (r.resena != null) throw ErrorReserva('Ya has reseñado esta cita');
    if (puntuacion < 1 || puntuacion > 5) throw ErrorReserva('La puntuación va de 1 a 5');
    final res = Resena(puntuacion: puntuacion, comentario: comentario.trim());
    r.resena = res;
    r.lavadero.resenas.add(res);
  }
}

List<Lavadero> _datosDeEjemplo() => [
      Lavadero(
        id: 'l1',
        nombre: 'Lavadero Ejemplo A',
        zona: 'Madrid centro',
        servicios: const [
          Servicio(id: 's1', nombre: 'Lavado completo', precioCent: 4000, duracionMin: 90),
          Servicio(id: 's2', nombre: 'Solo exterior', precioCent: 2500, duracionMin: 45),
        ],
        resenas: [const Resena(puntuacion: 5, comentario: 'Puntuales y el coche impecable.')],
      ),
      Lavadero(
        id: 'l2',
        nombre: 'Detailing Ejemplo B',
        zona: 'Madrid norte',
        servicios: const [
          Servicio(id: 's3', nombre: 'Detallado interior', precioCent: 6000, duracionMin: 120),
        ],
        resenas: [
          const Resena(puntuacion: 4, comentario: 'Muy buen trabajo.'),
          const Resena(puntuacion: 5, comentario: 'Repetiré.'),
        ],
      ),
      Lavadero(
        id: 'l3',
        nombre: 'Lavadero Ejemplo C',
        zona: 'Madrid sur',
        servicios: const [
          Servicio(id: 's4', nombre: 'Lavado básico', precioCent: 2000, duracionMin: 45),
        ],
      ),
    ];
