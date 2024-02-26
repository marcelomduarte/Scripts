# Script organizador de arquivos
# $downloadsFolder = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::MyDocuments) + "\Downloads"

$downloadsFolder = Join-Path -Path $env:USERPROFILE -ChildPath "Downloads"

# Define o caminho da pasta onde os arquivos serão organizados
$folderPath = $downloadsFolder

# Obtém uma lista de arquivos na pasta especificada
# Loop para iterar sobre cada arquivo
Get-ChildItem -Path $folderPath | ForEach-Object {
    
    # Obtém a extensão do arquivo atual
    $extension = $_.Extension
    
    # Cria o caminho de destino unindo o caminho da pasta de tarefas com a extensão do arquivo.
    $destination = Join-Path -Path $folderPath -ChildPath $extension

    # Verifica se o diretório de destino não existe
    if (!(Test-Path $destination)) {
        # Se o diretório de destino não existe, cria um novo diretório
        New-Item -ItemType Directory -Path $destination
    }
    
    # Move o arquivo atual para o diretório de destino
    Move-Item -Path $_.FullName -Destination $destination
}
