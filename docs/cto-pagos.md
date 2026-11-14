# Integración de la pasarela de pago (diseño de CTO #5)

> Estado: **diseño; no hay integración implementada** (hace falta la cuenta de Stripe y el backend NestJS). La tarea sigue abierta. Los importes y comisiones están en [finanzas/comisiones.md](finanzas/comisiones.md).

## Elección: Stripe Connect

Stripe permite cobrar al cliente, **retener** el importe y repartirlo después entre el lavadero y la plataforma. Tarifa estándar para tarjeta europea: 1,5 % + 0,25 € ([stripe.com/en-es/pricing](https://stripe.com/en-es/pricing)). Confirmar los costes específicos de Connect en su página de precios antes de contratar.

## Flujo

1. **Alta del lavadero:** crea una cuenta conectada (*Express*) y completa el alta con Stripe. Se guarda `stripe_account_id` en `lavaderos`.
2. **Reserva:** el backend crea un `PaymentIntent` con `capture_method = manual`, `amount` = precio del servicio y `transfer_data.destination` = cuenta del lavadero con `application_fee_amount` = comisión (`precio_cent × comision_pct / 100`). El cliente confirma el pago en la app; la tarjeta queda **autorizada, no cobrada**. Se crea la fila en `pagos` con estado `retenido`.
3. **Servicio completado:** el lavadero marca la cita como completada → el backend captura el `PaymentIntent`. Stripe liquida al lavadero y retiene la comisión. Estado `capturado`.
4. **Cancelación o no prestación:** el backend cancela el `PaymentIntent` (o hace un reembolso si ya estaba capturado). Estado `reembolsado`.
5. **Webhooks** (`payment_intent.succeeded`, `payment_intent.canceled`, `charge.refunded`) actualizan `pagos`; la verdad del estado es el webhook, no la app.

## Límite a tener en cuenta

Una autorización de tarjeta caduca (en general en torno a 7 días). Reservas con más antelación deben autorizar el pago más cerca de la fecha, o cobrar y reembolsar.

## Esquema y seguridad

- La tabla `pagos` ya existe en `supabase/migrations/0001_esquema.sql` (estados `retenido`, `capturado`, `reembolsado`, `fallido`) y solo es de lectura para clientes y lavaderos.
- Las claves de Stripe viven solo en el backend (variables de entorno); la app nunca ve la clave secreta.
- Endpoints previstos: `POST /reservas/:id/pago`, `POST /reservas/:id/completar`, `POST /reservas/:id/cancelar`, `POST /webhooks/stripe`.

## Pruebas

Usar claves de test de Stripe y las tarjetas de prueba de su documentación; cubrir captura, cancelación y reembolso con los webhooks en modo test.
