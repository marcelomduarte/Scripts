@echo off
setlocal enabledelayedexpansion

:: Funciona como uma chave de rede para desativar a Ethernet e Wi-Fi
:: e quando clica novamente no atalho, ativa a rede

:: Configura a chave de controle
set key=%UserProfile%\Documents\Scripts\scripts_desktop\key_network.txt

:: Verifique se o arquivo de controle existe
if not exist !key! (
    :: Desconeta a interface Ethernet
    netsh interface set interface name=Ethernet admin=disabled
    :: Desconeta a interface Wi-Fi
    netsh interface set interface name=Wi-Fi admin=disabled 
    :: Gera a chave de controle
    echo. > !key!
    ) else (
    :: Conecta a interface Ethernet
    netsh interface set interface name=Ethernet admin=enabled 
    :: Conecta a interface Wi-Fi
    netsh interface set interface name=Wi-Fi admin=enabled 
    :: Deleta a chave de controle
    del !key!
)

endlocal
exit

