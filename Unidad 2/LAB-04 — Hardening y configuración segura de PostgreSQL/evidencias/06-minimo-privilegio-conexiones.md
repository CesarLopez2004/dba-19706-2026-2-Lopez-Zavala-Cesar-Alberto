# Actividad 6 — Aplicar mínimo privilegio a conexiones

## Objetivo
Diseñar e implementar una regla de autenticación en `pg_hba.conf` altamente específica y restrictiva, aplicando el principio de lista blanca (*Allowlist*) por base de datos, usuario, origen de red y método criptográfico.

## Procedimiento
1. Se sustituyó el comodín abierto por una regla granular que segmenta el acceso exclusivamente a los recursos requeridos por la arquitectura de la Comercializadora Norte S.A. de C.V.
2. Se aplicó la configuración basada en los cuatro pilares de autenticación basada en host:

```text
# Tipo  Base de datos     Usuario     Dirección de origen    Método
host    basedatos_app     app_user    10.10.10.0/24          scram-sha-256
