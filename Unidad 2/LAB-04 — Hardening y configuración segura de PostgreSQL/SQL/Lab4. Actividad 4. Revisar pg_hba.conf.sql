-- LAB-04 — Hardening y configuración segura de PostgreSQL.
-- Actividad 4 — Revisar pg_hba.conf

SELECT
    type,
    database,
    user_name,
    address,
    auth_method
FROM pg_hba_file_rules;