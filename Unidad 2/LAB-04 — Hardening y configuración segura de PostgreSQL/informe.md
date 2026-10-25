Informe Técnico: Proceso de Hardening y Evaluación de Seguridad en PostgreSQL 18
Unidad: II — Seguridad, privacidad y control de acceso
Motor: PostgreSQL 18

1. Introducción
El presente informe documenta el proceso integral de hardening (fortalecimiento de la seguridad) aplicado sobre una instancia de PostgreSQL 16. Si bien las prácticas anteriores se centraron en la protección lógica de los datos (cifrado, enmascaramiento, políticas de privacidad y control de acceso), este laboratorio aborda la reducción de la superficie de ataque del entorno operativo y del motor de base de datos, garantizando una configuración robusta bajo los principios de Secure by default, mínimo privilegio y defensa en profundidad.

2. Desarrollo de Cuestuestionarios y Preguntas del Informe
1. ¿Cuál era la principal superficie de ataque inicial?
La principal superficie de ataque consistía en la combinación de un servidor configurado para escuchar peticiones en todas las interfaces de red disponibles (listen_addresses = '*') junto con una política de autenticación basada en host (pg_hba.conf) excesivamente abierta o con reglas comodín (como 0.0.0.0/0), lo que exponía directamente el puerto TCP 5432 a cualquier red conectada sin restricciones previas de origen geográfico o de segmento.

2. ¿Qué configuración representaba el mayor riesgo?
El uso potencial de cuentas con privilegios de superusuario (superuser = true) para conectar aplicaciones de software o de prueba. Si una aplicación web conectada de esta forma sufre una vulnerabilidad crítica (como inyección SQL o exposición de credenciales), el atacante obtiene control absoluto e inmediato sobre todo el motor de base de datos y el sistema operativo subyacente.

3. ¿Qué cambio produjo la mayor reducción de exposición?
La modificación combinada del parámetro listen_addresses (restringiéndolo a la interfaz local y a la subred privada de la aplicación) y la reconfiguración estricta de pg_hba.conf mediante listas blancas (Allowlist). Esto eliminó de inmediato la accesibilidad masiva desde redes no autorizadas o públicas.

4. ¿Qué diferencia existe entre el Firewall y el archivo pg_hba.conf?
Firewall (Nivel de red / IP y puerto): Controla a nivel de sistema operativo y red si un paquete TCP proveniente de una dirección IP externa puede llegar a establecer conexión con el puerto del servicio de base de datos.

pg_hba.conf (Nivel de servicio / Host-Based Authentication): Controla, una vez establecida la conexión de red, qué base de datos, qué usuario, desde qué dirección y mediante qué método criptográfico se permite autenticar la identidad ante PostgreSQL. Son barreras complementarias que operan en capas distintas.

5. ¿Qué diferencia existe entre Autenticación y Autorización?
Autenticación: Es el proceso técnico mediante el cual el sistema verifica quién es la entidad que intenta conectarse (por ejemplo, validar que el hash de la contraseña corresponda al usuario mediante scram-sha-256).

Autorización: Es el proceso mediante el cual se determina qué acciones, tablas o recursos tiene permitido consultar o modificar esa identidad una vez que ya ha sido autenticada (por ejemplo, los permisos otorgados mediante GRANT y REVOKE).

6. ¿Por qué una cuenta de aplicación no debe ser SUPERUSER?
Por estricto cumplimiento del principio de mínimo privilegio. Si una cuenta de aplicación posee privilegios de superusuario, un compromiso del software permite al atacante ejecutar comandos de sistema operativo (mediante extensiones), alterar catálogos del sistema o modificar configuraciones globales, amplificando catastróficamente el impacto de cualquier fallo de programación.

7. ¿Por qué cambiar el puerto por defecto de PostgreSQL no constituye hardening suficiente?
Cambiar el puerto 5432 a otro número (por ejemplo, 5433) solo reduce el ruido generado por escaneos automatizados masivos de bots en internet (security through obscurity). No protege en absoluto frente a un atacante dirigido, no cifra las comunicaciones, no corrige permisos deficientes en el sistema operativo ni valida la identidad o privilegios de los usuarios.

8. ¿Por qué listen_addresses = '*' puede ser innecesario?
Porque la gran mayoría de las arquitecturas empresariales conectan las aplicaciones localmente mediante sockets Unix o desde servidores ubicados en la misma red privada o contenedor de microservicios. Permitir que el motor escuche en todas las interfaces (incluyendo adaptadores públicos o virtuales) expone el servicio a redes donde no debería tener presencia operativa.

9. Qué papel tiene el Sistema Operativo en la seguridad de PostgreSQL?
El sistema operativo es la base sobre la cual descansa el motor de base de datos. Si el S.O. tiene permisos deficientes en sus archivos (como control total para usuarios locales no privilegiados sobre el directorio data o los archivos de configuración), cualquier usuario local malintencionado en el servidor podrá leer contraseñas, hashes o modificar tablas directamente en el disco, evadiendo por completo las restricciones internas de PostgreSQL.

10. ¿Qué controles deberían revisarse periódicamente?
Auditoría trimestral de roles, superusuarios y privilegios (pg_roles).

Revisión de las reglas activas en pg_hba.conf para asegurar que no se hayan introducido comodines.

Verificación de la vigencia y robustez de las políticas de contraseñas.

Análisis de los archivos de registro (logs) en búsqueda de intentos fallidos de autenticación o consultas anómalas.

Aplicación continua de parches de seguridad y actualizaciones del motor PostgreSQL y del sistema operativo.

3. Conclusiones
El proceso de hardening desarrollado en el LAB-04 demuestra que la seguridad de una base de datos de clase empresarial no depende exclusivamente de contar con contraseñas robustas, sino de implementar una estrategia integral de defensa en profundidad. Esto abarca desde la restricción perimetral en la red y el sistema operativo hasta la configuración estricta de la autenticación (scram-sha-256), el control de acceso basado en listas blancas y la aplicación rigurosa del principio de mínimo privilegio en los roles del motor. Documentar una línea base de seguridad y mantener un checklist de verificación son los pilares fundamentales para garantizar que la infraestructura tecnológica permanezca protegida a lo largo de su ciclo de vida productivo.
