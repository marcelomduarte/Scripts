# Obtém informações sobre as placas de rede
Get-CimInstance -ClassName Win32_NetworkAdapter | Select-Object *

$win32NetworkAdapter = Get-CimInstance Win32_NetworkAdapter | 
    Where-Object {
        ($_.NetConnectionID) -and 
        (($_.AdapterType -eq 'Ethernet 802.3') -or ($_.AdapterType -eq 'Wireless')) -and
        ($_.Name -notmatch 'Hyper-V|VMware|VirtualBox|vEthernet')
    }
$win32NetworkAdapter | Format-List

# Obtém informações sobre adaptadores de rede no sistema
$getNetAdapter = Get-NetAdapter | Where-Object {$_.MacAddress} |
    Select-Object -Property @{l='Adapter_ID';e={
            "$($_.Name); $($_.InterfaceDescription); $($_.MacAddress)"
        }},
        @{l='LinkSpeed';e={$_.LinkSpeed}},
        @{l='Status';e={$_.Status}},
        @{l='MediaType';e={$_.MediaType}},
        @{l='PhysicalMediaType';e={$_.PhysicalMediaType}},
        @{l='DriverInformation';e={$_.DriverInformation}}   
$getNetAdapter 


<#
Exibe o endereço físico (MAC address) das placas de rede
CMD:
getmac /v /fo list

/v: Ativa o modo detalhado.
/fo list: Define o formato de saída como "list".
#>

# Obtém informações sobre as configurações da placa de rede
$win32NetAdapterConfig = Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration -Filter "IPEnabled = True"| 
    Select-Object -Property  @{l='Adapter';e={$_.Description}},
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
$win32NetAdapterConfig

# Obtém informações sobre os endereços IP configurados nas interfaces de rede do sistema
$getNetIPAddress= Get-NetIPAddress -AddressFamily IPv4 | 
    Select-Object InterfaceAlias, IPAddress, AddressFamily, InterfaceIndex
$getNetIPAddress 
 
# Obtém informações informações sobre a configuração de rede IP 
$getNetIPConfiguration = Get-NetIPConfiguration
$getNetIPConfiguration

$getNetIPConfigurationDet = Get-NetIPConfiguration -Detailed
$getNetIPConfigurationDet

<#
Exibe informações relacionadas à configuração de rede
CMD:
ipconfig

ipconfig /all

/all: Exibe informações detalhadas sobre todas as interfaces de rede.

Exibe apenas o IP
ipconfig /all | findstr /i /C:ipv4

findstr /C:ipv4: Este comando é usado para encontrar linhas que contenham a string 
"ipv4" na saída do comando ipconfig.
A opção /i torna a pesquisa insensível a maiúsculas e minúsculas.
O parâmetro /C: especifica o texto a ser procurado, que neste caso é "ipv4". 
#>

# Obtém informações sobre interfaces de rede (configuradas no nível IP)
$getNetIPInterface = Get-NetIPInterface
$getNetIPInterface | Format-List

# Obtém informações sobre os perfis de conexão de rede 
$getNetConnectionProfile = Get-NetConnectionProfile
$getNetConnectionProfile

# Obtém informações sobre as conexões TCP ativas no sistema
$getNetTCPConnection = Get-NetTCPConnection
$getNetTCPConnection | Format-List

# Obtém informações sobre os pontos finais de conexão UDP (User Datagram Protocol)
$getNetUDPEndpoint = Get-NetUDPEndpoint
$getNetUDPEndpoint | Format-List

<# 
CMD:
netstat -tno

netstat -uno

netstat -ano


-t ou --tcp: Mostra apenas as estatísticas relacionadas ao protocolo TCP.
-u ou --udp: Mostra apenas as estatísticas relacionadas ao protocolo UDP.
-a ou --all: Mostra todas as conexões e portas em escuta, tanto TCP quanto UDP.
-n ou --numeric: Exibe endereços IP e números de porta em formato numérico, sem resolução de DNS.
-o: Exibe o identificador do processo (PID) associado a cada conexão.

Lista todas as portas em estado de escuta (listening)
netstat -ano | findstr /i /C:listening

Execute como administrador
netstat -anob

-b: Exibe o nome do executável envolvido em cada conexão ou porta em escuta.
#>

# Obtém informações sobre rotas de rede no sistema
$getNetRoute = Get-NetRoute
$getNetRoute | Format-List

# Obtém informações sobre rotas de rede no sistema - Rota padrão
$getNetRouteDefault = Get-NetRoute | 
    Where-Object { 
        ($_.DestinationPrefix -eq "0.0.0.0/0") 
    } | Format-List
$getNetRouteDefault

<# 
Exibe a tabela de roteamento do sistema
CMD:
route print
#>

Get-DnsClient | Format-List

# Obtém informações sobre os servidores DNS configurados em um cliente DNS
$getDnsClientServerAddress = Get-DnsClientServerAddress
$getDnsClientServerAddress

# Obtém informações sobre o cache DNS do cliente
$getDnsClientCache = Get-DnsClientCache
$getDnsClientCache | Format-List

<# 
CMD:
ipconfig /displaydns

/displaydns: Exibe o conteúdo atual do cache DNS.
#>

# Obtém informações sobre componentes vinculados a adaptadores de rede 
$getNetAdapterBinding = Get-NetAdapterBinding -AllBindings | 
    Where-Object {($_.Name -eq 'Ethernet' -or $_.Name -eq 'Wi-Fi')} | 
    Select-Object -Property @{l='Name';e={$_.Name}},
        @{l='DisplayName';e={$_.DisplayName}},
        @{l='ComponentID';e={$_.ComponentID}},
        @{l='Enabled';e={$_.Enabled}} | 
    Sort-Object -Property Name

$getNetAdapterBinding