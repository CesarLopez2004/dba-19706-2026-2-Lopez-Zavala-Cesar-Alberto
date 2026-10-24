-- LAB-03 — Privacidad, cumplimiento y gobierno de los datos.
-- Actividad 6 — Derechos ARCO y la base de datos.

SELECT
    id,
    nombre,
    correo,
    telefono,
    rfc,
    edad,
    ciudad,
    codigo_postal,
    fecha_alta
FROM clientes
WHERE correo = 'ana@example.com';

