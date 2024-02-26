<#
.SYNOPSIS
    Obtém informações sobre as configurações da placa de rede.

.DESCRIPTION
    Este script consulta informações sobre as configurações da interface de rede
    quando tem um endereço IP configurado e está habilitada para comunicação na rede
    ("IPEnabled = True").

    Ele usa a classe Win32_NetworkAdapterConfiguration seguindo diretrizes 
    do padrão CIM (Common Information Model).
    
    É uma abordagem mais moderna, eficiente e segura do que o uso direto do WMI 
    (Windows Management Instrumentation), como o obsoleto cmdlet Get-WmiObject.

    Utiliza também o cmdlet Get-NetAdapter para obter informações sobre adaptadores 
    de rede no sistema.
    
.LINK
    Get-CimInstance (https://learn.microsoft.com/en-us/powershell/module/cimcmdlets/get-ciminstance?view=powershell-7.3)

    Win32_NetworkAdapterConfiguration class (https://learn.microsoft.com/en-us/windows/win32/cimwin32prov/win32-networkadapterconfiguration)

    Get-NetAdapter (https://learn.microsoft.com/en-us/powershell/module/netadapter/get-netadapter?view=windowsserver2022-ps)

.INPUTS
    None

.OUTPUTS
    Os dados são exibidos no console ou são enviados para um arquivo com o objetivo de documentar sistema.
    
    Dados:
        Adapter                 - Descrição do adaptador de rede;
        Index                   - Número de índice da configuração do adaptador de rede;
        InterfaceIndex          - Índice exlusivo associado à interface de rede;
        IPAddress               - Endereço IP configurado na interface de rede;
        IPSubnet                - Máscara de sub-rede associada ao endereço IP; 
        DefaultIPGateway        - Lista os gateways padrão; 
        MACAddress              - Endereço MAC (Media Access Control) da interface de rede, também conhecido como endereço físico;
        DHCPEnabled             - Indica se o DHCP (Dynamic Host Configuration Protocol) está habilitado;
        DHCPServer              - Endereço IP do servidor DHCP;
        DNSServerSearchOrder    - Lista os servidores DNS (Domain Name System);
        TcpipNetbiosOptions     - Configurações relacionadas ao NetBIOS (Network Basic Input/Output System) sobre TCP/IP;
        WINSEnableLMHostsLookup - Indica se a pesquisa de LMHosts está habilitada no adaptador de rede;
        Adapter_ID              - Indentifica a interface de rede pelo nome, descrição e o endereço MAC;
        LinkSpeed               - Velocidade da conexão da interface de rede;
        Status                  - Indica se a interface de rede está em execução ou não;
        MediaType               - Tipo de mídia ou protocolo de comunicação usado pela interface de rede;
        PhysicalMediaType       - Meio físico real pelo qual a interface de rede se conecta à rede;
        DriverInformation       - Informações sobre o driver.

.NOTES
~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<><>~<>~<>~<>~<>
    Created with: Windows Terminal; VSCode
    FileName: Get-NetworkIConfigInfo.ps1
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
    $getNetworkConfigInfo = Get-NetworkIConfigInfo
    $getNetworkConfigInfo
#>
function Get-NetworkIConfigInfo{

    # Mapa dos códigos de "TcpipNetbiosOptions"
    $netbiosMapping = @{
        0 = 'EnableNetbiosViaDhcp'
        1 = 'EnableNetbios'
        2 = 'DisableNetbios'
    }
    # Configura a classe e as propriedades de Win32_NetworkAdapterConfiguration
    $classNetAdapterConfig = @{
        ClassName = 'Win32_NetworkAdapterConfiguration'
        Property  = @(
            @{l='Adapter';e={$_.Description}},
            @{l='Index';e={$_.Index}},
            @{l='InterfaceIndex';e={$_.InterfaceIndex}},
            @{l='IPAddress';e={$_.IPAddress}},
            @{l='IPSubnet';e={$_.IPSubnet}},
            @{l='DefaultIPGateway';e={$_.DefaultIPGateway}},
            @{l='MACAddress';e={$_.MACAddress}},
            @{l='DHCPEnabled';e={$_.DHCPEnabled}},
            @{l='DHCPServer';e={$_.DHCPServer}},
            @{l='DNSServerSearchOrder';e={$_.DNSServerSearchOrder}},
            @{l='TcpipNetbiosOptions';e={$netbiosMapping[[int]$_.TcpipNetbiosOptions]}},
            @{l='WINSEnableLMHostsLookup';e={$_.WINSEnableLMHostsLookup}}
        )
    }
    # Configura as propriedades de Get-NetAdapter
    $propertys = @(
        @{l='Adapter_ID';e={
            "$($_.Name); $($_.InterfaceDescription); $($_.MacAddress)"
        }},
        @{l='LinkSpeed';e={$_.LinkSpeed}},
        @{l='Status';e={$_.Status}},
        @{l='MediaType';e={$_.MediaType}},
        @{l='PhysicalMediaType';e={$_.PhysicalMediaType}},
        @{l='DriverInformation';e={$_.DriverInformation}}
    )
    try {
        # 1 Consulta para obter informações 
        # 1.1 Configuração da placa de rede 
        $win32NetworkAdapterConfig = Get-CimInstance -ClassName $classNetAdapterConfig.ClassName -Filter "IPEnabled = True" 

        # 1.2 Adaptadores de rede 
        $getNetAdapter = Get-NetAdapter | Where-Object {$_.MacAddress} 

        # 2 Exibe as informações
        # 2.1 Configuração da placa de rede 
        $win32NetworkAdapterConfig | Select-Object -Property $classNetAdapterConfig.Property

        # 2.2 Adaptadores de rede 
        $getNetAdapter | Select-Object -Property $propertys   
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