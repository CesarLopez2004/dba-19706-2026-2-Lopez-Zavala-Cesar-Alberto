-- LAB-04 — Hardening y configuración segura de PostgreSQL.
-- Actividad 10 — Revisar extensiones.

SELECT
    extname,
    extversion
FROM pg_extension
ORDER BY extname;