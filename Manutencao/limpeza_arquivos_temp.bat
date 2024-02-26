:: *******************************************************************************************
:: Script: limpeza_arquivos_temp_baboo_2023_v1.2a.bat
:: Finalidade: apagar arquivos temporários.
:: Instruções de uso: clique o botão direito do mouse nesse script e
:: e selecione "Executar como administrador". Execute esse script uma vez por semana 
:: ou a cada quinze dias.
:: Obsevação: esse script não apaga cookies, histórico e senhas dos navegadores.
:: Autor: Baboo
:: Site: www.baboo.com.br
:: Data de criação: 09/03/2023
:: Versão: 1.2a
:: Notas: 
:: 
:: Versão 1.2a - adição de código para esvaziar a lixeira via PowerShell.
:: *******************************************************************************************


:: ************************** Lixeira ******************************************

:: Esvaziar a lixeira
del c:\$recycle.bin\* /s /q
PowerShell.exe -NoProfile -Command Clear-RecycleBin -Confirm:$false >$null
del $null


:: ************************** Pasta Temp dos Usuários **************************

:: Apaga todos os arquivos temporários da pasta ""Temp" de todos os perfis de usuário 
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Temp\* /s /q

:: Cria um arquivo "vazio.txt" na pasta "Temp" de todos os perfis de usuário 
for /d %%F in (C:\Users\*) do type nul >"%%F\Appdata\Local\Temp\vazio.txt"

:: Apaga todas as pastas vazias dentro da pasta "Temp" de todos os perfis de usuário, mantendo a pasta "Temp" intacta
for /d %%F in (C:\Users\*) do robocopy %%F\AppData\Local\Temp\ %%F\AppData\Local\Temp\ /s /move /NFL /NDL /NJH /NJS /nc /ns /np

:: Apaga o arquivo "vazio.txt" dentro da pasta "Temp" de todos os perfis de usuário
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Temp\vazio.txt


:: *************************** Pasta Temp do Windows ***************************

:: Apaga todos arquivos da pasta "\Windows\Temp", mantendo a pasta "Temp" intacta
del c:\Windows\Temp\* /s /q

:: Cria um arquivo "vazio.txt" dentro da pasta "\Windows\Temp"
type nul > c:\Windows\Temp\vazio.txt

:: Apaga todas as pastas vazias dentro da pasta "\Windows\Temp", mantendo a pasta "Temp" intacta
robocopy c:\Windows\Temp c:\Windows\Temp /s /move /NFL /NDL /NJH /NJS /nc /ns /np

:: Apaga arquivo "vazio.txt" dentro da pasta "\Windows\Temp"
del c:\Windows\Temp\vazio.txt


:: ************************* Arquivos de Log do Windows *************************

:: Apaga arquivos de log do Windows
del c:\windows\logs\cbs\*.log
del C:\Windows\Logs\MoSetup\*.log
del C:\Windows\Panther\*.log /s /q
del C:\Windows\inf\*.log /s /q
del C:\Windows\logs\*.log /s /q
del C:\Windows\SoftwareDistribution\*.log /s /q
del C:\Windows\Microsoft.NET\*.log /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\OneDrive\setup\logs\*.log /s /q


::  ******* Arquivos de Log e de Cache do Windows e do Internet Explorer ********
:: Apaga principalmente os arquivos temporários, de log e de cache, relacionados ao Windows e ao Internet Explorer
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Windows\Explorer\*.db /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Windows\WebCache\*.log /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Windows\SettingSync\*.log /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Windows\Explorer\ThumbCacheToDelete\*.tmp /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\"Terminal Server Client"\Cache\*.bin /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Windows\INetCache\IE\* /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Windows\INetCache\Low\*.dat /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Windows\INetCache\Low\*.js /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Windows\INetCache\Low\*.htm /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Windows\INetCache\Low\*.txt /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Windows\INetCache\Low\*.jpg /s /q
for /d %%F in (C:\Users\*) do robocopy %%F\AppData\Local\Microsoft\Windows\INetCache\IE\ /s /move /NFL /NDL /NJH /NJS /nc /ns /np


:: ******************************* Microsoft Edge *******************************

::  Encerra todos os processos do Microsoft Edge
taskkill /F /IM "msedge.exe"

::  Apaga arquivos de cache e armazenamento do Edge
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\Default\Cache\Cache_Data\data*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\Default\Cache\Cache_Data\f*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\Default\Cache\Cache_Data\index. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\Default\Storage\*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\Default\GPUCache\d*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\Default\GPUCache\i*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\Default\"Code Cache"\js\*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\Default\"Service Worker"\CacheStorage\*. /s /q
for /d %%F in (C:\Users\*) do robocopy %%F\AppData\Local\Microsoft\Edge\"User Data"\Default\"Service Worker"\CacheStorage\ %%F\AppData\Local\Microsoft\Edge\"User Data"\Default\"Service Worker"\CacheStorage\ /s /move /NFL /NDL /NJH /NJS /nc /ns /np
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\Default\"Service Worker"\Database\*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\Default\"Service Worker"\ScriptCache\*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\Default\EdgeCoupons\coupons_data.db\*.ldb /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\Default\EdgeCoupons\coupons_data.db\index. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\Default\EdgeCoupons\coupons_data.db\*.log /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Microsoft\Edge\"User Data"\BrowserMetrics\*.pma /s /q


