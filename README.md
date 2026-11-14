# CristalAuto

> **Limpio como el cristal.**

CristalAuto es una app para **comparar, reservar, pagar y valorar lavados de coche a domicilio**. Eliges un lavadero o profesional del detallado por su reputación real, reservas una **hora exacta**, el pago queda retenido hasta que el trabajo está hecho y, al terminar, dejas tu reseña.

| Enlaces | |
|---|---|
| Tablero Kanban (GitHub Project) | <https://github.com/orgs/Proyecto-Intermodular-MM/projects/1> |
| Presentación (Canva) | <https://www.canva.com/d/9wAvFOnrHJSniHq> |

> Estado: esqueleto de Flutter, sin funcionalidad todavía. Este README describe el producto que se va a construir.

---

## 1. La idea

Hoy un lavado o detallado de coche se contrata por Instagram, WhatsApp o boca a boca: sin precios claros, sin reseñas fiables y sin compromiso de hora. CristalAuto resuelve las tres cosas en una sola app:

1. **Compara**: valoración media, número de reseñas, servicios y precios de cada lavadero.
2. **Reserva**: eliges día y hora exacta; el profesional va a tu domicilio.
3. **Valora**: solo puede reseñar quien completó la cita, así que las reseñas son verificadas.

El **pago se retiene** hasta que el servicio está hecho. CristalAuto cobra una **comisión por servicio completado**.

**Diferencial:** reseñas verificadas, pago retenido y reserva a domicilio con hora exacta.

## 2. Equipo y roles

| Persona | Usuario GitHub | Roles |
|---|---|---|
| Thiago Montblanch | `Cupid-OS` | CEO, CMO y diseño |
| Aram Aljundi | `nyarw` | CTO y CIO |
| Jose Ortega | `jekooo2814` | CFO y CTO |

Cada persona tiene tareas asignadas en el Kanban según su rol.

## 3. Mayor rival

**Milanuncios**: es el sitio más reconocible donde hoy se anuncian lavaderos y particulares, pero no ofrece reserva con hora, pago protegido ni reseñas verificadas. Otros referentes del mercado: Washfy, Chemical Guys y Elefanteazul.

## 4. Análisis FODA

| | |
|---|---|
| **Fortalezas** | Reseñas verificadas · pago retenido · reserva a domicilio con hora exacta · costes de arranque muy bajos |
| **Oportunidades** | Mercado fragmentado, lavaderos pequeños sin presencia digital · mucho parque de coches y poca oferta online · expansión a otros servicios del coche |
| **Debilidades** | Marca nueva sin base de usuarios · equipo de 3 personas · hay que captar a la vez lavaderos y clientes |
| **Amenazas** | Milanuncios y Washfy ya tienen usuarios · competidores con más presupuesto · reseñas falsas o mala calidad dañan la marca · cambios normativos en pagos y comisiones |

## 5. CEO: organización del proyecto

- Repositorio con este `README.md`.
- **Project Kanban** asociado con las columnas **To do, Doing, Done y Approved**: <https://github.com/orgs/Proyecto-Intermodular-MM/projects/1>.
- Todas las tareas están escritas como issues, **no se borran** y cada una está asignada según el rol (CEO/diseño → Thiago, CTO → Aram, CFO → Jose).
- **Misión:** que cualquier conductor compare, reserve, pague y valore un lavado en una sola app, con reseñas verificadas y pago protegido.
- **Visión:** ser la app de referencia en España para contratar servicios de cuidado del coche a domicilio.
- **Ciudad piloto (propuesta):** Madrid, a confirmar por el equipo. Detalle y justificación en [docs/mision-vision.md](docs/mision-vision.md).
- Estrategia: ciudad piloto, captar primero lavaderos locales y después usuarios. Hoja de ruta estimada: mes 1 MVP, meses 2-3 piloto con 10 lavaderos, mes 4 en adelante ampliar a más ciudades.

## 6. Diseño

