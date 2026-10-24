# LAB-03 — Privacidad, cumplimiento y gobierno de los datos

**Unidad:** II. Seguridad, privacidad y control de acceso  
**Tema:** 2.5 Privacidad, cumplimiento y gobierno de los datos  
**Motor principal:** PostgreSQL 16  

---

## 1. Introducción
Una base de datos puede estar técnicamente bien configurada en cuanto a permisos y cifrado, pero aun así presentar graves problemas de privacidad y cumplimiento si recopila datos innecesarios, los utiliza para finalidades distintas a las informadas, los conserva por tiempo indefinido o permite que cualquier empleado consulte información personal completa. En este informe se documenta la aplicación práctica de los principios de privacidad, minimización, limitación de finalidad, retención, derechos ARCO y gobierno de datos sobre el escenario de **Comercializadora Norte S.A. de C.V.** en PostgreSQL 16.

## 2. Inventario de datos
Se analizaron los 9 campos de la tabla `clientes`, identificando que todos constituyen datos personales (directos o indirectos al vincularse con un titular identificable):
- **Datos de identificación y contacto:** `id`, `nombre`, `correo`, `telefono`.
- **Datos fiscales:** `rfc`, `codigo_postal`.
- **Datos demográficos, geográficos y de control:** `edad`, `ciudad`, `fecha_alta`.

El detalle de clasificación, nivel de acceso y justificación por columna se documentó en [`evidencias/01-inventario-datos.md`](evidencias/01-inventario-datos.md).

## 3. Finalidades
Los datos almacenados se relacionaron estrictamente con las finalidades operativas de la organización:
- **Atención al cliente:** Requiere únicamente `id`, `nombre`, `correo` y `telefono` para dar seguimiento y soporte.
- **Facturación:** Requiere `nombre`, `rfc`, `codigo_postal` y `correo` para la emisión de comprobantes fiscales.
- **Analítica:** Requiere información estadística agregada (`ciudad`, rangos de `edad` y región de `codigo_postal`) sin necesidad de identificar individualmente a los clientes.
- **Finalidades secundarias (Marketing):** Cualquier uso promocional requiere validar previamente el Aviso de Privacidad y el consentimiento del titular ([`evidencias/05-finalidad-secundaria.md`](evidencias/05-finalidad-secundaria.md)).

## 4. Minimización
Aplicando el principio de minimización de datos:
- Para **Atención al cliente**, se diseñó la tabla `clientes_soporte` excluyendo `rfc`, `edad`, `ciudad`, `codigo_postal` y `fecha_alta` ([`sql/01-minimizacion.sql`](sql/01-minimizacion.sql)).
- Para **Analítica**, se diseñaron consultas agrupadas (`COUNT`) y generalización por rangos de edad (`CASE`), evitando entregar la tabla completa ([`sql/02-finalidad.sql`](sql/02-finalidad.sql)).
- En el análisis de **Privacidad por diseño**, se descartó la recolección de atributos innecesarios e intrusivos como `salario`, `ocupacion`, `estado_civil` y `fecha_nacimiento` ([`evidencias/12-privacidad-diseno.md`](evidencias/12-privacidad-diseno.md)).

## 5. Control de acceso
Para alinear los permisos técnicos con las funciones del puesto ([`sql/03-control-acceso.sql`](sql/03-control-acceso.sql)):
- Se creó el rol `analista` (`NOLOGIN`).
- Se creó la vista `v_analitica_clientes` exponiendo únicamente `ciudad` y `rango_edad`.
- Se otorgó permiso `SELECT` al rol `analista` exclusivamente sobre la vista `v_analitica_clientes`, sin otorgar acceso directo a la tabla `clientes`.

## 6. Derechos ARCO
Se analizaron las implicaciones técnicas en la base de datos para atender los derechos de los titulares:
- **Acceso:** Localización mediante consultas `SELECT` de toda la información asociada al titular en la tabla principal y tablas relacionadas.
- **Rectificación:** Ejecución precisa de sentencias `UPDATE` acompañadas de registros de auditoría que comprueben quién hizo el cambio y bajo qué autorización.
- **Cancelación:** Análisis del ciclo de vida completo del dato, considerando que un `DELETE` en la tabla principal no borra automáticamente la información en respaldos, réplicas, reportes, archivos exportados ni sistemas externos ([`evidencias/08-ciclo-vida.md`](evidencias/08-ciclo-vida.md)).
- **Oposición:** Separación técnica de finalidades mediante banderas de consentimiento y vistas filtradas para dejar de usar los datos en finalidades secundarias sin necesidad de eliminar los datos requeridos para la operación o facturación.

## 7. Retención
Se rechazó la política de conservar todos los datos indefinidamente. El periodo de retención debe determinarse en función de la vigencia de la relación comercial y las obligaciones legales aplicables (como los plazos de conservación fiscal para el `rfc`), documentando qué ocurre con cada dato al finalizar su plazo (bloqueo, eliminación o anonimización) ([`evidencias/10-retencion.md`](evidencias/10-retencion.md)).

## 8. Gobierno de datos
Se diseñó la matriz de gobierno de datos asignando para cada atributo su finalidad, área responsable, usuarios autorizados, medidas de protección en PostgreSQL, periodo de retención y acción al finalizar ([`evidencias/11-gobierno-datos.md`](evidencias/11-gobierno-datos.md)).

## 9. Evaluación integral
Se evaluó un escenario de 50,000 clientes identificando 10 riesgos críticos (acceso directo de analítica a la tabla maestra, 12 años de retención sin política, copias reales de producción entregadas a desarrolladores y uso de correos para marketing sin control de finalidad) ([`evidencias/14-evaluacion-integral.md`](evidencias/14-evaluacion-integral.md)), y se diseñó una propuesta de arquitectura separada en Operación, Analítica y Auditoría ([`evidencias/15-arquitectura.md`](evidencias/15-arquitectura.md)).

