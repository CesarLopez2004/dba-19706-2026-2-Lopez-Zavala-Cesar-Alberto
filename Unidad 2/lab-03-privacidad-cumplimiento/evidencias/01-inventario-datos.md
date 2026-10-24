# Evidencia 01 — Inventario y finalidad de los datos

## Objetivo
Identificar los datos personales dentro de la tabla `clientes`, relacionando cada campo con su finalidad, necesidad funcional, nivel de acceso y periodo de retención.

## Procedimiento
1. Se revisaron las 9 columnas de la tabla `clientes`.
2. Se contrastó cada campo con las funciones de Atención al cliente, Facturación, Analítica y DBA.
3. Se justificó cada decisión bajo los principios de privacidad y minimización.

## Resultado

| Campo | ¿Es dato personal? | Finalidad | ¿Es necesario? | Nivel de acceso | Retención | Justificación |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| `id` | Sí (Indirecto) | Identificar de forma única cada registro en la base de datos. | Sí | Atención al cliente, Facturación, DBA. | Vigencia de la relación comercial + plazo legal. | Aunque es un número, se vincula directamente con una persona física identificable. Es indispensable como llave primaria. |
| `nombre` | Sí (Directo) | Identificar al cliente para brindarle atención y emitir facturas. | Sí | Atención al cliente, Facturación. | Vigencia comercial + 5 años (obligación fiscal). | Es necesario para dirigirse al titular en soporte y como requisito fiscal obligatorio en facturación. |
| `correo` | Sí (Directo) | Comunicación con el cliente, seguimiento de soporte y envío de facturas. | Sí | Atención al cliente, Facturación. | Vigencia de la cuenta activa + 1 año para aclaraciones. | Es el canal principal de contacto operativo y de entrega de comprobantes fiscales. |
| `telefono` | Sí (Directo) | Contacto directo para atención al cliente y soporte rápido. | Sí | Exclusivo Atención al cliente. | Mientras el cliente esté activo; eliminar tras inactividad. | Solo Atención al cliente requiere llamar al usuario; Facturación y Analítica no tienen justificación para verlo. |
| `rfc` | Sí (Directo / Fiscal) | Cumplimiento fiscal y emisión de facturas (CFDI). | Sí (Solo si factura) | Exclusivo Facturación. | 5 a 10 años conforme al Código Fiscal de la Federación. | Su única finalidad legítima es fiscal. Ni Soporte ni Analítica deben tener acceso a este dato. |
| `edad` | Sí (Indirecto) | Generación de estadísticas demográficas de clientes. | Parcial (Basta rango de edad) | Analítica (solo en rangos agrupados). | Mientras el registro sea activo; luego solo conservar estadística agregada. | Ni Soporte ni Facturación ocupan la edad. Para Analítica basta con rangos de edad, no el dato individual exacto. |
| `ciudad` | Sí (Indirecto) | Estadísticas geográficas de ventas y contexto básico de ubicación. | Sí | Analítica (agregado), Atención al cliente. | Vigencia comercial; luego conservar solo en conteos anónimos. | Vinculado a una persona revela su ubicación; en analítica solo se necesita de forma agrupada. |
| `codigo_postal` | Sí (Indirecto / Fiscal) | Requisito para timbrado de facturas (CFDI 4.0) y análisis por zona. | Sí | Facturación (exacto), Analítica (solo región/prefijo). | 5 años en registros fiscales; agregado en analítica. | El SAT exige el código postal para facturar; Analítica solo requiere conocer la región general. |
| `fecha_alta` | Sí (Indirecto / Metadato) | Controlar la antigüedad del registro y calcular plazos de retención. | Sí | DBA, Analítica (métricas de antigüedad). | Hasta la eliminación definitiva del registro. | Es indispensable para que el DBA pueda aplicar políticas de retención y borrado de datos antiguos. |

## Análisis
La tabla `clientes` mezcla datos de contacto, datos fiscales (`rfc`) y datos demográficos (`edad`) en una misma estructura. Si se dan permisos sobre toda la tabla sin distinguir el rol, áreas como Soporte verán datos fiscales que no necesitan, y Analítica verá nombres y correos que no requiere para hacer estadísticas.

## Conclusión
Identificar la finalidad de cada columna permite demostrar que ningún área operativa necesita ver las 9 columnas completas al mismo tiempo, sentando las bases para aplicar minimización y control de acceso.
