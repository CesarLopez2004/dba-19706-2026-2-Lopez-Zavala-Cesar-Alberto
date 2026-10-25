# Actividad 14 — Diseñar una política de firewall

## Objetivo
Diseñar y configurar una política de control perimetral mediante firewall que complemente los controles de `pg_hba.conf`, restringiendo el tráfico de red hacia el puerto 5432 de PostgreSQL exclusivamente a los orígenes autorizados.

## Procedimiento
1. Se diseñó conceptualmente una regla perimetral basada en lista blanca (*Allowlist*).
2. Se aplicó el control en el sistema operativo (Firewall de Windows mediante PowerShell con privilegios elevados) para permitir el tráfico únicamente desde la subred de la aplicación y la red de administración:
   ```powershell
   New-NetFirewallRule -DisplayName "PostgreSQL Hardening - Permitir Subred Autorizada" `
       -Direction Inbound `
       -Protocol TCP `
       -LocalPort 5432 `
       -RemoteAddress "10.10.10.0/24" `
       -Action Allow
