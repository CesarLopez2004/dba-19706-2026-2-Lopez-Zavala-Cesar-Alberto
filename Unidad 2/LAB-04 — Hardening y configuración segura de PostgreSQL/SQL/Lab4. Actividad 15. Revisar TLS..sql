-- LAB-04 — Hardening y configuración segura de PostgreSQL.
-- Actividad 15 — Revisar TLS.

SHOW ssl_min_protocol_version;
SHOW ssl_max_protocol_version;

SELECT
    a.pid,
    a.usename,
    a.client_addr,
    s.ssl,
    s.version,
    s.cipher,
    s.bits
FROM pg_stat_ssl s
JOIN pg_stat_activity a ON s.pid = a.pid
WHERE s.pid = pg_backend_pid();