# Punto de equilibrio y previsión a 12 meses (CFO #6 y CFO #7)

La hoja de cálculo [previsiones-12-meses.xlsx](previsiones-12-meses.xlsx) tiene dos pestañas: **Supuestos** (celdas amarillas editables) y **12 meses** (ingresos, costes y resultado mes a mes, con gráfico del resultado acumulado). Las fórmulas se recalculan al cambiar los supuestos.

## Punto de equilibrio mensual

| Cálculo | Fórmula | Servicios al mes |
|---|---|---|
| Bruto (cifra de la presentación) | 153 € ÷ 4 € | **39** |
| **Neto de pasarela (más realista)** | 153 € ÷ (4 € − 0,85 €) = 153 ÷ 3,15 | **49** |

Supuestos: ticket 40 €, comisión 10 %, pasarela tipo Stripe (1,5 % + 0,25 € por tarjeta europea estándar), mantenimiento 153 €/mes.

## Previsión a 12 meses (caso base)

Rampa de servicios supuesta: 10, 25, 40, 60, 80, 100, 130, 160, 190, 220, 250 y 300 (piloto con unos 10 lavaderos al principio). Publicidad prudente: 0 € los tres primeros meses, 50 € de los meses 4 a 6 y 100 € desde el 7.

| Mes | Servicios | Resultado del mes | Acumulado |
|---|---|---|---|
| 1 | 10 | −561,50 € | −561,50 € |
| 2 | 25 | −74,25 € | −635,75 € |
| 3 | 40 | −27,00 € | −662,75 € |
| 4 | 60 | 86,00 € | −576,75 € |
| 5 | 80 | 149,00 € | −427,75 € |
| 6 | 100 | 212,00 € | −215,75 € |
| 7 | 130 | 356,50 € | 140,75 € |
| 12 | 300 | 892,00 € | 3.403,75 € |

Lectura: el mes 4 ya es rentable en el mes (se supera el equilibrio neto de 49 servicios) y la inversión inicial se recupera en el **mes 7**. Con la rampa del Canva (500 servicios al mes) los números mejorarían mucho. Son **escenarios propios**, no datos reales; hay que validarlos con el piloto. No incluye IVA, impuestos ni salarios.

## Qué cambia respecto a la presentación

La presentación dice «unos 39 servicios al mes». Es correcto antes de pasarela; si se descuenta, son unos **49**. Se sugiere decir ambas cifras o ajustar la diapositiva 16.
