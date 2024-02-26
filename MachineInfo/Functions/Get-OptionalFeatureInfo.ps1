<#
.SYNOPSIS
    Obtém informações sobre informações sobre os recursos opcionais.

.DESCRIPTION
    Este script consulta informações sobre recursos opcionais do Windows.
    
    Ele usa a classe Win32_OptionalFeature seguindo diretrizes do padrão CIM (Common Information Model).
    
    É uma abordagem mais moderna, eficiente e segura do que o uso direto do WMI 
    (Windows Management Instrumentation), como o obsoleto cmdlet Get-WmiObject.
 
.LINK
    Get-CimInstance (https://learn.microsoft.com/en-us/powershell/module/cimcmdlets/get-ciminstance?view=powershell-7.3)

    Win32_OptionalFeature class (https://learn.microsoft.com/en-us/windows/win32/cimwin32prov/win32-optionalfeature)

.INPUTS
    None

.OUTPUTS
    Os dados são exibidos no console ou são enviados para um arquivo com o objetivo de documentar sistema.
    
    Dados:
        Name         - Nome do recurso opcional;
        InstallState - Estado de instalação do recurso;
        Caption      - Nome amigável do recurso opcional.
       
.NOTES
~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<><>~<>~<>~<>~<>
    Created with: Windows Terminal; VSCode
    FileName: Get-OptionalFeatureInfo.ps1
    Version: 1.0.0
    E-mail: marcelomduarte30@outlook.com
    GitHub: https://github.com/marcelomduarte
    Linkedin: https://www.linkedin.com/in/marcelomduarte/
    Updatedby: Marcelo Magalhães
    LastUpdate: 12/03/2023 
    Changelog  
    Version     When        Who                    What
    1.0.0       09/03/2023  Marcelo Magalhães      Inicializado - Versão inicial
    
~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<><>~<>~<>~<>~<>
.EXAMPLE
    # Chama a função
    $getOptionalFeatureInfo = Get-OptionalFeatureInfo
    $getOptionalFeatureInfo
#>
function Get-OptionalFeatureInfo{

    # Mapa dos códigos de "InstallState"
    $installState_map = @{ 
        1 = 'Enabled'
        2 = 'Disabled'
        3 = 'Absent'
        4 = 'Unknown'
    }

    # Configura a classe e as propriedades de Win32_OptionalFeature
    $classwin32OptionalFeature = @{
        ClassName = 'Win32_OptionalFeature'
        Property  = @(
            @{l='Name';e={$_.Name}},
            @{l='InstallState';e={$installState_map[[int]$_.InstallState]}}
            @{l='Caption';e={$_.Caption}}
        )
    }
    try {
        # 1 Consulta para obter informações 
        # Compartilhamentos de rede
        $win32OptionalFeature = Get-CimInstance -ClassName $classwin32OptionalFeature.ClassName  

        # 2 Exibe as informações
        # 2.1 Compartilhamentos de rede
        $win32OptionalFeature | Select-Object -Property $classwin32OptionalFeature.Property | 
            Sort-Object -Property InstallState -Descending
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

        # Obtém o nome do script em execução
        $scriptName = $MyInvocation.MyCommand.Name

        # Linha estilizada para delimitar as mensagens no arquivo de log
        $lineStyling = "#######################################################"

        # Adiciona a linha estilizada ao arquivo de log
        $lineStyling | Out-File -FilePath $logFilePath -Append

        # Obtém a data atual e anexa ao arquivo de log junto com o nome do script
        "$date - $scriptName`n" | Out-File -FilePath $logFilePath -Append
      
        # Adiciona a mensagem de erro ao arquivo de log
        "$errorMessage`n"  | Out-File -FilePath $logFilePath -Append
        
        # Cria um link 
        $logFileUri = [System.Uri]::new($logFilePath)

        # Exibe o link clicável no console
        Write-Host "Ocorreu um erro. Consulte o arquivo de log em $logFileUri para detalhes."
    }
}