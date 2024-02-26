<#
.SYNOPSIS
    Obtém informações sobre as partições de disco no sistema. 

.DESCRIPTION
    Este script consulta informações sobre objetos de partição.
    
    Ele usa o cmdlet Get-Partition do módulo Storage no PowerShell.
    
.LINK
    Get-Partition (https://learn.microsoft.com/en-us/powershell/module/storage/get-partition?view=windowsserver2022-ps)

.NOTES
~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~
    Created with: Windows Terminal; VSCode
    FileName: Get-DiskPartitionInfo.ps1
    Version: 1.0.0
    E-mail: marcelomduarte30@outlook.com
    GitHub: https://github.com/marcelomduarte
    Linkedin: https://www.linkedin.com/in/marcelomduarte/
    Updatedby:
    LastUpdate: 
    Changelog  
    Version     Date        Author               Comment
    1.0.0       09/03/2023  Marcelo Magalhães    Versão inicial

~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~
.EXAMPLE
    # Chama a função
    $getDiskPartitionInfo = Get-DiskPartitionInfo
    $getDiskPartitionInfo
#>
Function Get-DiskPartitionInfo{

    $propertys = @{
        Property = @(
            @{l='DriveLetter';e={$_.DriveLetter}},
            @{l='DiskNumber';e={$_.DiskNumber}},
            @{l='PartitionNumber';e={$_.PartitionNumber}},
            @{l='Type';e={$_.Type}},
            @{l='Size';e={
                if ($_.Size -ge 1GB) {
                    [string]::Format('{0:N2} GB', [Math]::Round($_.Size / 1GB, 2))
                } else {
                    [string]::Format('{0:N2} MB', [Math]::Round($_.Size / 1MB, 2))
                }}
            }   
        )
    }
    try {
        # Consulta para obter informações sobre as partições de disco
        $getPartition = Get-Partition
        
        # Exibe as informações
        $getPartition | Select-Object -Property $propertys.Property |
            Sort-Object -Property DriveLetter     
    }
    catch {
        # Captura a mensagem de exceção
        $errorMessage = $_.Exception.Message
       
        # Define o caminho da pasta onde a mensagem de exceção será salva
        $documentPath = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::MyDocuments)
        $folderName = 'Env\ExceptionLogs'
        $newFolder = Join-Path -Path $documentPath -ChildPath $folderName

        # Verifica se o diretório existe 
        if (-not (Test-Path -Path $newFolder -PathType Container)) {
            # Se o diretório não existir, cria um novo diretório
            New-Item -Path $newFolder -ItemType Directory
        }

        # Combina o caminho da nova pasta com o nome do arquivo de log desejado
        $logFilePath = Join-Path -Path $newFolder -ChildPath "${env:COMPUTERNAME}_${env:USERNAME}_ExceptionMsg.txt"

        # Armazena a data e hora atuais 
        $date = Get-Date -UFormat "%d-%m-%Y - %Hh-%Mm-%Ss"

        $scriptName = $MyInvocation.MyCommand.Name

        $lineStyling = "#######################################################"

        $lineStyling | Out-File -FilePath $logFilePath -Append

        "$date - $scriptName`n" | Out-File -FilePath $logFilePath -Append
      
        "$errorMessage`n"  | Out-File -FilePath $logFilePath -Append
        
        # Cria um link 
        $logFileUri = [System.Uri]::new($logFilePath)

        # Exibe o link clicável no console
        Write-Host "Ocorreu um erro. Consulte o arquivo de log em $logFileUri para detalhes."
    } 
}