-- LAB-04 — Hardening y configuración segura de PostgreSQL.
-- Actividad 11 — Revisar configuración relacionada con conexiones.

SHOW max_connections;
SHOW superuser_reserved_connections;
SHOW statement_timeout;
SHOW idle_in_transaction_session_timeout;