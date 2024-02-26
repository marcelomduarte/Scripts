@echo off
chcp 65001 > nul
title Winget

:: Configura a cor para verde claro
color 0A

echo "Instalando Programas para Backup..."
echo.

winget install --id=2BrightSparks.SyncBackFree --exact --accept-package-agreements --accept-source-agreements --source winget

exit