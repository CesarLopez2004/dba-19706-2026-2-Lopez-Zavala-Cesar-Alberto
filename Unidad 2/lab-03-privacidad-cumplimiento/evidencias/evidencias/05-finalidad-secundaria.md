# Evidencia 05 — Análisis de una finalidad secundaria

## Objetivo
Analizar las implicaciones de privacidad y los controles técnicos necesarios cuando la empresa propone usar los datos existentes de clientes para una nueva finalidad secundaria: *"Enviar promociones personalizadas basadas en la edad, ciudad y comportamiento de compra"*.

## Procedimiento
1. Se evaluó la propuesta frente al principio de limitación de finalidad y consentimiento de la LFPDPPP.
2. Se determinaron las preguntas de validación legal/administrativa, los datos mínimos requeridos y los controles técnicos en PostgreSQL.

## Resultado

### 1. ¿El hecho de que la organización ya tenga los datos significa automáticamente que puede utilizarlos para cualquier finalidad?
**No.** Tener los datos almacenados en la base de datos no otorga propiedad libre sobre ellos. Los datos fueron recabados originalmente para finalidades primarias (atención al cliente y facturación). Usarlos para mercadotecnia y promociones personalizadas es una **finalidad secundaria** distinta; por el principio de **limitación de finalidad**, no pueden usarse para un propósito nuevo e incompatible sin que esté contemplado en el Aviso de Privacidad y exista el consentimiento del titular.

### 2. ¿Qué preguntas debería realizar la organización antes de implementar este tratamiento?
- ¿El Aviso de Privacidad que aceptaron los clientes informa explícitamente el uso de sus datos para fines publicitarios y promocionales?
- ¿Qué clientes otorgaron su consentimiento para recibir promociones y cuáles manifestaron su negativa u oposición?
- ¿Contamos con un campo en la base de datos para identificar y respetar a quienes no desean recibir publicidad?
- ¿Quién es el responsable de autorizar este nuevo tratamiento antes de que el DBA habilite cualquier acceso?

### 3. ¿Qué datos serían realmente necesarios?
Suponiendo que el tratamiento sea legalmente válido para los clientes que aceptaron:
- `correo` (únicamente de los clientes que dieron su consentimiento).
- `ciudad` y `rango_edad` (para segmentar la promoción sin usar la edad exacta).
- Categoría general de compra.
- **No son necesarios:** `rfc`, `telefono`, `codigo_postal` exacto ni los registros de clientes que rechazaron publicidad.

### 4. ¿Necesitaría el área de marketing acceso directo a `clientes`?
**No.** Si marketing accede directamente a la tabla `clientes`, tendría acceso al `rfc`, `telefono` y a los correos de personas que no aceptaron recibir publicidad.

### 5. ¿Qué controles técnicos podrían limitar la información entregada?
1. **Columna de consentimiento:** Agregar un atributo `acepta_promociones BOOLEAN DEFAULT FALSE` en la tabla.
2. **Vista filtrada por columnas y filas:** Crear una vista `v_clientes_promociones` que solo incluya las columnas necesarias y filtre con `WHERE acepta_promociones = TRUE`.
3. **Permisos restringidos (RBAC):** Crear un rol `marketing` que solo tenga permiso `SELECT` sobre la vista filtrada y ningún permiso sobre la tabla `clientes`.

## Análisis
Si el DBA entrega toda la tabla `clientes` al área de marketing sin cuestionar la finalidad secundaria, todos los clientes recibirán correos promocionales sin filtro, incumpliendo los derechos de quienes se opusieron y exponiendo datos fiscales (`rfc`) a un área que no debe verlos.

## Conclusión
Antes de exponer datos para un nuevo propósito de negocio, se debe validar con el área de privacidad/jurídico si la finalidad está autorizada y, técnicamente, filtrar tanto las columnas como las filas mediante vistas basadas en el consentimiento del titular.
