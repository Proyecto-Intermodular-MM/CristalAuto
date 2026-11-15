# Guía de despliegue (CTO #3)

Objetivo: API NestJS y web Flutter en **Oracle Cloud (capa gratuita)**, con el dominio **`cristalauto.app`** y **HTTPS** con Let's Encrypt + certbot.

> Estado: **es una guía; no se ha desplegado nada** (hace falta la cuenta de Oracle, el dominio comprado y acceso SSH, que no tengo). La tarea sigue abierta hasta que Aram siga estos pasos.

## 1. Máquina virtual

1. Cuenta en Oracle Cloud y una instancia *Always Free* (por ejemplo Ubuntu 22.04, ARM Ampere o AMD Micro).
2. En la red de la VCN abre los puertos **22, 80 y 443** (lista de seguridad) y en la VM: `sudo ufw allow 22,80,443/tcp && sudo ufw enable`.
3. Clave SSH solo para el equipo; desactivar acceso por contraseña.

## 2. Dominio

1. Comprar `cristalauto.app` (comprobar precio y renovación en el registrador).
2. Registros DNS: `A  cristalauto.app → IP pública de la VM` y `A  api.cristalauto.app → misma IP`.
3. Los dominios `.app` exigen HTTPS (están en la lista HSTS preload), por lo que el certificado es imprescindible.

## 3. Software en la VM

```bash
sudo apt update && sudo apt install -y nginx certbot python3-certbot-nginx git
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash - && sudo apt install -y nodejs
sudo npm i -g pm2
```

## 4. API (NestJS)

```bash
git clone https://github.com/Proyecto-Intermodular-MM/CristalAuto.git && cd CristalAuto/api   # carpeta de la API cuando exista
npm ci && npm run build
cp .env.example .env   # SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY, STRIPE_SECRET_KEY, STRIPE_WEBHOOK_SECRET
pm2 start dist/main.js --name cristalauto-api && pm2 save && pm2 startup
```

## 5. Web (Flutter)

En el PC de desarrollo: `flutter build web --release` y copiar `build/web` a `/var/www/cristalauto` en la VM (`scp -r build/web/* usuario@IP:/var/www/cristalauto/`).

## 6. nginx

`/etc/nginx/sites-available/cristalauto`:

```nginx
server {
  server_name cristalauto.app;
  root /var/www/cristalauto;
  location / { try_files $uri $uri/ /index.html; }
}
server {
  server_name api.cristalauto.app;
  location / { proxy_pass http://127.0.0.1:3000; proxy_set_header Host $host; proxy_set_header X-Forwarded-For $remote_addr; }
}
```

```bash
sudo ln -s /etc/nginx/sites-available/cristalauto /etc/nginx/sites-enabled/ && sudo nginx -t && sudo systemctl reload nginx
```

## 7. HTTPS con Let's Encrypt

```bash
sudo certbot --nginx -d cristalauto.app -d api.cristalauto.app
sudo certbot renew --dry-run   # comprueba la renovación automática
```

certbot instala un temporizador que renueva el certificado solo.

## 8. Comprobación final

- `curl -I https://cristalauto.app` responde `200` con certificado válido.
- `curl https://api.cristalauto.app/salud` responde (crear ese endpoint en la API).
- Supabase: URL y claves en variables de entorno, no en el repositorio.
