# Costes: inicial y mantenimiento (CFO #3)

Los costes que necesita el CTO (según [CTO #1](../../README.md#7-cto-necesidades-técnicas)), sumados en dos bloques. Todas son **estimaciones**; la columna «Comprobado» indica qué se ha contrastado con la web oficial (ver [validación](validacion-presupuestos.md)).

## Coste inicial (una sola vez)

| Concepto | Importe | Comprobado |
|---|---|---|
| Dominio `cristalauto.app` (1.er año) | 15 € | No (precio según registrador) |
| Cuenta de Google Play (pago único) | 25 € | Sí (≈ 25 USD) |
| Cuenta de Apple Developer (1.er año) | 99 € | Sí (99 USD al año, ≈ 91 €) |
| Marketing de lanzamiento | 300 € | Presupuesto propio |
| Oracle Cloud, Supabase (plan gratuito), HTTPS Let's Encrypt | 0 € | Sí |
| **Total inicial** | **439 € ≈ 440 €** | |

## Mantenimiento (al mes)

| Concepto | Importe | Comprobado |
|---|---|---|
| Supabase Pro (al superar el plan gratuito) | 23 € | Sí (25 USD ≈ 23 €) |
| Claude Code (IA) | 20 € | No |
| Dominio y Apple prorrateados (15 € + 99 €) ÷ 12 | 9,50 € | Sí |
| Marketing continuo | 100 € | Presupuesto propio |
| Oracle Cloud y HTTPS | 0 € | Sí |
| **Total mensual** | **152,50 € ≈ 153 €** (≈ 1.830 € al año) | |

## Dos puntos a vigilar

- El plan gratuito de Supabase **pausa el proyecto tras una semana sin actividad**; para el piloto o la demo conviene el plan Pro desde antes de abrir al público.
- No incluye la **pasarela de pago** (≈ 0,85 € por servicio de 40 €): ver [comisiones.md](comisiones.md) y [punto-de-equilibrio.md](punto-de-equilibrio.md).
