# Obtém informações sobre os dispositivos de teclado no sistema operacional Windows

# Mapa dos códigos de "Layout"
$layoutMapping = @{
    00000816 = 'Portuguese'
    00000416 = 'Portuguese (Brazil ABNT)'
    00010416 = 'Portuguese (Brazil ABNT2)'
    00010409 = 'United States-Dvorak'
    00030409 = 'United States-Dvorak for left hand'
    00040409 = 'United States-Dvorak for right hand'
    00020409 = 'United States-International'
}

$classPropertys  = @{
    ClassName = 'Win32_Keyboard'
    Property = @(
        @{l='Caption';e={$_.Caption}},
        @{l='Description';e={$_.Description}},
        @{l='Status';e={$_.Status}},
        @{l='Layout';e={$layoutMapping[[int]$_.Layout]}},
        @{l='NumberOfFunctionKeys';e={$_.NumberOfFunctionKeys}}, 
        @{l='PNPDeviceID';e={$_.PNPDeviceID}}
    )
}

$win32Keyboard = Get-CimInstance -ClassName $classPropertys.ClassName | 
    Select-Object -Property $classPropertys.Property 

$win32Keyboard


Get-CimInstance -ClassName Win32_Keyboard | Select-Object *