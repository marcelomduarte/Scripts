# Obtém informações sobre os dispositivos Plug and Play (PnP) no sistema
$classPropertys  = @{
    ClassName = 'Win32_PNPEntity'
    Property = @(
        @{l='PNPDeviceID';e={$_.PNPDeviceID}},
        @{l='Caption';e={$_.Caption}},
        @{l='Status';e={$_.Status}}, 
        @{l='PNPClass';e={$_.PNPClass}},
        @{l='ClassGuid';e={$_.ClassGuid}},
        @{l='Present';e={$_.Present}},
        @{l='Service';e={$_.Service}}
    )
}
$win32PNPEntityUSB = Get-CimInstance -ClassName $classPropertys.ClassName | 
    Select-Object -Property $classPropertys.Property | 
    Where-Object {$_.PNPDeviceID -like 'USB*'}

$win32PNPEntityUSB

<# 
    O cmdlet Get-PnpDevice retorna informações sobre os dispositivos Plug and Play (PnP) no sistema.
    
    Get-PnpDevice (https://learn.microsoft.com/en-us/powershell/module/pnpdevice/get-pnpdevice?view=windowsserver2022-ps)
#>
$propertys = @{
    Property = @(
        @{l='PNPDeviceID';e={$_.PNPDeviceID}},
        @{l='Caption';e={$_.Caption}},
        @{l='Status';e={$_.Status}}, 
        @{l='PNPClass';e={$_.PNPClass}},
        @{l='ClassGuid';e={$_.ClassGuid}},
        @{l='Present';e={$_.Present}},
        @{l='Service';e={$_.Service}}
    )
}

# Lista dipositivos USB presentes (não inclui dispositivos desconectados ou ausentes)
$getPnpDeviceOn = Get-PnpDevice -PresentOnly | Where-Object {$_.InstanceId -match '^USB'} | 
    Select-Object $propertys.Property  
$getPnpDeviceOn

# Lista todos os dipositivos USB
$getPnpDevice = Get-PnpDevice | Where-Object {$_.InstanceId -match '^USB'} | 
    Select-Object $propertys.Property 
$getPnpDevice
<#  
    O devcon.exe é uma ferramenta de linha de comando que faz parte do Windows Driver Kit (WDK).
    É usada para gerenciar dispositivos no sistema.

    DevCon (https://learn.microsoft.com/en-us/windows-hardware/drivers/download-the-wdk0
#>
# Define o caminho do arquivo do devcon.exe 
$filePathDevcon = "C:\Program Files (x86)\Windows Kits\10\Tools\x64\devcon.exe"

# Executa o arquivo devcon.exe e lista os dipositivos USB
& $filePathDevcon listclass USB 

# Obter todos os discos USB (removíveis)
$disk = Get-Disk
$disk | Where-Object -FilterScript {$_.Bustype -eq "USB"} | Format-List