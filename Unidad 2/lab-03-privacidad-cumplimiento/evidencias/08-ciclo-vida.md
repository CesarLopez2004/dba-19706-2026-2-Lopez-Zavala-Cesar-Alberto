# Evidencia 08 — Derecho de cancelación y ciclo de vida

## Objetivo
Analizar qué ocurre con los datos de un titular a lo largo de toda la infraestructura cuando se autoriza una solicitud de Cancelación, explicando por qué un `DELETE` en la tabla principal no elimina automáticamente toda su información en la organización.

## Procedimiento
1. Se revisaron todos los puntos donde se replica, respalda o exporta la información de la tabla `clientes`.
2. Se construyó el mapa de dispersión del dato y se analizaron las implicaciones técnicas de cada repositorio.

## Resultado

### Mapa de ubicación de datos derivados de `clientes`

```text
clientes (Tabla principal)
   │
   ├── tablas relacionadas (clientes_soporte, facturas, pedidos)
   ├── respaldos (archivos pg_dump, snapshots e históricos)
   ├── réplicas (servidores secundarios de lectura / standby)
   ├── registros de auditoría (logs de base de datos y bitácoras)
   ├── reportes y copias de analítica (vistas materializadas, BI)
   ├── exportaciones (archivos CSV o Excel descargados por usuarios)
   └── sistemas externos (CRM, sistemas de facturación PAC, correo)
