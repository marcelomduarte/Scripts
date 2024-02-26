# Obtém informações sobre os dispositivos apontadores (mouses, touchpads)

# Mapa dos códigos de "DeviceInterface"
$DeviceInterfaceMapping = @{
    1 = 'Other'
    2 = 'Unknown'
    3 = 'Serial'
    4 = 'PS/2'
    5 = 'Infrared'
    6 = 'HP-HIL'
    7 = 'Bus mouse'
    8 = 'ADB (Apple Desktop Bus)'
    160 = 'Bus mouse DB-9'
    161 = 'Bus mouse micro-DIN'
    162 = 'USB'
}

# Mapa dos códigos de "PointingType"
$PointingTypeMapping = @{
    1 = 'Other'
    2 = 'Unknown'
    3 = 'Mouse'
    4 = 'Track Ball'
    5 = 'Track Point'
    6 = 'Glide Point'
    7 = 'Touch Pad'
    8 = 'Touch Screen'
    9 = 'Mouse - Optical Sensor'
}

$classPropertys  = @{
    ClassName = 'Win32_PointingDevice'
    Property = @(
        @{l='Caption';e={$_.Caption}},
        @{l='Manufacturer';e={$_.Manufacturer}},
        @{l='Status';e={$_.Status}},
        @{l='DeviceInterface';e={$DeviceInterfaceMapping[[int]$_.DeviceInterface]}},
        @{l='PointingType';e={$PointingTypeMapping[[int]$_.PointingType]}},
        @{l='PNPDeviceID';e={$_.PNPDeviceID}}
    )
}

$win32PointingDevice = Get-CimInstance -ClassName $classPropertys.ClassName | 
    Select-Object -Property $classPropertys.Property 

$win32PointingDevice


Get-CimInstance -ClassName Win32_PointingDevice | Select-Object *