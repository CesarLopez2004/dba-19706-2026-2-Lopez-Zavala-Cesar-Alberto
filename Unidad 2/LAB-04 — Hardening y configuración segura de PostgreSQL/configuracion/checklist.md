# Actividad 17 — Elaborar checklist de hardening

## Objetivo
Construir una lista de verificación formal que compruebe que todos los aspectos críticos de seguridad y configuración de la instancia de PostgreSQL cumplen con los estándares establecidos.

## Resultado: Lista de Verificación (Hardening Checklist)

| # | Control de Seguridad | Verificado | Evidencia / Comprobación |
| :- | :--- | :---: | :--- |
| **1** | Puerto documentado y analizado | [x] | `SHOW port;` verificado en 5432. |
| **2** | Interfaces de escucha restringidas | [x] | `listen_addresses` ajustado y comprobado por red. |
| **3** | Archivo `pg_hba.conf` auditado | [x] | Ausencia de comodines globales (`0.0.0.0/0`). |
| **4** | Redes autorizadas limitadas (*Allowlist*) | [x] | Subredes específicas configuradas (`10.10.10.0/24`). |
| **5** | Autenticación robusta forzada | [x] | `scram-sha-256` verificado mediante `SHOW password_encryption;`. |
| **6** | Superusuarios identificados y segregados | [x] | Auditoría de `pg_roles` confirmando cuenta única `postgres`. |
| **7** | Cuentas de aplicación separadas | [x] | Roles operativos creados sin privilegios de superusuario. |
| **8** | Principio de mínimo privilegio aplicado | [x] | Permisos de objetos acotados estrictamente por esquema. |
| **9** | Extensiones auditadas y limpias | [x] | Módulos innecesarios removidos (`pg_extension`). |
| **10** | Conexiones TLS verificadas y activas | [x] | `pg_stat_ssl` confirmando protocolo cifrado robusto. |
| **11** | Archivos de configuración protegidos en SO | [x] | Permisos estrictos de lectura en el sistema operativo. |
| **12** | Directorio de datos protegido | [x] | Permisos `700` auditados mediante `Get-Acl`. |
| **13** | Reglas de firewall implementadas | [x] | Tráfico perimetral filtrado por subred de origen. |
| **14** | Mantenimiento y parches documentados | [x] | Bitácora de actualizaciones y control de versiones activa. |
| **15** | Línea base de seguridad registrada | [x] | Documento `baseline.md` integrado en el repositorio. |

## Conclusión
El uso de un checklist estructurado asegura que ningún vector crítico de seguridad sea pasado por alto durante el proceso de despliegue y hardening del servidor de bases de datos.
