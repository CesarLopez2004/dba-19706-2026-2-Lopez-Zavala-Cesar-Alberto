-- LAB-03 — Privacidad, cumplimiento y gobierno de los datos.
-- Actividad 7 — Derecho de rectificación.

-- Actualizar únicamente el dato correspondiente
UPDATE clientes
SET correo = 'nuevo-correo@example.com'
WHERE id = 1;

-- Verificar el cambio
SELECT
    id,
    nombre,
    correo
FROM clientes
WHERE id = 1;