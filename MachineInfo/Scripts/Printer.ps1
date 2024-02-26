 # Obtém informações sobre as impressoras instaladas no sistema Windows
# Mapa dos códigos de "PrinterStatus"
$printerStatusMapping = @{
    1 = 'Other'
    2 = 'Unknown'
    3 = 'Idle'
    4 = 'Printing'
    5 = 'Warmup'
    6 = 'Stopped Printing'
    7 = 'Offline'
}

$classPropertys  = @{
    ClassName = 'Win32_Printer'
    Property = @(
        @{l='DeviceID';e={$_.Name}},
        @{l='DriverName';e={$_.DriverName}},
        @{l='PortName';e={$_.PortName}},
        @{l='PrinterStatus';e={$printerStatusMapping[[int]$_.PrinterStatus]}},
        @{l='Default';e={$_.Default}},
        @{l='Shared';e={$_.Shared}},
        @{l='Local';e={$_.Local}},
        @{l='Network ';e={$_.Network}},
        @{l='Hidden';e={$_.Hidden}},
        @{l='HorizontalResolution';e={$_.HorizontalResolution}},
        @{l='VerticalResolution';e={$_.VerticalResolution}}
    )
}

$win32Printer = Get-CimInstance -ClassName $classPropertys.ClassName | 
    Select-Object -Property $classPropertys.Property 
$win32Printer

Get-CimInstance -ClassName Win32_Printer | Select-Object *

# Obtém informações sobre as impressoras instaladas 
$getPrinter = Get-Printer
$getPrinter | Format-List

# Obtém informações sobre os drivers de impressora instalados no sistema Windows
$win32PrinterDriver = Get-CimInstance -ClassName Win32_PrinterDriver | Select-Object *
$win32PrinterDriver

# Obtém informações sobre os drivers de impressora
$getPrinterDriver = Get-PrinterDriver
$getPrinterDriver | Format-List

#  Obtém informações sobre os trabalhos de impressão (print jobs)
Get-CimInstance -ClassName Win32_PrintJob   | Select-Object *

# Obtém informações sobre as compartilhamentos de impressoras    
Get-CimInstance -ClassName Win32_PrinterShare  | Select-Object *


<# Sites:
https://4sysops.com/archives/install-remove-list-and-set-default-printer-with-powershell/
https://techbloggingfool.com/2021/07/24/powershell-remove-offline-network-printers-from-all-workstations/
#>