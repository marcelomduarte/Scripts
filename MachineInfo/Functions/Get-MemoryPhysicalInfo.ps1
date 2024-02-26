<#
.SYNOPSIS
    Obtém informações sobre os módulos de memória física. 

.DESCRIPTION
    Este script consulta informações sobre os módulos e os arrays (conjuntos) 
    de módulos de memória física (RAM). 
    
    Ele usa as classes Win32_PhysicalMemory, Win32_PhysicalMemoryArray, Win32_OperatingSystem 
    seguindo diretrizes do padrão CIM (Common Information Model).
    
    É uma abordagem mais moderna, eficiente e segura do que o uso direto do WMI 
    (Windows Management Instrumentation), como o obsoleto cmdlet Get-WmiObject.
    
.LINK
    Get-CimInstance (https://learn.microsoft.com/en-us/powershell/module/cimcmdlets/get-ciminstance?view=powershell-7.3)

    Win32_PhysicalMemory class (https://learn.microsoft.com/en-us/windows/win32/cimwin32prov/win32-physicalmemory)

    Win32_PhysicalMemoryArray class (https://learn.microsoft.com/en-us/windows/win32/cimwin32prov/win32-physicalmemoryarray)

    Win32_OperatingSystem class (https://learn.microsoft.com/en-us/windows/win32/cimwin32prov/win32-operatingsystem)

.INPUTS
    None

.OUTPUTS
    Os dados são exibidos no console ou são enviados para um arquivo com o objetivo de documentar sistema.
    
    Dados:
        MemoryModuleCapacity   - Capacidade total por módulo de memória física, em megabytes (MB);
        MemoryType             - Tipo de memória física; 
        MemoryFormFactor       - Formato físico do módulo de memória;
        MemoryTypeDetail       - Detalhes adicionais sobre o tipo de módulo de memória;
        MemoryVoltage          - Voltagem configurada para o módulo de memória, em volts (V);
        MemoryClockSpeed       - Velocidade do clock (ou frequência) configurada para o módulo de memória física, em megahertz (MHz); 
        MemoryManufacturer     - Fabricante do módulo de memória física;
        BankLabel              - Etiqueta do banco de memória;
        DeviceLocator          - Localização física dos dispositivos de memória na placa-mãe;
        PartNumber             - Número da peça ou o código de peça único atribuído ao módulo de memória;
        SerialNumber           - Número de série exclusivo atribuído ao módulo de memória;
        MemoryCapacityTotal    - Soma da capacidade dos módulos de memória física, em gigabytes (GB);
        MemoryCapacityMax      - Capacidade máxima de memória instalável, em gigabytes (GB);
        SlotsUsed              - Número de dispositivos de memórias, slots físicos ou soquetes, usados e disponíveis;
        TotalVisibleMemorySize - Quantidade total da memória física disponível para o sistema operacional, em gigabytes (GB);
        FreePhysicalMemory     - Quantidade de memória física disponível no sistema que não está sendo usada, em gigabytes (GB);
        %FreePhysicalMemory    - Porcentagem de FreePhysicalMemory; 
        MemoryUsage            - Quantidade de memória física em uso no sistema, em gigabytes (GB);
        %MemoryUsage           - Porcentagem de MemoryUsage.

.NOTES
~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<><>~<>~<>~<>~<>
    Created with: Windows Terminal; VSCode
    FileName: Get-MemoryPhysicalInfo.ps1
    Version: 1.0.0
    E-mail: marcelomduarte30@outlook.com
    GitHub: https://github.com/marcelomduarte
    Linkedin: https://www.linkedin.com/in/marcelomduarte/
    Updatedby: Marcelo Magalhães
    LastUpdate: 12/03/2023 
    Changelog  
    Version     When        Who                    What
    1.0.0       09/03/2023  Marcelo Magalhães      Inicializado - Versão inicial
    1.0.1       11/03/2023  Marcelo Magalhães      Adicionado - Comentários em ".OUTPUTS"
    1.0.2       12/03/2023  Marcelo Magalhães      Adicionado - Dados sobre slots usados (SlotsUsed)
~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<><>~<>~<>~<>~<>
.EXAMPLE
    # Chama a função
    $getMemoryInfo = Get-MemoryPhysicalInfo
    $getMemoryInfo
#>
function Get-MemoryPhysicalInfo{

    # Mapa dos códigos de "MemoryType"
    $memoryTypeMapping = @{
        0  = 'Unknown'
        1  = 'Other'
        2  = 'DRAM'
        3  = 'Synchronous DRAM'
        4  = 'Cache DRAM'
        5  = 'EDO'
        6  = 'EDRAM'
        7  = 'VRAM '
        8  = 'SRAM'
        9  = 'RAM'
        10 = 'ROM'
        11 = 'Flash'
        12 = 'EEPROM'
        13 = 'FEPROM'
        14 = 'EPROM'
        15 = 'CDRAM'
        16 = '3DRAM'
        17 = 'SDRAM'
        18 = 'SGRAM'
        19 = 'RDRAM'
        20 = 'DDR'
        21 = 'DDR2'
        22 = 'DDR2 FB-DIMM'
        24 = 'DDR3'
        25 = 'FBD2'
        26 = 'DDR4'
    }

    # Mapa dos códigos de "FormFactor"
    $formFactorMapping = @{
        0  = 'Unknown'
        1  = 'Other'
        2  = 'SIP'
        3  = 'DIP'
        4  = 'ZIP'
        5  = 'SOJ'
        6  = 'Proprietary'
        7  = 'SIMM'
        8  = 'DIMM'
        9  = 'TSOP'
        10 = 'PGA'
        11 = 'RIMM'
        12 = 'SODIMM'
        13 = 'SRIMM'
        14 = 'SMD'
        15 = 'SSMP'
        16 = 'QFP'
        17 = 'TQFP'
        18 = 'SOIC'
        19 = 'LCC'
        20 = 'PLCC'
        21 = 'BGA'
        22 = 'FPBGA'
        23 = 'LGA'
    }

    # Mapa dos códigos de "TypeDetail"
    $typeDetailMapping = @{
        1    = 'Reserved'
        2    = 'Other'
        4    = 'Unknown'
        8    = 'Fast-paged'
        16   = 'Static column'
        32   = 'Pseudo-static'
        64   = 'RAMBUS '
        128  = 'Synchronous'
        256  = 'CMOS'
        512  = 'EDO'
        1024 = 'Window DRAM'
        2048 = 'Cache DRAM'
        4096 = 'Non-volatile'
    }

    # Configura a classe e as propriedades de Win32_PhysicalMemory
    $classPhysicalM = @{
        ClassName = 'Win32_PhysicalMemory'
        Property  = @(
            @{l='MemoryModuleCapacity'; e={
               $capacityMB = [math]::Round($_.Capacity / 1024 / 1024, 0)
               [string]::Format('{0} MB', $capacityMB)
            }},
            @{l='MemoryType';e={$memoryTypeMapping[[int]$_.MemoryType]}},
            @{l='MemoryFormFactor';e={$formFactorMapping[[int]$_.FormFactor]}},
            @{l='MemoryTypeDetail';e={$typeDetailMapping[[int]$_.TypeDetail]}},
            @{l='MemoryVoltage';e={
                $voltage = [math]::Round($_.ConfiguredVoltage / 1000, 2)
                    if ($voltage -lt 1.35) {
                        $voltageRange = 'Low'
                    } elseif ($voltage -gt 1.5) {
                        $voltageRange = 'High'
                    } else { 
                        $voltageRange = 'Standard'
                    }
                [string]::Format('{0:N2} V ({1})', $voltage, $voltageRange)
            }},
            @{l='MemoryClockSpeed';e={
                [string]::Format('{0} MHz', ($_.ConfiguredClockSpeed))
            }},
            @{l='MemoryManufacturer';e={$_.Manufacturer}},
            @{l='BankLabel';e={$_.BankLabel}},
            @{l='DeviceLocator';e={$_.DeviceLocator}},
            @{l='PartNumber';e={$_.PartNumber}},
            @{l='SerialNumber';e={
                if ($_.SerialNumber -ne '00000000') {
                    $_.SerialNumber
                } else {
                    'N/A'
                }
            }}
        )
    }

    # Configura a classe e as propriedades de Win32_PhysicalMemoryArray
    $classPhysicalMA = @{
        ClassName = 'Win32_PhysicalMemoryArray'
        Property  = @(
            @{l='MemoryCapacityMax'; e={
                $maxCapacityGB = [math]::Round($_.MaxCapacityEx / 1024 / 1024, 2) 
                [string]::Format('{0:N2} GB', $maxCapacityGB)
            }}
        )
    }
    
    # Configura a classe e as propriedades de Win32_OperatingSystem
    $classOS = @{
        ClassName = 'Win32_OperatingSystem'
        Property  = @(
            @{l='TotalVisibleMemorySize'; e={
                $totalVisibleMemorySizeGB = [math]::Round($_.TotalVisibleMemorySize / 1024 / 1024, 2) 
                [string]::Format('{0:N2} GB', $totalVisibleMemorySizeGB)
            }},
            @{l='FreePhysicalMemory'; e={
                $freePhysicalMemoryMB = [math]::Round($_.FreePhysicalMemory / 1024, 0) 
                $freePhysicalMemoryGB = [math]::Round($_.FreePhysicalMemory / 1024 / 1024, 2)
                if ($freePhysicalMemoryGB -ge 1) {    
                    [string]::Format('{0:N2} GB', $freePhysicalMemoryGB)
                } else {
                    [string]::Format('{0:N2} MB', $freePhysicalMemoryMB)
                }
            }},
            @{l='%FreePhysicalMemory';e={
                $freeMemory = $_.FreePhysicalMemory
                $totalMemory = $_.TotalVisibleMemorySize
                $percentfreeMemory = [math]::Round(($freeMemory / $totalMemory) * 100, 2)
                [string]::Format('{0:N2} %', $percentfreeMemory)
            }},     
            @{l='MemoryUsage'; e={
                $memoryInUse = $_.TotalVisibleMemorySize - $_.FreePhysicalMemory
                $memoryInUseMB = [math]::Round($memoryInUse / 1024, 0)
                $memoryInUseGB = [math]::Round($memoryInUse / 1024 / 1024, 2)
                if ($memoryInUseGB -ge 1) {
                    [string]::Format('{0:N2} GB', $memoryInUseGB)
                } else {
                    [string]::Format('{0} MB', $memoryInUseMB)
                }  
            }}, 
            @{l='%MemoryUsage';e={
                $memoryInUse = $_.TotalVisibleMemorySize - $_.FreePhysicalMemory
                $totalMemory = $_.TotalVisibleMemorySize
                $percentMemoryInUse = [math]::Round(($memoryInUse / $totalMemory) * 100, 2)
                    if ($percentMemoryInUse -le 80) {
                        $use = 'Normal' 
                    }
                    elseif ($percentMemoryInUse -le 90) {
                        $use = 'Medium'
                    }
                    else {
                        $use = 'High'
                    }
                [string]::Format('{0:N2} % ({1})', $percentMemoryInUse, $use)
            }}    
        )
    }
        
    try {
        # 1 Consulta para obter informações 
        # 1.1 Módulos de memória física
        $win32PhysicalM = Get-CimInstance -ClassName $classPhysicalM.ClassName 

        # 1.2 Conjuntos de módulos de memória física
        $win32PhysicalMA = Get-CimInstance -ClassName $classPhysicalMA.ClassName

        # 1.3 Memória física do sistema operacional
        $win32OS = Get-CimInstance -ClassName $classOS.ClassName 
        
        # 2 Cálculos
        # 2.1 Mede a capacidade total de memória - "$win32PhysicalM"    
        $capacityTotal = $win32PhysicalM.Capacity | Measure-Object -Sum
        
        # 2.2 Obtém o número total de slots disponíveis no sistema - "$win32PhysicalMA"
        $availableSlots = $win32PhysicalMA | Select-Object -ExpandProperty MemoryDevices

        # 2.3 Obtém o número de slots usados - "$win32PhysicalM" 
        $usedSlots = $win32PhysicalM | Where-Object { $_.Capacity -gt 0 } | 
            Measure-Object -Property Capacity -Sum  
        
        # 3 Exibe as informações
        # 3.1 Módulos de memória física
        $win32PhysicalM | Select-Object -Property $classPhysicalM.Property

        # 3.2 Capacidade total
        $capacityTotal | Select-Object -Property @{l='MemoryCapacityTotal';e={
            $total = [math]::Round($_.Sum / 1024 / 1024 / 1024, 2)
            [string]::Format('{0:N2} GB', $total)
        }}
        
        # 3.3 Conjuntos de módulos de memória física
        $win32PhysicalMA| Select-Object -Property $classPhysicalMA.Property
        
        # 3.4 Slots usados
        $usedSlots | Select-Object -Property @{l='SlotsUsed';e={
            $usedSlots = $_.Count
            [string]::Format('{0} of {1}', $usedSlots, $availableSlots) 
        }}

        # 3.5 Memória física do sistema operacional
        $win32OS | Select-Object -Property $classOS.Property
    }
    catch {
        # Captura a mensagem de exceção
        $errorMessage = $_.Exception.Message
       
        # Define o caminho da pasta onde a mensagem de exceção será salva
        $documentPath = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::MyDocuments)
        $folderName = 'Env\ExceptionLogs'
        $newFolder = Join-Path -Path $documentPath -ChildPath $folderName

        # Verifica se o diretório existe 
        if (-not (Test-Path -Path $newFolder -PathType Container)) {
            # Se o diretório não existir, cria um novo diretório
            New-Item -Path $newFolder -ItemType Directory
        }
        # Combina o caminho da nova pasta com o nome do arquivo de log desejado
        $logFilePath = Join-Path -Path $newFolder -ChildPath "${env:COMPUTERNAME}_${env:USERNAME}_ExceptionMsg.txt"

        # Armazena a data e hora atuais 
        $date = Get-Date -UFormat "%d-%m-%Y - %Hh-%Mm-%Ss"

        # Obtém o nome do script em execução
        $scriptName = $MyInvocation.MyCommand.Name

        # Linha estilizada para delimitar as mensagens no arquivo de log
        $lineStyling = "#######################################################"

        # Adiciona a linha estilizada ao arquivo de log
        $lineStyling | Out-File -FilePath $logFilePath -Append

        # Obtém a data atual e anexa ao arquivo de log junto com o nome do script
        "$date - $scriptName`n" | Out-File -FilePath $logFilePath -Append
      
        # Adiciona a mensagem de erro ao arquivo de log
        "$errorMessage`n"  | Out-File -FilePath $logFilePath -Append
        
        # Cria um link 
        $logFileUri = [System.Uri]::new($logFilePath)

        # Exibe o link clicável no console
        Write-Host "Ocorreu um erro. Consulte o arquivo de log em $logFileUri para detalhes."
    }
} 