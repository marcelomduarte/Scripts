<#
.SYNOPSIS
    Obtém informações sobre os dispositivos Plug and Play (PnP) no sistema. 

.DESCRIPTION
    Este script consulta informações sobre os dispositivos Plug and Play (PnP) no sistema.
    
    Ele usa a classe Win32_PNPEntity, seguindo diretrizes do padrão CIM (Common Information Model).
    
    É uma abordagem mais moderna, eficiente e segura do que o uso direto do WMI 
    (Windows Management Instrumentation), como o obsoleto cmdlet Get-WmiObject.
    
.LINK
    Get-CimInstance (https://learn.microsoft.com/en-us/powershell/module/cimcmdlets/get-ciminstance?view=powershell-7.3)

    Win32_PNPEntity class (https://learn.microsoft.com/en-us/windows/win32/cimwin32prov/win32-pnpentity)
    
.NOTES
~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~
    Created with: Windows Terminal; VSCode
    FileName: Get-USBInfo.ps1
    Version: 1.0.0
    E-mail: marcelomduarte30@outlook.com
    GitHub: https://github.com/marcelomduarte
    Linkedin: https://www.linkedin.com/in/marcelomduarte/
    Creation Date: 10/03/2023 
    Updatedby:
    LastUpdate: 
    Changelog  
    Version     Date        Who                  What
    1.0.0       10/03/2023  Marcelo Magalhães    Versão inicial

~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~
.EXAMPLE
    # Chama a função
    $getUSB = Get-USB
    $getUSB
#>
Function Get-USB{

    $classPropertys  = @{
        ClassName = 'Win32_PNPEntity'
        Property = @(
            @{l='PNPDeviceID';e={$_.PNPDeviceID}},
            @{l='Caption';e={$_.Caption}},
            @{l='Status';e={$_.Status}}, 
            @{l='PNPClass';e={$_.PNPClass}},
            @{l='ClassGuid';e={$_.ClassGuid}},
            @{l='Present';e={$_.Present}},
            @{l='Service';e={$_.Service}}
        )
    }
    try {
        # Consulta para obter informações sobre dispositivos PnP
        $win32PNPEntity = Get-CimInstance -ClassName $classPropertys.ClassName 
        
        # Exibe as informações
        $win32PNPEntity | Select-Object -Property $classPropertys.Property | 
        Where-Object {$_.PNPDeviceID -like 'USB*'}
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

# Chama a função
$getUSB = Get-USB
$getUSB