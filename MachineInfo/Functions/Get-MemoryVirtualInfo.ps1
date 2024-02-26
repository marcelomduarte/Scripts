<#
.SYNOPSIS
    Obtém informações sobre a memória virtual do sistema. 

.DESCRIPTION
    Este script consulta informações sobre o arquivo de paginação e a memória virtual do sistema. 

    Ele usa as classes Win32_PageFileUsage, Win32_ComputerSystem e Win32_OperatingSystem, 
    seguindo diretrizes do padrão CIM (Common Information Model).
    
    É uma abordagem mais moderna, eficiente e segura do que o uso direto do WMI 
    (Windows Management Instrumentation), como o obsoleto cmdlet Get-WmiObject.
    
.LINK
    Get-CimInstance (https://learn.microsoft.com/en-us/powershell/module/cimcmdlets/get-ciminstance?view=powershell-7.3)

    Win32_PageFileUsage class (https://learn.microsoft.com/en-us/windows/win32/cimwin32prov/win32-pagefileusage)
    
    Win32_ComputerSystem class (https://learn.microsoft.com/en-us/windows/win32/cimwin32prov/win32-computersystem)

    Win32_OperatingSystem class (https://learn.microsoft.com/en-us/windows/win32/cimwin32prov/win32-operatingsystem)

.INPUTS
    None

.OUTPUTS
    Os dados são exibidos no console ou são enviados para um arquivo com o objetivo de documentar sistema.
    
    Dados:

        OsPagingFile                - Local e nome do arquivo de paginação (pagefile.sys)
        AllocatedBaseSize           - Tamanho base atualmente alocado para o arquivo de paginação, em megabytes (MB);
        InstallDate                 - Data da instalação (dd-MM-yyyy);
        CurrentUsage                - Quantidade atual de espaço usado no arquivo de paginação;
        PagingFileFreeSpace         - Quantidade de espaço livre disponível no arquivo de paginação no disco, em megabytes (MB)
        SizeStoredInPagingFiles     - Tamanho total do arquivo de paginação no disco, em megabytes (MB);
        FreeSpaceInPagingFiles      - Quantidade total de espaço livre disponível nos arquivos de paginação no disco, em megabytes (MB)
        TotalVirtualMemorySize      - Quantidade total da memória virtual disponível no sistema, em gigabytes (GB);
        FreeVirtualMemory           - Quantidade de memória virtual disponível no sistema que não está sendo usada, em gigabytes (GB);
        %FreeVirtualMemory          - Porcentagem de FreeVirtualMemory;
        MemoryVirtualUsage          - Quantidade de memória virtual em uso no sistema, em gigabytes (GB);
        %MemoryVirtualUsage         - Porcentagem de MemoryVirtualUsage. 

.NOTES
~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<><>~<>~<>~<>~<>
    Created with: Windows Terminal; VSCode
    FileName: Get-MemoryVirtualInfo.ps1
    Version: 1.0.0
    E-mail: marcelomduarte30@outlook.com
    GitHub: https://github.com/marcelomduarte
    Linkedin: https://www.linkedin.com/in/marcelomduarte/
    Updatedby: Marcelo Magalhães
    LastUpdate: 11/03/2023 
    Changelog  
    Version     When        Who                    What
    1.0.0       09/03/2023  Marcelo Magalhães      Inicializado - Versão inicial
    1.0.1       11/03/2023  Marcelo Magalhães      Adicionado - Comentários em ".OUTPUTS"
~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<><>~<>~<>~<>~<>
.EXAMPLE
    # Chama a função
    $getMemoryVirtualInfo = Get-MemoryVirtualInfo
    $getMemoryVirtualInfo
#>
function Get-MemoryVirtualInfo{
    
    # Configura a classe e as propriedades de Win32_PageFileUsage
    $classPageFileUsage  = @{
        ClassName = 'Win32_PageFileUsage'
        Property  = @(
            @{l='OsPagingFile';e={$_.Name}},
            @{l='InstallDate';e={
                if ($null -ne $_.InstallDate) {
                    $_.InstallDate.ToString('dd-MM-yyyy')
                } else {
                    'N/A'
                }
            }},
            @{l='AllocatedBaseSize';e={
                $allocatedBaseSizeMB = [math]::Round($_.AllocatedBaseSize, 0)
                [string]::Format('{0} MB', $allocatedBaseSizeMB)
            }},
            @{l='CurrentUsage';e={
                $currentUsageMB = $_.CurrentUsage
                [string]::Format('{0} MB', $currentUsageMB, 0)
            }}
            @{l='PagingFileFreeSpace';e={
                $freeSpaceInPagingFileMB = $_.AllocatedBaseSize - $_.CurrentUsage
                [string]::Format('{0} MB', $freeSpaceInPagingFileMB)
            }}
        )
    }
    
    # Configura a classe e a propriedade de Win32_ComputerSystem
    $classComputerSystem  = @{
        ClassName = 'Win32_ComputerSystem'
        Property  = @(
            @{l='AutomaticManagedPagefile';e={
                if ($_.AutomaticManagedPagefile -eq $true) {
                    'Yes'
                } else {
                    'No'
                }
            }}
        )
    }
    
    # Configura a classe e as propriedades de Win32_OperatingSystem
    $classOS = @{
        ClassName = 'Win32_OperatingSystem'
        Property  = @(
            @{l='SizeStoredInPagingFiles'; e={
                $sizeStoredInPagingFilesGB = [math]::Round($_.SizeStoredInPagingFiles / 1024 / 1024, 2) 
                [string]::Format('{0:N2} GB', $sizeStoredInPagingFilesGB )
            }},
            @{l='FreeSpaceInPagingFiles'; e={
                $freeSpaceInPagingFilesGB = [math]::Round($_.FreeSpaceInPagingFiles / 1024 / 1024, 2) 
                [string]::Format('{0:N2} GB', $freeSpaceInPagingFilesGB )
            }},   
            @{l='TotalVirtualMemorySize'; e={
                $totalVirtualMemorySizeGB = [math]::Round($_.TotalVirtualMemorySize / 1024 / 1024, 2) 
                [string]::Format('{0:N2} GB', $totalVirtualMemorySizeGB )
            }},
            @{l='FreeVirtualMemory'; e={
                $freeVirtualMemoryMB  = [math]::Round($_.FreeVirtualMemory / 1024 / 1024, 2) 
                [string]::Format('{0:N2} GB', $freeVirtualMemoryMB)
            }},
            @{l='%FreeVirtualMemory';e={
                $freeMemory = $_.FreeVirtualMemory
                $totalMemory = $_.TotalVirtualMemorySize
                $percentfreeMemoryVirtual = [math]::Round(($freeMemory / $totalMemory) * 100, 2)
                [string]::Format('{0:N2} %', $percentfreeMemoryVirtual)
            }}, 
            @{l='MemoryVirtualUsage'; e={
                $memoryInUse = $_.TotalVirtualMemorySize - $_.FreeVirtualMemory
                $memoryInUseMB = [math]::Round($memoryInUse / 1024, 0)
                $memoryInUseGB = [math]::Round($memoryInUse / 1024 / 1024, 2)
                if ($memoryInUseGB -ge 1) {
                    [string]::Format('{0:N2} GB', $memoryInUseGB)
                } else {
                    [string]::Format('{0} MB', $memoryInUseMB)
                }  
            }}, 
            @{l='%MemoryVirtualUsage';e={
                $memoryInUse = $_.TotalVirtualMemorySize - $_.FreeVirtualMemory
                $totalMemory = $_.TotalVirtualMemorySize
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
        # 1.1 Arquivo de paginação
        $win32PageFileUsage = Get-CimInstance -ClassName $classPageFileUsage.ClassName
        
        # 1.2  Arquivo de paginação - Gerenciamento do tamanho (automático ou manual) 
        $win32ComputerSystem = Get-CimInstance -ClassName $classComputerSystem.ClassName 
        
        # 1.3 Memória virtual
        $win32OS = Get-CimInstance -ClassName $classOS.ClassName 
        
        # Verifica se há arquivos de paginação
        if ($win32PageFileUsage) {
            # 2 Exibe as informações
            # 2.1 Arquivo de paginação
            $win32PageFileUsage | Select-Object -Property $classPageFileUsage.Property

            # 2.2 Arquivo de paginação - Gerenciamento do tamanho (automático ou manual) 
            $win32ComputerSystem | Select-Object -Property $classComputerSystem.Property

            # 2.3 Memória virtual
            $win32OS | Select-Object -Property $classOS.Property 
        } else {
            'No paging files found.'
        }

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