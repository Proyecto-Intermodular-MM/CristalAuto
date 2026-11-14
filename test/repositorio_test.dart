import 'package:cristal_auto/modelos.dart';
import 'package:cristal_auto/repositorio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Repositorio repo;
  late Lavadero lav;
  late Servicio srv;
  final inicio = DateTime(2030, 1, 10, 10);

  setUp(() {
    repo = Repositorio();
    lav = repo.lavaderos.first;
    srv = lav.servicios.first;
  });

  test('no permite dos citas solapadas en el mismo lavadero', () {
    repo.reservar(lav, srv, inicio, 'Calle 1');
    expect(() => repo.reservar(lav, srv, inicio.add(const Duration(minutes: 30)), 'Calle 2'),
        throwsA(isA<ErrorReserva>()));
    // otra franja libre sí
    repo.reservar(lav, srv, inicio.add(const Duration(hours: 3)), 'Calle 2');
  });

  test('el pago queda retenido y se libera al completar', () {
    final r = repo.reservar(lav, srv, inicio, 'Calle 1');
    expect(r.estadoPago, EstadoPago.retenido);
    for (var i = 0; i < 4; i++) {
      repo.avanzar(r);
    }
    expect(r.estado, EstadoReserva.completada);
    expect(r.estadoPago, EstadoPago.capturado);
    expect(r.comisionCent, 400); // 10 % de 40 €
    expect(r.netoLavaderoCent, 3600);
  });

  test('cancelar reembolsa; no se puede cancelar en curso', () {
    final r = repo.reservar(lav, srv, inicio, 'Calle 1');
    repo.cancelar(r);
    expect(r.estadoPago, EstadoPago.reembolsado);
    final r2 = repo.reservar(lav, srv, inicio, 'Calle 1'); // la hora vuelve a quedar libre
    repo.avanzar(r2);
    repo.avanzar(r2);
    repo.avanzar(r2);
    expect(() => repo.cancelar(r2), throwsA(isA<ErrorReserva>()));
  });

  test('solo se reseña una cita completada y una vez', () {
    final r = repo.reservar(lav, srv, inicio, 'Calle 1');
    expect(() => repo.resenar(r, 5, 'Genial'), throwsA(isA<ErrorReserva>()));
    for (var i = 0; i < 4; i++) {
      repo.avanzar(r);
    }
    final antes = lav.resenas.length;
    repo.resenar(r, 4, 'Bien');
    expect(lav.resenas.length, antes + 1);
    expect(() => repo.resenar(r, 5, 'Otra'), throwsA(isA<ErrorReserva>()));
  });

  test('exige dirección', () {
    expect(() => repo.reservar(lav, srv, inicio, '  '), throwsA(isA<ErrorReserva>()));
  });
}
