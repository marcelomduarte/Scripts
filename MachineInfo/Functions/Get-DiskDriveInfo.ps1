<#
.SYNOPSIS
    Obtém informações sobre os discos físicos no sistema. 

.DESCRIPTION
    Este script consulta informações sobre as unidades de disco rígido do sistema.
    
    Ele usa a classe Win32_DiskDrive, seguindo diretrizes do padrão CIM (Common Information Model).
    
    É uma abordagem mais moderna, eficiente e segura do que o uso direto do WMI 
    (Windows Management Instrumentation), como o obsoleto cmdlet Get-WmiObject.

    Utiliza também o cmdlet Get-Disk do módulo Storage no PowerShell, retornando objetos de disco físico.
    
.LINK
    Get-CimInstance (https://learn.microsoft.com/en-us/powershell/module/cimcmdlets/get-ciminstance?view=powershell-7.3)

    Win32_DiskDrive class (https://learn.microsoft.com/en-us/windows/win32/cimwin32prov/win32-diskdrive)

    Get-Disk (https://learn.microsoft.com/en-us/powershell/module/storage/get-disk?view=windowsserver2022-ps)

.NOTES
~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~
    Created with: Windows Terminal; VSCode
    FileName: Get-DiskDriveInfo.ps1
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
    $getDiskDriveInfo = Get-DiskDriveInfo
    $getDiskDriveInfo
#>
Function Get-DiskDriveInfo{
    
    $classPropertys = @{
        ClassName = 'Win32_DiskDrive'
        Property = @(
            @{l='DeviceID';e={$_.DeviceID}},
            @{l='TotalSize';e={
                if ($_.Size -ge 1GB) {
                    [string]::Format('{0:N2} GB', [Math]::Round($_.Size / 1GB, 2))
                } else {
                    [string]::Format('{0:N2} MB', [Math]::Round($_.Size / 1MB, 2))
                }}
            },
            @{l='InterfaceType';e={$_.InterfaceType}},
            @{l='Model';e={$_.Model}},
            @{l='SerialNumber';e={$_.SerialNumber}},
            @{l='PNPDeviceID';e={$_.PNPDeviceID}},
            @{l='FirmwareRevision';e={$_.FirmwareRevision}}  
        )
    }
    
    $propertys = @{
        Property = @(
            @{l='Number';e={$_.Number}}, 
            @{l='NumberOfPartitions';e={$_.NumberOfPartitions}}, 
            @{l='IsSystem';e={$_.IsSystem}},
            @{l='IsBoot';e={$_.IsBoot}},
            @{n='HealthStatus';e={$_.HealthStatus}},
            @{n='OperationalStatus';e={$_.OperationalStatus}},
            @{l='PartitionStyle';e={$_.PartitionStyle}} 
        )
    }
    
    try {
        # Consulta para obter informações sobre discos físicos
        $win32DiskDrive = Get-CimInstance -ClassName $classPropertys.ClassName
        
        $getDisk = Get-Disk

        # Exibe as informações
        $win32DiskDrive | Select-Object -Property $classPropertys.Property | 
            Sort-Object -Property DeviceID

        $getDisk | Select-Object -Property $propertys.Property | 
            Sort-Object -Property Number
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