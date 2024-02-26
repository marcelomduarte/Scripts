<#
.SYNOPSIS
    Obtém informações de geolocalização com base em um endereço IP. 

.DESCRIPTION
    Este script consulta informações em uma Interface de Programação de Aplicações (API) da Web
    sobre a geolocalização aproximada com base em um endereço IP.

    Ele utiliza o cmdlet Invoke-RestMethod para fazer uma solicitação GET para 
    API "ipify.org" para obter o endereço IP externo (IP publico).
    Depois de retornar esse IP, faz outra solicitação para a API do "ipinfo.io" 
    para obter informações sobre a geolocalização do IP.
    
.LINK
    Invoke-RestMethod (https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/invoke-restmethod?view=powershell-7.3)
    
    ipify API (https://www.ipify.org/)

    ipinfo.io (https://ipinfo.io/)

.INPUTS
    None

.OUTPUTS
    Os dados são exibidos no console ou são enviados para um arquivo com o objetivo de documentar sistema.
    
    Dados:
        IPAddress    - Endereço IP público;
        HostName     - O nome de host associado ao endereço IP;
        Country      - O país onde o endereço IP está localizado;
        State/Region - A Região ou estado dentro do país onde o endereço IP está localizado;
        City         - A cidade onde o endereço IP está localizado;
        Coordinates  - As coordenadas geográficas (latitude e longitude) do endereço IP;
        Organization - A organização ou provedor de serviços de Internet (ISP) associado ao endereço IP;
        Postal       - O código postal associado ao endereço IP;
        TimeZone     - O fuso horário associado ao endereço IP.
     
.NOTES
~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<><>~<>~<>~<>~<>
    Created with: Windows Terminal; VSCode
    FileName: Get-IpGeolocationApi.ps1
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
    $getIpGeolocationApi = Get-IpGeolocationApi
    $getIpGeolocationApi
#>
function Get-IpGeolocationApi{

    # Configura as propriedades
    $propertys = @(
        @{l='IPAddress';e={$_.ip}},
        @{l='HostName';e={
            if ($null -ne $_.hostname) {
                $_.hostname
            } else {
                'N/A'
            }
        }},
        @{l='Country';e={$_.country}},
        @{l='State/Region';e={$_.region}},
        @{l='City';e={$_.city}},
        @{l='Coordinates';e={"Lat.: $($_.loc.Split(',')[0]), Long.: $($_.loc.Split(',')[1])"}},
        @{l='Organization';e={$_.org}},
        @{l='Postal';e={$_.postal}},
        @{l='TimeZone';e={$_.timezone}}
    )

    try {
        # 1 Solicitação Get - geolocalização com base em um endereço IP
        # 1.1 Obtém o endereço IP público
        $ipv4Ify = Invoke-RestMethod -Uri 'https://api.ipify.org?format=json' -Method Get 

        # 1.2 Obtém informações relacionadas ao IP público retornado pela API "ipify.org".
        $ipInfo = Invoke-RestMethod -Uri "https://ipinfo.io/$($IPv4Ify.ip)/json" -Method Get 

        # 2 Exibe as informações 
        # 2.1 Geolocalização de IP
        $ipInfo | Select-Object -Property $propertys
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

$getIpGeolocationApi = Get-IpGeolocationApi
$getIpGeolocationApi