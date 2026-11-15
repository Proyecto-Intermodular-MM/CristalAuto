# Comisiones: cómo se aplican y cuánto cobramos (CFO #2)

## Cómo se aplica

1. El cliente reserva y **paga el total** a través de la pasarela de pagos (la app de pago que usemos). El dinero queda **retenido**.
2. Cuando el lavadero marca el servicio como completado y el cliente no abre incidencia, se **libera el pago**: CristalAuto se queda con su comisión y el resto va al lavadero.
3. Si se cancela en plazo o el servicio no se presta, **se reembolsa** y no hay comisión.

Con una pasarela con pagos a terceros (por ejemplo Stripe Connect) esto se hace en el propio cobro: la comisión se descuenta automáticamente y no hay que perseguir pagos al lavadero.

## Cuánto cobramos

| Fase | Comisión | Motivo |
|---|---|---|
| Piloto (meses 1-3) | **5 %** | Atraer a los primeros lavaderos con una cuota baja. |
| Lanzamiento (a partir del mes 4) | **10 %** | Caso base del punto de equilibrio. |
| Servicio consolidado | **10-15 %** | Según ingresos y gastos de gestión, una vez haya reseñas y reservas fiables. |

La horquilla coincide con la de la presentación (5-10 % al inicio, 10-15 % consolidado). La comisión se muestra al lavadero **antes** de darse de alta; el cliente no paga recargo.

## Ejemplo (ticket de 40 €)

| Comisión | Ingreso bruto | Pasarela (1,5 % + 0,25 €) | Ingreso neto |
|---|---|---|---|
| 5 % | 2,00 € | 0,85 € | 1,15 € |
| 10 % | 4,00 € | 0,85 € | 3,15 € |
| 15 % | 6,00 € | 0,85 € | 5,15 € |

Con un 5 % apenas queda margen tras la pasarela, así que el 5 % solo tiene sentido como oferta de arranque limitada en el tiempo. Más detalle en [punto-de-equilibrio.md](punto-de-equilibrio.md).

> Decisión que debe confirmar el equipo: quién asume el coste de la pasarela. Aquí se supone que lo asume CristalAuto.
