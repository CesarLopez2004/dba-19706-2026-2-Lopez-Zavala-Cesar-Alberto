-- LAB-03 — Privacidad, cumplimiento y gobierno de los datos.
-- Actividad 4 — Control de acceso relacionado con la finalidad.

-- 1. Crear el rol sin login
CREATE ROLE analista NOLOGIN;

-- 2. Crear la vista con información preparada para analítica
CREATE VIEW v_analitica_clientes AS
SELECT
    ciudad,
    CASE
        WHEN edad < 18 THEN 'Menor de 18'
        WHEN edad BETWEEN 18 AND 29 THEN '18-29'
        WHEN edad BETWEEN 30 AND 44 THEN '30-44'
        WHEN edad BETWEEN 45 AND 59 THEN '45-59'
        ELSE '60 o más'
    END AS rango_edad
FROM clientes;

-- 3. Otorgar permisos únicamente sobre el esquema y la vista (NO sobre la tabla clientes)
GRANT USAGE ON SCHEMA public TO analista;

GRANT SELECT
ON v_analitica_clientes
TO analista;

-- 4. Verificación de privilegios
SELECT
    grantee,
    table_name,
    privilege_type
FROM information_schema.role_table_grants
WHERE grantee = 'analista';
