# CristalAuto

App para encontrar, valorar y contratar **car detailers** (personas que limpian y detallan coches) que se desplazan hasta ti, en la **hora exacta** que tú elijas. Después del servicio, dejas tu reseña.

> Estado del proyecto: esqueleto de Flutter, aún sin funcionalidad. Este README describe el producto que se quiere construir.

---

## 1. La idea

Limpiar bien un coche no es lavarlo: es detailing. Pulido, descontaminación, corrección de pintura, tapicería, motor, cerámica. Es un trabajo de especialista, y hoy se contrata por Instagram, WhatsApp o boca a boca: sin precios claros, sin reseñas fiables y sin forma de saber si alguien vendrá a la hora que dice.

CristalAuto resuelve las tres cosas en una sola app:

1. **Ver cómo trabaja cada detailer** — valoración media, número de reseñas, fotos de antes y después, servicios y precios.
2. **Reservar en una hora exacta** — tú dices día y hora, el detailer viene a tu dirección y limpia el coche allí.
3. **Volver a valorarlo** — solo puedes reseñar si el servicio se completó, y la reseña alimenta la reputación que ven los siguientes clientes.

Es un marketplace de servicios a domicilio con reputación verificada y agenda por franjas exactas.

---

## 2. Problema que resuelve

**Para el dueño del coche**

- No sabe a quién contratar ni cuánto debería costar.
- Las reseñas que encuentra están fuera de contexto (Instagram, grupos, comentarios sueltos).
- No hay compromiso horario: "te aviso cuando pueda" no es una cita.
- No hay garantía de que el trabajo se haya hecho ni forma de reclamar.

**Para el detailer**

- Depende de seguidores y mensajes para conseguir clientes.
- Pierde horas contestando presupuestos que no cierran.
- No tiene historial público de su trabajo que le diferencie de un lavacoches.
- Su agenda es un cuaderno o su memoria.

**Con la app**

- El cliente compara por reputación real y reserva con hora fija.
- El detailer publica su catálogo, define su zona y su disponibilidad, y recibe citas confirmadas.

---

## 3. Usuarios

### Cliente
Dueño de un coche que quiere que se lo limpien y detallen en su casa o trabajo, sin moverse, y con la tranquilidad de saber quién viene.

### Detailer
Profesional o autónomo del detailing que ofrece servicio a domicilio, gestiona su disponibilidad y construye reputación dentro de la plataforma.

### Admin (interno)
Modera reseñas, resuelve disputas, verifica identidad de detailers y gestiona cancelaciones problemáticas.

---

## 4. Flujo principal del cliente

1. **Buscar**
   Abre la app y ve una lista de detailers ordenada por valoración (con filtros: tipo de servicio, precio, distancia, disponibilidad para hoy o para una fecha concreta).

2. **Comparar**
   Cada tarjeta muestra foto del antes/después, nombre, valoración media con estrellas, número de reseñas, precio desde, radio de cobertura y próxima disponibilidad.

3. **Ver perfil**
   - Galería de trabajos.
   - Servicios con precio y duración estimada (ej. *Lavado premium — 90 min — 45 €*; *Corrección de pintura — 5 h — 280 €*).
   - Reseñas con estrellas, texto, fotos del resultado y respuesta del detailer.
   - Zona de cobertura y recargo por desplazamiento, si lo hay.

4. **Elegir servicio y hora**
   - Selecciona el servicio.
   - Elige día y **hora exacta** en el calendario de huecos disponibles reales del detailer (no es un "te llamo luego": es un slot bloqueado).
   - Indica dirección (con geolocalización), tipo de coche y notas ("está muy sucio por dentro", "aparcado en garaje", "hay toma de agua").

5. **Confirmar**
   - Resumen con precio desglosado: servicio + desplazamiento + extras.
   - Método de pago (tarjeta; el cobro se retiene hasta que el servicio se marca como completado).
   - El detailer acepta o el hueco se confirma automáticamente, según su configuración.

6. **Seguimiento**
   - Estado de la cita: *confirmada → en camino → en curso → completada / cancelada*.
   - Notificaciones y contacto dentro de la app.

7. **Reseñar**
   - Al pasar a *completada* se habilita la reseña (una por cita, dentro de una ventana de 30 días).
   - Valoración de 1 a 5 estrellas + texto + fotos opcionales.
   - La reseña es pública y no se puede borrar; el detailer puede responder una vez.

---

## 5. Flujo principal del detailer

1. **Alta y verificación**
   - Registro con datos, documento de identidad y, opcionalmente, alta de autónomo o seguro.
   - Verificación por el equipo antes de recibir la primera cita (evita perfiles fantasma).

2. **Perfil y catálogo**
   - Foto, bio, años de experiencia, productos que usa.
   - Servicios con precio, duración estimada y qué incluye cada uno.
   - Fotos de antes/después por trabajo.

3. **Zona y agenda**
   - Radio de cobertura en km y recargo opcional por distancia.
   - Disponibilidad semanal recurrente + excepciones puntuales (vacaciones, día libre).
   - Tiempo de desplazamiento entre citas para no solapar huecos.

4. **Gestión de citas**
   - Bandeja de solicitudes con aceptar / rechazar / proponer otra hora.
   - Vista de calendario con las citas del día y la dirección de cada una.
   - Marcar *en camino*, *en curso*, *completada*. Al completar se libera el pago.

