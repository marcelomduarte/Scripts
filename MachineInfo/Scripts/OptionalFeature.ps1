# Obtém informações sobre recursos opcionais do Windows
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

$win32OptionalFeature = Get-CimInstance -ClassName $classwin32OptionalFeature.ClassName | 
    Select-Object -Property $classwin32OptionalFeature.Property | 
    Sort-Object -Property InstallState -Descending

$win32OptionalFeature

<# 
Get-WindowsOptionalFeature - Obtém informações sobre os recursos opcionais do Windows 
Obs.: execute o comando como administrador
#>
# Lista todos os recursos opcionais
$getOptionalFeature = Get-WindowsOptionalFeature -Online
$getOptionalFeature

# Lista apenas os recursos opcionais instalados
$getOptionalFeature = Get-WindowsOptionalFeature -Online
$getOptionalFeature | Where-Object {$_.State -eq 'Enabled'}


# Detecta o Internet-Explorer
$ie = if ([Environment]::Is64BitProcess) {
    'Internet-Explorer-Optional-amd64'
} else {
    'Internet-Explorer-Optional-x86'
}
$getOptionalFeatureIE = Get-WindowsOptionalFeature -Online -FeatureName $ie
$getOptionalFeatureIE


# Detecta o PowerShellv2
$powerShellv2 = @('MicrosoftWindowsPowerShellV2', 'MicrosoftWindowsPowerShellV2Root')
$getOptionalFeatureps= $powerShellv2 | 
    ForEach-Object {
        $ps = $_
        Get-WindowsOptionalFeature -Online -FeatureName $ps
    }
$getOptionalFeatureps


# Detecta o SMB (Server Message Block) - SMBv1
$getOptionalFeaturesmb1 = Get-WindowsOptionalFeature -Online -FeatureName SMB1Protocol
$getOptionalFeaturesmb1 