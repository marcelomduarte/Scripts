<#
.SYNOPSIS
    Obtém informações sobre as impressoras instaladas no sistema.

.DESCRIPTION
    Este script consulta informações sobre as impressoras instaladas no sistema Windows. 
    
    Ele usa a classe Win32_Printer, seguindo diretrizes do padrão CIM (Common Information Model).
    
    É uma abordagem mais moderna, eficiente e segura do que o uso direto do WMI 
    (Windows Management Instrumentation), como o obsoleto cmdlet Get-WmiObject.
    
.LINK
    Get-CimInstance (https://learn.microsoft.com/en-us/powershell/module/cimcmdlets/get-ciminstance?view=powershell-7.3)

    Win32_Printer class (https://learn.microsoft.com/pt-br/windows/win32/cimwin32prov/win32-printer)

.NOTES
~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~
    Created with: Windows Terminal; VSCode
    FileName: Get-PrinterInfo.ps1
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
    $getPrinterInfo = Get-PrinterInfo
    $getPrinterInfo
#>
Function Get-PrinterInfo{
    
    # Mapa dos códigos de "PrinterStatus"
    $printerStatusMapping = @{
        1 = 'Other'
        2 = 'Unknown'
        3 = 'Idle'
        4 = 'Printing'
        5 = 'Warmup'
        6 = 'Stopped Printing'
        7 = 'Offline'
    }
    
    $classPropertys  = @{
        ClassName = 'Win32_Printer'
        Property = @(
            @{l='DeviceID';e={$_.Name}},
            @{l='DriverName';e={$_.DriverName}},
            @{l='PortName';e={$_.PortName}},
            @{l='PrinterStatus';e={$printerStatusMapping[[int]$_.PrinterStatus]}},
            @{l='Default';e={$_.Default}},
            @{l='Shared';e={$_.Shared}},
            @{l='Local';e={$_.Local}},
            @{l='Network ';e={$_.Network}},
            @{l='Hidden';e={$_.Hidden}},
            @{l='HorizontalResolution';e={$_.HorizontalResolution}},
            @{l='VerticalResolution';e={$_.VerticalResolution}}
        )
    }
    try {
        # Consulta para obter informações sobre impressoras
        $win32Printer = Get-CimInstance -ClassName $classPropertys.ClassName
        
        # Exibe as informações
        $win32Printer | Select-Object -Property $classPropertys.Property 
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

$getPrinterInfo = Get-PrinterInfo
$getPrinterInfo