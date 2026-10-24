# Evidencia 10 — Política de retención

## Objetivo
Analizar la propuesta organizacional de *"Conservar todos los datos de clientes indefinidamente porque podrían ser útiles en el futuro"* y definir los criterios correctos para establecer una política de retención.

## Procedimiento
1. Se evaluó la política de conservación indefinida frente a los principios de minimización, finalidad y seguridad.
2. Se respondieron las 4 preguntas clave para justificar y documentar los periodos de retención.

## Resultado

### Pregunta 1: ¿Es compatible con el principio de minimización?
**No.** El principio de minimización y conservación exige que los datos personales se mantengan únicamente durante el tiempo necesario para cumplir la finalidad para la cual fueron recabados. Guardar datos personales indefinidamente "por si acaso" no tiene una finalidad válida y contradice directamente la minimización.

### Pregunta 2: ¿Qué riesgos genera conservar información innecesaria?
- **Mayor impacto en caso de robo o filtración:** Si ocurre un incidente de seguridad, se expondrán datos de miles de exclientes antiguos que ya no tenían relación con la empresa.
- **Incumplimiento legal:** Conservar datos personales una vez cumplida su finalidad y vencidos los plazos legales viola la LFPDPPP.
- **Datos desactualizados:** Con el paso de los años, teléfonos, correos, edades y direcciones dejan de ser reales, perdiendo calidad.
- **Carga operativa y técnica:** Aumenta el peso de la base de datos, el tamaño de los respaldos y dificulta la gestión de derechos ARCO.

### Pregunta 3: ¿Qué debería determinar la organización antes de establecer un periodo de retención?
1. **Duración de la relación comercial:** Cuánto tiempo permanece activo el cliente.
2. **Obligaciones legales de conservación:** Qué leyes obligan a guardar ciertos datos por un tiempo fijo (por ejemplo, la ley fiscal exige conservar datos asociados a facturas como el `rfc` entre 5 y 10 años).
3. **Plazos de prescripción legal:** Tiempo necesario de bloqueo para responder ante posibles aclaraciones o demandas.
4. **Necesidad estadística:** Determinar cuándo el dato personal puede ser anonimizado o agrupado para conservar solo la estadística sin guardar la identidad del cliente.

### Pregunta 4: ¿Qué información debería documentarse para justificar el periodo seleccionado?
- Nombre del dato o tabla.
- Finalidad que cumple.
- Evento a partir del cual inicia el conteo (ej. fecha de alta, última compra o última factura).
- Plazo de retención activa y plazo de bloqueo.
- Fundamento legal o de negocio que justifica ese tiempo.
- Acción final al vencer el plazo (eliminación física o anonimización).

## Análisis
En la base de datos, diferentes datos tienen diferentes tiempos de vida: un `telefono` de soporte puede eliminarse poco después de que el cliente deja de ser activo, mientras que el `rfc` vinculado a una factura debe conservarse por ley durante 5 años. Por ello, la retención debe planificarse por tipo de dato y finalidad.

## Conclusión
Conservar datos personales indefinidamente convierte la base de datos en un riesgo creciente. El DBA debe implementar procesos programados de depuración o anonimización basados en la columna `fecha_alta` o fecha de última actividad, siguiendo los plazos definidos por las áreas legal y de negocio.
