# Actividad 13 — Diferenciar controles técnicos y administrativos

## Objetivo
Clasificar distintas medidas de seguridad y privacidad en controles técnicos y controles administrativos, identificando aquellos casos en los que una medida involucra ambos tipos de control dentro de la gestión de bases de datos.

## Procedimiento
1. Se revisó cada una de las 8 medidas propuestas en la actividad.
2. Se evaluó su naturaleza conforme a las definiciones de la práctica:
   - **Control técnico:** Medida implementada mediante tecnología (como permisos en PostgreSQL, cifrado, vistas o registros de auditoría) para reducir un riesgo.
   - **Control administrativo:** Política, procedimiento, responsabilidad o regla organizacional utilizada para reducir riesgos.
3. Se justificaron los casos donde una política o procedimiento administrativo requiere de una implementación técnica en la base de datos para cumplirse.

## Resultado

| Medida | Técnico | Administrativo | Justificación |
| :--- | :---: | :---: | :--- |
| **Crear roles de PostgreSQL** | **X** | | Es un control **técnico** porque se implementa directamente en el motor de base de datos mediante comandos SQL (`CREATE ROLE`, `GRANT`, `REVOKE`). |
| **Política de retención** | **X** *(implementación)* | **X** *(principal)* | **Involucra ambos:** Es principalmente un control **administrativo** (regla organizacional y legal que define cuánto tiempo conservar cada dato), pero requiere controles **técnicos** (scripts automatizados de borrado o anonimización en la BD) para ejecutarse en la práctica. |
| **Cifrado de datos** | **X** | | Es un control **técnico** que utiliza mecanismos criptográficos en el sistema o motor de base de datos (como `pgcrypto` o TLS) para proteger la confidencialidad de la información. |
| **Procedimiento para solicitudes ARCO** | **X** *(apoyo)* | **X** *(principal)* | **Involucra ambos:** Es un control **administrativo** que establece los pasos, responsables y plazos legales para atender al titular; sin embargo, involucra controles **técnicos** cuando el DBA debe ejecutar consultas (`SELECT`, `UPDATE`, `DELETE` o vistas filtradas) para aplicar el derecho en la base de datos. |
| **Vista con información limitada** | **X** | | Es un control **técnico** (`CREATE VIEW`) implementado en PostgreSQL para restringir las columnas o registros que un usuario puede consultar. |
| **Clasificación de información** | | **X** | Es un control **administrativo** y de gobierno de datos mediante el cual la organización define qué datos son públicos, internos, personales o sensibles y cómo deben tratarse. |
| **Registro de auditoría** | **X** | | Es un control **técnico** configurado en el servidor o motor de base de datos (bitácoras, triggers o logs del sistema) para mantener trazabilidad de quién accedió o modificó un dato. |
| **Política de control de acceso** | **X** *(traducción)* | **X** *(principal)* | **Involucra ambos:** Es un control **administrativo** donde la organización define las reglas sobre qué puesto o área debe acceder a qué datos según su finalidad, y posteriormente se traduce en un control **técnico** cuando el DBA configura los permisos y roles en PostgreSQL. |

## Análisis
Los controles técnicos y administrativos no funcionan de manera aislada:
- Un **control administrativo** sin un control técnico (por ejemplo, tener una *Política de control de acceso* escrita en papel pero dejar que todos los usuarios usen el rol `postgres` en la base de datos) no protege realmente la información.
- Un **control técnico** sin un control administrativo (por ejemplo, saber crear roles y vistas en PostgreSQL pero no tener una *Clasificación de información* ni una *Política de retención* que indique qué datos ocultar o cuándo borrarlos) carece de dirección y sustento de cumplimiento.

## Conclusión
El trabajo del DBA se ubica en la intersección de ambos mundos: comprende las reglas establecidas en los controles administrativos (políticas de acceso, retención y procedimientos ARCO definidos por las áreas responsables) y las materializa en controles técnicos efectivos dentro de PostgreSQL (roles, vistas limitadas, cifrado y registros de auditoría).
