<#
.SYNOPSIS
    Obtém informações sobre os dispositivos de teclado.

.DESCRIPTION
    Este script consulta informações sobre os dispositivos de teclado no sistema operacional Windows.
    Ele usa a classe Win32_Keyboard, seguindo diretrizes do padrão CIM (Common Information Model).
    É uma abordagem mais moderna, eficiente e segura do que o uso direto do WMI 
    (Windows Management Instrumentation), como o obsoleto cmdlet Get-WmiObject.
    
.LINK
    Get-CimInstance (https://learn.microsoft.com/en-us/powershell/module/cimcmdlets/get-ciminstance?view=powershell-7.3)

    Win32_Keyboard class (https://learn.microsoft.com/en-us/windows/win32/cimwin32prov/win32-keyboard)

    Windows keyboard layouts (https://learn.microsoft.com/pt-br/windows-hardware/manufacture/desktop/windows-language-pack-default-values?view=windows-11&source=recommendations)

.NOTES
~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~
    Created with: Windows Terminal; VSCode
    FileName: Get_KeyboardInfo.ps1
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
    $getKeyboardInfo = Get_KeyboardInfo
    $getKeyboardInfo
#>
Function Get_KeyboardInfo{
    
    # Mapa dos códigos de "Layout"
    $layoutMapping = @{
        00000816 = 'Portuguese'
        00000416 = 'Portuguese (Brazil ABNT)'
        00010416 = 'Portuguese (Brazil ABNT2)'
        00010409 = 'United States-Dvorak'
        00030409 = 'United States-Dvorak for left hand'
        00040409 = 'United States-Dvorak for right hand'
        00020409 = 'United States-International'
    }

    $classPropertys  = @{
        ClassName = 'Win32_Keyboard'
        Property = @(
            @{l='Caption';e={$_.Caption}},
            @{l='Description';e={$_.Description}},
            @{l='Status';e={$_.Status}},
            @{l='Layout';e={$layoutMapping[[int]$_.Layout]}},
            @{l='NumberOfFunctionKeys';e={$_.NumberOfFunctionKeys}}, 
            @{l='PNPDeviceID';e={$_.PNPDeviceID}}
        )
    }
    try {
        # Consulta para obter informações sobre dispositivos de teclado
        $win32Keyboard = Get-CimInstance -ClassName $classPropertys.ClassName
        
        # Exibe as informações
        $win32Keyboard | Select-Object -Property $classPropertys.Property 
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