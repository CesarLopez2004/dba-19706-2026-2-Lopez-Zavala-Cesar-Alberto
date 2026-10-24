# Evidencia 11 — Matriz de gobierno de datos

## Objetivo
Construir una matriz de gobierno de datos para los campos principales de la tabla `clientes`, relacionando el acceso con la necesidad funcional de cada rol dentro de la organización.

## Procedimiento
1. Se analizaron los 7 campos solicitados (`nombre`, `correo`, `telefono`, `rfc`, `edad`, `ciudad`, `codigo_postal`).
2. Se asignó un área responsable (propietario del dato), los usuarios autorizados según sus funciones, las medidas de protección en PostgreSQL, el tiempo de retención y la acción al finalizar su ciclo de vida.

## Resultado

| Dato | Finalidad | Responsable | Usuarios autorizados | Protección | Retención | Acción al finalizar |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| `nombre` | Identificación del cliente para soporte y facturación. | Atención al cliente / Facturación | Atención al cliente, Facturación *(DBA solo administración técnica)*. | Control de permisos por rol; excluido de vistas de analítica; enmascarado en pruebas. | Vigencia comercial + 5 años si tiene facturas. | Eliminación o anonimización al vencer el plazo fiscal. |
| `correo` | Contacto con el cliente, soporte y envío de facturas. | Atención al cliente | Atención al cliente, Facturación. | Restricción de acceso por rol; cifrado en tránsito; registro de auditoría en cambios. | Vigencia de cuenta activa + 1 año por aclaraciones. | Eliminación (`UPDATE` a nulo o borrado del registro). |
| `telefono` | Comunicación directa para atención de soporte. | Atención al cliente | Exclusivamente Atención al cliente. | Separado en tabla/vista `clientes_soporte`; inaccesible para Facturación y Analítica. | Mientras el cliente esté activo + 6 meses de inactividad. | Eliminación física inmediata al terminar relación comercial. |
| `rfc` | Emisión de comprobantes fiscales (CFDI). | Facturación | Exclusivamente Facturación. | Acceso restringido solo al rol de facturación; auditoría de consultas; oculto para Soporte y Analítica. | 5 a 10 años por obligación fiscal (Código Fiscal). | Bloqueo al terminar relación activa; eliminación definitiva al cumplir plazo fiscal. |
| `edad` | Generación de estadísticas por segmento demográfico. | Analítica / Dirección | Analítica (únicamente como rango de edad). | Transformado en rangos mediante la vista `v_analitica_clientes`; sin acceso al dato individual. | Durante la vigencia activa del registro. | Conservación únicamente como conteo estadístico agregado y anónimo. |
| `ciudad` | Estadísticas de clientes por ubicación geográfica. | Analítica / Atención al cliente | Analítica (agregado), Atención al cliente, Dirección (reportes). | Presentado de forma agrupada (`COUNT`) en vistas para analítica y reportes de dirección. | Vigencia comercial; indefinido solo en reportes agregados anónimos. | Desvinculación del cliente individual; se conserva solo el total estadístico. |
| `codigo_postal` | Dato fiscal obligatorio para facturación y análisis regional. | Facturación | Facturación (código completo), Analítica (solo región/prefijo). | Vista completa para Facturación; vista truncada por región para Analítica. | 5 años en registros fiscales; agregado en analítica. | Eliminación del dato fiscal exacto al vencer el plazo legal. |

## Análisis
En la matriz se observa cómo cada rol recibe acceso únicamente a lo que necesita para trabajar:
- **Atención al cliente** consulta `nombre`, `correo`, `telefono` y `ciudad`.
- **Facturación** consulta `nombre`, `correo`, `rfc` y `codigo_postal`.
- **Analítica** y **Dirección** consultan datos agrupados y transformados (`rango_edad`, `ciudad`, región de `codigo_postal`) sin ver identidades.
- El **DBA** implementa los permisos y administra el motor, pero no utiliza los datos para fines operativos.

## Conclusión
El gobierno de datos evita que todos los usuarios vean toda la tabla. Al definir responsables y usuarios autorizados por columna, el DBA puede configurar vistas y roles precisos en PostgreSQL.
