# Actividad 5 — Analizar una regla permisiva

## Objetivo
Analizar detalladamente el impacto y los riesgos de seguridad derivados de una regla de autenticación excesivamente abierta en `pg_hba.conf`, documentando su estado actual y proponiendo una alternativa restrictiva basada en el principio de mínimo privilegio.

## Procedimiento
1. Se tomó como referencia analítica la regla genérica detectada en configuraciones por defecto o inseguras:
   `host    all    all    0.0.0.0/0    scram-sha-256`
2. Se evaluaron cada uno de sus componentes frente a los principios de minimización y control de acceso.

## Resultado del Análisis

### 1. ¿Qué bases de datos permite?
Permite el acceso a **todas** las bases de datos de la instancia (`all`), incluyendo esquemas de sistema, catálogos y cualquier base de datos operativa o confidencial presente en el servidor.

### 2. ¿Qué usuarios permite?
Permite el acceso a **todos** los roles y usuarios registrados en el motor (`all`), incluyendo cuentas administrativas y de superusuario.

### 3. ¿Qué direcciones de origen permite?
Permite conexiones desde **cualquier dirección IPv4 de internet** (`0.0.0.0/0`), exponiendo el servicio a cualquier red sin restricciones geográficas ni de segmento.

### 4. ¿Qué método de autenticación utiliza?
Utiliza `scram-sha-256`, el cual es criptográficamente robusto frente a escuchas en red, pero insuficiente por sí solo para mitigar ataques de fuerza bruta si el origen de red está abierto globalmente.

### 5. ¿Por qué puede representar una exposición innecesaria?
Porque amplía masivamente la superficie de ataque de la base de datos, permitiendo que bots automatizados y atacantes desde cualquier parte del mundo lancen intentos de autenticación masiva contra el puerto 5432.

### 6. ¿Qué información necesitarías para restringirla?
- Conocer exactamente qué bases de datos específicas consume la aplicación.
- Identificar qué cuentas o usuarios de aplicación son los únicos autorizados para conectarse.
- Definir la subred o dirección IP exacta del servidor de aplicaciones (ej. `10.10.10.0/24`).

---

### Documentación de la Regla (Plantilla de Análisis)

* **Regla actual:** 
  `host    all    all    0.0.0.0/0    scram-sha-256`
* **Problema:** 
  Exposición global de todas las bases de datos y usuarios a cualquier IP de internet.
* **Origen que realmente necesita acceso:** 
  Subred del servidor de aplicaciones (`10.10.10.0/24`).
* **Base de datos:** 
  `basedatos_app` (exclusiva del sistema).
* **Usuario:** 
  `app_user` (cuenta con privilegios mínimos).
* **Regla propuesta:** 
  `host    basedatos_app    app_user    10.10.10.0/24    scram-sha-256`

## Conclusión
Una regla abierta en `pg_hba.conf` anula la efectividad de contar con contraseñas robustas al permitir un volumen ilimitado de intentos de conexión desde redes no confiables. El reemplazo por una regla granular es un paso obligatorio de hardening.
