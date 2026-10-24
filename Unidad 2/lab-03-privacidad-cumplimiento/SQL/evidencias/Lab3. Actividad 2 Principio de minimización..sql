-- LAB-03 — Privacidad, cumplimiento y gobierno de los datos.
-- Actividad 2 — Principio de minimización.

-- Crear tabla con únicamente los datos necesarios para soporte
CREATE TABLE clientes_soporte (
    id BIGINT PRIMARY KEY,
    nombre VARCHAR(120) NOT NULL,
    correo VARCHAR(150) NOT NULL,
    telefono VARCHAR(20)
);

-- Cargar información a partir de clientes
INSERT INTO clientes_soporte (
    id,
    nombre,
    correo,
    telefono
)
SELECT
    id,
    nombre,
    correo,
    telefono
FROM clientes;

-- Consultar resultado
SELECT *
FROM clientes_soporte;