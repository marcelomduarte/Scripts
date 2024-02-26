
@echo off
chcp 65001 > nul
title Winget

:: Configura a cor para verde claro
color 0A

echo "Instalando Programas Essenciais..."
echo.

winget install --id=7zip.7zip  --exact --accept-package-agreements --accept-source-agreements --source winget
winget install --id=VideoLAN.VLC  --exact --accept-package-agreements --accept-source-agreements --source winget
winget install --id=Notepad++.Notepad++  --exact --accept-package-agreements --accept-source-agreements --source winget
winget install --id=IrfanSkiljan.IrfanView  --exact --accept-package-agreements --accept-source-agreements --source winget
winget install --id=IrfanSkiljan.IrfanView.PlugIns  --exact --accept-package-agreements --accept-source-agreements --source winget
winget install --id=Microsoft.PowerToys  --exact --accept-package-agreements --accept-source-agreements --source winget

exit