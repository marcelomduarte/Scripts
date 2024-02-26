# Obtém informações sobre o processador do sistema

# Mapa dos código de "Architecture"
$architectureMapping = @{
    0  = 'x86 (32 bits)'
    1  = 'MIPS'
    2  = 'Alpha'
    3  = 'PowerPC'
    5  = 'ARM'
    6  = 'ia64 (Itanium)'
    9  = 'x64 (64 bits)'
    12 = 'ARM64 (64 bits)'
}
$classPropertys  = @{
    ClassName = 'Win32_Processor'
    Property = @(
        @{l='DeviceID';e={$_.DeviceID}},
        @{l='Role';e={$_.Role}},
        @{l='Name';e={$_.Name}},
        @{l='Caption';e={$_.Caption}},
        @{l='Architecture';e={$architectureMapping[[int]$_.Architecture]}},
        @{l='NumberOfCores';e={$_.NumberOfCores}},
        @{l='NumberOfLogicalProcessors';e={$_.NumberOfLogicalProcessors}},
        @{l='CurrentClockSpeed';e={[string]::Format('{0} MHz', $_.CurrentClockSpeed)}},
        @{l='MaxClockSpeed';e={[string]::Format('{0} MHz', $_.MaxClockSpeed)}},
        @{l='L2CacheSize';e={[string]::Format('{0} KB', $_.L2CacheSize)}},
        @{l='L3CacheSize';e={[string]::Format('{0} KB', $_.L3CacheSize)}},
        @{l='TotalCacheSize';e={[string]::Format('{0:N2} MB', 
            [Math]::Round(($_.L2CacheSize + $_.L3CacheSize)/ 1024, 2))}},
        @{l='ThreadCount';e={$_.ThreadCount}},
        @{l='Revision';e={$_.Revision}},
        @{l='SocketDesignation';e={$_.SocketDesignation}}
    )
}

$win32Processor = Get-CimInstance -ClassName $classPropertys.ClassName | 
    Select-Object -Property $classPropertys.Property

$win32Processor 


Get-CimInstance -ClassName Win32_Processor | Select-Object *







 # Read Host CPU

 $HostCPUSockets = ($win32Processor  | Measure-Object).Count
 $HostCPUCores = ($win32Processor | Measure-Object -Property NumberOfCores -Sum).Sum
 $HostCPULogicalProcessors = ($win32Processor | Measure-Object -Property NumberOfLogicalProcessors -Sum).Sum
 Write-Host "HostCPUSockets: $HostCPUSockets Sockets" -ForegroundColor Green
 Write-Host "HostCPUCores: $HostCPUCores Sockets" -ForegroundColor Green
 Write-Host "HostCPULogicalProcessors: $HostCPULogicalProcessors Sockets" -ForegroundColor Green




 Get-CimInstance -ClassName Win32_AssociatedProcessorMemory | Select-Object *

 Get-CimInstance -ClassName Win32_CacheMemory | Select-Object *