-- CristalAuto · esquema inicial para Supabase (PostgreSQL)
-- Tablas: perfiles, lavaderos, servicios, reservas, pagos y resenas, con permisos por rol (RLS).
-- Importes en céntimos de euro (enteros) para evitar errores de redondeo.

create extension if not exists btree_gist;

create type rol_usuario as enum ('cliente', 'lavadero', 'admin');
create type estado_reserva as enum ('pendiente', 'aceptada', 'en_camino', 'en_curso', 'completada', 'cancelada');
create type estado_pago as enum ('retenido', 'capturado', 'reembolsado', 'fallido');

-- Perfil de cada usuario (la autenticación la gestiona auth.users de Supabase)
create table perfiles (
  id uuid primary key references auth.users (id) on delete cascade,
  rol rol_usuario not null default 'cliente',
  nombre text not null,
  telefono text,
  creado_en timestamptz not null default now()
);

create table lavaderos (
  id uuid primary key default gen_random_uuid(),
  propietario_id uuid not null references perfiles (id) on delete cascade,
  nombre text not null,
  descripcion text,
  ciudad text not null,
  zona text,
  verificado boolean not null default false,
  activo boolean not null default true,
  creado_en timestamptz not null default now()
);
create index on lavaderos (ciudad) where activo;

create table servicios (
  id uuid primary key default gen_random_uuid(),
  lavadero_id uuid not null references lavaderos (id) on delete cascade,
  nombre text not null,
  descripcion text,
  precio_cent integer not null check (precio_cent > 0),
  duracion_min integer not null check (duracion_min > 0),
  activo boolean not null default true
);
create index on servicios (lavadero_id);

create table reservas (
  id uuid primary key default gen_random_uuid(),
  cliente_id uuid not null references perfiles (id),
  lavadero_id uuid not null references lavaderos (id),
  servicio_id uuid not null references servicios (id),
  inicio timestamptz not null,
  fin timestamptz not null,
  direccion text not null,
  estado estado_reserva not null default 'pendiente',
  precio_cent integer not null check (precio_cent > 0),
  comision_pct numeric(4, 1) not null default 10 check (comision_pct between 0 and 30),
  creado_en timestamptz not null default now(),
  check (fin > inicio),
  -- un lavadero no puede tener dos citas activas que se solapen (hora exacta)
  exclude using gist (
    lavadero_id with =,
    tstzrange(inicio, fin) with &&
  ) where (estado <> 'cancelada')
);
create index on reservas (cliente_id);
create index on reservas (lavadero_id, inicio);

create table pagos (
  id uuid primary key default gen_random_uuid(),
  reserva_id uuid not null unique references reservas (id) on delete cascade,
  referencia_pasarela text,                -- p. ej. PaymentIntent de Stripe
  importe_cent integer not null check (importe_cent > 0),
  estado estado_pago not null default 'retenido',
  actualizado_en timestamptz not null default now()
);

create table resenas (
  id uuid primary key default gen_random_uuid(),
  reserva_id uuid not null unique references reservas (id) on delete cascade, -- una reseña por cita
  cliente_id uuid not null references perfiles (id),
  lavadero_id uuid not null references lavaderos (id),
  puntuacion smallint not null check (puntuacion between 1 and 5),
  comentario text,
  creado_en timestamptz not null default now()
);
create index on resenas (lavadero_id);

-- Reseña verificada: solo si la cita está completada y es del mismo cliente y lavadero
create function comprobar_resena() returns trigger
language plpgsql as $$
declare r reservas%rowtype;
begin
  select * into r from reservas where id = new.reserva_id;
  if not found or r.estado <> 'completada'
     or r.cliente_id <> new.cliente_id or r.lavadero_id <> new.lavadero_id then
    raise exception 'Solo se puede reseñar una cita completada propia';
  end if;
  return new;
end $$;
create trigger resenas_verificadas before insert on resenas
  for each row execute function comprobar_resena();

-- Valoración media y número de reseñas por lavadero
create view lavaderos_valoracion with (security_invoker = true) as
select l.id as lavadero_id,
       coalesce(round(avg(r.puntuacion), 2), 0) as media,
       count(r.id) as num_resenas
from lavaderos l left join resenas r on r.lavadero_id = l.id
group by l.id;

-- Permisos por rol (RLS)
create function es_admin() returns boolean language sql stable security definer set search_path = public as
$$ select exists (select 1 from perfiles where id = auth.uid() and rol = 'admin') $$;

create function es_dueno(lav uuid) returns boolean language sql stable security definer set search_path = public as
$$ select exists (select 1 from lavaderos where id = lav and propietario_id = auth.uid()) $$;

alter table perfiles enable row level security;
alter table lavaderos enable row level security;
alter table servicios enable row level security;
alter table reservas enable row level security;
alter table pagos enable row level security;
alter table resenas enable row level security;

-- perfiles: cada uno ve y edita el suyo (no puede cambiarse el rol)
create policy perfil_ver on perfiles for select using (id = auth.uid() or es_admin());
create policy perfil_crear on perfiles for insert with check (id = auth.uid() and rol in ('cliente', 'lavadero'));
create policy perfil_editar on perfiles for update using (id = auth.uid())
  with check (id = auth.uid() and rol = (select p.rol from perfiles p where p.id = auth.uid()));

-- lavaderos y servicios: lectura pública de los activos; gestión por el dueño
create policy lav_ver on lavaderos for select using (activo or propietario_id = auth.uid() or es_admin());
create policy lav_crear on lavaderos for insert with check (propietario_id = auth.uid());
create policy lav_editar on lavaderos for update using (propietario_id = auth.uid() or es_admin())
  with check (propietario_id = auth.uid() or es_admin());
create policy serv_ver on servicios for select using (activo or es_dueno(lavadero_id) or es_admin());
create policy serv_gestionar on servicios for all using (es_dueno(lavadero_id)) with check (es_dueno(lavadero_id));

-- reservas: el cliente ve y crea las suyas; el lavadero ve y actualiza las de su negocio
create policy res_ver on reservas for select using (cliente_id = auth.uid() or es_dueno(lavadero_id) or es_admin());
create policy res_crear on reservas for insert with check (cliente_id = auth.uid() and estado = 'pendiente');
create policy res_actualizar on reservas for update using (cliente_id = auth.uid() or es_dueno(lavadero_id))
  with check (cliente_id = auth.uid() or es_dueno(lavadero_id));

-- pagos: solo lectura para las partes; los cambios los hace el backend con la service role
create policy pago_ver on pagos for select using (
  exists (select 1 from reservas r where r.id = reserva_id and (r.cliente_id = auth.uid() or es_dueno(r.lavadero_id)))
  or es_admin());

-- reseñas: lectura pública; solo las crea el cliente de la cita (el trigger exige cita completada)
create policy resena_ver on resenas for select using (true);
create policy resena_crear on resenas for insert with check (cliente_id = auth.uid());
