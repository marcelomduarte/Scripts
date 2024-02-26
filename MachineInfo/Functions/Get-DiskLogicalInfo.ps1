<#
.SYNOPSIS
    Obtém informações sobre discos lógicos (unidades de disco montadas)

.DESCRIPTION
    Este script consulta informações sobre as unidades de discos lógicos do sistema.
   
    Ele usa a classe Win32_LogicalDisk, seguindo diretrizes do padrão CIM (Common Information Model).
    
    É uma abordagem mais moderna, eficiente e segura do que o uso direto do WMI 
    (Windows Management Instrumentation), como o obsoleto cmdlet Get-WmiObject.
    
.LINK
    Get-CimInstance (https://learn.microsoft.com/en-us/powershell/module/cimcmdlets/get-ciminstance?view=powershell-7.3)

    Win32_LogicalDisk class (https://learn.microsoft.com/en-us/windows/win32/cimwin32prov/win32-logicaldisk)

    .NOTES
~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~
    Created with: Windows Terminal; VSCode
    FileName: Get-DiskLogicalInfo.ps1
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
    $getDiskLogicalInfo = Get-DiskLogicalInfo
    $getDiskLogicalInfo
#>
Function Get-DiskLogicalInfo{
 
    # Mapa dos códigos de "DriveType"
    $driveTypeMapping = @{
        0 = 'Unknown'
        1 = 'No Root Directory'
        2 = 'Removable Disk'
        3 = 'Local Disk'
        4 = 'Network Drive'
        5 = 'CD-ROM'
        6 = 'RAM Disk'
    }

    # Mapa dos códigos de "MediaType"
    $mediaTypeMapping = @{
        0 = 'Unknown'
        1 = 'Other'
        2 = 'Unknown'
        3 = 'Unknown'
        4 = 'HDD'
        5 = 'CD-ROM'
        6 = 'RAM Disk'
        7 = 'Flash ROM'
        8 = 'Unknown'
        9 = 'Network Drive'
        10 = 'Zip Drive'
        11 = 'Jaz Drive'
        12 = 'SSD'
    }
    
    $classPropertys = @{
        ClassName = 'Win32_LogicalDisk'
        Property = @(
            @{l='DeviceID';e={$_.DeviceID}},
            @{l='Size';e={
                if ($_.Size -ge 1GB) {
                    [string]::Format('{0:N2} GB', [Math]::Round($_.Size / 1GB, 2))
                } else {
                    [string]::Format('{0:N2} MB', [Math]::Round($_.Size / 1MB, 2))
                }}
            },
            @{l='UsedSpace';e={
                if (($_.Size - $_.FreeSpace) -ge 1GB) {
                    [string]::Format('{0:N2} GB', [Math]::Round(($_.Size - $_.FreeSpace) / 1GB, 2))
                } else {
                    [string]::Format('{0:N2} MB', [Math]::Round(($_.Size - $_.FreeSpace) / 1MB, 2))
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
                [string]::Format('{0:N2} %', [Math]::Round(($_.FreeSpace / $_.Size) * 100, 2))}
            },
            @{l='DriveType';e={$driveTypeMapping[[int]$_.DriveType]}},
            @{l='MediaType';e={$mediaTypeMapping[[int]$_.MediaType]}},
            @{l='FileSystem';e={$_.FileSystem}},
            @{l='MaximumComponentLength';e={$_.MaximumComponentLength}},
            @{l='VolumeSerialNumber';e={$_.VolumeSerialNumber}} 
        )
    }
    try {
        # Consulta para obter informações sobre discos lógicos 
        $win32LogicalDisk = Get-CimInstance -ClassName $classPropertys.ClassName

        # Exibe as informações
        $win32LogicalDisk  | Select-Object -Property $classPropertys.Property
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