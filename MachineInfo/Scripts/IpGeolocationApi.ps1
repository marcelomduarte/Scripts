# Obtém informações de geolocalização com base em um endereço IP
# Obtém o endereço IP público
$ipv4Ify = Invoke-RestMethod -Uri 'https://api.ipify.org?format=json' -Method Get 

# Obtém informações relacionadas ao IP público retornado pela API "ipify.org".
$ipInfo = Invoke-RestMethod -Uri "https://ipinfo.io/$($IPv4Ify.ip)/json" -Method Get 

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

# Exibe as informações 
$ipInfo | Select-Object -Property $propertys

<#
Obtém informações sobre o endereço IP externo (IP publico)
CMD:
curl ipinfo.io/json
#>