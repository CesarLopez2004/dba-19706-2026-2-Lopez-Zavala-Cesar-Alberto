# Evidencia 12 — Privacidad por diseño

## Objetivo
Evaluar una propuesta de creación de tabla para una nueva aplicación que pretende almacenar datos excesivos bajo la justificación *"Es mejor guardar todos los datos por si posteriormente necesitamos alguno"*, aplicando los principios de privacidad por diseño y por defecto.

## Procedimiento
1. Se revisó la estructura propuesta por el desarrollador (`id`, `nombre`, `correo`, `telefono`, `rfc`, `edad`, `direccion`, `ciudad`, `codigo_postal`, `fecha_nacimiento`, `ocupacion`, `salario`, `estado_civil`).
2. Se respondieron las 6 preguntas de análisis identificando riesgos, datos innecesarios y mejoras de diseño.

## Resultado

### 1. ¿Qué problemas identificas?
- **Recolección excesiva de datos personales:** Se piden datos patrimoniales y personales como `salario`, `ocupacion` y `estado_civil` que no tienen relación con el registro normal de un cliente.
- **Duplicidad innecesaria:** Se guarda `edad` y también `fecha_nacimiento`.
- **Mayor riesgo ante incidentes:** Si esa base de datos se filtra, se exponen salarios, direcciones exactas, fechas de nacimiento y RFC de las personas, facilitando fraudes o robo de identidad.
- **Uso de tipos de datos sin control:** Todas las columnas de texto usan `TEXT` sin límites de longitud ni restricciones `NOT NULL`.

### 2. ¿Qué principio de privacidad se está ignorando?
Se ignoran los principios de **Minimización de datos**, **Limitación de finalidad**, **Necesidad**, **Proporcionalidad** y **Privacidad por diseño**. Guardar datos "por si se ocupan después" viola el requisito de tener una finalidad determinada antes de recabar la información.

### 3. ¿Qué preguntas realizarías antes de aprobar el diseño?
1. ¿Cuál es la finalidad exacta de cada campo dentro de la nueva aplicación?
2. ¿Para qué proceso obligatorio se necesita saber el `salario`, la `ocupacion` y el `estado_civil` del cliente?
3. ¿Por qué se pide tanto `edad` como `fecha_nacimiento`?
4. ¿Todos los clientes requieren facturación (`rfc`) y envío a domicilio (`direccion`), o solo algunos?
5. ¿Quiénes tendrán acceso a esta tabla y cuánto tiempo se conservarán los datos?

### 4. ¿Qué datos eliminarías?
Eliminaría por completo:
- `salario`
- `estado_civil`
- `ocupacion`
- `fecha_nacimiento` (si solo se necesita estadística, basta un rango de edad).

### 5. ¿Qué datos requerirían una justificación adicional?
- `rfc` y `codigo_postal`: Solo deben solicitarse si el cliente pide factura (pueden guardarse en una tabla separada de datos fiscales).
- `direccion`: Solo debe pedirse si la empresa realiza entregas físicas en el domicilio del cliente.
- `telefono`: Solo si el servicio requiere contacto telefónico de soporte o entrega.

### 6. ¿Cómo aplicarías privacidad por defecto?
- **Datos mínimos en el registro inicial:** Que el formulario y la tabla principal solo pidan los datos básicos indispensables (`nombre` y `correo`).
- **Tablas separadas para datos opcionales:** Guardar datos fiscales o de envío únicamente cuando el usuario solicite ese servicio.
- **Consentimientos desactivados por defecto:** Si hay opciones de promociones, configurar el campo como `DEFAULT FALSE`.
- **Permisos cerrados por defecto en PostgreSQL:** Revocar permisos generales (`REVOKE ALL FROM PUBLIC`) y dar acceso a cada rol únicamente mediante vistas con las columnas que necesita.

## Análisis
El error de guardar todos los datos posibles nace de pensar solo en el almacenamiento técnico y olvidar las obligaciones legales de privacidad. Corregir la tabla antes de crearla en producción evita almacenar información sensible que la empresa no necesita proteger ni administrar.

## Conclusión
Aplicar privacidad por diseño en bases de datos significa modelar tablas que solo contengan los atributos estrictamente justificados por una finalidad actual, dejando fuera cualquier dato innecesario desde el primer momento.