## 10. Conclusiones
La seguridad técnica y la privacidad son complementarias pero distintas. El trabajo del DBA no consiste en decidir por sí mismo las finalidades legales ni en dar acceso libre a las tablas, sino en traducir los principios de minimización, limitación de finalidad, retención y gobierno de datos en controles técnicos concretos dentro de PostgreSQL (vistas, roles de mínimo privilegio, separación de esquemas, trazabilidad y depuración controlada).

---

## Preguntas de reflexión (Sección 27)

### 1. ¿Una base de datos técnicamente segura necesariamente cumple con todos los requisitos de privacidad?
No. Una base de datos puede estar perfectamente protegida con contraseñas, cifrado y respaldos, y aun así incumplir la privacidad si recopila datos excesivos que no necesita, si los conserva durante más tiempo del debido, si los utiliza para finalidades no autorizadas por el titular o si permite que áreas internas consulten datos personales que no corresponden a su función.

### 2. ¿Por qué el principio de mínimo privilegio también contribuye a la privacidad?
Porque asegura que cada usuario o rol dentro de la base de datos solo pueda acceder a las columnas y registros estrictamente necesarios para cumplir con su finalidad laboral, evitando la exposición interna innecesaria de datos personales (como impedir que un analista vea el RFC o el nombre de los clientes).

### 3. ¿Por qué el DBA no debería decidir por sí solo la finalidad del tratamiento de los datos?
Porque definir para qué se recopilan y utilizan los datos personales es una decisión de negocio, administrativa y jurídica que debe apegarse al Aviso de Privacidad y a la legislación vigente. El DBA es el custodio técnico encargado de implementar los controles, pero las decisiones sobre la finalidad corresponden al responsable del tratamiento, a los propietarios de los datos y al área jurídica/privacidad.

### 4. ¿Por qué los desarrolladores no deberían recibir automáticamente copias completas de bases de datos productivas?
Porque los datos personales fueron entregados por los clientes para recibir un servicio comercial, no para hacer pruebas de programación. Entregar copias productivas completas expone innecesariamente la información real de miles de personas a usuarios que solo necesitan datos ficticios o sintéticos para probar el funcionamiento del sistema.

### 5. ¿Por qué una copia utilizada para desarrollo también puede representar un riesgo de privacidad?
Porque los entornos de desarrollo y pruebas suelen tener controles de seguridad más débiles que producción (equipos locales, menores restricciones de acceso, sin monitoreo estricto). Si contienen datos reales, un robo o descuido en desarrollo expone la información personal real de los clientes, o puede provocar que un sistema en pruebas envíe correos por error a clientes reales.

### 6. ¿Por qué la retención debe formar parte del ciclo de vida de los datos?
Porque ningún dato personal debe almacenarse para siempre sin propósito. Incluir la retención y eliminación en el ciclo de vida garantiza que, una vez cumplida la finalidad comercial y los plazos legales de conservación, la información sea suprimida o anonimizada, reduciendo riesgos legales y de seguridad.

### 7. ¿Qué relación existe entre privacidad por diseño y diseño de bases de datos?
La privacidad por diseño implica considerar la protección de los datos personales desde el momento en que se modela la estructura de las tablas (`CREATE TABLE`). Al diseñar la base de datos bajo este enfoque, se evita crear columnas innecesarias, se separan los datos según su finalidad y se configuran permisos y valores por defecto que limitan la exposición de información desde el inicio.

### 8. ¿Qué controles técnicos implementarías para reducir el riesgo de exposición de datos personales?
- Creación de roles por función aplicando el principio de mínimo privilegio (`CREATE ROLE`, `GRANT`, `REVOKE`).
- Uso de vistas (`CREATE VIEW`) que oculten identificadores directos y entreguen solo datos agrupados o rangos para analítica.
- Separación de tablas o esquemas según la finalidad (operación, facturación, analítica, auditoría).
- Enmascaramiento o generación de datos sintéticos para entornos de desarrollo y pruebas.
- Cifrado de datos sensibles y conexiones seguras.
- Registros de auditoría para mantener trazabilidad de consultas y cambios.

### 9. ¿Qué información debería conocer un DBA para responder técnicamente a una solicitud ARCO?
Debe conocer la instrucción validada y autorizada por el área de privacidad/jurídico (qué derecho se va a ejercer y el folio de autorización), el identificador del titular a localizar, en qué tablas, vistas, respaldos o sistemas relacionados se encuentra distribuida su información, y si debe aplicar una consulta de extracción (Acceso), una actualización trazable (Rectificación), un bloqueo/borrado (Cancelación) o un filtro de exclusión (Oposición).

### 10. ¿Qué responsabilidades deberían corresponder al DBA, al responsable de privacidad, al área jurídica y al propietario de los datos?
- **Propietario de los datos (Data Owner):** Define qué datos necesita su área para operar, con qué finalidad y qué usuarios de su equipo requieren acceso.
- **Área jurídica:** Determina las obligaciones legales aplicables (LFPDPPP, plazos fiscales), redacta el Aviso de Privacidad y valida la base legal de los tratamientos.
- **Responsable de privacidad:** Supervisa el cumplimiento de los principios de privacidad, recibe y gestiona las solicitudes de derechos ARCO y coordina las políticas de protección de datos.
- **DBA (Custodio de los datos):** Implementa y mantiene los controles técnicos en la base de datos (roles, permisos, vistas, respaldos seguros, trazabilidad y ejecución técnica de retención o solicitudes ARCO autorizadas) sin decidir por cuenta propia el uso de la información.
