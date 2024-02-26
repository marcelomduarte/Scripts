<#
    Script: config_git.ps1
    Finalidade: instalar e configurar o ambiente Git no Windows.
    
    Instruções de uso:
    1. Defina as variáveis $GitUsername e $GitUseremail com suas informações pessoais.
    2. Defina as variáveis $GitEditor e $GitDefaultBranch com informações gerais.
    3. Execute o script no PowerShell usando o comando:
       .\config_git.ps1

    Autor: Marcelo Magalhães 
    Data de Criação: 06/10/2022
#>

# Início (configuração global do Git)
$GitUsername = "Username" # Define o nome
$GitUseremail = "Useremail" # Define o e-mail
$GitEditor = "code --wait" # Define o editor
$GitDefaultBranch = "main" # Define o nome de ramificação padrão
# Fim (configuração global do Git)

# Verifica se o comando git não está disponível
if (-Not (Get-Command git))
{
    Write-Host "Instalando o Git..." -ForegroundColor "Yellow"

    # Instala o Git
    $InstallResult = winget install --id=Git.Git -e --accept-package-agreements --accept-source-agreements
    
    # Verifica o resultado da instalação
    if ($InstallResult.ExitCode -eq 0)
    {
        Write-Host
    }
    else
    {
        Write-Host "Falha na instalação do Git." -ForegroundColor DarkOrange
    }
}
else
{   
    Write-Host "Configurando o Git..." -ForegroundColor "Yellow"
    
    # Configura o Git
    git config --global user.name $GitUsername
    git config --global user.email $GitUseremail
    git config --global core.editor $GitEditor
    git config --global init.defaultBranch $GitDefaultBranch

    Write-Host
    Write-Host "Configurações do Git aplicadas com sucesso." -ForegroundColor "Green"
}