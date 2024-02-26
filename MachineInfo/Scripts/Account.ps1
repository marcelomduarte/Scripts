# Obtém informações sobre contas de usuário no sistema operacional Windows
# Win32_UserAccount class (https://learn.microsoft.com/en-us/windows/win32/cimwin32prov/win32-useraccount)
<#
Name - Nome da conta de usuário do Windows no domínio especificado pela propriedade Domain dessa classe.
AccountType - Sinalizadores que descrevem as características de uma conta de usuário do Windows.
Disabled - A conta de usuário do Windows está desabilitada.
FullName - Nome completo de um usuário local, por exemplo: "Dan Wilson".
LocalAccount - Se for true, a conta será definida no computador local.
SID - SID (identificador de segurança) para essa conta. 
#>

# Mapa dos códigos de "AccountType"
$accountType_map = @{ 
    256  = 'Temporary duplicate account'
    512  = 'Normal account'
    2048 = 'Interdomain trust account'
    4096 = 'Workstation trust account'
    8192 = 'Server trust account'
}

# Configura a classe e as propriedades de Win32_UserAccount
$classUserAccount = @{
    ClassName = 'Win32_UserAccount'
    Property  = @(
        @{l='Name';e={$_.Name}},
        @{l='FullName';e={
            if ($_.FullName) {
                $_.FullName
            } else {
                'N/A'
            }
        }},
        @{l='Description';e={
            if ($_.Description) {
                $_.Description
            } else {
                'N/A'
            }
        }},
        @{l='SID';e={$_.SID}},
        @{l='Domain';e={$_.Domain}},
        @{l='AccountType';e={$accountType_map[[int]$_.AccountType]}},
        @{l='LocalAccount';e={$_.LocalAccount}},
        @{l='Disabled';e={$_.Disabled}}
    )
}

$win32UserAccount = Get-CimInstance -ClassName $classUserAccount.ClassName 
$win32UserAccount | Select-Object -Property $classUserAccount.Property
  

# Obtém informações sobre contas de usuário locais 
# Get-LocalUser (https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.localaccounts/get-localuser?view=powershell-5.1&viewFallbackFrom=powershell-7.3)
$getLocalUsers = Get-LocalUser
$getLocalUsers | Select-Object @{l='Name';e={$_.Name}},
    @{l='Enabled';e={$_.Enabled}}, @{l='LastLogon';e={$_.LastLogon}},
    @{l='Description';e={
        if ($_.Description) {
            $_.Description
        } else {
            'N/A'
        }
    }}


# Conta o número de itens dentro do diretório C:\Users 
$usersCount = Get-Item -Path 'c:\Users\*' | Measure-Object | 
    Select-Object -Property @{l='UsersCount';e={$_.Count}}
$usersCount 


# Obtém informações sobre contas de grupo
# Win32_Group class (https://learn.microsoft.com/en-us/windows/win32/cimwin32prov/win32-group)
# Configura a classe e as propriedades de Win32_Group
$classwin32Group = @{
    ClassName = 'Win32_Group'
    Property  = @(
        @{l='Name';e={$_.Name}},
        @{l='Domain';e={$_.Domain}},
        @{l='Description';e={
            if ($_.Description) {
                $_.Description
            } else {
                'N/A'
            }
        }},
        @{l='SID';e={$_.SID}},
        @{l='LocalAccount';e={$_.LocalAccount}}
    )
}

$win32Group = Get-CimInstance -ClassName $classwin32Group.ClassName 
$win32Group | Select-Object -Property $classwin32Group.Property


# Obtém informações sobre contas de grupo
# Get-LocalGroup (https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.localaccounts/get-localgroup?view=powershell-5.1&viewFallbackFrom=powershell-7.3)
$getLocalGroup = Get-LocalGroup 
$getLocalGroup | Format-List


# Obtém informações sobre contas do sistema
# Win32_SystemAccount class (https://learn.microsoft.com/en-us/windows/win32/cimwin32prov/win32-systemaccount)
# Configura a classe e as propriedades de Win32_SystemAccount
$classwin32SystemAccount = @{
    ClassName = 'Win32_SystemAccount'
    Property  = @(
        @{l='Name';e={$_.Name}},
        @{l='Domain';e={$_.Domain}},
        @{l='Description';e={
            if ($_.Description) {
                $_.Description
            } else {
                'N/A'
            }
        }},
        @{l='SID';e={$_.SID}},
        @{l='LocalAccount';e={$_.LocalAccount}}
    )
}

$win32SystemAccount = Get-CimInstance -ClassName $classwin32SystemAccount.ClassName 
$win32SystemAccount | Select-Object -Property $classwin32SystemAccount.Property