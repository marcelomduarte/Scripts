@echo off
chcp 65001 > nul
setlocal enabledelayedexpansion
title Arquivos em branco

echo Quantos arquivos em branco você deseja criar?
set /p num_files=

:: Verifique se o número inserido é válido
if not "!num_files!"=="" (
    for /l %%i in (1,1,!num_files!) do (
        echo Nome do arquivo %%i:
        set /p input=
        if not "!input!"=="" (
            echo. > !input!
        )
    )
)


