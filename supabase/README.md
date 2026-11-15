# Base de datos (Supabase) · CTO #2

`migrations/0001_esquema.sql` crea el esquema de CristalAuto: `perfiles`, `lavaderos`, `servicios`, `reservas`, `pagos` y `resenas`, con permisos por rol mediante RLS.

## Cómo aplicarlo en Supabase

1. Crea un proyecto en [supabase.com](https://supabase.com) (plan gratuito).
2. Abre **SQL Editor**, pega el contenido de `migrations/0001_esquema.sql` y ejecútalo. O con la CLI: `supabase link` y `supabase db push`.
3. En **Authentication** activa email y contraseña.
4. Guarda la `anon key` (app) y la `service_role key` (solo en el backend NestJS, nunca en la app).

> Este paso (crearlo en el proyecto real de Supabase) lo tiene que hacer Aram con la cuenta del equipo; aquí el esquema está escrito y probado en local, pero **no está aplicado** en ningún proyecto Supabase.

## Reglas que garantiza el esquema

- Una cita por lavadero y franja horaria: una restricción de exclusión impide solapes (hora exacta).
- Reseña verificada: un trigger exige que la cita esté **completada** y sea del mismo cliente; una sola reseña por cita (`unique`).
- Permisos por rol: el cliente solo ve sus reservas; el lavadero, las de su negocio; los servicios y lavaderos activos son públicos; los pagos son de solo lectura (los cambia el backend con la `service_role`).
- Importes en céntimos y la comisión guardada en cada reserva (`comision_pct`).

## Prueba local

`tests/prueba_local.sql` simula `auth.users` y `auth.uid()` y comprueba seis casos (solape rechazado, reseña antes de completar rechazada, una reseña por cita, media de valoración, RLS por rol y suplantación). Con PostgreSQL 16 instalado:

```bash
psql -d postgres -v ON_ERROR_STOP=1 -f supabase/tests/prueba_local.sql   # en una base vacía
```

Resultado esperado: seis mensajes `NOTICE: OK n`.
