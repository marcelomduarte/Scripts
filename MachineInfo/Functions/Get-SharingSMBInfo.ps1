<#
.SYNOPSIS
    Obtém informações sobre compartilhamentos de rede e sobre o protocolo SMB. 


.DESCRIPTION
    Este script consulta informações sobre os recursos compartilhados em um sistema Windows.

    Ele usa a classe Win32_Share seguindo diretrizes do padrão CIM (Common Information Model).
    
    É uma abordagem mais moderna, eficiente e segura do que o uso direto do WMI 
    (Windows Management Instrumentation), como o obsoleto cmdlet Get-WmiObject.

    Além disso, é exibido o protocolo SMB e quais versões desse protocolo estão habilitadas
    ou desabilitadas. Para isso, é utilizado o cmdlet Get-SmbServerConfiguration. Esse
    cmdlet obtém informações sobre as configurações do servidor SMB.
    O SMB (Server Message Block) é utilizado para comunicação entre computadores em uma rede, 
    permitindo que eles acessem e compartilhem arquivos e recursos. 
    
.LINK
    Get-CimInstance (https://learn.microsoft.com/en-us/powershell/module/cimcmdlets/get-ciminstance?view=powershell-7.3)

    Win32_Share class (https://learn.microsoft.com/en-us/windows/win32/cimwin32prov/win32-share)

    Get-SmbServerConfiguration (https://learn.microsoft.com/en-us/powershell/module/smbshare/get-smbserverconfiguration?view=windowsserver2019-ps)

    SMB (https://docs.microsoft.com/en-us/windows-server/storage/file-server/troubleshoot/detect-enable-and-disable-smbv1-v2-v3)
    
.INPUTS
    None

.OUTPUTS
    Os dados são exibidos no console ou são enviados para um arquivo com o objetivo de documentar sistema.
    
    Dados:
        Name               - Nome do compartilhamento;
        Path               - Caminho do recurso compartilhado;
        Type               - Tipo de recurso que está sendo compartilhado;
        Caption            - Descrição amigável do compartilhamento;
        EnableSMB1Protocol - Controla se o suporte ao protocolo SMB 1.0 está habilitado ou desabilitado no servidor;
        EnableSMB2Protocol - Controla se o suporte ao protocolo SMB 2.0 está habilitado ou desabilitado no servidor.
.NOTES
~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<><>~<>~<>~<>~<>
    Created with: Windows Terminal; VSCode
    FileName: Get-SharingSMBInfo.ps1
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
    $getSharingSMBInfo = Get-SharingSMBInfo
    $getSharingSMBInfo | Format-List
#>
function Get-SharingSMBInfo{

    # Mapa dos códigos de "Type"
    $type_map = @{ 
        0          = 'Disk Drive'
        1          = 'Print Queue'
        2          = 'Device'
        3          = 'IPC'
        2147483648 = 'Disk Drive Admin'
        2147483649 = 'Print Queue Admin'
        2147483650 = 'Device Admin'
        2147483651 = 'IPC Admin'
    }
    
    # Configura a classe e as propriedades de Win32_Share
    $classwin32Share = @{
        ClassName = 'Win32_Share'
        Property  = @(
            @{l='Name';e={$_.Name}},
            @{l='Path';e={
                if ($_.Path) {
                    $_.Path
                } else {
                    'N/A'
                }
            }},
            @{l='Type';e={
                $value = $_.Type
                if ($value -ge [int]::MinValue -and $value -le [int]::MaxValue) {
                    $type_map[[int]$value]
                } else {
                    $type_map[[int64]$value]
                }
                
            }},
            @{l='Caption';e={$_.Caption}}
        )
    }
    # Configura as propriedades de Get-SmbServerConfiguration
    $propertys = @(
        @{l='EnableSMB1Protocol';e={$_.EnableSMB1Protocol}},
        @{l='EnableSMB2Protocol';e={$_.EnableSMB2Protocol}}
    )

    try {
        # 1 Consulta para obter informações 
        # 1.1 Compartilhamentos de rede
        $win32Share = Get-CimInstance -ClassName $classwin32Share.ClassName
        
        # 1.2 Protocolo SMB
        $getSmbServerConfiguration = Get-SmbServerConfiguration

        # 2 Exibe as informações
        # 2.1 Compartilhamentos de rede
        $win32Share | Select-Object -Property $classwin32Share.Property

        # 2.2 Protocolo SMB
        $getSmbServerConfiguration | Select-Object -Property $propertys
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

