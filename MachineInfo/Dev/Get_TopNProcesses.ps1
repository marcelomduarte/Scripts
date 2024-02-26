# Retorna uma lista dos processos em execução que usam mais recursos da CPU
Function Get-TopProcess{
    # Define os parâmetros
    param(
        [Parameter(Mandatory = $true)]
        [int]$TopN
    )
    # Executa o comando
    Get-Process | Sort-Object CPU -Descending |
        Select-Object -First $TopN -Property ID,
        ProcessName, @{l='CPU';e={'{0:N}' -f $_.CPU}}
}

Get-TopProcess