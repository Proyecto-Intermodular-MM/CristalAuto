# Guion de la exposición (≈ 10 min 40 s)

El enunciado pide una exposición de **9 a 12 minutos**. Las notas actuales del Canva suman unos **15 min 20 s** (20 + 15 + 75 + 30 + 60 + 45 + 45 + 75 + 75 + 30 + 75 + 30 + 90 + 75 + 60 + 60 + 45 + 15 segundos), así que se pasan. Este guion recorta cada diapositiva (las notas recortadas están ya en una copia del Canva: [Radiografía del sector - guion 10-11 min](https://www.canva.com/d/Td51zv7NdWZ5Nsz), donde además la diapositiva 16 muestra el equilibrio en ~49 servicios con pasarela) y reparte los turnos de forma más equilibrada. Las 18 diapositivas son las de [Radiografía del sector - CristalAuto](https://www.canva.com/d/SaNKTR3gMCf32qh).

> Regla: no leer la diapositiva; contar la idea con palabras propias. Ensayar con cronómetro y ajustar (el margen es de ±1 min).

## Reparto y tiempos

| Nº | Diapositiva | Quién | Tiempo | Qué decir (resumen) |
|---|---|---|---|---|
| 1 | Portada | Thiago | 0:15 | Nos presentamos y damos el lema: «Limpio como el cristal». |
| 2 | Índice | Thiago | 0:10 | Idea, equipo, rival, FODA y luego cada rol. |
| 3 | La idea | Thiago | 1:00 | Hoy un lavado se contrata por Instagram o WhatsApp, sin precio claro ni hora asegurada. CristalAuto: comparas, reservas hora exacta, el profesional va a tu domicilio y reseñas solo si la cita se completó. Pago retenido hasta terminar. Cobramos una comisión por servicio completado. |
| 4 | Equipos y roles | Aram | 0:25 | Presenta a los tres: Thiago (CEO, CMO y diseño), Aram (CTO y CIO), Jose (CFO y CTO). Todos con tareas en el Kanban. |
| 5 | Mayor rival | Thiago | 0:40 | Milanuncios: el más conocido, pero es un tablón de anuncios: sin reserva con hora, sin pago protegido y sin reseñas verificadas. |
| 6 | Modelo de idea | Aram | 0:25 | Esquema: conductor + lavadero → CristalAuto → coche limpio, cliente contento, lavadero con trabajo. |
| 7 | Análisis de mercado | Aram | 0:30 | Washfy, Chemical Guys y Elefanteazul cubren una parte; ninguna junta reseñas verificadas, hora exacta a domicilio y pago retenido. |
| 8 | FODA | Jose | 0:50 | Una frase por cuadrante: fortalezas (reseñas verificadas, pago retenido), oportunidades (lavaderos sin presencia digital), debilidades (marca nueva, 3 personas), amenazas (Milanuncios y Washfy con usuarios). Respuesta: ciudad piloto. |
| 9 | CEO: visión y organización | Thiago | 0:50 | Repo con README, Kanban de 4 columnas, estrategia: ciudad piloto → lavaderos → usuarios. Hoja de ruta: mes 1 MVP, meses 2-3 piloto con 10 lavaderos, mes 4 más ciudades. |
| 10 | CEO: tablero Kanban | Thiago | 0:25 | Enseñar el tablero real; todas las tareas escritas, ninguna borrada, cada una con responsable. |
| 11 | Identidad visual | Thiago | 0:50 | Nombre fácil de decir en España, logo gota + coche, eslogan, 4 colores y dos tipografías (Montserrat ExtraBold y Poppins Regular). |
| 12 | Tecnologías | Aram | 0:20 | Dart + Flutter (Android, iOS y web con una base de código) y TypeScript + NestJS para la API. |
| 13 | CTO: datos, IA e infraestructura | Aram | 1:00 | Supabase (PostgreSQL) con permisos por rol; Claude Code como IA de apoyo; Oracle Cloud sí se puede usar; dominio `cristalauto.app`; HTTPS gratis con Let's Encrypt y certbot. |
| 14 | CFO: modelo de ingresos | Jose | 0:50 | Comisión 5-10 % al inicio y 10-15 % después, cobrada al completar el servicio; anuncios poco invasivos para cubrir el hosting. Ejemplo: 40 € × 10 % = 4 €. |
| 15 | CFO: costes | Jose | 0:40 | Inicial ≈ 440 € (una vez); mantenimiento ≈ 153 €/mes. |
| 16 | CFO: punto de equilibrio | Jose | 0:50 | 153 ÷ 4 ≈ 39 servicios/mes. Si se descuenta la pasarela de pago (≈ 0,85 € por servicio), serían ≈ 49. Todo son estimaciones a validar con el piloto. |
| 17 | Conclusión | Thiago | 0:30 | Compara, reserva, paga y valora; reseñas verificadas y pago retenido; próximos pasos: MVP, piloto, mejorar con opiniones. |
| 18 | Gracias | Todos | 0:10 | Agradecer y abrir preguntas. |

**Total: 10 min 40 s** (Thiago 4:40 · Aram 2:40 · Jose 3:10 · todos 0:10).

## Posibles preguntas del tribunal

- **¿Por qué os van a elegir frente a Milanuncios o Washfy?** Reseñas solo de citas completadas, pago retenido y hora exacta; es lo que ninguno junta.
- **¿Cómo ganáis dinero?** Comisión por servicio completado y anuncios discretos.
- **¿Cuánto cuesta arrancar?** Unos 440 € gracias a planes gratuitos (Oracle, Supabase, Let's Encrypt).
- **¿Cuántos servicios hacen falta para no perder dinero?** Unos 39 al mes antes de pasarela y unos 49 contando la pasarela (ver [docs/finanzas](finanzas/)).
- **¿Qué pasa si el lavadero no se presenta?** El pago retenido se reembolsa.
- **¿Por qué empezar en una sola ciudad?** Hay que captar a la vez lavaderos y clientes; concentrar la oferta evita una app vacía.

## Para ensayar

1. Ensayo completo con cronómetro y cambio de turno entre diapositivas.
2. Tener abierto el tablero real de GitHub para la diapositiva 10.
3. Comprobar proyector y el enlace del Canva antes de empezar.
