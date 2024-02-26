@echo off
chcp 65001 > nul
title Winget

:: Configura a cor para verde claro
color 0A

echo "Instalando Navegadores Web..."
echo.

winget install --id=Mozilla.Firefox --exact --accept-package-agreements --accept-source-agreements --source winget
winget install --id=Google.Chrome --exact --accept-package-agreements --accept-source-agreements --source winget
winget install --id=VivaldiTechnologies.Vivaldi --exact --accept-package-agreements --accept-source-agreements --source winget
winget install --id=DuckDuckGo.DesktopBrowser --exact --accept-package-agreements --accept-source-agreements --source winget

exit