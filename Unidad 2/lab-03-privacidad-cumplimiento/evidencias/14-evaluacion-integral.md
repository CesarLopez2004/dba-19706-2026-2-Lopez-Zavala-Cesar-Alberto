# Evidencia 14 — Evaluación integral de riesgos

## Objetivo
Identificar al menos 10 problemas o riesgos de privacidad y seguridad en el escenario de los 50,000 clientes, señalando el principio afectado, el riesgo asociado y el control propuesto para cada uno.

## Procedimiento
1. Se analizó cada enunciado del escenario integral (analítica, retención de 12 años, copias para desarrolladores, campañas de marketing y falta de documentación).
2. Se documentaron 10 problemas concretos en la matriz solicitada.

## Resultado

| # | Problema | Principio afectado | Riesgo | Control propuesto |
| :- | :--- | :--- | :--- | :--- |
| **1** | Todos los empleados de analítica pueden consultar directamente la tabla `clientes`. | Mínimo privilegio y Privacidad por defecto. | Exposición innecesaria de los datos personales de los 50,000 clientes ante todo el departamento. | Revocar el permiso `SELECT` sobre `clientes` al rol de analítica y dar acceso solo a vistas. |
| **2** | Analítica puede ver `nombre`, `correo`, `telefono` y `rfc` aunque solo genera estadísticas mensuales. | Minimización de datos y Limitación de finalidad. | Filtración o robo de identidades y datos fiscales en reportes estadísticos que solo requerían conteos. | Crear una vista agregada (`v_analitica_clientes`) que solo muestre conteos por ciudad y rangos de edad. |
| **3** | Los datos de los clientes se conservan desde hace 12 años sin depuración. | Retención / Conservación limitada y Proporcionalidad. | En caso de un incidente de seguridad, se compromete información histórica de personas que ya no son clientes desde hace años. | Establecer plazos máximos de vigencia y eliminar o anonimizar los registros que ya cumplieron su finalidad y plazo fiscal. |
| **4** | No existe una política documentada de retención. | Gobierno de datos y Cumplimiento. | La empresa no sabe cuándo debe borrar o bloquear un dato, acumulando información indefinidamente sin sustento legal. | Documentar y aprobar una política formal de retención que defina tiempos activos, de bloqueo y de eliminación por cada dato. |
| **5** | Los desarrolladores reciben copias completas de la base de datos para realizar pruebas. | Limitación de finalidad y Minimización. | Usar datos personales reales para pruebas de software es una finalidad distinta a la autorizada por los titulares. | Prohibir la entrega de copias de producción a desarrollo y generar bases de prueba con datos sintéticos (ficticios). |
| **6** | Las copias de desarrollo contienen información real de los 50,000 clientes. | Seguridad, Confidencialidad y Privacidad por diseño. | Los entornos de pruebas suelen ser menos seguros; existe alto riesgo de fuga de datos reales o envío accidental de correos de prueba a clientes reales. | Aplicar scripts de enmascaramiento o anonimización irreversible antes de utilizar cualquier estructura en entornos de prueba. |
| **7** | El área de marketing utiliza los correos electrónicos para campañas promocionales directamente. | Limitación de finalidad y Consentimiento. | Tratamiento no autorizado al usar correos de contacto operativo para fines publicitarios sin verificar quién dio su consentimiento. | Verificar el Aviso de Privacidad, agregar un campo de consentimiento publicitario y filtrar solo a los clientes que aceptaron. |
| **8** | No existe forma técnica de excluir en marketing a quienes ejerzan su derecho de Oposición. | Derechos ARCO (Oposición). | Seguir enviando promociones a clientes que solicitaron no recibir publicidad, generando quejas y sanciones legales. | Crear una vista filtrada o política RLS para marketing que oculte automáticamente los registros con oposición a publicidad. |
| **9** | No existe documentación clara sobre qué finalidad corresponde a cada dato. | Finalidad determinada y Gobierno de datos. | Cualquier área utiliza las columnas de la tabla para nuevos propósitos sin control ni autorización previa. | Elaborar el inventario/catálogo de datos y la matriz de gobierno definiendo finalidad y propietario (*Data Owner*) para cada columna. |
| **10** | Imposibilidad de garantizar el derecho de Cancelación debido a las copias reales repartidas en desarrollo. | Derechos ARCO (Cancelación) y Ciclo de vida. | Aunque se elimine a un cliente en producción, sus datos reales seguirán guardados en las copias locales de los desarrolladores. | Eliminar las copias reales en entornos de desarrollo y controlar estrictamente el ciclo de vida de respaldos y exportaciones. |

## Análisis
El escenario muestra que el principal problema de la empresa no es un fallo técnico del motor PostgreSQL, sino la falta total de gobierno y separación por finalidad: analistas, desarrolladores y marketing tienen acceso a datos reales e identificables que no necesitan para hacer su trabajo.

## Conclusión
Aplicar vistas agregadas para analítica, datos sintéticos para desarrollo, filtros de consentimiento para marketing y plazos de retención definidos permite reducir drásticamente el riesgo sobre los 50,000 clientes sin detener la operación de la empresa.
