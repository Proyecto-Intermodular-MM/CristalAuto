import 'package:cristal_auto/main.dart';
import 'package:cristal_auto/repositorio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('flujo completo: comparar, reservar, completar y reseñar', (tester) async {
    final repo = Repositorio();
    await tester.pumpWidget(CristalAutoApp(repositorio: repo));

    // 1) La lista muestra los lavaderos, el mejor valorado primero
    expect(find.text('Detailing Ejemplo B'), findsOneWidget);
    await tester.tap(find.text('Lavadero Ejemplo A'));
    await tester.pumpAndSettle();

    // 2) Detalle: reserva del lavado completo
    expect(find.text('Reseñas verificadas'), findsOneWidget);
    await tester.tap(find.text('Reservar 40 €'));
    await tester.pumpAndSettle();

    // 3) Reserva: hora exacta y dirección
    await tester.tap(find.text('10:00'));
    await tester.enterText(find.byType(TextField), 'Calle Ejemplo 1');
    await tester.ensureVisible(find.text('Confirmar y pagar'));
    await tester.tap(find.text('Confirmar y pagar'));
    await tester.pumpAndSettle();
    expect(repo.reservas, hasLength(1));

    // 4) Mis reservas: avanzar hasta completar y reseñar
    await tester.tap(find.byTooltip('Mis reservas'));
    await tester.pumpAndSettle();
    expect(find.text('Estado: Pendiente'), findsOneWidget);
    expect(find.textContaining('Pago retenido'), findsOneWidget);
    for (var i = 0; i < 4; i++) {
      await tester.tap(find.text('Avanzar estado'));
      await tester.pump();
    }
    expect(find.text('Estado: Completada'), findsOneWidget);
    expect(find.textContaining('Pago liberado'), findsOneWidget);
    await tester.tap(find.text('Dejar reseña'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('estrella4')));
    await tester.pump();
    await tester.tap(find.text('Publicar reseña'));
    await tester.pumpAndSettle();
    expect(find.text('Tu reseña: ★★★★'), findsOneWidget);
    expect(repo.lavaderos.first.resenas, isNotEmpty);
  });
}
