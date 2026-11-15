-- Prueba local del esquema contra un PostgreSQL normal (simula auth.users y auth.uid()).
-- Uso: psql -f supabase/tests/prueba_local.sql (ver supabase/README.md)
\set ON_ERROR_STOP on
create schema auth;
create table auth.users (id uuid primary key);
create function auth.uid() returns uuid language sql stable as $$ select nullif(current_setting('app.uid', true), '')::uuid $$;
create role anon_app; create role auth_app;
\i supabase/migrations/0001_esquema.sql
grant usage on schema public, auth to auth_app;
grant all on all tables in schema public to auth_app;
grant execute on all functions in schema public to auth_app;
grant execute on function auth.uid() to auth_app;

insert into auth.users values ('00000000-0000-0000-0000-00000000000a'),('00000000-0000-0000-0000-00000000000b'),('00000000-0000-0000-0000-00000000000c');
insert into perfiles (id, rol, nombre) values
 ('00000000-0000-0000-0000-00000000000a','cliente','Ana'),
 ('00000000-0000-0000-0000-00000000000b','lavadero','Lavadero B'),
 ('00000000-0000-0000-0000-00000000000c','cliente','Carlos');
insert into lavaderos (id, propietario_id, nombre, ciudad) values ('10000000-0000-0000-0000-000000000001','00000000-0000-0000-0000-00000000000b','Lavadero Ejemplo','Madrid');
insert into servicios (id, lavadero_id, nombre, precio_cent, duracion_min) values ('20000000-0000-0000-0000-000000000001','10000000-0000-0000-0000-000000000001','Lavado completo',4000,90);
insert into reservas (id, cliente_id, lavadero_id, servicio_id, inicio, fin, direccion, precio_cent) values
 ('30000000-0000-0000-0000-000000000001','00000000-0000-0000-0000-00000000000a','10000000-0000-0000-0000-000000000001','20000000-0000-0000-0000-000000000001','2026-11-21 10:30+01','2026-11-21 12:00+01','Calle Ejemplo 1',4000);

-- 1) Doble reserva solapada: debe fallar
do $$ begin
  begin
    insert into reservas (cliente_id, lavadero_id, servicio_id, inicio, fin, direccion, precio_cent) values
     ('00000000-0000-0000-0000-00000000000c','10000000-0000-0000-0000-000000000001','20000000-0000-0000-0000-000000000001','2026-11-21 11:00+01','2026-11-21 12:30+01','Otra',4000);
    raise exception 'FALLO: permitió solapar citas';
  exception when exclusion_violation then raise notice 'OK 1: cita solapada rechazada'; end;
end $$;

-- 2) Reseña antes de completar: debe fallar
do $$ begin
  begin
    insert into resenas (reserva_id, cliente_id, lavadero_id, puntuacion) values
     ('30000000-0000-0000-0000-000000000001','00000000-0000-0000-0000-00000000000a','10000000-0000-0000-0000-000000000001',5);
    raise exception 'FALLO: reseña sin cita completada';
  exception when raise_exception then
    if sqlerrm like 'FALLO%' then raise; end if; raise notice 'OK 2: reseña antes de completar rechazada'; end;
end $$;

-- 3) Completada: la reseña entra; una segunda reseña de la misma cita falla
update reservas set estado = 'completada' where id = '30000000-0000-0000-0000-000000000001';
insert into resenas (reserva_id, cliente_id, lavadero_id, puntuacion) values
 ('30000000-0000-0000-0000-000000000001','00000000-0000-0000-0000-00000000000a','10000000-0000-0000-0000-000000000001',5);
do $$ begin
  begin
    insert into resenas (reserva_id, cliente_id, lavadero_id, puntuacion) values
     ('30000000-0000-0000-0000-000000000001','00000000-0000-0000-0000-00000000000a','10000000-0000-0000-0000-000000000001',1);
    raise exception 'FALLO: segunda reseña';
  exception when unique_violation then raise notice 'OK 3: una reseña por cita'; end;
end $$;
do $$ declare m numeric; begin
  select media into m from lavaderos_valoracion; if m <> 5 then raise exception 'FALLO: media %', m; end if;
  raise notice 'OK 4: valoración media = %', m; end $$;

-- 5) RLS: Carlos no ve la reserva de Ana; Ana sí; el lavadero también
set role auth_app;
do $$ declare n int; begin
  perform set_config('app.uid','00000000-0000-0000-0000-00000000000c',false);
  select count(*) into n from reservas; if n <> 0 then raise exception 'FALLO: Carlos ve % reservas', n; end if;
  perform set_config('app.uid','00000000-0000-0000-0000-00000000000a',false);
  select count(*) into n from reservas; if n <> 1 then raise exception 'FALLO: Ana ve % reservas', n; end if;
  perform set_config('app.uid','00000000-0000-0000-0000-00000000000b',false);
  select count(*) into n from reservas; if n <> 1 then raise exception 'FALLO: lavadero ve % reservas', n; end if;
  raise notice 'OK 5: RLS de reservas por rol'; end $$;
-- 6) Carlos no puede reservar a nombre de Ana
do $$ begin
  perform set_config('app.uid','00000000-0000-0000-0000-00000000000c',false);
  begin
    insert into reservas (cliente_id, lavadero_id, servicio_id, inicio, fin, direccion, precio_cent) values
     ('00000000-0000-0000-0000-00000000000a','10000000-0000-0000-0000-000000000001','20000000-0000-0000-0000-000000000001','2026-11-22 10:00+01','2026-11-22 11:30+01','X',4000);
    raise exception 'FALLO: suplantó cliente';
  exception when insufficient_privilege then raise notice 'OK 6: no se puede reservar a nombre de otro'; end;
end $$;
