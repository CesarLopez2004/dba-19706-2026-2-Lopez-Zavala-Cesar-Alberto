# Actividad 16 — Comparar configuración antes y después (Línea Base de Cambios)

## Objetivo
Construir una tabla comparativa documentada que refleje el estado inicial (inseguro/por defecto) frente al estado posterior al proceso de hardening (*hardened*), justificando técnicamente cada modificación realizada.

## Resultado: Tabla Comparativa de Control

| Control | Estado Inicial (Inseguro) | Estado Posterior (Hardened) | Justificación Técnica |
| :--- | :--- | :--- | :--- |
| **listen_addresses** | `*` (Todas las interfaces de red) | `127.0.0.1, 10.10.10.20` | Reduce la superficie de ataque evitando que el servicio escuche en interfaces de red públicas o innecesarias. |
| **pg_hba.conf** | `host all all 0.0.0.0/0 scram-sha-256` | Reglas específicas por base de datos, usuario y subred (`10.10.10.0/24`) | Aplica el principio de *Allowlist*, impidiendo conexiones desde redes no autorizadas. |
| **Autenticación** | Posible uso mixto o herencia `md5` | `scram-sha-256` forzado | Proporciona resistencia robusta frente a ataques de fuerza bruta e intercepción de hashes en tránsito. |
| **Cuentas de Aplicación** | Uso ocasional de superusuarios para pruebas | Roles dedicados sin privilegios administrativos (`rolsuper = false`) | Aplica el principio de mínimo privilegio; si la app es vulnerada, el daño se limita al esquema asignado. |
| **Permisos de Archivos (SO)** | Permisos relajados o legibles por grupo | `chmod 700` en data dir y `600` en archivos conf | Impide que usuarios locales no privilegiados del sistema operativo lean credenciales, certificados o parámetros sensibles. |
| **TLS / Cifrado** | Opcional / No verificado | `ssl = on`, `TLSv1.3` | Garantiza la confidencialidad e integridad de los datos en tránsito frente a ataques de escucha en la red (*sniffing*). |

## Conclusión
La documentación sistemática del antes y después permite validar que los riesgos detectados en la auditoría inicial han sido mitigados de manera efectiva mediante controles técnicos verificables.
