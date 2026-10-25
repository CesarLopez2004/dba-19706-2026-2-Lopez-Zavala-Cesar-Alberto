# Actividad 9 — Separar cuentas administrativas y de aplicación

## Objetivo
Diseñar conceptualmente una estructura segregada de cuentas de usuario en PostgreSQL que distinga claramente entre las responsabilidades de administración, operación de software y consulta analítica, aplicando el principio de mínimo privilegio.

## Procedimiento
1. Se analizaron las necesidades funcionales del entorno operativo y los riesgos asociados al uso indebido de cuentas con privilegios elevados.
2. Se estructuró una matriz de separación de roles y responsabilidades.

## Resultado: Matriz de Segregación de Cuentas

| Cuenta | Propósito | LOGIN | Privilegios / Alcance |
| :--- | :--- | :---: | :--- |
| **DBA** | Administración de infraestructura, respaldos, mantenimiento y seguridad general del motor. | Sí | Administrativos absolutos sobre el motor (restringidos a personal autorizado de TI). |
| **APP** | Conexión exclusiva utilizada por el software aplicativo de producción. | Sí | Privilegios mínimos estrictos (exclusivo lectura/escritura sobre las tablas de su propio esquema de negocio). |
| **CONSULTA** | Cuenta destinada a herramientas de BI, reportes o analítica de negocio. | Sí | Privilegios estrictos de solo lectura (`SELECT`) sobre vistas o tablas agregadas autorizadas. |

---

### Pregunta de Reflexión
* **¿Qué riesgo existe si la aplicación se conecta utilizando una cuenta administrativa?**
  El riesgo principal es la **amplificación catastrófica del impacto** ante cualquier fallo o brecha de seguridad (como una inyección SQL). Al no existir separación entre la identidad del software y la identidad de control del motor (`SUPERUSER`), un atacante que comprometa la capa de aplicación heredará automáticamente la capacidad de ejecutar consultas de administración global, alterar catálogos, acceder a esquemas ajenos o manipular los archivos del sistema operativo.

## Conclusión
