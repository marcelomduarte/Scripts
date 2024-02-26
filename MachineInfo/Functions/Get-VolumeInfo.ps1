<#
.SYNOPSIS
    Obtém informações sobre os volumes de armazenamento.

.DESCRIPTION
    Este script consulta informações sobre os volumes de armazenamento.
    
    Ele usa a classe Win32_Volume, seguindo diretrizes do padrão CIM (Common Information Model).
    
    É uma abordagem mais moderna, eficiente e segura do que o uso direto do WMI 
    (Windows Management Instrumentation), como o obsoleto cmdlet Get-WmiObject.
    
.LINK
    Get-CimInstance (https://learn.microsoft.com/en-us/powershell/module/cimcmdlets/get-ciminstance?view=powershell-7.3)

    Win32_Volume class - link não encontrado.

.NOTES
~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~
    Created with: Windows Terminal; VSCode
    FileName: Get-VolumeInfo.ps1
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
    $getvolumeInfo = Get-VolumeInfo
    $getvolumeInfo

#>
Function Get-VolumeInfo{

    $classPropertys = @{
        ClassName = 'Win32_Volume'
        Property = @(
            @{l='DriveLetter';e={$_.DriveLetter}},
            @{l='DeviceID';e={$_.DeviceID}},
            @{l='Capacity';e={
                if ($_.Capacity -ge 1GB) {
                    [string]::Format('{0:N2} GB', [Math]::Round($_.Capacity / 1GB, 2))
                } else {
                    [string]::Format('{0:N2} MB', [Math]::Round($_.Capacity / 1MB, 2))
                }}
            },
            @{l='UsedSpace';e={
                if (($_.Capacity - $_.FreeSpace) -ge 1GB) {
                    [string]::Format('{0:N2} GB', [Math]::Round(($_.Capacity - $_.FreeSpace) / 1GB, 2))
                } else {
                    [string]::Format('{0:N2} MB', [Math]::Round(($_.Capacity - $_.FreeSpace) / 1MB, 2))
                }}
            },
            @{l='FreeSpace';e={
                if ($_.FreeSpace -ge 1GB) {
                    [string]::Format('{0:N2} GB', [Math]::Round($_.FreeSpace / 1GB, 2))
                } else {
                    [string]::Format('{0:N2} MB', [Math]::Round($_.FreeSpace / 1MB, 2))
                }}
            },
            @{l='%FreeSpace';e={
                [string]::Format('{0:N2} %', [Math]::Round(($_.FreeSpace / $_.Capacity) * 100, 2))
                }
            },
            @{l='FileSystem';e={$_.FileSystem}},
            @{l='MaximumFileNameLength';e={$_.MaximumFileNameLength}},
            @{l='BootVolume';e={$_.BootVolume}},
            @{l='SystemVolume';e={$_.SystemVolume}},
            @{l='SerialNumber';e={$_.SerialNumber}}    
        )
    }
    try {
        # Consulta para obter informações sobre os volumes de armazenamento
        $win32Volume = Get-CimInstance -ClassName $classPropertys.ClassName

        # Exibe as informações
        $win32Volume | Select-Object -Property $classPropertys.Property | 
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