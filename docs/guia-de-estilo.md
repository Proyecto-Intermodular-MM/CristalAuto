# Guía de estilo de CristalAuto

Para el CTO y quien use la identidad en la app y el Canva. Parte de las decisiones de la tarea [Diseñador #1].

## Marca

- **Nombre:** CristalAuto (fácil de decir y recordar en España).
- **Logo:** gota de agua azul con un coche dentro y destellos. *Pendiente: añadir el archivo original del logo (SVG o PNG) a `assets/`; este repositorio no lo contiene aún.*
- **Eslogan:** «Limpio como el cristal.» Apoyo: «Tu coche impecable, sin moverte de casa».

## Colores

| Uso | Nombre | Hex |
|---|---|---|
| Primario | Azul noche | `#1A233C` |
| Secundario | Crema | `#F4F0D2` |
| Acento 1 (botones principales, avisos) | Amarillo brillo | `#FFC30F` |
| Acento 2 (enlaces, iconos) | Azul agua | `#3FA9F5` |

Los colores primario y secundario son mates y de uso general; los acentos son más saturados y se usan en pequeñas dosis. Los tokens están en [assets/colores.json](../assets/colores.json) y [assets/colores.dart](../assets/colores.dart).

Contraste: el texto crema sobre azul noche y el azul noche sobre amarillo brillo cumplen holgadamente el contraste recomendado; evitar texto amarillo sobre crema.

## Tipografía

| Uso | Fuente |
|---|---|
| Títulos | Montserrat ExtraBold (800) |
| Textos y botones | Poppins Regular (400) |

Ambas son de [Google Fonts](https://fonts.google.com) y gratuitas. En Flutter se pueden usar con el paquete `google_fonts` o añadiendo los archivos en `assets/fonts` y declarándolos en `pubspec.yaml`. La aplicación efectiva de las fuentes en el Canva y en la app la hace el diseñador.

## Prototipo

Un [prototipo navegable de las cuatro pantallas](diseno/prototipo.html) (comparar, detalle, reservar y reseña) usa esta paleta y tipografía.