5. **Reputación**
   - Media de estrellas, desglose por servicio y por criterio (puntualidad, resultado, trato).
   - Responder reseñas.
   - Las cancelaciones injustificadas del detailer penalizan su posición en la búsqueda.

---

## 6. Reglas de negocio importantes

**Reseñas**

- Solo se puede reseñar una cita en estado *completada*.
- Una reseña por cita, no editable después de publicar (se puede reportar y moderar).
- La valoración media que se muestra en la búsqueda se calcula ponderando el número de reseñas, para que un perfil con una sola reseña de 5 estrellas no adelante a uno con 200 de 4,8.
- Las reseñas sin texto y solo estrellas cuentan menos visualmente, pero cuentan igual en la media.
- Reportar → moderación → retirar solo si incumple normas (insultos, datos personales, contenido falso).

**Citas y hora exacta**

- El cliente elige un hueco, no un "rango aproximado".
- Cada servicio tiene una duración estimada; el hueco se bloquea por esa duración + margen de desplazamiento.
- Cancelación gratuita hasta X horas antes; después, penalización según política.
- Reprogramación permitida si ambas partes aceptan el nuevo hueco.
- Si el detailer no llega y no cancela, se reembolsa y penaliza su perfil.

**Pagos**

- Cobro autorizado al confirmar, capturado al marcar *completada*.
- Reembolso automático si se cancela dentro de plazo o no se presta el servicio.
- Propinas opcionales tras la reseña.

**Confianza**

- El detailer no puede eliminar una cita que ya tiene reseña.
- Fotos de antes/después verificables por fecha de la cita.
- Bloqueo de reseñas cruzadas entre cuentas vinculadas.

---

## 7. Pantallas previstas (MVP)

**Cliente**

- `Home / Descubrir`: lista de detailers ordenada por reputación, buscador y filtros.
- `Perfil de detailer`: galería, servicios, reseñas.
- `Reserva`: selección de servicio, calendario de huecos, dirección, notas.
- `Confirmación y pago`.
- `Mis citas`: próximas, historial, estados.
- `Detalle de cita`: estado, contacto, cancelar/reprogramar, botón de reseña.
- `Escribir reseña`: estrellas, texto, fotos.
- `Mi cuenta`: coches guardados, direcciones, métodos de pago.

**Detailer**

- `Panel`: citas de hoy, ingresos, valoración.
- `Calendario / disponibilidad`.
- `Mis servicios` (CRUD con precio y duración).
- `Reseñas` y respuestas.
- `Perfil público` (vista previa).

---

## 8. Modelo de datos (borrador)

```
User            (id, rol, nombre, email, teléfono, foto, verificado)
Vehicle         (id, userId, marca, modelo, color, matrícula, notas)
DetailerProfile (id, userId, bio, experiencia, radioKm, recargoKm,
                 ratingAvg, ratingCount, verificado)
Service         (id, detailerId, nombre, descripción, precio, duraciónMin, activo)
Availability    (id, detailerId, díaSemana, horaInicio, horaFin, excepción)
Booking         (id, clienteId, detailerId, serviceId, vehicleId,
                 inicio, fin, dirección, lat, lng, notas,
                 estado, precioTotal, estadoPago)
Review          (id, bookingId, clienteId, detailerId,
                 estrellas, texto, fotos, creadaEn, respuestaDetailer)
Payment         (id, bookingId, importe, autorizado, capturado, reembolsado)
```

Estados de `Booking`: `pendiente → confirmada → enCamino → enCurso → completada` / `cancelada` / `noPresentado`.

---

## 9. Stack técnico

- **App**: Flutter (ya inicializado en este repo), Android + iOS + web. Una sola base de código, Material 3.
- **Estado**: se decidirá con la implementación (Riverpod o Bloc; preferible Riverpod por simplicidad).
- **Backend**: API REST o Supabase/Firebase. Necesita autenticación, almacenamiento de fotos, geolocalización y notificaciones push.
- **Pagos**: Stripe (Connect para pagar a los detailers) o equivalente local.
- **Mapas**: Google Maps / Mapbox para dirección, radio de cobertura y navegación del detailer.

---

## 10. Alcance

**Dentro del MVP**

- Registro/login de clientes y detailers.
- Búsqueda con filtros y reputación.
- Perfil de detailer con servicios y reseñas.
- Reserva con hora exacta y dirección.
- Gestión de estados de la cita.
- Reseña posterior al servicio.
- Pago con retención y captura al completar.

**Fuera del MVP (después)**

- Chat en tiempo real (basta con notificaciones y teléfono al principio).
- Suscripciones o planes de mantenimiento periódico.
- Programa de fidelización y cupones.
- Facturación automática para empresas con flota.
- Analytics avanzado para el detailer.

---

## 11. Roadmap sugerido

1. **Fundación** — modelo de datos, autenticación, roles, perfiles.
2. **Catálogo y reputación** — servicios, fotos, media ponderada de reseñas.
3. **Agenda** — disponibilidad recurrente, huecos reales, antisolape.
4. **Reserva** — flujo completo de cita con estados.
5. **Pago** — autorización, captura, reembolso.
6. **Reseñas** — solo tras cita completada, respuesta del detailer, moderación.
7. **Pulido** — notificaciones, mapas, verificación de identidad, panel admin.

---

## 12. Desarrollo

```bash
flutter pub get
flutter run
```

```bash
flutter test        # tests
flutter analyze     # lints
```

Estructura relevante:

```
lib/main.dart       # punto de entrada (plantilla por defecto)
lib/                # aquí va el código de la app
test/               # tests
```
