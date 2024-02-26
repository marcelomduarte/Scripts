<#
.SYNOPSIS
    Obtém informações sobre as credenciais de Wi-Fi.

.DESCRIPTION
    Este script consulta informações sobre as credenciais de Wi-Fi armazenadas em cache.

.INPUTS
    None

.OUTPUTS
    Os dados são exibidos no console ou são enviados para um arquivo com o objetivo de documentar sistema.
    
    Dados:
        SSID           - SSID (Service Set Identifier): nome da rede Wi-Fi;            
        Password       - Chave de segurança;
        Authentication - Método de autenticação. 
    
.NOTES
~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<><>~<>~<>~<>~<>
    Created with: Windows Terminal; VSCode
    FileName: Get-WiFiPasswords.ps1
    Version: 1.0.0
    E-mail: marcelomduarte30@outlook.com
    GitHub: https://github.com/marcelomduarte
    Linkedin: https://www.linkedin.com/in/marcelomduarte/
    Updatedby: Marcelo Magalhães
    LastUpdate: 12/03/2023 
    Changelog  
    Version     When        Who                    What
    1.0.0       09/03/2023  Marcelo Magalhães      Inicializado - Versão inicial
    
~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<>~<><>~<>~<>~<>~<>
.EXAMPLE
    # Chama a função
    $getWiFiPasswords = Get-WiFiPasswords
    $getWiFiPasswords
#>
function Get-WiFiPasswords{

    $profileAll = (netsh wlan show profiles) | Select-String -Pattern "\:(.+)$" | 
        ForEach-Object -Process {$_.Matches.Groups[1].Value.Trim()}
    
    # Exibe as informações sobre as credenciais de Wi-Fi
    $profileAll | ForEach-Object -Process {
        $password = (netsh wlan show profile name=$_ key=clear) | 
            Select-String -Pattern "Conteúdo da Chave\W+\:(.+)$" | 
            ForEach-Object -Process {
                $_.Matches.Groups[1].Value.Trim()
            }
        $authenticationType = (netsh wlan show profile name=$_ key=clear) | 
            Select-String -Pattern "Autenticação\W+\:(.+)$" | 
            Select-Object -First 1 | 
            ForEach-Object -Process {
                $_.Matches.Groups[1].Value.Trim()
            }
        [PSCustomObject]@{
            SSID = $_
            Password = $password
            Authentication = $authenticationType
        }
    } 
}