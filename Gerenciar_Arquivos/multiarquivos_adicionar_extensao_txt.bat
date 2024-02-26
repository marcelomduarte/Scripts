@echo off
setlocal enabledelayedexpansion

:: Este loop percorre todos os arquivos no diretório atual
for %%f in (*) do (

  :: Extrai o nome base do arquivo (sem extensão) 
  set "filename=%%~nf"  

  :: Extrai a extensão do arquivo
  set "extension=%%~xf" 
  
  :: Verifica se a extensão não é ".bat"
  if not "!extension!"==".bat" (

    :: Renomeia o arquivo adicionando a extensão ".txt"
    ren "%%f" "%%f.txt"
  )
)

endlocal

:: for %%f in (*) do ren "%%f" "%%f.txt"