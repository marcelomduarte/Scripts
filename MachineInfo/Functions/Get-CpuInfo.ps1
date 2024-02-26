<#
.SYNOPSIS
    Obtém informações sobre o processador do sistema.

.DESCRIPTION
    Este script consulta informações sobre o processador.
    
    Ele usa a classe Win32_Processor, seguindo diretrizes do padrão CIM (Common Information Model).
    
    É uma abordagem mais moderna, eficiente e segura do que o uso direto do WMI 
    (Windows Management Instrumentation), como o obsoleto cmdlet Get-WmiObject.
    
.LINK
    Get-CimInstance (https://learn.microsoft.com/en-us/powershell/module/cimcmdlets/get-ciminstance?view=powershell-7.3)

    Win32_Processor class (https://learn.microsoft.com/en-us/windows/win32/cimwin32prov/win32-processor)

.NOTES
~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~
    Created with: Windows Terminal; VSCode
    FileName: Get-CpuInfo.ps1
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
    $getCpuInfo = Get-CpuInfo
    $getCpuInfo
#>
Function Get-CpuInfo{

    # Mapa dos código de "Architecture"
    $architectureMapping = @{
        0  = 'x86 (32 bits)'
        1  = 'MIPS'
        2  = 'Alpha'
        3  = 'PowerPC'
        5  = 'ARM'
        6  = 'ia64 (Itanium)'
        9  = 'x64 (64 bits)'
        12 = 'ARM64 (64 bits)'
    }
    
    $classPropertys  = @{
        ClassName = 'Win32_Processor'
        Property = @(
            @{l='DeviceID';e={$_.DeviceID}},
            @{l='Role';e={$_.Role}},
            @{l='Name';e={$_.Name}},
            @{l='Caption';e={$_.Caption}},
            @{l='Architecture';e={$architectureMapping[[int]$_.Architecture]}},
            @{l='NumberOfCores';e={$_.NumberOfCores}},
            @{l='NumberOfLogicalProcessors';e={$_.NumberOfLogicalProcessors}},
            @{l='CurrentClockSpeed';e={[string]::Format('{0} MHz', $_.CurrentClockSpeed)}},
            @{l='MaxClockSpeed';e={[string]::Format('{0} MHz', $_.MaxClockSpeed)}},
            @{l='L2CacheSize';e={[string]::Format('{0} KB', $_.L2CacheSize)}},
            @{l='L3CacheSize';e={[string]::Format('{0} KB', $_.L3CacheSize)}},
            @{l='TotalCacheSize';e={[string]::Format('{0:N2} MB', 
                [Math]::Round(($_.L2CacheSize + $_.L3CacheSize)/ 1024, 2))}},
            @{l='ThreadCount';e={$_.ThreadCount}},
            @{l='Revision';e={$_.Revision}},
            @{l='SocketDesignation';e={$_.SocketDesignation}}
        )
    }
    try {
        # Consulta para obter informações sobre a CPU
        $win32Processor = Get-CimInstance -ClassName $classPropertys.ClassName

        # Exibe as informações
        $win32Processor | Select-Object -Property $classPropertys.Property
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