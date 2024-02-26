<#
.SYNOPSIS
    Obtém informações sobre componentes vinculados a adaptadores de rede.

.DESCRIPTION
    Este script consulta informações sobre componentes associados a adaptadores 
    de rede em um sistema Windows. Ele retorna detalhes sobre os protocolos e 
    serviços vinculados a adaptadores de rede específicos.

.LINK
    Get-NetAdapterBinding (https://learn.microsoft.com/en-us/powershell/module/netadapter/get-netadapterbinding?view=windowsserver2022-ps)

.INPUTS
    None

.OUTPUTS
    Os dados são exibidos no console ou são enviados para um arquivo com o objetivo de documentar sistema.
    
    Dados:
        Name        - Nome do adaptador de rede;
        DisplayName - Nome exibido do componente de ligação;
        ComponentID - Identificador do componente de ligação;
        Enabled     - Indica se o componente de ligação está habilitado ou desabilitado.
       
.NOTES
~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<><>~<>~<>~<>~<>
    Created with: Windows Terminal; VSCode
    FileName: Get-NetAdapterBindingInfo.ps1
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
    $getNetAdapterBindingInfo = Get-NetAdapterBindingInfo
    $getNetAdapterBindingInfo
#>
function Get-NetAdapterBindingInfo{

    # Configura as propriedades de Get-NetAdapterBinding
    $propertys = @(
        @{l='Name';e={$_.Name}},
        @{l='DisplayName';e={$_.DisplayName}},
        @{l='ComponentID';e={$_.ComponentID}},
        @{l='Enabled';e={$_.Enabled}}
    )
    try {
        # 1 Consulta para obter informações 
        # 1.1 Componentes vinculados a adaptadores de rede
        $getNetAdapterBinding = Get-NetAdapterBinding -AllBindings 

        # 2 Exibe as informações
        # 2.1 Componentes vinculados a adaptadores de rede
        $getNetAdapterBinding | 
            Where-Object {
                ($_.Name -eq 'Ethernet' -or $_.Name -eq 'Wi-Fi')
            } | 
            Select-Object -Property $propertys | 
            Sort-Object -Property Name
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

$getNetAdapterBindingInfo = Get-NetAdapterBindingInfo
$getNetAdapterBindingInfo