@echo off
setlocal enabledelayedexpansion

:: Itera sobre todos os arquivos no diretório atual com a extensão ".txt"
for %%f in (*.txt) do (

  :: Extrai o nome base (sem extensão) do arquivo e armazena-o na variável "name"
  set "name=%%~nf"
  
  :: Renomeia o arquivo, ::ovendo a extensão ".txt" e substituindo pelo valor armazenado em "name"
  ren "%%f" "!name!"
)

endlocal