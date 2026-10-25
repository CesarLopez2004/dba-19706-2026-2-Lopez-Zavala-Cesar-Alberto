# LAB-04 — Hardening y configuración segura de PostgreSQL

## Objetivo
Aplicar un proceso integral de hardening sobre una instancia de PostgreSQL 16 para reducir su superficie de ataque y asegurar la configuración del entorno.

## Entorno
- PostgreSQL 16 sobre entorno aislado de prácticas.

## Superficie de ataque inicial
- Escucha abierta en todas las interfaces de red (`*`).
- Reglas excesivamente permisivas en `pg_hba.conf` (`0.0.0.0/0`).
- Uso de cuentas con privilegios de superusuario en aplicaciones.

## Hallazgos
Exposición innecesaria a redes públicas y ausencia de privilegios mínimos en roles de aplicación.

## Cambios realizados
- Restricción de `listen_addresses`.
- Reemplazo de reglas en `pg_hba.conf` por lista blanca (*allowlist*).
- Forzado de autenticación `scram-sha-256`.
- Segregación de cuentas de aplicación.

## Justificación de los cambios
Aplicación de los principios de mínimo privilegio, superficie de ataque mínima y *Secure by default*.

## Verificación
Comprobación mediante catálogos de sistema (`pg_stat_activity`, `pg_stat_ssl`) y comandos de red del SO (`ss -lnt`).

## Checklist de hardening
1. Puerto documentado y analizado.
2. Interfaces de escucha restringidas.
3. `pg_hba.conf` auditado y limpio de comodines.
4. Redes autorizadas limitadas.
5. Autenticación segura (`scram-sha-256`).
6. Superusuarios segregados.
7. Cuentas de aplicación separadas.
8. Principio de mínimo privilegio aplicado.
9. Extensiones revisadas.
10. TLS verificado y activo.
11. Archivos de configuración protegidos.
12. Directorio de datos protegido (`700`).
13. Firewall conceptual documentado.
14. Mantenimiento y parches registrados.
15. Línea base documentada.

## Conclusiones
El hardening integral asegura que la base de datos se defienda mediante múltiples capas tecnológicas, protegiendo tanto los datos como el entorno operativo que los sostiene.
