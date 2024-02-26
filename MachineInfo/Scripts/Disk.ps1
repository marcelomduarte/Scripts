# Obtém informações sobre os discos físicos no sistema 
# Get-Disk 
$disk = Get-Disk
$disk | Sort-Object -Property Number | Format-Table -AutoSize
$disk | Sort-Object -Property Number | Format-List

# Obter todos os discos USB
$disk = Get-Disk
$disk | Where-Object -FilterScript {$_.Bustype -eq "USB"} | Format-List

# Get-PhysicalDisk
$physicalDisk = Get-PhysicalDisk
$physicalDisk | Sort-Object -Property DeviceId | Format-Table -AutoSize -Wrap
$physicalDisk | Sort-Object -Property DeviceId | Format-List

# Win32_DiskDrive
Get-CimInstance -ClassName Win32_DiskDrive | Sort-Object -Property DeviceID | Select-Object *

# Obtém informações sobre as partições de disco em um sistema
# Get-Partition
$partition = Get-Partition
$partition | Sort-Object -Property DriveLetter | Format-Table -AutoSize
$partition | Sort-Object -Property DriveLetter | Format-List

# Win32_DiskPartition
Get-CimInstance -ClassName Win32_DiskPartition | Sort-Object -Property DeviceID | Select-Object *

# Obtém informações sobre discos lógicos (unidades de disco montadas)
Get-CimInstance -ClassName Win32_LogicalDisk | Select-Object *

# Obtém informações sobre os volumes de armazenamento
# Get-Volume
$volume = Get-Volume
$volume | Sort-Object -Property DriveLetter | Out-GridView
$volume | Sort-Object -Property DriveLetter | Format-Table -AutoSize -Wrap
$volume | Sort-Object -Property DriveLetter | Format-List

# Win32_Volume 
Get-CimInstance -ClassName Win32_Volume | Sort-Object -Property DriveLetter | Select-Object *

<#  Relaciona unidades de disco rígido (Win32_DiskDrive) 
às partições de disco (Win32_DiskPartition) #> 
Get-CimInstance -ClassName Win32_DiskDriveToDiskPartition | Select-Object *

<# Relaciona discos lógicos (Win32_LogicalDisk) 
às partições de disco (Win32_DiskPartition) #>
Get-CimInstance -ClassName Win32_LogicalDiskToPartition | Select-Object *

Function Get-DiskToDisk{

    $classNames = @('Win32_DiskDriveToDiskPartition', 'Win32_LogicalDiskToPartition')
    
    $classNames | ForEach-Object { 
        $className = $_ 
        Get-CimInstance -ClassName $className |
            Sort-Object -Property DeviceID |
            Select-Object -Property Antecedent, Dependent
    }                              
}

$getDiskToDisk = Get-DiskToDisk
$getDiskToDisk | Format-List

# Obtém informações sobre os drives (unidades) disponíveis 
$PsDrive = Get-PSDrive
$PsDrive | Where-Object {$_.Name -like '?'}
ou 
$PsDrive | Where-Object {$_.Name  -match '^[A-Z]$'} 

# Lista as unidades relacionadas ao sistema de arquivos disponíveis no sistema
Get-PSDrive -PSProvider FileSystem

# CDRomDrive
$CDRomDrive = Get-CimInstance -Class CIM_CDROMDrive
$CDRomDrive | Format-List

Get-CimInstance -ClassName Win32_CDROMDrive | Select-Object *