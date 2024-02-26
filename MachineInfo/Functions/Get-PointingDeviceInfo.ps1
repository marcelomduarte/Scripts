<#
.SYNOPSIS
    Obtém informações sobre os dispositivos apontadores.

.DESCRIPTION
    Este script consulta informações sobre os dispositivos apontadores (mouses, touchpads etc)  no sistema operacional Windows.
    
    Ele usa a classe Win32_PointingDevice, seguindo diretrizes do padrão CIM (Common Information Model).
    
    É uma abordagem mais moderna, eficiente e segura do que o uso direto do WMI 
    (Windows Management Instrumentation), como o obsoleto cmdlet Get-WmiObject.
    
.LINK
    Get-CimInstance (https://learn.microsoft.com/en-us/powershell/module/cimcmdlets/get-ciminstance?view=powershell-7.3)

    Win32_PointingDevice class (https://learn.microsoft.com/en-us/windows/win32/cimwin32prov/win32-pointingdevice)

.NOTES
~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~
    Created with: Windows Terminal; VSCode
    FileName: Get-PointingDeviceInfo.ps1
    Version: 1.0.0
    E-mail: marcelomduarte30@outlook.com
    GitHub: https://github.com/marcelomduarte
    Linkedin: https://www.linkedin.com/in/marcelomduarte/
    Creation Date: 10/03/2023 
    Updatedby:
    LastUpdate: 
    Changelog  
    Version     When        Who                    What
    1.0.0       09/03/2023  Marcelo Magalhães      Versão inicial

~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~
.EXAMPLE
    # Chama a função
    $getPointingDeviceInfo = Get-PointingDeviceInfo
    $getPointingDeviceInfo
#>
Function Get-PointingDeviceInfo{
    
    # Mapa dos códigos de "DeviceInterface"
    $DeviceInterfaceMapping = @{
        1 = 'Other'
        2 = 'Unknown'
        3 = 'Serial'
        4 = 'PS/2'
        5 = 'Infrared'
        6 = 'HP-HIL'
        7 = 'Bus mouse'
        8 = 'ADB (Apple Desktop Bus)'
        160 = 'Bus mouse DB-9'
        161 = 'Bus mouse micro-DIN'
        162 = 'USB'
    }

    # Mapa dos códigos de "PointingType"
    $PointingTypeMapping = @{
        1 = 'Other'
        2 = 'Unknown'
        3 = 'Mouse'
        4 = 'Track Ball'
        5 = 'Track Point'
        6 = 'Glide Point'
        7 = 'Touch Pad'
        8 = 'Touch Screen'
        9 = 'Mouse - Optical Sensor'
    }

    $classPropertys  = @{
        ClassName = 'Win32_PointingDevice'
        Property = @(
            @{l='Caption';e={$_.Caption}},
            @{l='Manufacturer';e={$_.Manufacturer}},
            @{l='Status';e={$_.Status}},
            @{l='DeviceInterface';e={$DeviceInterfaceMapping[[int]$_.DeviceInterface]}},
            @{l='PointingType';e={$PointingTypeMapping[[int]$_.PointingType]}},
            @{l='PNPDeviceID';e={$_.PNPDeviceID}}
        )
    }
    try {
        # Consulta para obter informações sobre dispositivos apontadores
        $win32PointingDevice = Get-CimInstance -ClassName $classPropertys.ClassName
        
        # Exibe as informações
        $win32PointingDevice | Select-Object -Property $classPropertys.Property 
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

        # Combina o caminho da nova pasta com o nome do arquivo de log
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