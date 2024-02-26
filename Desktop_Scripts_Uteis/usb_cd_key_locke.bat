@echo off
setlocal enabledelayedexpansion

:: Configura o caminho da chave de controle
set key=%UserProfile%\Documents\Scripts\scripts_desktop\key_usb_cd.txt

:: Verifique se o arquivo de controle existe
if not exist !key! (
    :: Desativa o armazenamento USB 
    reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\USBSTOR /t REG_DWORD /v Start /d 4 /f
    :: Verifica a existência da chave relacionada à unidade de CD/DVD-ROM 
    reg query HKLM\System\CurrentControlSet\Services\cdrom
    if %errorlevel% equ 0 (
        :: A chave existe, então desative a unidade de CD/DVD-ROM
        reg add HKLM\System\CurrentControlSet\Services\cdrom /t REG_DWORD /v Start /d 4 /f
    )
    :: Gera a chave de controle
    echo. > !key!
) else (
    :: Ativa o armazenamento USB 
    reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\USBSTOR /t REG_DWORD /v Start /d 3 /f
    :: Verifica a existência da chave relacionada à unidade de CD/DVD-ROM 
    reg query HKLM\System\CurrentControlSet\Services\cdrom
    if %errorlevel% equ 0 (
        :: A chave existe, então ative a unidade de CD/DVD-ROM
        reg add HKLM\System\CurrentControlSet\Services\cdrom /t REG_DWORD /v Start /d 1 /f
    )
    :: Deleta a chave de controle
    del !key!
)

endlocal
exit



