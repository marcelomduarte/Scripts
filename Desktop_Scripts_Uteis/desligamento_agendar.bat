@echo off
chcp 65001 > nul
setlocal enabledelayedexpansion

:: Agenda o desligamento do computador de forma planejada,
:: encerrando todos os processos e programas em execução.

:: Configura a chave de controle
set key=%UserProfile%\Documents\Scripts\scripts_desktop\key_shutdown.txt

:: Verifique se o arquivo de controle existe
if not exist !key! (
    :: Configura a cor para texto em azul
    color 0B
    :: Define o tamanho do console para 80 colunas de largura e 10 linhas de altura
    mode 80,10
    echo.                                                  
    echo            Agendar Desligamento 
    echo.
    set /p t1=Digite o tempo em minutos e pressione enter: 
    set /a t2=!t1! * 60
    :: O arquivo não existe, então inicie o desligamento
    shutdown /s /f /t !t2! /c "!t2! minutos..." /d p:4:1
    echo. > !key!
    echo.
    echo ----------------------------------------------------
    echo      Seu dispositivo será desligado em !t2! min
    echo ----------------------------------------------------
    timeout /t 5 
    ) else (
    :: O arquivo existe, então interrompa o desligamento
    shutdown /a
    del !key!
)

endlocal
exit
