# Win32_Battery class (https://learn.microsoft.com/en-us/windows/win32/cimwin32prov/win32-battery)

$win32Battery = Get-CimInstance -ClassName Win32_Battery | 
Select-Object -Property @{l='Name';e={$_.Name}},
@{l='Deviceid';e={$_.Deviceid}},
@{l='DesignVoltage';e={$_.DesignVoltage}},
@{l='EstimatedChargeRemaining';e={$_.EstimatedChargeRemaining}},
@{l='EstimatedRunTime';e={$_.EstimatedRunTime}}


$win32Battery 


powercfg /energy


Get-CimInstance -ClassName Win32_MappedLogicalDisk | 
Select-Object *

Get-CimInstance Win32_StartupCommand | Select-Object Name, @{Name="Application Command"; Expression={$_.command}},Location 

Get-CimInstance Win32_StartupCommand | Select-Object *