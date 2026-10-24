-- LAB-03 — Privacidad, cumplimiento y gobierno de los datos.
-- Actividad 1 — Inventario y finalidad de los datos.

CREATE TABLE clientes (
    id BIGSERIAL PRIMARY KEY,
    nombre VARCHAR(120),
    correo VARCHAR(150),
    telefono VARCHAR(20),
    rfc VARCHAR(13),
    edad INTEGER,
    ciudad VARCHAR(80),
    codigo_postal VARCHAR(10),
    fecha_alta DATE
);

INSERT INTO clientes (nombre, correo, telefono, rfc, edad, ciudad, codigo_postal, fecha_alta) VALUES
('Ana García', 'ana@example.com', '8112345678', 'GALA900512HDF', 34, 'Monterrey', '64000', '2022-03-15'),
('Carlos Ruiz', 'carlos@example.com', '5587654321', 'RUIC851120MDF', 40, 'Ciudad de México', '06600', '2021-07-22'),
('María Torres', 'maria@example.com', '3322334455', 'TOMF980110MJZ', 26, 'Guadalajara', '44100', '2023-11-05'),
('Jorge Ramírez', 'jorge@example.com', '8188990011', 'RALJ620830HNL', 62, 'Monterrey', '64700', '2019-01-10');

