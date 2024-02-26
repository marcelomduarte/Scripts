
@echo off
chcp 65001 > nul
title Winget

:: Configura a cor para verde claro
color 0A

echo "Instalando Programas para Pdfs e Epubs..."
echo.

winget install --id=calibre.calibre -e --accept-package-agreements --accept-source-agreements --source winget
winget install --id=iLovePDF.iLovePDFDesktop --exact --accept-package-agreements --accept-source-agreements --source winget

exit