- **Nombre:** CristalAuto (fácil de decir y recordar en España; sustituye al nombre inicial, difícil de pronunciar).
- **Logo:** gota de agua azul con un coche dentro y destellos.
- **Eslogan:** *Limpio como el cristal.* (apoyo: «Tu coche impecable, sin moverte de casa»).
- **Colores:** primario azul noche `#1A233C` y secundario crema `#F4F0D2` (tonos mates); acentos saturados amarillo brillo `#FFC30F` y azul agua `#3FA9F5`.
- **Tipografía:** Montserrat ExtraBold (títulos) y Poppins Regular (textos y botones).

## 7. CTO: necesidades técnicas

| Necesidad | Decisión |
|---|---|
| Lenguajes | Dart (app) y TypeScript (API) |
| Frameworks | Flutter (Android, iOS y web) y NestJS |
| Base de datos | Supabase (PostgreSQL) con autenticación y permisos por rol: usuarios, lavaderos, servicios, reservas, reseñas y pagos |
| IA | Claude Code como asistente para programar y revisar código |
| Despliegue | Oracle Cloud (capa gratuita) para la API y la web |
| Dominio | `cristalauto.app` |
| HTTPS | Let's Encrypt con certbot (gratis y con renovación automática) |
| Dependencias | Renovate bot abre pull requests de actualización |

## 8. CFO: dinero

**Ingresos**
- **Comisión por reserva:** 5-10 % al inicio, 10-15 % con el servicio consolidado.
- **Anuncios** poco invasivos (Google Ads) en app y web para cubrir el hosting; nunca durante la reserva ni el pago.

**Costes (estimación)**
- Inicial, una sola vez: unos **440 €** (dominio 15 €, Google Play 25 €, Apple Developer 99 €, marketing de lanzamiento 300 €; Oracle, Supabase y HTTPS en plan gratuito).
- Mantenimiento: unos **153 €/mes** (Supabase Pro 23 €, Claude Code 20 €, dominio y Apple prorrateados 9,5 €, marketing 100 €).

**Punto de equilibrio:** con un ticket medio de 40 € y comisión del 10 % se ingresan 4 € por servicio, así que bastan unos **39 servicios al mes** para cubrir el mantenimiento. Las cifras son estimaciones a validar con el piloto.

## 9. Funcionamiento resumido

**Cliente:** busca y compara → abre el perfil → elige servicio y hora exacta → confirma y paga (retenido) → sigue el estado de la cita → reseña tras completarla.

**Lavadero / detailer:** alta y verificación → catálogo de servicios con precio y duración → zona y agenda → gestiona citas (aceptar, en camino, en curso, completada) → construye su reputación.

**Reglas clave:** solo se reseña una cita completada, una reseña por cita, el cobro se captura al completar el servicio y se reembolsa si se cancela en plazo o no se presta.

## 10. Alcance del MVP

Registro y login, búsqueda con filtros y reputación, perfil con servicios y reseñas, reserva con hora exacta y dirección, estados de la cita, pago con retención y reseña posterior. Quedan fuera por ahora: chat en tiempo real, suscripciones, cupones y facturación de flotas.

## 11. Desarrollo

```bash
flutter pub get
flutter run
flutter test        # tests
flutter analyze     # lints
```

Para colaborar, consulta [CONTRIBUTING.md](CONTRIBUTING.md).

## 12. Documentación

| Documento | Contenido |
|---|---|
| [docs/mision-vision.md](docs/mision-vision.md) | Misión, visión y ciudad piloto |
| [docs/rival.md](docs/rival.md) | Análisis del rival y la competencia |
| [docs/captacion.md](docs/captacion.md) | Plan de captación (borrador) |
| [docs/guion-exposicion.md](docs/guion-exposicion.md) | Guion y reparto de la exposición (≈ 10 min 40 s) |
| [docs/guia-de-estilo.md](docs/guia-de-estilo.md) | Colores, tipografía y marca |
| [docs/diseno/prototipo.html](docs/diseno/prototipo.html) | Prototipo de pantallas |
| [docs/finanzas/](docs/finanzas/) | Comisiones, costes, validación de precios, publicidad y previsión a 12 meses |