:: ****************************** Mozilla Firefox ******************************

::  Encerra todos os processos do Mozilla Firefox
taskkill /F /IM "firefox.exe"

:: Apaga arquivos temporários e configurações do Firefox 
for /d %%F in (C:\Users\*) do del %%F\AppData\local\Mozilla\Firefox\Profiles\*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\local\Mozilla\Firefox\Profiles\script*.bin /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\local\Mozilla\Firefox\Profiles\startup*.* /s /q


:: *******************************  Google Chrome *******************************

::  Encerra todos os processos do Google Chrome
taskkill /F /IM "chrome.exe"

:: Apaga arquivos temporários e configurações do Google Chrome 
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Google\Chrome\"User Data"\Default\Cache\Cache_Data\data*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Google\Chrome\"User Data"\Default\Cache\Cache_Data\f*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Google\Chrome\"User Data"\Default\Cache\Cache_Data\index. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Google\Chrome\"User Data"\Default\Storage\*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Google\Chrome\"User Data"\Default\GPUCache\d*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Google\Chrome\"User Data"\Default\GPUCache\i*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Google\Chrome\"User Data"\Default\"Code Cache"\js\*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Google\Chrome\"User Data"\Default\"Service Worker"\CacheStorage\*. /s /q
for /d %%F in (C:\Users\*) do robocopy %%F\AppData\Local\Google\Chrome\"User Data"\Default\"Service Worker"\CacheStorage\ %%F\AppData\Local\Google\Chrome\"User Data"\Default\"Service Worker"\CacheStorage\ /s /move /NFL /NDL /NJH /NJS /nc /ns /np
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Google\Chrome\"User Data"\Default\"Service Worker"\Database\*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Google\Chrome\"User Data"\Default\"Service Worker"\ScriptCache\*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Google\Chrome\"User Data"\brow*.* /s /q


:: *********************************** Brave ***********************************

::  Encerra todos os processos do Brave
taskkill /F /IM "brave.exe"

:: Apaga arquivos temporários e configurações do Brave
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\BraveSoftware\Brave-Browser\"User Data"\Default\Cache\Cache_Data\data*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\BraveSoftware\Brave-Browser\"User Data"\Default\Cache\Cache_Data\f*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\BraveSoftware\Brave-Browser\"User Data"\Default\Cache\Cache_Data\index. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\BraveSoftware\Brave-Browser\"User Data"\Default\Storage\*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\BraveSoftware\Brave-Browser\"User Data"\Default\GPUCache\d*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\BraveSoftware\Brave-Browser\"User Data"\Default\GPUCache\i*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\BraveSoftware\Brave-Browser\"User Data"\Default\"Code Cache"\js\*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\BraveSoftware\Brave-Browser\"User Data"\Default\"Service Worker"\CacheStorage\*. /s /q
for /d %%F in (C:\Users\*) do robocopy %%F\AppData\Local\BraveSoftware\Brave-Browser\"User Data"\Default\"Service Worker"\CacheStorage\ %%F\AppData\Local\BraveSoftware\Brave-Browser\"User Data"\Default\"Service Worker"\CacheStorage\ /s /move /NFL /NDL /NJH /NJS /nc /ns /np
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\BraveSoftware\Brave-Browser\"User Data"\Default\"Service Worker"\Database\*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\BraveSoftware\Brave-Browser\"User Data"\Default\"Service Worker"\ScriptCache\*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\BraveSoftware\Brave-Browser\"User Data"\brow*.* /s /q


:: ********************************** Vivaldi **********************************

::  Encerra todos os processos do Vivaldi
taskkill /F /IM "vivaldi.exe"

:: Apaga arquivos temporários e configurações do Vivaldi
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Vivaldi\"User Data"\Default\Cache\Cache_Data\data*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Vivaldi\"User Data"\Default\Cache\Cache_Data\f*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Vivaldi\"User Data"\Default\Cache\Cache_Data\index. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Vivaldi\"User Data"\Default\Storage\*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Vivaldi\"User Data"\Default\GPUCache\d*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Vivaldi\"User Data"\Default\GPUCache\i*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Vivaldi\"User Data"\Default\"Code Cache"\js\*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Vivaldi\"User Data"\Default\"Service Worker"\CacheStorage\*. /s /q
for /d %%F in (C:\Users\*) do robocopy %%F\AppData\Local\Vivaldi\"User Data"\Default\"Service Worker"\CacheStorage\ %%F\AppData\Local\Vivaldi\"User Data"\Default\"Service Worker"\CacheStorage\ /s /move /NFL /NDL /NJH /NJS /nc /ns /np
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Vivaldi\"User Data"\Default\"Service Worker"\Database\*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Vivaldi\"User Data"\Default\"Service Worker"\ScriptCache\*. /s /q
for /d %%F in (C:\Users\*) do del %%F\AppData\Local\Vivaldi\"User Data"\brow*.* /s /q


:: *********************************** Adobe ***********************************

:: Apaga arquivos da pasta "Media Cache files" da Adobe em todos os perfis de usuário 
for /d %%F in (C:\Users\*) do del %%F\AppData\Roaming\Adobe\Common\"Media Cache files"\*.* /s /q


exit