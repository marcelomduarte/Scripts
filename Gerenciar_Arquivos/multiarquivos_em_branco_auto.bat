@echo off
chcp 65001 > nul
setlocal enabledelayedexpansion
title Arquivos em branco

echo Quantos arquivos você deseja criar?
set /p num_files=

if not "!num_files!"=="" (
    for /l %%i in (1, 1, !num_files!) do (
        echo. > "arq_%%i"
    )
)
