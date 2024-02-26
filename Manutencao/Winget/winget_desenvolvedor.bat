@echo off
chcp 65001 > nul
title Winget

:: Configura a cor para verde claro
color 0A

echo "Instalando Programas para Desenvolvedores..."
echo.

winget install --id=Microsoft.PowerShell --exact --accept-package-agreements --accept-source-agreements --source winget
winget install --id=Microsoft.WindowsTerminal --exact --accept-package-agreements --accept-source-agreements --source winget
winget install --id=Microsoft.VisualStudioCode --exact --accept-package-agreements --accept-source-agreements --source winget
winget install --id=Git.Git --exact --accept-package-agreements --accept-source-agreements --source winget
winget install --id=Docker.DockerDesktop --exact --accept-package-agreements --accept-source-agreements --source winget

exit