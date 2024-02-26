# Obtém informações sobre os compartilhamentos SMB (Server Message Block) em um sistema Windows
$getSmbShare = Get-SmbShare
$getSmbShare

<# 
Obtém informações sobre compartilhamentos de rede
CMD:
net share

Obs.: os compartilhamentos com símbolo "$"" no final 
serão considerados administrativos ou ocultos no Windows.
#>

# Obtém informações sobre os recursos compartilhados em um sistema Windows
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

$win32Share = Get-CimInstance -ClassName $classwin32Share.ClassName | 
    Select-Object -Property $classwin32Share.Property 

$win32Share | Format-List

<# 
Obtém informações sobre os compartilhamentos de rede
CMD:
wmic share get /format:list
#>

# Obtém informações sobre a configuração do cliente SMB (Server Message Block)
$getSmbClientConfiguration = Get-SmbClientConfiguration
$getSmbClientConfiguration

# Obtém informações sobre as configurações do servidor SMB 
$propertys = @(
    @{l='EnableSMB1Protocol';e={$_.EnableSMB1Protocol}},
    @{l='EnableSMB2Protocol';e={$_.EnableSMB2Protocol}}
)

$getSmbServerConfiguration = Get-SmbServerConfiguration

$getSmbServerConfiguration | Select-Object -Property $propertys