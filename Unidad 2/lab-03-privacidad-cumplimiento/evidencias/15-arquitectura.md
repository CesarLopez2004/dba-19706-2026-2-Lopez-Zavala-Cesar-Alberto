# Evidencia 15 — Propuesta de arquitectura de datos protegidos

## Objetivo
Diseñar una propuesta conceptual de arquitectura de base de datos que separe la información de acuerdo con su finalidad (Operación, Analítica y Auditoría), integrando controles de privacidad y seguridad.

## Procedimiento
1. Se tomó como base el esquema conceptual de separación en tres dominios: Operación, Analítica y Auditoría (más un entorno separado para Desarrollo).
2. Se definieron los controles específicos para acceso, minimización, protección de información sensible, retención, trazabilidad, eliminación y atención de solicitudes ARCO.

## Resultado

### Diagrama de Arquitectura por Finalidad

```text
                               BASE DE DATOS (PostgreSQL 16)
                                             │
            ┌────────────────────────────────┼────────────────────────────────┐
            │                                │                                │
            ▼                                ▼                                ▼
     [1. OPERACIÓN]                   [2. ANALÍTICA]                   [3. AUDITORÍA]
   (Esquema: operacion)             (Esquema: analitica)             (Esquema: auditoria)
            │                                │                                │
            ▼                                ▼                                ▼
  Datos necesarios por área:       Datos agregados / anónimos:      Trazabilidad y control:
  ├── T: clientes_soporte          ├── V: v_clientes_ciudad         ├── T: bitacora_arco
  │   (id, nombre, correo, tel)    ├── V: v_rangos_edad             ├── T: log_accesos
  ├── T: clientes_facturacion      └── V: v_region_cp               └── T: control_eliminados
  │   (id, nombre, rfc, cp)            (Sin nombre, correo ni RFC)      (Evidencia de cambios)
  └── T: control_consentimiento
            │
            └──────► [Proceso de Enmascaramiento / Datos Ficticios] ──► [Entorno de Desarrollo/Pruebas]

## Controles integrados en la arquitectura
Control de acceso:

Creación de roles separados por función (rol_soporte, rol_facturacion, rol_analista, rol_auditor).

Cada rol tiene permiso SELECT únicamente sobre la tabla o vista de su esquema correspondiente. Ningún rol de negocio tiene acceso a todas las tablas.

Minimización:

Operación: Soporte solo ve datos de contacto (clientes_soporte); Facturación solo ve datos fiscales (clientes_facturacion).

Analítica: Solo consume vistas con conteos (COUNT) y rangos de edad, sin identificadores personales.

Desarrollo: Recibe únicamente datos ficticios o enmascarados, nunca copias reales de producción.

Protección de información sensible y personal:

Conexiones cifradas mediante SSL/TLS hacia PostgreSQL.

Cifrado o enmascaramiento del rfc y separación estricta en el esquema operativo.

Retención:

Uso del campo fecha_alta y fecha de última operación para identificar registros inactivos.

Los datos de soporte se depuran al terminar la relación activa; los datos fiscales pasan a estado de bloqueo durante los 5 años que exige la ley antes de su borrado final.

Trazabilidad:

El esquema auditoria almacena quién consultó o modificó registros sensibles y guarda la bitácora de todas las actualizaciones vinculadas a un folio de autorización.

Eliminación:

Proceso estructurado que borra o anonimiza los datos en el esquema operacion una vez vencido el plazo de retención, registrando el id en control_eliminados para asegurar que no se reactive si se restaura un respaldo.

Atención de solicitudes (Derechos ARCO):

Acceso: Consulta centralizada por id en el esquema operacion para entregar al titular el reporte de sus datos.

Rectificación: Actualización controlada sobre el campo específico registrando el cambio en bitacora_arco.

Cancelación: Bloqueo lógico (si aún tiene facturas vigentes por ley) y posterior eliminación/anonimización definitiva.

Oposición: Actualización en control_consentimiento para excluir de inmediato al cliente de vistas de finalidades secundarias (como marketing).

Análisis
Al separar la base de datos en esquemas y vistas por finalidad, un usuario de analítica jamás podrá ver un RFC o un correo aunque intente escribir una consulta diferente, porque su rol solo tiene visibilidad sobre el esquema analitica. De igual forma, las solicitudes ARCO se vuelven fáciles de rastrear gracias al esquema auditoria.

Conclusión
Los principios de privacidad pueden traducirse directamente en decisiones de arquitectura dentro de PostgreSQL combinando esquemas, tablas segmentadas, vistas agregadas, roles de mínimo privilegio y bitácoras de auditoría.
