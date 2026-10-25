-- LAB-04 — Hardening y configuración segura de PostgreSQL.
-- Actividad 1 — Identificar la superficie de ataque.

-- 1. Inspección inicial de versión, puertos y red
SELECT version();

SHOW port;
SHOW listen_addresses;
SHOW ssl;
SHOW password_encryption;

-- 2. Conexiones activas y superficie expuesta
SELECT
    pid,
    usename,
    datname,
    client_addr,
    client_port,
    application_name
FROM pg_stat_activity;